library IEEE;
use IEEE.std_logic_1164.all;

entity ex_mem_reg is
    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        ex_reg_write     : in  std_logic;
        ex_reg_in_src    : in  std_logic;
        ex_data_write    : in  std_logic;
        ex_alu_result    : in  std_logic_vector(31 downto 0);
        ex_rt_val        : in  std_logic_vector(31 downto 0);
        ex_write_addr    : in  std_logic_vector(4 downto 0);
        mem_reg_write    : out std_logic;
        mem_reg_in_src   : out std_logic;
        mem_data_write   : out std_logic;
        mem_alu_result   : out std_logic_vector(31 downto 0);
        mem_rt_val       : out std_logic_vector(31 downto 0);
        mem_write_addr   : out std_logic_vector(4 downto 0)
    );
end ex_mem_reg;

architecture rtl of ex_mem_reg is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            mem_reg_write  <= '0'; mem_reg_in_src <= '0'; mem_data_write <= '0';
            mem_alu_result <= (others => '0');
            mem_rt_val     <= (others => '0');
            mem_write_addr <= (others => '0');
        elsif rising_edge(clk) then
            mem_reg_write  <= ex_reg_write;
            mem_reg_in_src <= ex_reg_in_src;
            mem_data_write <= ex_data_write;
            mem_alu_result <= ex_alu_result;
            mem_rt_val     <= ex_rt_val;
            mem_write_addr <= ex_write_addr;
        end if;
    end process;
end rtl;
