library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu_pipelined is
    port(
        reset    : in  std_logic;
        clk      : in  std_logic;
        pc_out   : out std_logic_vector(3 downto 0);
        overflow : out std_logic;
        zero     : out std_logic
    );
end cpu_pipelined;

architecture rtl of cpu_pipelined is

    component pc_reg is
        port(
            clk    : in  std_logic;
            reset  : in  std_logic;
            pc_in  : in  std_logic_vector(31 downto 0);
            pc_out : out std_logic_vector(31 downto 0)
        );
    end component;

    component icache is
        port(
            addr     : in  std_logic_vector(4 downto 0);
            data_out : out std_logic_vector(31 downto 0)
        );
    end component;

    component regfile is
        port(
            din           : in  std_logic_vector(31 downto 0);
            reset         : in  std_logic;
            clk           : in  std_logic;
            write         : in  std_logic;
            read_a        : in  std_logic_vector(4 downto 0);
            read_b        : in  std_logic_vector(4 downto 0);
            write_address : in  std_logic_vector(4 downto 0);
            out_a         : out std_logic_vector(31 downto 0);
            out_b         : out std_logic_vector(31 downto 0)
        );
    end component;

    component alu is
        port(
            x          : in  std_logic_vector(31 downto 0);
            y          : in  std_logic_vector(31 downto 0);
            add_sub    : in  std_logic;
            logic_func : in  std_logic_vector(1 downto 0);
            func       : in  std_logic_vector(1 downto 0);
            output     : out std_logic_vector(31 downto 0);
            overflow   : out std_logic;
            zero       : out std_logic
        );
    end component;

    component sign_extend is
        port(
            immediate : in  std_logic_vector(15 downto 0);
            func      : in  std_logic_vector(1 downto 0);
            extended  : out std_logic_vector(31 downto 0)
        );
    end component;

    component dcache is
        port(
            clk        : in  std_logic;
            reset      : in  std_logic;
            data_write : in  std_logic;
            addr       : in  std_logic_vector(4 downto 0);
            d_in       : in  std_logic_vector(31 downto 0);
            d_out      : out std_logic_vector(31 downto 0)
        );
    end component;

    component control_unit is
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
    end component;

    component if_id_reg is
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
    end component;

    component id_ex_reg is
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
    end component;

    component ex_mem_reg is
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
    end component;

    component mem_wb_reg is
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
    end component;

    component hazard_detection_unit is
        port(
            id_ex_reg_in_src  : in  std_logic;
            id_ex_rt_addr     : in  std_logic_vector(4 downto 0);
            if_id_rs_addr     : in  std_logic_vector(4 downto 0);
            if_id_rt_addr     : in  std_logic_vector(4 downto 0);
            stall             : out std_logic;
            id_ex_flush       : out std_logic
        );
    end component;

    component forwarding_unit is
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
    end component;

    -- IF stage
    signal if_pc_current   : std_logic_vector(31 downto 0);
    signal if_pc_plus1     : std_logic_vector(31 downto 0);
    signal if_pc_next      : std_logic_vector(31 downto 0);
    signal if_instruction  : std_logic_vector(31 downto 0);

    -- Hazard / flush
    signal stall           : std_logic;
    signal if_id_flush     : std_logic;
    signal id_ex_flush_lw  : std_logic;
    signal id_ex_flush_br  : std_logic;
    signal id_ex_flush     : std_logic;
    signal branch_or_jump  : std_logic;

    -- IF/ID outputs
    signal id_pc_plus1     : std_logic_vector(31 downto 0);
    signal id_instruction  : std_logic_vector(31 downto 0);

    -- ID stage
    signal id_opcode       : std_logic_vector(5 downto 0);
    signal id_rs_addr      : std_logic_vector(4 downto 0);
    signal id_rt_addr      : std_logic_vector(4 downto 0);
    signal id_rd_addr      : std_logic_vector(4 downto 0);
    signal id_func_field   : std_logic_vector(5 downto 0);
    signal id_imm_field    : std_logic_vector(15 downto 0);
    signal id_reg_write    : std_logic;
    signal id_reg_dst      : std_logic;
    signal id_reg_in_src   : std_logic;
    signal id_alu_src      : std_logic;
    signal id_add_sub      : std_logic;
    signal id_data_write   : std_logic;
    signal id_logic_func   : std_logic_vector(1 downto 0);
    signal id_func         : std_logic_vector(1 downto 0);
    signal id_branch_type  : std_logic_vector(1 downto 0);
    signal id_pc_sel       : std_logic_vector(1 downto 0);
    signal id_rs_val       : std_logic_vector(31 downto 0);
    signal id_rt_val       : std_logic_vector(31 downto 0);
    signal id_sign_ext     : std_logic_vector(31 downto 0);

    -- ID/EX outputs
    signal ex_reg_write    : std_logic;
    signal ex_reg_dst      : std_logic;
    signal ex_reg_in_src   : std_logic;
    signal ex_alu_src      : std_logic;
    signal ex_add_sub      : std_logic;
    signal ex_data_write   : std_logic;
    signal ex_logic_func   : std_logic_vector(1 downto 0);
    signal ex_func         : std_logic_vector(1 downto 0);
    signal ex_branch_type  : std_logic_vector(1 downto 0);
    signal ex_pc_sel       : std_logic_vector(1 downto 0);
    signal ex_rs_val       : std_logic_vector(31 downto 0);
    signal ex_rt_val       : std_logic_vector(31 downto 0);
    signal ex_sign_ext     : std_logic_vector(31 downto 0);
    signal ex_rs_addr      : std_logic_vector(4 downto 0);
    signal ex_rt_addr      : std_logic_vector(4 downto 0);
    signal ex_rd_addr      : std_logic_vector(4 downto 0);
    signal ex_pc_plus1     : std_logic_vector(31 downto 0);

    -- EX stage
    signal forward_a       : std_logic_vector(1 downto 0);
    signal forward_b       : std_logic_vector(1 downto 0);
    signal ex_alu_a        : std_logic_vector(31 downto 0);
    signal ex_alu_b_fwd    : std_logic_vector(31 downto 0);
    signal ex_alu_b        : std_logic_vector(31 downto 0);
    signal ex_alu_result   : std_logic_vector(31 downto 0);
    signal ex_alu_overflow : std_logic;
    signal ex_alu_zero     : std_logic;
    signal ex_write_addr   : std_logic_vector(4 downto 0);
    signal ex_branch_taken : std_logic;
    signal ex_br_true      : std_logic;
    signal ex_branch_target: std_logic_vector(31 downto 0);
    signal ex_jump_target  : std_logic_vector(31 downto 0);

    -- EX/MEM outputs
    signal mem_reg_write   : std_logic;
    signal mem_reg_in_src  : std_logic;
    signal mem_data_write  : std_logic;
    signal mem_alu_result  : std_logic_vector(31 downto 0);
    signal mem_rt_val      : std_logic_vector(31 downto 0);
    signal mem_write_addr  : std_logic_vector(4 downto 0);

    -- MEM stage
    signal mem_dcache_out  : std_logic_vector(31 downto 0);

    -- MEM/WB outputs
    signal wb_reg_write    : std_logic;
    signal wb_reg_in_src   : std_logic;
    signal wb_alu_result   : std_logic_vector(31 downto 0);
    signal wb_dcache_out   : std_logic_vector(31 downto 0);
    signal wb_write_addr   : std_logic_vector(4 downto 0);

    -- WB stage
    signal wb_reg_d_in     : std_logic_vector(31 downto 0);

begin

    -- IF stage
    if_pc_plus1    <= std_logic_vector(unsigned(if_pc_current) + 1);
    branch_or_jump <= ex_branch_taken or ex_pc_sel(1) or ex_pc_sel(0);

    if_pc_next <= if_pc_current    when stall = '1'           else
                  ex_jump_target   when ex_pc_sel = "01"      else
                  ex_alu_a         when ex_pc_sel = "10"      else
                  ex_branch_target when ex_branch_taken = '1' else
                  if_pc_plus1;

    U_PC: pc_reg port map(
        clk => clk, reset => reset,
        pc_in => if_pc_next, pc_out => if_pc_current
    );

    U_ICACHE: icache port map(
        addr => if_pc_current(4 downto 0), data_out => if_instruction
    );

    if_id_flush    <= branch_or_jump;
    id_ex_flush    <= id_ex_flush_lw or id_ex_flush_br;
    id_ex_flush_br <= branch_or_jump;

    U_IF_ID: if_id_reg port map(
        clk => clk, reset => reset, stall => stall, flush => if_id_flush,
        if_pc_plus1 => if_pc_plus1, if_instr => if_instruction,
        id_pc_plus1 => id_pc_plus1, id_instr => id_instruction
    );

    -- ID stage
    id_opcode     <= id_instruction(31 downto 26);
    id_rs_addr    <= id_instruction(25 downto 21);
    id_rt_addr    <= id_instruction(20 downto 16);
    id_rd_addr    <= id_instruction(15 downto 11);
    id_func_field <= id_instruction(5 downto 0);
    id_imm_field  <= id_instruction(15 downto 0);

    U_CONTROL: control_unit port map(
        opcode => id_opcode, func_field => id_func_field,
        reg_write => id_reg_write, reg_dst => id_reg_dst,
        reg_in_src => id_reg_in_src, alu_src => id_alu_src,
        add_sub => id_add_sub, data_write => id_data_write,
        logic_func => id_logic_func, func => id_func,
        branch_type => id_branch_type, pc_sel => id_pc_sel
    );

    U_REGFILE: regfile port map(
        din => wb_reg_d_in, reset => reset, clk => clk,
        write => wb_reg_write, read_a => id_rs_addr, read_b => id_rt_addr,
        write_address => wb_write_addr, out_a => id_rs_val, out_b => id_rt_val
    );

    U_SIGN_EXT: sign_extend port map(
        immediate => id_imm_field, func => id_func, extended => id_sign_ext
    );

    U_HAZARD: hazard_detection_unit port map(
        id_ex_reg_in_src => ex_reg_in_src, id_ex_rt_addr => ex_rt_addr,
        if_id_rs_addr => id_rs_addr, if_id_rt_addr => id_rt_addr,
        stall => stall, id_ex_flush => id_ex_flush_lw
    );

    U_ID_EX: id_ex_reg port map(
        clk => clk, reset => reset, flush => id_ex_flush,
        id_reg_write => id_reg_write, id_reg_dst => id_reg_dst,
        id_reg_in_src => id_reg_in_src, id_alu_src => id_alu_src,
        id_add_sub => id_add_sub, id_data_write => id_data_write,
        id_logic_func => id_logic_func, id_func => id_func,
        id_branch_type => id_branch_type, id_pc_sel => id_pc_sel,
        id_rs_val => id_rs_val, id_rt_val => id_rt_val,
        id_sign_ext => id_sign_ext, id_rs_addr => id_rs_addr,
        id_rt_addr => id_rt_addr, id_rd_addr => id_rd_addr,
        id_pc_plus1 => id_pc_plus1,
        ex_reg_write => ex_reg_write, ex_reg_dst => ex_reg_dst,
        ex_reg_in_src => ex_reg_in_src, ex_alu_src => ex_alu_src,
        ex_add_sub => ex_add_sub, ex_data_write => ex_data_write,
        ex_logic_func => ex_logic_func, ex_func => ex_func,
        ex_branch_type => ex_branch_type, ex_pc_sel => ex_pc_sel,
        ex_rs_val => ex_rs_val, ex_rt_val => ex_rt_val,
        ex_sign_ext => ex_sign_ext, ex_rs_addr => ex_rs_addr,
        ex_rt_addr => ex_rt_addr, ex_rd_addr => ex_rd_addr,
        ex_pc_plus1 => ex_pc_plus1
    );

    -- EX stage
    U_FORWARD: forwarding_unit port map(
        ex_rs_addr => ex_rs_addr, ex_rt_addr => ex_rt_addr,
        mem_reg_write => mem_reg_write, mem_write_addr => mem_write_addr,
        wb_reg_write => wb_reg_write, wb_write_addr => wb_write_addr,
        forward_a => forward_a, forward_b => forward_b
    );

    ex_alu_a     <= mem_alu_result when forward_a = "10" else
                    wb_reg_d_in    when forward_a = "01" else ex_rs_val;

    ex_alu_b_fwd <= mem_alu_result when forward_b = "10" else
                    wb_reg_d_in    when forward_b = "01" else ex_rt_val;

    ex_alu_b     <= ex_sign_ext when ex_alu_src = '1' else ex_alu_b_fwd;

    ex_write_addr <= ex_rd_addr when ex_reg_dst = '1' else ex_rt_addr;

    U_ALU: alu port map(
        x => ex_alu_a, y => ex_alu_b,
        add_sub => ex_add_sub, logic_func => ex_logic_func, func => ex_func,
        output => ex_alu_result, overflow => ex_alu_overflow, zero => ex_alu_zero
    );

    process(ex_branch_type, ex_alu_a, ex_alu_b_fwd)
    begin
        case ex_branch_type is
            when "01"   => ex_br_true <= '1' when ex_alu_a = ex_alu_b_fwd else '0';
            when "10"   => ex_br_true <= '1' when ex_alu_a /= ex_alu_b_fwd else '0';
            when "11"   => ex_br_true <= ex_alu_a(31);
            when others => ex_br_true <= '0';
        end case;
    end process;

    ex_branch_taken  <= ex_br_true;
    ex_branch_target <= std_logic_vector(unsigned(ex_pc_plus1) + unsigned(ex_sign_ext));
    ex_jump_target   <= "000000" & ex_sign_ext(25 downto 0);

    U_EX_MEM: ex_mem_reg port map(
        clk => clk, reset => reset,
        ex_reg_write => ex_reg_write, ex_reg_in_src => ex_reg_in_src,
        ex_data_write => ex_data_write, ex_alu_result => ex_alu_result,
        ex_rt_val => ex_alu_b_fwd, ex_write_addr => ex_write_addr,
        mem_reg_write => mem_reg_write, mem_reg_in_src => mem_reg_in_src,
        mem_data_write => mem_data_write, mem_alu_result => mem_alu_result,
        mem_rt_val => mem_rt_val, mem_write_addr => mem_write_addr
    );

    -- MEM stage
    U_DCACHE: dcache port map(
        clk => clk, reset => reset, data_write => mem_data_write,
        addr => mem_alu_result(4 downto 0), d_in => mem_rt_val,
        d_out => mem_dcache_out
    );

    U_MEM_WB: mem_wb_reg port map(
        clk => clk, reset => reset,
        mem_reg_write => mem_reg_write, mem_reg_in_src => mem_reg_in_src,
        mem_alu_result => mem_alu_result, mem_dcache_out => mem_dcache_out,
        mem_write_addr => mem_write_addr,
        wb_reg_write => wb_reg_write, wb_reg_in_src => wb_reg_in_src,
        wb_alu_result => wb_alu_result, wb_dcache_out => wb_dcache_out,
        wb_write_addr => wb_write_addr
    );

    -- WB stage
    wb_reg_d_in <= wb_alu_result when wb_reg_in_src = '1' else wb_dcache_out;

    pc_out   <= if_pc_current(3 downto 0);
    overflow <= ex_alu_overflow;
    zero     <= ex_alu_zero;

end rtl;