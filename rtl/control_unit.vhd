library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is
    port(
        opcode      : in  std_logic_vector(5 downto 0);
        func_field  : in  std_logic_vector(5 downto 0);
        reg_write   : out std_logic;
        reg_dst     : out std_logic;
        reg_in_src  : out std_logic;
        alu_src     : out std_logic;
        add_sub     : out std_logic;
        data_write  : out std_logic;
        logic_func  : out std_logic_vector(1 downto 0);
        func        : out std_logic_vector(1 downto 0);
        branch_type : out std_logic_vector(1 downto 0);
        pc_sel      : out std_logic_vector(1 downto 0)
    );
end control_unit;

architecture rtl of control_unit is
begin
    process(opcode, func_field)
    begin
        reg_write   <= '0';
        reg_dst     <= '0';
        reg_in_src  <= '1';
        alu_src     <= '0';
        add_sub     <= '0';
        data_write  <= '0';
        logic_func  <= "00";
        func        <= "10";
        branch_type <= "00";
        pc_sel      <= "00";

        case opcode is
            when "000000" =>
                case func_field is
                    when "100000" =>
                        reg_write <= '1'; reg_dst <= '1'; reg_in_src <= '1';
                        alu_src <= '0'; add_sub <= '0'; func <= "10";
                    when "100010" =>
                        reg_write <= '1'; reg_dst <= '1'; reg_in_src <= '1';
                        alu_src <= '0'; add_sub <= '1'; func <= "10";
                    when "101010" =>
                        reg_write <= '1'; reg_dst <= '1'; reg_in_src <= '1';
                        alu_src <= '0'; add_sub <= '1'; func <= "01";
                    when "100100" =>
                        reg_write <= '1'; reg_dst <= '1'; reg_in_src <= '1';
                        alu_src <= '0'; logic_func <= "00"; func <= "11";
                    when "100101" =>
                        reg_write <= '1'; reg_dst <= '1'; reg_in_src <= '1';
                        alu_src <= '0'; logic_func <= "01"; func <= "11";
                    when "100110" =>
                        reg_write <= '1'; reg_dst <= '1'; reg_in_src <= '1';
                        alu_src <= '0'; logic_func <= "10"; func <= "11";
                    when "100111" =>
                        reg_write <= '1'; reg_dst <= '1'; reg_in_src <= '1';
                        alu_src <= '0'; logic_func <= "11"; func <= "11";
                    when "001000" =>
                        pc_sel <= "10";
                    when others => null;
                end case;

            when "001111" =>
                reg_write <= '1'; reg_dst <= '0'; reg_in_src <= '1';
                alu_src <= '1'; func <= "00";
            when "001000" =>
                reg_write <= '1'; reg_dst <= '0'; reg_in_src <= '1';
                alu_src <= '1'; add_sub <= '0'; func <= "10";
            when "001010" =>
                reg_write <= '1'; reg_dst <= '0'; reg_in_src <= '1';
                alu_src <= '1'; add_sub <= '1'; func <= "01";
            when "001100" =>
                reg_write <= '1'; reg_dst <= '0'; reg_in_src <= '1';
                alu_src <= '1'; logic_func <= "00"; func <= "11";
            when "001101" =>
                reg_write <= '1'; reg_dst <= '0'; reg_in_src <= '1';
                alu_src <= '1'; logic_func <= "01"; func <= "11";
            when "001110" =>
                reg_write <= '1'; reg_dst <= '0'; reg_in_src <= '1';
                alu_src <= '1'; logic_func <= "10"; func <= "11";
            when "100011" =>
                reg_write <= '1'; reg_dst <= '0'; reg_in_src <= '0';
                alu_src <= '1'; add_sub <= '0'; func <= "10";
            when "101011" =>
                reg_write <= '0'; alu_src <= '1';
                add_sub <= '0'; data_write <= '1'; func <= "10";
            when "000010" =>
                pc_sel <= "01";
            when "000001" =>
                branch_type <= "11";
            when "000100" =>
                add_sub <= '1'; func <= "10"; branch_type <= "01";
            when "000101" =>
                add_sub <= '1'; func <= "10"; branch_type <= "10";
            when others => null;
        end case;
    end process;
end rtl;