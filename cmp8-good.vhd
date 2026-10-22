
library ieee;
use ieee.std_logic_1164.all;

entity cmp8 is
  port(
    a, b       : in  std_logic_vector(7 downto 0);
    reset, clk : in  std_logic;
    s, e, i    : out std_logic
    );
end cmp8;

architecture struct of cmp8 is
  component cmp4
    port(a, b       : in  std_logic_vector(3 downto 0);
         sp, ep, ip : in  std_logic;
         s, e, i    : out std_logic);
  end component;

  component reggen
    generic(N : positive := 1);
    port(clk, reset : in  std_logic;
         input      : in  std_logic_vector(N-1 downto 0);
         output     : out std_logic_vector(N-1 downto 0));
  end component;

  signal a_r, b_r               : std_logic_vector(7 downto 0);
  signal s_low, e_low, i_low    : std_logic;
  signal s_high, e_high, i_high : std_logic;
begin
  reg_a : reggen generic map ( N => 8 )
  port map(
    clk    => clk,
    reset  => reset,
    input  => a,
    output => a_r);
  reg_b : reggen generic map( N => 8)
  port map(
    clk    => clk,
    reset  => reset,
    input  => b,
    output => b_r
    );
  reg_s_out : reggen generic map (N => 1)
  port map(
    clk => clk,
    reset => reset,
    input(0) => s_low,
    output(0) => s
  );
  reg_e_out : reggen generic map (N => 1)
  port map(
    clk => clk,
    reset => reset,
    input(0) => e_low,
    output(0) => e
  );
  reg_i_out : reggen generic map (N => 1)
  port map(
    clk => clk,
    reset => reset,
    input(0) => i_low,
    output(0) => i
  );
   cmp_high_nibble : cmp4 port map(
    a  => a_r(7 downto 4), b => b_r(7 downto 4),
    sp => '0', ep => '1', ip => '0',
    s  => s_high, e => e_high, i => i_high
    );
  cmp_low_nibble : cmp4 port map(
    a  => a_r(3 downto 0), b => b_r(3 downto 0),
    sp => s_high, ep => e_high, ip => i_high,
    s  => s_low, e => e_low, i => i_low
    );
end struct;
