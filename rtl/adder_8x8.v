//Author     : Alex Zhang(cgzhangwei@gmail.com)
//Date       : Jul.13.2014
//Desciption : Brent-Kung 8 bits adder Implementation
//             The resource is reused partly
`define WIDTH 8
module Adder8BitBrentKung(
clk,
resetn,
iValid,
iCarryIn,
iX,
iY,
oZ,
oCarryOut,
oReady
);
input  clk;
input  resetn;
input  iValid;
input  iCarryIn;
input  iX;
input  iY;
output oZ;
output oCarryOut;
output oReady;
parameter N= 8;

wire  [N-1:0] iX;
wire  [N-1:0] iY;
wire  [N-1:0] oZ;
wire          oReady;
wire          oCarryOut;

wire  [N-1:0] p,g;
wire  [N-1:0] wX, wY;

FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_X (
  .clk(clk),
  .resetn(resetn),
  .D(iX),
  .Q(wX)
);
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_Y (
  .clk(clk),
  .resetn(resetn),
  .D(iY),
  .Q(wY)
);

wire wValidPP1;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay1 (
  .clk(clk),
  .resetn(resetn),
  .D(iValid),
  .Q(wValidPP1)
);
genvar i;
generate for (i=0; i<N; i++) begin :pg_cla
    assign p[i] = wX[i]^wY[i];
    assign g[i] = wX[i]&wY[i];
end endgenerate 

//Stage 1
wire [N-1:0] p1,g1;

GP_Buf   gp1Buf0   (.iBufG( g[0]), .oBufG(g1[0]), .iBufP(p[0]), .oBufP(p1[0]));
GP_Adder gp1Adder1 (.iGi_j1(g[1]), .iPi_j1(p[1]), .iGj_k(g[0]), .iPj_k( p[0]), .oGi_k(g1[1]), .oPi_k(p1[1]));
GP_Buf   gp1Buf2   (.iBufG( g[2]), .oBufG(g1[2]), .iBufP(p[2]), .oBufP(p1[2]));
GP_Adder gp1Adder3 (.iGi_j1(g[3]), .iPi_j1(p[3]), .iGj_k(g[2]), .iPj_k( p[2]), .oGi_k(g1[3]), .oPi_k(p1[3]));
GP_Buf   gp1Buf4   (.iBufG( g[4]), .oBufG(g1[4]), .iBufP(p[4]), .oBufP(p1[4]));
GP_Adder gp1Adder5 (.iGi_j1(g[5]), .iPi_j1(p[5]), .iGj_k(g[4]), .iPj_k( p[4]), .oGi_k(g1[5]), .oPi_k(p1[5]));
GP_Buf   gp1Buf6   (.iBufG( g[6]), .oBufG(g1[6]), .iBufP(p[6]), .oBufP(p1[6]));
GP_Adder gp1Adder7 (.iGi_j1(g[7]), .iPi_j1(p[7]), .iGj_k(g[6]), .iPj_k( p[6]), .oGi_k(g1[7]), .oPi_k(p1[7]));

//Stage 2
wire  [N-1:0] p2, g2;
GP_Buf   gp2Buf0   (.iBufG( g1[0]), .oBufG( g2[0]), .iBufP(p1[0]), .oBufP(p2[0]));
GP_Buf   gp2Buf1   (.iBufG( g1[1]), .oBufG( g2[1]), .iBufP(p1[1]), .oBufP(p2[1]));
GP_Buf   gp2Buf2   (.iBufG( g1[2]), .oBufG( g2[2]), .iBufP(p1[2]), .oBufP(p2[2]));
GP_Adder gp2Adder3 (.iGi_j1(g1[3]), .iPi_j1(p1[3]), .iGj_k(g1[1]), .iPj_k(p1[1]), .oGi_k(g2[3]), .oPi_k(p2[3]));
GP_Buf   gp2Buf4   (.iBufG( g1[4]), .oBufG( g2[4]), .iBufP(p1[4]), .oBufP(p2[4]));
GP_Buf   gp2Buf5   (.iBufG( g1[5]), .oBufG( g2[5]), .iBufP(p1[5]), .oBufP(p2[5]));
GP_Buf   gp2Buf6   (.iBufG( g1[6]), .oBufG( g2[6]), .iBufP(p1[6]), .oBufP(p2[6]));
GP_Adder gp2Adder7 (.iGi_j1(g1[7]), .iPi_j1(p1[7]), .iGj_k(g1[5]), .iPj_k(p1[5]), .oGi_k(g2[7]), .oPi_k(p2[7]));

//Insert the D-FlipFlops to form pipeline 
wire  [N-1:0] p2_pp, g2_pp;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P1 (
  .clk(clk),
  .resetn(resetn),
  .D(p2),
  .Q(p2_pp)
);

FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G1 (
  .clk(clk),
  .resetn(resetn),
  .D(g2),
  .Q(g2_pp)
);
//Pipeline the p for the sum 
wire [N-1:0] p_pp;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP (
  .clk(clk),
  .resetn(resetn),
  .D(p),
  .Q(p_pp)
);

//Stage 3 
wire [N-1:0] p3, g3;
GP_Buf   gp3Buf0   (.iBufG( g2_pp[0]), .oBufG(    g3[0]), .iBufP(p2_pp[0]), .oBufP(   p3[0]));
GP_Buf   gp3Buf1   (.iBufG( g2_pp[1]), .oBufG(    g3[1]), .iBufP(p2_pp[1]), .oBufP(   p3[1]));
GP_Adder gp3Adder2 (.iGi_j1(g2_pp[2]), .iPi_j1(p2_pp[2]), .iGj_k(g2_pp[1]), .iPj_k(p2_pp[1]), .oGi_k(g3[2]), .oPi_k(p3[2]));
GP_Buf   gp3Buf3   (.iBufG( g2_pp[3]), .oBufG(    g3[3]), .iBufP(p2_pp[3]), .oBufP(   p3[3]));
GP_Buf   gp3Buf4   (.iBufG( g2_pp[4]), .oBufG(    g3[4]), .iBufP(p2_pp[4]), .oBufP(   p3[4]));
GP_Adder gp3Adder5 (.iGi_j1(g2_pp[5]), .iPi_j1(p2_pp[5]), .iGj_k(g2_pp[3]), .iPj_k(p2_pp[3]), .oGi_k(g3[5]), .oPi_k(p3[5]));
GP_Buf   gp3Buf6   (.iBufG( g2_pp[6]), .oBufG(    g3[6]), .iBufP(p2_pp[6]), .oBufP(   p3[6]));
GP_Adder gp3Adder7 (.iGi_j1(g2_pp[7]), .iPi_j1(p2_pp[7]), .iGj_k(g2_pp[3]), .iPj_k(p2_pp[3]), .oGi_k(g3[7]), .oPi_k(p3[7]));

//Stage 4
wire [N-1:0] p4,g4;
GP_Buf   gp4Buf0   (.iBufG( g3[0]), .oBufG( g4[0]), .iBufP(p3[0]), .oBufP(p4[0]));
GP_Buf   gp4Buf1   (.iBufG( g3[1]), .oBufG( g4[1]), .iBufP(p3[1]), .oBufP(p4[1]));
GP_Buf   gp4Buf2   (.iBufG( g3[2]), .oBufG( g4[2]), .iBufP(p3[2]), .oBufP(p4[2]));
GP_Buf   gp4Buf3   (.iBufG( g3[3]), .oBufG( g4[3]), .iBufP(p3[3]), .oBufP(p4[3]));
GP_Adder gp3Adder4 (.iGi_j1(g3[4]), .iPi_j1(p3[4]), .iGj_k(g3[3]), .iPj_k(p3[3]), .oGi_k(g4[4]), .oPi_k(p4[4]));
GP_Buf   gp4Buf5   (.iBufG( g3[5]), .oBufG( g4[5]), .iBufP(p3[5]), .oBufP(p4[5]));
GP_Adder gp3Adder6 (.iGi_j1(g3[6]), .iPi_j1(p3[6]), .iGj_k(p3[5]), .iPj_k(p3[6]), .oGi_k(g4[6]), .oPi_k(p4[6]));
GP_Buf   gp4Buf7   (.iBufG( g3[7]), .oBufG( g4[7]), .iBufP(p3[7]), .oBufP(p4[7]));

//Output D-FlipFlop
wire wValidPP2;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay2 (
  .clk(clk),
  .resetn(resetn),
  .D(wValidPP1),
  .Q(wValidPP2)
);
wire  [N-1:0] p4_pp, g4_pp;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P2 (
  .clk(clk),
  .resetn(resetn),
  .D(p4),
  .Q(p4_pp)
);

FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G2 (
  .clk(clk),
  .resetn(resetn),
  .D(g4),
  .Q(g4_pp)
);

assign oZ[0] = p4[0];
generate for (i=1; i<N; i=i+1 ) begin 
    assign oZ [i] = p_pp[i]^ g4[i-1];
end endgenerate

assign oCarryOut = g4[N-1]; 
assign oReady    = wValidPP2;

endmodule 

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

