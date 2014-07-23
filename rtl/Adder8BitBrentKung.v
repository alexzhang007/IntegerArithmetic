//Author    : Alex Zhang (cgzhangwei@gmail.com)
//Date      : 07-22-2014

`define WIDTH 8
module Adder8BitBrentKung(
clk, resetn,
iValid,iCarryIn
iX,iY,
oZ,oCarryOut,oReady
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
parameter N=8;
wire [N-1:0] iX;
wire [N-1:0] iY;
wire [N-1:0] oZ;
wire         oReady;
wire         oCarryOut;
//Input DFFwire [N-1:0] p,g,wX,wY;
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
wire [N-1:0] p1, g1;
GP_Buf   gp1Buf0   (.iBufG( g[0]), .oBufG(g1[0]), .iBufP(p[0]), .oBufP(p1[0]));
GP_Adder gp1Adder1 (.iGi_j1(g[(0+1)]), .iPi_j1(p[0+1]), .iGj_k(g[0]), .iPj_k( p[0]), .oGi_k(g1[0+1]), .oPi_k(p1[0+1]));
GP_Buf   gp1Buf0   (.iBufG( g[2]), .oBufG(g1[2]), .iBufP(p[2]), .oBufP(p1[2]));
GP_Adder gp1Adder1 (.iGi_j1(g[(2+1)]), .iPi_j1(p[2+1]), .iGj_k(g[2]), .iPj_k( p[2]), .oGi_k(g1[2+1]), .oPi_k(p1[2+1]));
GP_Buf   gp1Buf0   (.iBufG( g[4]), .oBufG(g1[4]), .iBufP(p[4]), .oBufP(p1[4]));
GP_Adder gp1Adder1 (.iGi_j1(g[(4+1)]), .iPi_j1(p[4+1]), .iGj_k(g[4]), .iPj_k( p[4]), .oGi_k(g1[4+1]), .oPi_k(p1[4+1]));
GP_Buf   gp1Buf0   (.iBufG( g[6]), .oBufG(g1[6]), .iBufP(p[6]), .oBufP(p1[6]));
GP_Adder gp1Adder1 (.iGi_j1(g[(6+1)]), .iPi_j1(p[6+1]), .iGj_k(g[6]), .iPj_k( p[6]), .oGi_k(g1[6+1]), .oPi_k(p1[6+1]));
endmodule 
