library IEEE;
use IEEE.std_logic_1164.all;

entity mem_wb_reg is
    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        mem_reg_write    : in  std_logic;
        mem_reg_in_src   : in  std_logic;
        mem_alu_result   : in  std_logic_vector(31 downto 0);
        mem_dcache_out   : in  std_logic_vector(31 downto 0);
        mem_write_addr   : in  std_logic_vector(4 downto 0);
        wb_reg_write     : out std_logic;
        wb_reg_in_src    : out std_logic;
        wb_alu_result    : out std_logic_vector(31 downto 0);
        wb_dcache_out    : out std_logic_vector(31 downto 0);
        wb_write_addr    : out std_logic_vector(4 downto 0)
    );
end mem_wb_reg;

architecture rtl of mem_wb_reg is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            wb_reg_write  <= '0'; wb_reg_in_src <= '0';
            wb_alu_result <= (others => '0');
            wb_dcache_out <= (others => '0');
            wb_write_addr <= (others => '0');
        elsif rising_edge(clk) then
            wb_reg_write  <= mem_reg_write;
            wb_reg_in_src <= mem_reg_in_src;
            wb_alu_result <= mem_alu_result;
            wb_dcache_out <= mem_dcache_out;
            wb_write_addr <= mem_write_addr;
        end if;
    end process;
end rtl;