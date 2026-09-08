library IEEE;
use IEEE.std_logic_1164.all;

entity if_id_reg is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        stall       : in  std_logic;
        flush       : in  std_logic;
        if_pc_plus1 : in  std_logic_vector(31 downto 0);
        if_instr    : in  std_logic_vector(31 downto 0);
        id_pc_plus1 : out std_logic_vector(31 downto 0);
        id_instr    : out std_logic_vector(31 downto 0)
    );
end if_id_reg;

architecture rtl of if_id_reg is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            id_pc_plus1 <= (others => '0');
            id_instr    <= (others => '0');
        elsif rising_edge(clk) then
            if flush = '1' then
                id_pc_plus1 <= (others => '0');
                id_instr    <= (others => '0');
            elsif stall = '0' then
                id_pc_plus1 <= if_pc_plus1;
                id_instr    <= if_instr;
            end if;
        end if;
    end process;
end rtl;