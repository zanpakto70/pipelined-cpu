library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port(
        x, y       : in  std_logic_vector(31 downto 0);
        add_sub    : in  std_logic;
        logic_func : in  std_logic_vector(1 downto 0);
        func       : in  std_logic_vector(1 downto 0);
        output     : out std_logic_vector(31 downto 0);
        overflow   : out std_logic;
        zero       : out std_logic
    );
end alu;

architecture rtl of alu is
    signal add_sub_res, x_in, y_in, logic_out, zero_comparator : signed(31 downto 0);
    signal add_sub_msb : signed(31 downto 0) := (others => '0');
begin
    x_in <= signed(x);
    y_in <= signed(y);
    zero_comparator <= (others => '0');
    add_sub_msb(0) <= add_sub_res(31);

    add_sub_res <= x_in + y_in when add_sub = '0' else
                   x_in - y_in;

    with logic_func select
        logic_out <= x_in and y_in when "00",
                     x_in or  y_in when "01",
                     x_in xor y_in when "10",
                     x_in nor y_in when others;

    with func select
        output <= std_logic_vector(y_in)          when "00",
                  std_logic_vector(add_sub_msb)   when "01",
                  std_logic_vector(add_sub_res)   when "10",
                  std_logic_vector(logic_out)     when others;

    zero <= '1' when add_sub_res = zero_comparator else '0';

    overflow <= '1' when
        (add_sub = '0' and x_in(31) = '0' and y_in(31) = '0' and add_sub_res(31) = '1') or
        (add_sub = '0' and x_in(31) = '1' and y_in(31) = '1' and add_sub_res(31) = '0') or
        (add_sub = '1' and x_in(31) = '0' and y_in(31) = '1' and add_sub_res(31) = '1') or
        (add_sub = '1' and x_in(31) = '1' and y_in(31) = '0' and add_sub_res(31) = '0')
    else '0';
end;