library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dcache is
    port(
        clk        : in  std_logic;
        reset      : in  std_logic;
        data_write : in  std_logic;
        addr       : in  std_logic_vector(4 downto 0);
        d_in       : in  std_logic_vector(31 downto 0);
        d_out      : out std_logic_vector(31 downto 0)
    );
end dcache;

architecture rtl of dcache is
    type mem_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal memory : mem_array;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            for i in 0 to 31 loop
                memory(i) <= (others => '0');
            end loop;
        elsif rising_edge(clk) then
            if data_write = '1' then
                memory(to_integer(unsigned(addr))) <= d_in;
            end if;
        end if;
    end process;

    d_out <= memory(to_integer(unsigned(addr)));
end rtl;