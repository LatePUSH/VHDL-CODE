library IEEE;
use IEEE.std_logic_1164.all;

entity buffer_3_etats is
port(
en : in std_logic;
din: in std_logic;
dout : out std_logic
);
end buffer_3_etats;

architecture archi of buffer_3_etats is 

begin
process(en,din)
begin
if en = '1' then
	dout <= din;
else
	dout <= 'Z';
end if;
end process;
end archi;
