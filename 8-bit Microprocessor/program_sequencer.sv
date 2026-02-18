module program_sequencer(input wire clk, sync_reset, dont_jmp, jmp,jmp_nz,
input wire[3:0] jmp_addr,
output reg [7:0] pm_addr,
output reg [7:0] pc, 
output reg [7:0] from_PS
);

 
//assign from_PS = 8'h0;  // when we enter to exam this should be uncommented 

always @ *
from_PS=pc;  // only for preamble ;


always @ (posedge clk)
pc=pm_addr;

always @ (*)
if(sync_reset)
pm_addr=8'd0;
else if((jmp==1) || ((jmp_nz==1) && (dont_jmp == 0)))
begin
pm_addr[3:0] = 4'h0;
pm_addr[7:4] = jmp_addr;
end 
else
pm_addr=pc+8'h1;

endmodule