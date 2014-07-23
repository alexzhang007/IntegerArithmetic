//Author    : Alex Zhang (cgzhangwei@gmail.com)
//Date      : 07-22-2014

`define WIDTH 16
module Adder16BitBrentKung(
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
parameter N=16;
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
GP_Adder gp1Adder1 (.iGi_j1(g[1]), .iPi_j1(p[1]), .iGj_k(g[0]), .iPj_k( p[0]), .oGi_k(g1[1]), .oPi_k(p1[1]));
GP_Buf   gp1Buf2   (.iBufG( g[2]), .oBufG(g1[2]), .iBufP(p[2]), .oBufP(p1[2]));
GP_Adder gp1Adder3 (.iGi_j1(g[3]), .iPi_j1(p[3]), .iGj_k(g[2]), .iPj_k( p[2]), .oGi_k(g1[3]), .oPi_k(p1[3]));
GP_Buf   gp1Buf4   (.iBufG( g[4]), .oBufG(g1[4]), .iBufP(p[4]), .oBufP(p1[4]));
GP_Adder gp1Adder5 (.iGi_j1(g[5]), .iPi_j1(p[5]), .iGj_k(g[4]), .iPj_k( p[4]), .oGi_k(g1[5]), .oPi_k(p1[5]));
GP_Buf   gp1Buf6   (.iBufG( g[6]), .oBufG(g1[6]), .iBufP(p[6]), .oBufP(p1[6]));
GP_Adder gp1Adder7 (.iGi_j1(g[7]), .iPi_j1(p[7]), .iGj_k(g[6]), .iPj_k( p[6]), .oGi_k(g1[7]), .oPi_k(p1[7]));
GP_Buf   gp1Buf8   (.iBufG( g[8]), .oBufG(g1[8]), .iBufP(p[8]), .oBufP(p1[8]));
GP_Adder gp1Adder9 (.iGi_j1(g[9]), .iPi_j1(p[9]), .iGj_k(g[8]), .iPj_k( p[8]), .oGi_k(g1[9]), .oPi_k(p1[9]));
GP_Buf   gp1Buf10   (.iBufG( g[10]), .oBufG(g1[10]), .iBufP(p[10]), .oBufP(p1[10]));
GP_Adder gp1Adder11 (.iGi_j1(g[11]), .iPi_j1(p[11]), .iGj_k(g[10]), .iPj_k( p[10]), .oGi_k(g1[11]), .oPi_k(p1[11]));
GP_Buf   gp1Buf12   (.iBufG( g[12]), .oBufG(g1[12]), .iBufP(p[12]), .oBufP(p1[12]));
GP_Adder gp1Adder13 (.iGi_j1(g[13]), .iPi_j1(p[13]), .iGj_k(g[12]), .iPj_k( p[12]), .oGi_k(g1[13]), .oPi_k(p1[13]));
GP_Buf   gp1Buf14   (.iBufG( g[14]), .oBufG(g1[14]), .iBufP(p[14]), .oBufP(p1[14]));
GP_Adder gp1Adder15 (.iGi_j1(g[15]), .iPi_j1(p[15]), .iGj_k(g[14]), .iPj_k( p[14]), .oGi_k(g1[15]), .oPi_k(p1[15]));
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
GP_Buf   gp2Buf8   (.iBufG( g1[8]), .oBufG( g2[8]), .iBufP(p1[8]), .oBufP(p2[8]));
GP_Buf   gp2Buf9   (.iBufG( g1[9]), .oBufG( g2[9]), .iBufP(p1[9]), .oBufP(p2[9]));
GP_Buf   gp2Buf10   (.iBufG( g1[10]), .oBufG( g2[10]), .iBufP(p1[10]), .oBufP(p2[10]));
GP_Adder gp2Adder11 (.iGi_j1(g1[11]), .iPi_j1(p1[11]), .iGj_k(g1[9]), .iPj_k(p1[9]), .oGi_k(g2[11]), .oPi_k(p2[11]));
GP_Buf   gp2Buf12   (.iBufG( g1[12]), .oBufG( g2[12]), .iBufP(p1[12]), .oBufP(p2[12]));
GP_Buf   gp2Buf13   (.iBufG( g1[13]), .oBufG( g2[13]), .iBufP(p1[13]), .oBufP(p2[13]));
GP_Buf   gp2Buf14   (.iBufG( g1[14]), .oBufG( g2[14]), .iBufP(p1[14]), .oBufP(p2[14]));
GP_Adder gp2Adder15 (.iGi_j1(g1[15]), .iPi_j1(p1[15]), .iGj_k(g1[13]), .iPj_k(p1[13]), .oGi_k(g2[15]), .oPi_k(p2[15]));
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
wire [N-1:0] p_pp1;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP1 (
  .clk(clk),
  .resetn(resetn),
  .D(p),
  .Q(p_pp1)
);
//Stage 3
wire  [N-1:0] p3, g3;
GP_Buf   gp3Buf0   (.iBufG( g2_pp[0]), .oBufG( g3[0]), .iBufP(p2_pp[0]), .oBufP(p3[0]));
GP_Buf   gp3Buf1   (.iBufG( g2_pp[1]), .oBufG( g3[1]), .iBufP(p2_pp[1]), .oBufP(p3[1]));
GP_Buf   gp3Buf2   (.iBufG( g2_pp[2]), .oBufG( g3[2]), .iBufP(p2_pp[2]), .oBufP(p3[2]));
GP_Buf   gp3Buf3   (.iBufG( g2_pp[3]), .oBufG( g3[3]), .iBufP(p2_pp[3]), .oBufP(p3[3]));
GP_Buf   gp3Buf4   (.iBufG( g2_pp[4]), .oBufG( g3[4]), .iBufP(p2_pp[4]), .oBufP(p3[4]));
GP_Buf   gp3Buf5   (.iBufG( g2_pp[5]), .oBufG( g3[5]), .iBufP(p2_pp[5]), .oBufP(p3[5]));
GP_Buf   gp3Buf6   (.iBufG( g2_pp[6]), .oBufG( g3[6]), .iBufP(p2_pp[6]), .oBufP(p3[6]));
GP_Adder gp3Adder7 (.iGi_j1(g2_pp[7]), .iPi_j1(p2_pp[7]), .iGj_k(g2_pp[3]), .iPj_k(p2_pp[3]), .oGi_k(g3[7]), .oPi_k(p3[7]));
GP_Buf   gp3Buf8   (.iBufG( g2_pp[8]), .oBufG( g3[8]), .iBufP(p2_pp[8]), .oBufP(p3[8]));
GP_Buf   gp3Buf9   (.iBufG( g2_pp[9]), .oBufG( g3[9]), .iBufP(p2_pp[9]), .oBufP(p3[9]));
GP_Buf   gp3Buf10   (.iBufG( g2_pp[10]), .oBufG( g3[10]), .iBufP(p2_pp[10]), .oBufP(p3[10]));
GP_Buf   gp3Buf11   (.iBufG( g2_pp[11]), .oBufG( g3[11]), .iBufP(p2_pp[11]), .oBufP(p3[11]));
GP_Buf   gp3Buf12   (.iBufG( g2_pp[12]), .oBufG( g3[12]), .iBufP(p2_pp[12]), .oBufP(p3[12]));
GP_Buf   gp3Buf13   (.iBufG( g2_pp[13]), .oBufG( g3[13]), .iBufP(p2_pp[13]), .oBufP(p3[13]));
GP_Buf   gp3Buf14   (.iBufG( g2_pp[14]), .oBufG( g3[14]), .iBufP(p2_pp[14]), .oBufP(p3[14]));
GP_Adder gp3Adder15 (.iGi_j1(g2_pp[15]), .iPi_j1(p2_pp[15]), .iGj_k(g2_pp[11]), .iPj_k(p2_pp[11]), .oGi_k(g3[15]), .oPi_k(p3[15]));
//Stage 4
wire  [N-1:0] p4, g4;
GP_Buf   gp4Buf0   (.iBufG( g2_pp[0]), .oBufG( g3[0]), .iBufP(p2_pp[0]), .oBufP(p3[0]));
GP_Buf   gp4Buf1   (.iBufG( g2_pp[1]), .oBufG( g3[1]), .iBufP(p2_pp[1]), .oBufP(p3[1]));
GP_Buf   gp4Buf2   (.iBufG( g2_pp[2]), .oBufG( g3[2]), .iBufP(p2_pp[2]), .oBufP(p3[2]));
GP_Buf   gp4Buf3   (.iBufG( g2_pp[3]), .oBufG( g3[3]), .iBufP(p2_pp[3]), .oBufP(p3[3]));
GP_Buf   gp4Buf4   (.iBufG( g2_pp[4]), .oBufG( g3[4]), .iBufP(p2_pp[4]), .oBufP(p3[4]));
GP_Buf   gp4Buf5   (.iBufG( g2_pp[5]), .oBufG( g3[5]), .iBufP(p2_pp[5]), .oBufP(p3[5]));
GP_Buf   gp4Buf6   (.iBufG( g2_pp[6]), .oBufG( g3[6]), .iBufP(p2_pp[6]), .oBufP(p3[6]));
GP_Buf   gp4Buf7   (.iBufG( g2_pp[7]), .oBufG( g3[7]), .iBufP(p2_pp[7]), .oBufP(p3[7]));
GP_Buf   gp4Buf8   (.iBufG( g2_pp[8]), .oBufG( g3[8]), .iBufP(p2_pp[8]), .oBufP(p3[8]));
GP_Buf   gp4Buf9   (.iBufG( g2_pp[9]), .oBufG( g3[9]), .iBufP(p2_pp[9]), .oBufP(p3[9]));
GP_Buf   gp4Buf10   (.iBufG( g2_pp[10]), .oBufG( g3[10]), .iBufP(p2_pp[10]), .oBufP(p3[10]));
GP_Buf   gp4Buf11   (.iBufG( g2_pp[11]), .oBufG( g3[11]), .iBufP(p2_pp[11]), .oBufP(p3[11]));
GP_Buf   gp4Buf12   (.iBufG( g2_pp[12]), .oBufG( g3[12]), .iBufP(p2_pp[12]), .oBufP(p3[12]));
GP_Buf   gp4Buf13   (.iBufG( g2_pp[13]), .oBufG( g3[13]), .iBufP(p2_pp[13]), .oBufP(p3[13]));
GP_Buf   gp4Buf14   (.iBufG( g2_pp[14]), .oBufG( g3[14]), .iBufP(p2_pp[14]), .oBufP(p3[14]));
GP_Adder gp4Adder15 (.iGi_j1(g2_pp[15]), .iPi_j1(p2_pp[15]), .iGj_k(g2_pp[7]), .iPj_k(p2_pp[7]), .oGi_k(g3[15]), .oPi_k(p3[15]));
endmodule 
