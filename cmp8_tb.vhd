-- Banc de test de cmp8, comparateur 8 bits synchrone sur front montant, asynchrone sur reset.
-- Scénario :
--   1) Test du reset asynchrone, S = E = I = 0, indépendamment de clk, A et B.
--   2) Test de l'horloge clk front montant, changement de S, E, I avec reset = 0 après au moins 2 fronts montants (2 registres).
--   3) Test de l'horloge clk front descendant, aucun changement avec reset = 0 (test après 2 fronts montants).
--   4) Test de la comparaison a b, avec tous les cas possibles (2^8 * 2^8 = 2^16 = 65 536) toujours après 2 fronts montants.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity cmp8_tb is
end cmp8_tb;

architecture scenario of cmp8_tb is
    signal a, b    : std_logic_vector(7 downto 0) := "00000000";
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal s, e, i : std_logic;
    signal sei     : std_logic_vector(2 downto 0);
    signal done    : boolean := false;
begin
    dut : entity work.cmp8
    port map(a => a, b=>b, reset=>reset, clk=>clk, s=>s, e=>e, i=>i);
    sei <= s & e & i;
    
    gene_clk : process
    begin
        clk <= '0'; wait for 10 ns;
        clk <= '1'; wait for 10 ns;
        if done then wait; end if;
    end process gene_clk;  
    
    
    test_cmp8 : process   
        procedure check(item : in string; expected_sei : in std_logic_vector(2 downto 0)) is
        begin
          assert sei = expected_sei
            report item & " SEI=" & std_logic'image(s) & std_logic'image(e) & std_logic'image(i)
            severity error;
        end procedure;
        
        procedure test_case(item : in string; va, vb : in natural;
                        expected_sei : in std_logic_vector(2 downto 0)) is
        begin
          a <= conv_std_logic_vector(va, 8);
          b <= conv_std_logic_vector(vb, 8);
          wait until rising_edge(clk);
          wait until rising_edge(clk);
          wait for 1 ns;  -- les registres changent un delta après le front
          check(item, expected_sei);
        end procedure;
        
        
        begin
        -- 1) Test du reset asynchrone
        wait for 5 ns;
        check("1) avant le 1er front", "000");
        a <= conv_std_logic_vector(16#A5#, 8);
        b <= conv_std_logic_vector(16#A0#, 8);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;
        check("1) reset, 2 fronts", "000");
        
        -- 2) Test de l'horloge clk front montant
        reset <= '0';
        a <= conv_std_logic_vector(16#A5#, 8);
        b <= conv_std_logic_vector(16#A0#, 8);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;
        check("2) Front montant", "100");
        
        -- 3) Test de l'horloge clk front descendant
        a <= conv_std_logic_vector(16#30#, 8);
        b <= conv_std_logic_vector(16#40#, 8);
        wait until falling_edge(clk); wait for 1 ns;
        check("3) 1er front descendant", "100");
        wait until rising_edge(clk);  wait for 1 ns;
        check("3) 1er front montant", "100");    -- registres d'entrée chargés, sorties inchangées
        wait until falling_edge(clk); wait for 1 ns;
        check("3) 2e front descendant", "100");  -- un registre sur front descendant changerait ici
        wait until rising_edge(clk);  wait for 1 ns;
        check("3) 2e front montant", "001");     -- le verdict arrive au 2e front montant
        
        
        -- 4) Test de toutes les paires possibles
        for va in 0 to 255 loop
          for vb in 0 to 255 loop
            if va > vb then
              test_case("4)", va, vb, "100");
            elsif va = vb then
              test_case("4)", va, vb, "010");
            else
              test_case("4)", va, vb, "001");
            end if;
          end loop;
        end loop;
        done <= true;
        wait;
      end process;
    
    
end architecture scenario;

