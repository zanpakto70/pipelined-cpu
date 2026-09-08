library IEEE;
use IEEE.std_logic_1164.all;

entity icache is
	port(
    	addr 	: in  std_logic_vector(4 downto 0);
    	data_out : out std_logic_vector(31 downto 0)
	);
end icache;

architecture rtl of icache is
begin
	process(addr)
	begin
    	case addr is

        	-- 00: addi r1, r0, 5   	r1 = 5
        	when "00000" => data_out <= "00100000000000010000000000000101";
        	-- 01: addi r2, r0, 3   	r2 = 3
        	when "00001" => data_out <= "00100000000000100000000000000011";
        	-- 02: add r3, r1, r2   	r3 = 8
        	when "00010" => data_out <= "00000000001000100001100000100000";
        	-- 03: sub r4, r1, r2   	r4 = 2
        	when "00011" => data_out <= "00000000001000100010000000100010";
        	-- 04: and r5, r1, r2   	r5 = 1
        	when "00100" => data_out <= "00000000001000100010100000100100";
        	-- 05: or r6, r1, r2    	r6 = 7
        	when "00101" => data_out <= "00000000001000100011000000100101";
        	-- 06: slt r7, r2, r1   	r7 = 1 (3 < 5)
        	when "00110" => data_out <= "00000000010000010011100000101010";
        	-- 07: sw r3, 0(r0)     	mem[0] = 8
        	when "00111" => data_out <= "10101100000000110000000000000000";
        	-- 08: lw r8, 0(r0)     	r8 = mem[0] = 8
        	when "01000" => data_out <= "10001100000010000000000000000000";
        	-- 09: beq r1, r2, +1   	not taken (5 != 3)
        	when "01001" => data_out <= "00010000001000100000000000000001";
        	-- 10: bne r1, r2, +1   	taken (5 != 3), skips to 12
        	when "01010" => data_out <= "00010100001000100000000000000001";
        	-- 11: nop (skipped by bne)
        	when "01011" => data_out <= "00000000000000000000000000000000";
        	-- 12: addi r9, r0, -1  	r9 = -1
        	when "01100" => data_out <= "00100000000010011111111111111111";
        	-- 13: bltz r9, +1      	taken (r9 < 0), skips to 15
        	when "01101" => data_out <= "00000101001000000000000000000001";
        	-- 14: nop (skipped by bltz)
        	when "01110" => data_out <= "00000000000000000000000000000000";
        	-- 15: xor r10, r1, r2  	r10 = 6
        	when "01111" => data_out <= "00000000001000100101000000100110";
        	-- 16: nor r11, r1, r2  	r11 = NOT(5 OR 3)
        	when "10000" => data_out <= "00000000001000100101100000100111";
        	-- 17: andi r12, r1, 3  	r12 = 1
        	when "10001" => data_out <= "00110000001011000000000000000011";
        	-- 18: ori r13, r1, 3   	r13 = 7
        	when "10010" => data_out <= "00110100001011010000000000000011";
        	-- 19: lui r14, 1       	r14 = 0x00010000
        	when "10011" => data_out <= "00111100000011100000000000000001";
        	-- 20: slti r15, r1, 10 	r15 = 1 (5 < 10)
        	when "10100" => data_out <= "00101000001011110000000000001010";
        	-- 21: xori r16, r1, 7  	r16 = 2
        	when "10101" => data_out <= "00111000001100000000000000000111";
        	-- 22: j 0              	loop back to start
        	when "10110" => data_out <= "00001000000000000000000000000000";
        	when others  => data_out <= (others => '0');
    	end case;
	end process;
end rtl;
