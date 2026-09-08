library IEEE;
use IEEE.std_logic_1164.all;

entity sign_extend is
    port(
        immediate : in  std_logic_vector(15 downto 0);
        func      : in  std_logic_vector(1 downto 0);
        extended  : out std_logic_vector(31 downto 0)
    );
end sign_extend;

architecture rtl of sign_extend is
begin
    process(immediate, func)
    begin
        case func is
            when "00"   => extended <= immediate & x"0000";
            when "01"   => extended <= (31 downto 16 => immediate(15)) & immediate;
            when "10"   => extended <= (31 downto 16 => immediate(15)) & immediate;
            when "11"   => extended <= x"0000" & immediate;
            when others => extended <= (others => '0');
        end case;
    end process;
end rtl;