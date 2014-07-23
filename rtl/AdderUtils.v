//Generate and Propagate add
module GP_Adder (
iGi_j1,
iPi_j1,
iGj_k,
iPj_k,
oGi_k,
oPi_k
);
input  iGi_j1; //iG(i,j+1)
input  iPi_j1; //iP(i,j+1)
input  iGj_k;  //iG(j,k)
input  iPj_k;  //iP(j,k)
output oGi_k;
output oPi_k;

reg    oGi_k;
reg    oPi_k;

always @(*) begin
    oGi_k = iGi_j1 + ( iGj_k & iPi_j1);
    oPi_k = iPi_j1 & iPj_k;
end 

endmodule 

module GP_Buf (
iBufP,
iBufG,
oBufP,
oBufG
);
input  iBufP;
input  iBufG;
output oBufP;
output oBufG;

buf (oBufP, iBufP);
buf (oBufG, iBufG);

endmodule 

module FFD_POSEDGE_ASYNC_ENABLE_RESET # ( parameter SIZE=`WIDTH )
	(
	input wire clk,
	input wire resetn, 
    input wire enable,
	input wire [SIZE-1:0] D,
	output reg [SIZE-1:0] Q
	); 
 
  always @(posedge clk or negedge resetn) begin 
	   if (~resetn)  
        Q <= 0; 
      else 
        if (enable)
            Q <= D; 
    end 
endmodule 

module FFD_POSEDGE_ASYNC_RESET # ( parameter SIZE=`WIDTH )
	(
	input wire clk,
	input wire resetn, 
	input wire [SIZE-1:0] D,
	output reg [SIZE-1:0] Q
	); 
 
  always @(posedge clk or negedge resetn) begin 
	   if (~resetn)  
        Q <= 0; 
      else 
            Q <= D; 
    end 
endmodule 

