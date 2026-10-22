-- Banc de test de cmp4, comparateur 4 bits combinatoire cascade.
-- Codes et sorties dans l'ordre S, E, I : code = SP EP IP, sorties = S E I.
-- Scénario :
--   1) IP = 1 seul (code 001, "inférieur déjà décidé") : S = E = 0, I = 1,
--      indépendamment de A et B.
--   2) SP = 1 seul (code 100, "supérieur déjà décidé") : S = 1, E = I = 0,
--      indépendamment de A et B.
--   3) EP = 1 seul (code 010, "égal jusqu'ici") : le bloc compare A et B,
--      A > B donne S, A = B donne E, A < B donne I.
--   4) codes invalides 000, 011, 101, 110, 111 : S = E = I = 0 quels que soient A et B.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity cmp4_tb is
end cmp4_tb;

architecture scenario of cmp4_tb is
    signal a, b       : std_logic_vector(3 downto 0) := "0000";
    signal sp, ep, ip : std_logic := '0';
    signal s, e, i    : std_logic;
    signal sei        : std_logic_vector(2 downto 0);
begin
    dut : entity work.cmp4
    port map(a => a, b => b, sp => sp, ep => ep, ip => ip, s => s, e => e, i => i);
    sei <= s & e & i;


    test_cmp4 : process
        procedure check(item : in string; expected_sei : in std_logic_vector(2 downto 0)) is
        begin
          assert sei = expected_sei
            report item & " SEI=" & std_logic'image(s) & std_logic'image(e) & std_logic'image(i)
            severity error;
        end procedure;

        procedure test_case(item : in string; code : in std_logic_vector(2 downto 0);
                        va, vb : in natural; expected_sei : in std_logic_vector(2 downto 0)) is
        begin
          sp <= code(2); ep <= code(1); ip <= code(0);
          a <= conv_std_logic_vector(va, 4);
          b <= conv_std_logic_vector(vb, 4);
          wait for 10 ns;  -- pas d'horloge : on laisse la logique se stabiliser
          check(item, expected_sei);
        end procedure;


        begin
        -- 1) IP = 1 seul : la décision reçue passe, A et B ne comptent pas
        for va in 0 to 15 loop
          for vb in 0 to 15 loop
            test_case("1) code 001", "001", va, vb, "001");
          end loop;
        end loop;

        -- 2) SP = 1 seul : idem dans l'autre sens
        for va in 0 to 15 loop
          for vb in 0 to 15 loop
            test_case("2) code 100", "100", va, vb, "100");
          end loop;
        end loop;

        -- 3) EP = 1 seul : le bloc compare A et B
        for va in 0 to 15 loop
          for vb in 0 to 15 loop
            if va > vb then
              test_case("3) code 010", "010", va, vb, "100");
            elsif va = vb then
              test_case("3) code 010", "010", va, vb, "010");
            else
              test_case("3) code 010", "010", va, vb, "001");
            end if;
          end loop;
        end loop;

        -- 4) codes invalides : tous les codes sauf 001 (1), 010 (2) et 100 (4)
        for c in 0 to 7 loop
          if c /= 1 and c /= 2 and c /= 4 then
            for va in 0 to 15 loop
              for vb in 0 to 15 loop
                test_case("4) code invalide", conv_std_logic_vector(c, 3), va, vb, "000");
              end loop;
            end loop;
          end if;
        end loop;
        wait;
      end process;


end architecture scenario;
