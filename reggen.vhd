library ieee;
use ieee.std_logic_1164.all;

entity reggen is
  generic(N : positive := 1);
  port(
    clk    : in  std_logic;
    reset  : in  std_logic;
    input  : in  std_logic_vector(N-1 downto 0);
    output : out std_logic_vector(N-1 downto 0)
    );
end reggen;

architecture async_reg of reggen is
begin
    reg_out : process(clk, reset)
    begin
        if reset = '1' then
            output <= (others => '0');
        elsif rising_edge(clk) then
            output <= input;
        end if;
    end process;
end async_reg;
