add wave -radix binary   /cpu_pipelined/reset
add wave -radix binary   /cpu_pipelined/clk
add wave -radix unsigned /cpu_pipelined/if_pc_current
add wave -radix binary   /cpu_pipelined/if_instruction
add wave -radix decimal  /cpu_pipelined/id_rs_val
add wave -radix decimal  /cpu_pipelined/id_rt_val
add wave -radix decimal  /cpu_pipelined/ex_alu_result
add wave -radix decimal  /cpu_pipelined/wb_reg_d_in
add wave -radix unsigned /cpu_pipelined/wb_write_addr
add wave -radix binary   /cpu_pipelined/id_reg_write
add wave -radix binary   /cpu_pipelined/id_reg_dst
add wave -radix binary   /cpu_pipelined/id_reg_in_src
add wave -radix binary   /cpu_pipelined/id_alu_src
add wave -radix binary   /cpu_pipelined/id_add_sub
add wave -radix binary   /cpu_pipelined/id_data_write
add wave -radix binary   /cpu_pipelined/id_logic_func
add wave -radix binary   /cpu_pipelined/id_func
add wave -radix binary   /cpu_pipelined/id_branch_type
add wave -radix binary   /cpu_pipelined/id_pc_sel
add wave -radix decimal  /cpu_pipelined/id_sign_ext
add wave -radix decimal  /cpu_pipelined/mem_dcache_out
add wave -radix binary   /cpu_pipelined/ex_alu_overflow
add wave -radix binary   /cpu_pipelined/ex_alu_zero
add wave -radix binary   /cpu_pipelined/stall
add wave -radix binary   /cpu_pipelined/forward_a
add wave -radix binary   /cpu_pipelined/forward_b

force /cpu_pipelined/clk 0
force /cpu_pipelined/reset 1
run 20 ns
force /cpu_pipelined/reset 0

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns

force /cpu_pipelined/clk 1
run 10 ns
force /cpu_pipelined/clk 0
run 10 ns