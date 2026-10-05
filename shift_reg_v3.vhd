Library ieee;
use ieee.std_logic_1164.all;

entity shift_reg_v3 is
    Port ( clk : in  std_logic;
		   reset : in std_logic;
           din : in  std_logic_vector(7 downto 0);
           dout : out  std_logic_vector(7 downto 0));
end shift_reg_v3;

architecture Behavioral of shift_reg_v3 is
BEGIN
	PROCESS(clk,reset)	
	VARIABLE vint : std_logic_vector(7 downto 0);
	BEGIN
		if reset='1' then
			dout <=  "00000000";
			vint :=  "00000000";
		elsif rising_edge(clk) then
				vint := din;
				dout <= vint;
		end if;	
	END PROCESS;
end Behavioral;