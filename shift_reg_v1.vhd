library IEEE;
use IEEE.std_logic_1164.all;


entity shift_reg_v1 is
    Port ( clk : in  std_logic;
	       reset : in std_logic;
           din : in  std_logic_vector(7 downto 0);
           dout : out  std_logic_vector(7 downto 0));
end shift_reg_v1;

architecture Behavioral of shift_reg_v1 is
SIGNAL sint : std_logic_vector(7 downto 0);
BEGIN
	PROCESS(reset, clk)	
	BEGIN
		if (reset= '1' ) then
			dout <=  "00000000";
			sint <=  "00000000";
		elsif rising_edge(clk) then
			sint <= din;
			dout <= sint;		
		end if;
	END PROCESS;
end Behavioral;



