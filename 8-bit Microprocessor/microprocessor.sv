module microprocessor (
output reg[3:0] o_reg,
output reg [7:0] pm_data, 
output reg [7:0] pc,
output reg [7:0] from_PS,
output reg [7:0] pm_address,
output reg [7:0]  ir,
output reg [7:0] from_ID, 
output reg [8:0] register_enables,
output reg NOPC8, NOPCF, NOPD8, NOPDF,
output reg [7:0] from_CU,
output reg [3:0] i,
output reg [3:0] x0,
output reg [3:0] x1,
output reg [3:0] y0,
output reg [3:0] y1,
output reg [3:0] r,
output reg [3:0] m,
output reg sync_reset, zero_flag,
input reg clk, reset, 
input reg[3:0] i_pins

);

reg jump, conditional_jump, i_mux_select, y_reg_select, x_reg_select;
reg [3:0] LS_nibble_ir, source_select, data_mem_addr, data_bus, dm; ///////////// i=data_mem_addr


always @ (posedge clk)
sync_reset=reset;



program_memory	program_memory_inst (
	.address (pm_address),
	.clock (~clk),
	.q (pm_data)
	);


instruction_decoder instr_decoder(.clk(clk), .sync_reset(sync_reset), 
.jmp(jump), .jmp_nz(conditional_jump),
 .ir_nibble(LS_nibble_ir), .i_sel(i_mux_select), .y_sel(y_reg_select), 
 .x_sel(x_reg_select), .source_sel(source_select), .reg_en(register_enables), .next_instr(pm_data), .ir(ir), .from_ID(from_ID), 
 .nopc8(NOPC8), .nopcf(NOPCF), .nopd8(NOPD8), .nopdf(NOPDF));
 
program_sequencer prog_sequencer(.clk(clk), .sync_reset(sync_reset), .pm_addr(pm_address), 
.jmp(jump), .jmp_nz(conditional_jump), .jmp_addr(LS_nibble_ir), 
.dont_jmp(zero_flag), .pc(pc), .from_PS(from_PS));

cpu comp_unit(.clk(clk), .sync_reset(sync_reset), .r_eq_0(zero_flag), .i_pins(i_pins), 
.nibble_ir(LS_nibble_ir), .i_sel(i_mux_select), .y_sel(y_reg_select), .x_sel(x_reg_select),
.source_sel(source_select), .reg_en(register_enables), 
.i(i), .data_bus(data_bus), .dm(dm), .o_reg(o_reg),
 .x0(x0), .x1(x1), .y0(y0), .y1(y1), .r(r), .m(m), .from_CU(from_CU));

RAM_1_Built data_mem(.clock(~clk), .address(i), .data(data_bus), .q(dm), .wren(register_enables[7]));


endmodule