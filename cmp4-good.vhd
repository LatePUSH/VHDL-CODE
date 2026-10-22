library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cmp4 is
  port(a, b       : in  std_logic_vector(3 downto 0);
       sp, ep, ip : in  std_logic;
       s, e, i    : out std_logic);
end cmp4;

architecture combinatoire of cmp4 is
signal sei : std_logic_vector(2 downto 0);
begin
    sei <= sp & ep & ip;
    s <= '1' when sei = "100" or ( sei = "010" and a > b) else '0';
    e <= '1' when sei = "010" and a = b else '0';
    i <= '1' when sei = "001" or ( sei = "010" and a < b) else '0';
end combinatoire;
