library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity compteur is
    Port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        enable : in  std_logic;
        s_out  : out std_logic_vector(3 downto 0)
    );
end compteur;

architecture arch of compteur is
    signal valeur : std_logic_vector(3 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            valeur <= "0000";             -- Reset asynchrone
        elsif rising_edge(clk) then
            if enable = '1' then
                valeur <= valeur + 1;     -- Incrémentation synchrone
            end if;
        end if;
    end process;

    s_out <= valeur;
end arch;