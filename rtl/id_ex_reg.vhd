library IEEE;
use IEEE.std_logic_1164.all;

entity id_ex_reg is
    port(
        clk             : in  std_logic;
        reset           : in  std_logic;
        flush           : in  std_logic;
        id_reg_write    : in  std_logic;
        id_reg_dst      : in  std_logic;
        id_reg_in_src   : in  std_logic;
        id_alu_src      : in  std_logic;
        id_add_sub      : in  std_logic;
        id_data_write   : in  std_logic;
        id_logic_func   : in  std_logic_vector(1 downto 0);
        id_func         : in  std_logic_vector(1 downto 0);
        id_branch_type  : in  std_logic_vector(1 downto 0);
        id_pc_sel       : in  std_logic_vector(1 downto 0);
        id_rs_val       : in  std_logic_vector(31 downto 0);
        id_rt_val       : in  std_logic_vector(31 downto 0);
        id_sign_ext     : in  std_logic_vector(31 downto 0);
        id_rs_addr      : in  std_logic_vector(4 downto 0);
        id_rt_addr      : in  std_logic_vector(4 downto 0);
        id_rd_addr      : in  std_logic_vector(4 downto 0);
        id_pc_plus1     : in  std_logic_vector(31 downto 0);
        ex_reg_write    : out std_logic;
        ex_reg_dst      : out std_logic;
        ex_reg_in_src   : out std_logic;
        ex_alu_src      : out std_logic;
        ex_add_sub      : out std_logic;
        ex_data_write   : out std_logic;
        ex_logic_func   : out std_logic_vector(1 downto 0);
        ex_func         : out std_logic_vector(1 downto 0);
        ex_branch_type  : out std_logic_vector(1 downto 0);
        ex_pc_sel       : out std_logic_vector(1 downto 0);
        ex_rs_val       : out std_logic_vector(31 downto 0);
        ex_rt_val       : out std_logic_vector(31 downto 0);
        ex_sign_ext     : out std_logic_vector(31 downto 0);
        ex_rs_addr      : out std_logic_vector(4 downto 0);
        ex_rt_addr      : out std_logic_vector(4 downto 0);
        ex_rd_addr      : out std_logic_vector(4 downto 0);
        ex_pc_plus1     : out std_logic_vector(31 downto 0)
    );
end id_ex_reg;

architecture rtl of id_ex_reg is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            ex_reg_write <= '0'; ex_reg_dst <= '0'; ex_reg_in_src <= '0';
            ex_alu_src <= '0'; ex_add_sub <= '0'; ex_data_write <= '0';
            ex_logic_func <= "00"; ex_func <= "00";
            ex_branch_type <= "00"; ex_pc_sel <= "00";
            ex_rs_val <= (others => '0'); ex_rt_val <= (others => '0');
            ex_sign_ext <= (others => '0'); ex_pc_plus1 <= (others => '0');
            ex_rs_addr <= (others => '0'); ex_rt_addr <= (others => '0');
            ex_rd_addr <= (others => '0');
        elsif rising_edge(clk) then
            if flush = '1' then
                ex_reg_write <= '0'; ex_reg_dst <= '0'; ex_reg_in_src <= '0';
                ex_alu_src <= '0'; ex_add_sub <= '0'; ex_data_write <= '0';
                ex_logic_func <= "00"; ex_func <= "00";
                ex_branch_type <= "00"; ex_pc_sel <= "00";
                ex_rs_val <= (others => '0'); ex_rt_val <= (others => '0');
                ex_sign_ext <= (others => '0'); ex_pc_plus1 <= (others => '0');
                ex_rs_addr <= (others => '0'); ex_rt_addr <= (others => '0');
                ex_rd_addr <= (others => '0');
            else
                ex_reg_write   <= id_reg_write;
                ex_reg_dst     <= id_reg_dst;
                ex_reg_in_src  <= id_reg_in_src;
                ex_alu_src     <= id_alu_src;
                ex_add_sub     <= id_add_sub;
                ex_data_write  <= id_data_write;
                ex_logic_func  <= id_logic_func;
                ex_func        <= id_func;
                ex_branch_type <= id_branch_type;
                ex_pc_sel      <= id_pc_sel;
                ex_rs_val      <= id_rs_val;
                ex_rt_val      <= id_rt_val;
                ex_sign_ext    <= id_sign_ext;
                ex_rs_addr     <= id_rs_addr;
                ex_rt_addr     <= id_rt_addr;
                ex_rd_addr     <= id_rd_addr;
                ex_pc_plus1    <= id_pc_plus1;
            end if;
        end if;
    end process;
end rtl;