library IEEE;
use IEEE.std_logic_1164.all;

entity TB is
end TB;

architecture arc_TB of TB is
  signal clk, reset : std_logic;
  signal wave : std_logic_vector(1 downto 0) := "11";
begin
  process
  begin
    clk <= '0'; wait for 10 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process
  begin
    wait for 20 ns; reset <= '1';
    wait for 7 ns;
    reset <= '0'; wait for 150 ns;
  end process;

  process
  begin
    for i in 0 to 2 loop wait until rising_edge(clk); end loop;
    wave <= "01"; wait until falling_edge(clk);
    wave <= "00";
    wave <= "11"; wait until rising_edge(clk);
    wave <= "11"; wait for 15 ns;
    wave <= "10";
    wave <= "10"; wait for 12 ns;
    wave <= "11";
    wave <= "01";
    for i in 0 to 1 loop wait until rising_edge(clk); end loop;
    wave <= "10";
    for i in 0 to 1 loop wait until falling_edge(clk); end loop;
  end process;
end arc_TB;
