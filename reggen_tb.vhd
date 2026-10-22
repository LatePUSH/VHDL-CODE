-- Banc de test de reggen, registre N bits synchrone sur front montant, asynchrone sur reset.
-- Testé pour N = 1 et N = 8, les deux tailles utilisées dans cmp8.
-- Scénario :
--   1) Test du reset asynchrone, output = 0 N bits indépendemment de l'horloge et de l'input.
--   2) Test du front montant, output = input après un front montant.
--   3) Test du front descendant, output retient sa valeur précédente après changement de l'input après un front montant

library ieee;
use ieee.std_logic_1164.all;

entity reggen_tb is
end reggen_tb;

architecture scenario of reggen_tb is
    signal clk     :  std_logic := '0';
    signal reset   :  std_logic := '1';
    signal input1  :  std_logic_vector(0 downto 0);
    signal output1 :  std_logic_vector(0 downto 0);
    signal input8  :  std_logic_vector(7 downto 0);
    signal output8 :  std_logic_vector(7 downto 0);
    signal done    :  boolean := false;

    begin
     dut1 : entity work.reggen
        generic map(N => 1)
        port map(clk => clk, reset => reset, input => input1, output => output1);

     dut8 : entity work.reggen
        generic map(N => 8)
        port map(clk => clk, reset => reset, input => input8, output => output8);

     gene_clk : process
        begin
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
            if done then wait; end if;
        end process gene_clk;

     test_reggen : process
        procedure check(item : in string; expected1 : in std_logic_vector(0 downto 0);
                        expected8 : in std_logic_vector(7 downto 0)) is
        begin
          assert output1 = expected1 report item & " (N = 1)" severity error;
          assert output8 = expected8 report item & " (N = 8)" severity error;
        end procedure;

        begin
            -- 1) Test du reset asynchrone : 
            input1 <= "1"; input8 <= "11110000";
            wait for 5 ns;
            check("1) avant le 1er front", "0", "00000000");
            wait until rising_edge(clk); wait until rising_edge(clk); wait for 1 ns;
            check("1) reset, 2 fronts", "0", "00000000");
            
            -- 1bis) Test du reset entre deux fronts
            reset <= '0';
            input1 <= "1"; input8 <= "11110000";
            wait until rising_edge(clk); wait for 1 ns;
            check("1bis) avant le reset", "1", "11110000");
            wait for 5 ns;
            reset <= '1';
            wait for 1 ns;
            check("1bis) reset entre deux fronts", "0", "00000000");

            -- 2) Test du front montant
            reset <= '0';
            wait until rising_edge(clk); wait for 1 ns;
            check("2) front montant", "1", "11110000");

            -- 3) Test du front descendant
            input1 <= "0"; input8 <= "00001111";
            wait until falling_edge(clk); wait for 1 ns;
            check("3) front descendant", "1", "11110000");
            wait until rising_edge(clk); wait for 1 ns;
            check("3) front montant suivant", "0", "00001111");



            done <= true;
            wait;
        end process test_reggen;
end architecture scenario;
