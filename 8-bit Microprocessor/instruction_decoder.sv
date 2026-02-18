module instruction_decoder(
input clk, sync_reset,
input [7:0] next_instr,
output reg jmp, jmp_nz, i_sel, x_sel, y_sel, 
output reg [3:0] ir_nibble,
output reg [3:0] source_sel,
output reg [8:0] reg_en,
output reg [7:0]  ir,
output reg [7:0] from_ID, 
output reg nopc8, nopcf, nopd8, nopdf
);


/*
always @ *
from_ID=8'h0; // When enetering exam this should be uncommented 
*/

always @ *
from_ID=reg_en[7:0];  // Only for preamble, should be removed uppon entering exam 


always @ (posedge clk)
ir <= next_instr;



/////////////////////// ir_nibble //////////////////////////////////////////////
always @ *
ir_nibble <= ir[3:0]; 



////////////////////// i_sel //////////////////////////////////////////////////
always @ *
if(sync_reset == 1'b1)
i_sel<=1'b0;
else if((ir[7]==1'b0 &&  ir[6:4] == 3'h6) || (ir[5:3]==3'h6 && ir[7:6]==2'h2))
i_sel<=1'b0;
else 
i_sel<=1'b1;


////////////////////////////////  y_sel and x_sel ////////////////////////////////// 
always @ *
if(sync_reset == 1'b1)
begin 
x_sel <= 1'b0;
y_sel <= 1'b0;
end
else
begin
x_sel <= ir[4];
y_sel <= ir[3];
end 

////////////////////////////  JUMP ///////////////////////////////////////
always @ *
if(sync_reset == 1'b1)
jmp <= 1'b0;
else if( ir[7:4] == 4'HE)
jmp <= 1'b1;
else
jmp<=1'b0;

/////////////////////////////// JUMP_NOT_ZERO //////////////////////////////////
always @ * 
if(sync_reset == 1'b1)
jmp_nz <= 1'b0;
else if(ir[7:4] == 4'Hf)
jmp_nz <= 1'b1;
else 
jmp_nz<=1'b0;


/////////////////////////// source_sel ////////////////////////////////////////////////////
always @ *
if(sync_reset == 1'b1)
source_sel<=4'd10;
else if(ir[7]==1'b0)
source_sel<=4'd8;
else if(ir[7:6]==2'h2 ) /////////////////// i_pin handle  
if(ir[5:3] ==3'h4 && ir[2:0]==3'h4)
source_sel<=4'h4;
else if(ir[5:3] == ir[2:0])
source_sel<=4'h9;
else
source_sel <= {1'b0, ir[2:0]};
else
source_sel <=4'd10; 



////////////////////////// reg_en[0] ////////////////////////////////////////////////////
always @ * 
if(sync_reset == 1'b1)
reg_en[0] <= 1'b1;
else if(ir[7]==1'b0 && ir[6:4]==3'd0)
reg_en[0] <= 1'b1;
else if ((ir[7:6] == 2'b10) && (ir[5:3] == 3'd0))
reg_en[0] <= 1'b1;
else 
reg_en[0] <= 1'b0;




////////////////////////// reg_en[1] ////////////////////////////////////////////////////
always @ * 
if(sync_reset == 1'b1)
reg_en[1] <= 1'b1;
else if(ir[7]==1'b0 && ir[6:4]==3'h1)
reg_en[1] <= 1'b1;
else if ((ir[7:6] == 2'b10) && (ir[5:3] == 3'h1))
reg_en[1] <= 1'b1;
else 
reg_en[1] <= 1'b0;



////////////////////////// reg_en[2] ////////////////////////////////////////////////////
always @ *  
if(sync_reset == 1'b1)
reg_en[2] <= 1'b1;
else if(ir[7]==1'b0 && ir[6:4]==3'h2)
reg_en[2] <= 1'b1;
else if ((ir[7:6] == 2'b10) && (ir[5:3] == 3'h2))
reg_en[2] <= 1'b1;
else 
reg_en[2] <= 1'b0;




////////////////////////// reg_en[3] ////////////////////////////////////////////////////
always @ * 
if(sync_reset == 1'b1)
reg_en[3] <= 1'b1;
else if(ir[7]==1'b0 && ir[6:4]==3'h3)
reg_en[3] <= 1'b1;
else if ((ir[7:6] == 2'b10) && (ir[5:3] == 3'h3))
reg_en[3] <= 1'b1;
else 
reg_en[3] <= 1'b0;


////////////////////// reg_en[4] ///////////////////////////////////////////////
always @ * 
if(sync_reset == 1'b1)
reg_en[4] <= 1'b1;
else if(ir[7:5] == 3'd6)
reg_en[4] <= 1'b1;
else
reg_en[4] <= 1'b0;



////////////////////////// reg_en[5] ////////////////////////////////////////////////////
always @ * 
if(sync_reset == 1'b1)
reg_en[5] <= 1'b1;
else if(ir[7]==1'b0 && ir[6:4]==3'h5)
reg_en[5] <= 1'b1;
else if ((ir[7:6] == 2'b10) && (ir[5:3] == 3'h5))
reg_en[5] <= 1'b1;
else 
reg_en[5] <= 1'b0;




////////////////////////// reg_en[6] ////////////////////////////////////////////////////
always @ * 
if(sync_reset == 1'b1)
reg_en[6] = 1'b1;
else if(ir[7:4] == 4'b0110)
reg_en[6] <= 1'b1;
else if(ir[7:4] == 4'b0111)
reg_en[6] <= 1'b1;
else if(ir[7:3] == 5'b10110)
reg_en[6] <= 1'b1;
else if(ir[7:6] == 2'b10 && (ir[5:3]==3'd7 || ir[2:0]==3'd7))
reg_en[6] <= 1'b1;
else
reg_en[6] <= 1'b0;


///////////////////////////////// reg_en[7]  ////////////////////////////////////////////////////
always @ * 
if(sync_reset == 1'b1)
reg_en[7] <= 1'b1;
else if(ir[7] == 1'b0 && ir[6:4]== 3'd7)
reg_en[7] <= 1'b1;
else if((ir[7:6] == 2'b10) && (ir[5:3] == 3'd7))
reg_en[7] <= 1'b1;
else 
reg_en[7] <= 1'b0;



////////////////////////// reg_en[8] ////////////////////////////////////////////////////
always @ * 
if(sync_reset == 1'b1)
reg_en[8] <= 1'b1;
else if(ir[7] == 1'b0 && ir[6:4]== 3'h4)
reg_en[8] <= 1'b1;
else if((ir[7:6] == 2'b10) && (ir[5:3] == 3'h4))
reg_en[8] <= 1'b1;
else 
reg_en[8] <= 1'b0;


/////////////////////////////////////////  NOP's ////////////////////////////////////////////////////////////// 

always @ *
if(ir==8'hc8)
nopc8=1'b1;
else 
nopc8=1'b0;

always @ *
if(ir==8'hcf)
nopcf=1'b1;
else 
nopcf=1'b0;


always @ *
if(ir==8'hd8)
nopd8=1'b1;
else 
nopd8=1'b0;


always @ *
if(ir==8'hdf)
nopdf=1'b1;
else 
nopdf=1'b0;



endmodule