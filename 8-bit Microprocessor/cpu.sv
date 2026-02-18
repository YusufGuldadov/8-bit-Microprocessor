module cpu(
input wire [3:0] nibble_ir,
input wire i_sel, y_sel, x_sel, clk, sync_reset,
input wire [3:0] source_sel,
input wire [8:0] reg_en, 
input wire [3:0] dm,
input wire [4:0] i_pins, 
output reg [3:0] o_reg, 
output reg [3:0] data_bus,
output reg [3:0] i,
output reg [3:0] x0,
output reg [3:0] x1,
output reg [3:0] y0,
output reg [3:0] y1,
output reg [3:0] r,
output reg [3:0] m,
output reg r_eq_0, 
output reg [7:0] from_CU
);

/*
always @ *
// from_CU = 8'h00; //Uppon enetring to exam this should be uncommented 
*/

always @ *
from_CU={x1, x0};


reg reset_output, ir_3, alu_out_eq_0;
reg [2:0] alu_func;
reg [3:0] pm_data, x, y, alu_out;

reg [3:0] ir_nibble;

always @ (*)
ir_nibble=nibble_ir;
always @ (*)
pm_data<=ir_nibble;

////////////////////////////// i register////////////////////////// 

always @ (posedge clk) 
if(reg_en[6])
if(i_sel)
i<=i+m;
else
i<=data_bus;

////////////////////////////// m register////////////////////////// 
always @ (posedge clk)
if(reg_en[5])
m<=data_bus;

////////////////////////////// o register////////////////////////// 
always @ (posedge clk)
if(reg_en[8])
o_reg<=data_bus;

////////////////////////////// x0 register////////////////////////// 
always @ (posedge clk)
if(reg_en[0])
x0<=data_bus;

////////////////////////////// x1 register////////////////////////// 
always @ (posedge clk)
if(reg_en[1])
x1<=data_bus;


always @ *
if(x_sel)
x<=x1;
else
x<=x0;

////////////////////////////// y0 register////////////////////////// 
always @ (posedge clk)
if(reg_en[2])
y0<=data_bus;

////////////////////////////// y1 register////////////////////////// 
always @ (posedge clk)
if(reg_en[3])
y1<=data_bus;


always @ *
if(y_sel)
y<=y1;
else
y<=y0;


////////////////////////////// r register////////////////////////// 
always @ (posedge clk)

if(reg_en[4])
r<=alu_out;


////////////////////////////// r_eq_0 register////////////////////////// 
always @ (posedge clk)
if(reg_en[4])
r_eq_0<=alu_out_eq_0;

///////////////////////////// source_sel ////////////////////////////////////////////// 
always @ *
case(source_sel)
	4'h0 : data_bus<=x0;
	4'h1 : data_bus<=x1;
	4'h2 : data_bus<=y0;
	4'h3 : data_bus<=y1;
	4'h4 : data_bus<=r;
	4'h5 : data_bus<=m;
	4'h6 : data_bus<=i;
	4'h7 : data_bus<=dm;
	4'h8 : data_bus<=pm_data;
	4'h9 : data_bus<=i_pins;
	default : data_bus<=4'h0;
endcase

//////////////////////////////////////////////////////// ALU unit /////////////////////////////////////////////////

reg [7:0] temp_8_bit;

always @ (*)
reset_output<=sync_reset;

always @ (*)
ir_3<=ir_nibble[3];

always @ (*)
alu_func<=ir_nibble[2:0];


always @ *
if(alu_out==1'b0)
alu_out_eq_0=1'b1;
else
alu_out_eq_0=1'b0;


//if(reset_output)
//alu_out_eq_0=1;
//else if(alu_func[2:0]==3'b000 && ir_3==1'b0)
//if(x==4'h0)
//alu_out_eq_0=1;
//else 
//alu_out_eq_0=0;
//else if(alu_func[2:0]==3'b000 && ir_3==1'b1)
//alu_out_eq_0=alu_out_eq_0;
//else if(alu_func[2:0]==3'b111 && ir_3==1'b0)
//if(x==4'hF)
//alu_out_eq_0=1;
//else 
//alu_out_eq_0=0; 
//else if(alu_func[2:0]==3'b111 && ir_3==1'b1)
//alu_out_eq_0=alu_out_eq_0;




always @ (*)
if(reset_output)
alu_out<=4'h0;
else if(alu_func[2:0]==3'b000 && ir_3==1'b0)
alu_out<=-x;
else if(alu_func[2:0]==3'b000 && ir_3==1'b1)
alu_out<=r; 
else if(alu_func[2:0]==3'b001)
alu_out=x-y;
else if(alu_func[2:0]==3'b010)
alu_out=x+y;
else if(alu_func[2:0]==3'b011)
begin
temp_8_bit=x*y;
alu_out=temp_8_bit[7:4];
end 
else if(alu_func[2:0]==3'b100)
begin
temp_8_bit=x*y;
alu_out=temp_8_bit[3:0];
end
else if(alu_func[2:0]==3'b101)
alu_out=x^y;
else if(alu_func[2:0]==3'b110)
alu_out=x&y;
else if(alu_func[2:0]==3'b111 && ir_3==1'b0)
alu_out<=~x;
else if(alu_func[2:0]==3'b111 && ir_3==1'b1)
alu_out<=r;





endmodule