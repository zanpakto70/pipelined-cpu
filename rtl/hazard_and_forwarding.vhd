library IEEE;
use IEEE.std_logic_1164.all;

entity hazard_detection_unit is
    port(
        id_ex_reg_in_src  : in  std_logic;
        id_ex_rt_addr     : in  std_logic_vector(4 downto 0);
        if_id_rs_addr     : in  std_logic_vector(4 downto 0);
        if_id_rt_addr     : in  std_logic_vector(4 downto 0);
        stall             : out std_logic;
        id_ex_flush       : out std_logic
    );
end hazard_detection_unit;

architecture rtl of hazard_detection_unit is
begin
    process(id_ex_reg_in_src, id_ex_rt_addr, if_id_rs_addr, if_id_rt_addr)
    begin
        if (id_ex_reg_in_src = '0') and
           (id_ex_rt_addr /= "00000") and
           ((id_ex_rt_addr = if_id_rs_addr) or
            (id_ex_rt_addr = if_id_rt_addr)) then
            stall       <= '1';
            id_ex_flush <= '1';
        else
            stall       <= '0';
            id_ex_flush <= '0';
        end if;
    end process;
end rtl;


library IEEE;
use IEEE.std_logic_1164.all;

entity forwarding_unit is
    port(
        ex_rs_addr     : in  std_logic_vector(4 downto 0);
        ex_rt_addr     : in  std_logic_vector(4 downto 0);
        mem_reg_write  : in  std_logic;
        mem_write_addr : in  std_logic_vector(4 downto 0);
        wb_reg_write   : in  std_logic;
        wb_write_addr  : in  std_logic_vector(4 downto 0);
        forward_a      : out std_logic_vector(1 downto 0);
        forward_b      : out std_logic_vector(1 downto 0)
    );
end forwarding_unit;

architecture rtl of forwarding_unit is
begin
    process(ex_rs_addr, mem_reg_write, mem_write_addr, wb_reg_write, wb_write_addr)
    begin
        if (mem_reg_write = '1') and
           (mem_write_addr /= "00000") and
           (mem_write_addr = ex_rs_addr) then
            forward_a <= "10";
        elsif (wb_reg_write = '1') and
              (wb_write_addr /= "00000") and
              (wb_write_addr = ex_rs_addr) then
            forward_a <= "01";
        else
            forward_a <= "00";
        end if;
    end process;

    process(ex_rt_addr, mem_reg_write, mem_write_addr, wb_reg_write, wb_write_addr)
    begin
        if (mem_reg_write = '1') and
           (mem_write_addr /= "00000") and
           (mem_write_addr = ex_rt_addr) then
            forward_b <= "10";
        elsif (wb_reg_write = '1') and
              (wb_write_addr /= "00000") and
              (wb_write_addr = ex_rt_addr) then
            forward_b <= "01";
        else
            forward_b <= "00";
        end if;
    end process;
end rtl;