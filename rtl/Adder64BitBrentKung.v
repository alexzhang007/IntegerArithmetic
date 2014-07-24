//Author    : Alex Zhang (cgzhangwei@gmail.com)
//Date      : 07-23-2014

`define WIDTH 64
module Adder64BitBrentKung(
clk, resetn,
iValid,iCarryIn,
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
parameter N=64;
wire [N-1:0] iX;
wire [N-1:0] iY;
wire [N-1:0] oZ;
wire         oReady;
wire         oCarryOut;
//Input DFF
wire [N-1:0] p0,g0,wX,wY;
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
wire wCarryInPP1;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay1 (
  .clk(clk), 
  .resetn(resetn), 
  .D(iCarryIn), 
  .Q(wCarryInPP1) 
);
genvar i;         
generate for (i=0; i<N; i++) begin :pg_cla
    assign p0[i] = wX[i]^wY[i];
    assign g0[i] = wX[i]&wY[i];
end endgenerate 
//Insert the D-FlipFlop to fix the slack time=-0.07
wire [N-1:0] p,g;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P0 (
  .clk(clk),
  .resetn(resetn),
  .D(p0),
  .Q(p)
);

FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G0 (
  .clk(clk),
  .resetn(resetn),
  .D(g0),
  .Q(g)
);
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
GP_Buf   gp1Buf16   (.iBufG( g[16]), .oBufG(g1[16]), .iBufP(p[16]), .oBufP(p1[16]));
GP_Adder gp1Adder17 (.iGi_j1(g[17]), .iPi_j1(p[17]), .iGj_k(g[16]), .iPj_k( p[16]), .oGi_k(g1[17]), .oPi_k(p1[17]));
GP_Buf   gp1Buf18   (.iBufG( g[18]), .oBufG(g1[18]), .iBufP(p[18]), .oBufP(p1[18]));
GP_Adder gp1Adder19 (.iGi_j1(g[19]), .iPi_j1(p[19]), .iGj_k(g[18]), .iPj_k( p[18]), .oGi_k(g1[19]), .oPi_k(p1[19]));
GP_Buf   gp1Buf20   (.iBufG( g[20]), .oBufG(g1[20]), .iBufP(p[20]), .oBufP(p1[20]));
GP_Adder gp1Adder21 (.iGi_j1(g[21]), .iPi_j1(p[21]), .iGj_k(g[20]), .iPj_k( p[20]), .oGi_k(g1[21]), .oPi_k(p1[21]));
GP_Buf   gp1Buf22   (.iBufG( g[22]), .oBufG(g1[22]), .iBufP(p[22]), .oBufP(p1[22]));
GP_Adder gp1Adder23 (.iGi_j1(g[23]), .iPi_j1(p[23]), .iGj_k(g[22]), .iPj_k( p[22]), .oGi_k(g1[23]), .oPi_k(p1[23]));
GP_Buf   gp1Buf24   (.iBufG( g[24]), .oBufG(g1[24]), .iBufP(p[24]), .oBufP(p1[24]));
GP_Adder gp1Adder25 (.iGi_j1(g[25]), .iPi_j1(p[25]), .iGj_k(g[24]), .iPj_k( p[24]), .oGi_k(g1[25]), .oPi_k(p1[25]));
GP_Buf   gp1Buf26   (.iBufG( g[26]), .oBufG(g1[26]), .iBufP(p[26]), .oBufP(p1[26]));
GP_Adder gp1Adder27 (.iGi_j1(g[27]), .iPi_j1(p[27]), .iGj_k(g[26]), .iPj_k( p[26]), .oGi_k(g1[27]), .oPi_k(p1[27]));
GP_Buf   gp1Buf28   (.iBufG( g[28]), .oBufG(g1[28]), .iBufP(p[28]), .oBufP(p1[28]));
GP_Adder gp1Adder29 (.iGi_j1(g[29]), .iPi_j1(p[29]), .iGj_k(g[28]), .iPj_k( p[28]), .oGi_k(g1[29]), .oPi_k(p1[29]));
GP_Buf   gp1Buf30   (.iBufG( g[30]), .oBufG(g1[30]), .iBufP(p[30]), .oBufP(p1[30]));
GP_Adder gp1Adder31 (.iGi_j1(g[31]), .iPi_j1(p[31]), .iGj_k(g[30]), .iPj_k( p[30]), .oGi_k(g1[31]), .oPi_k(p1[31]));
GP_Buf   gp1Buf32   (.iBufG( g[32]), .oBufG(g1[32]), .iBufP(p[32]), .oBufP(p1[32]));
GP_Adder gp1Adder33 (.iGi_j1(g[33]), .iPi_j1(p[33]), .iGj_k(g[32]), .iPj_k( p[32]), .oGi_k(g1[33]), .oPi_k(p1[33]));
GP_Buf   gp1Buf34   (.iBufG( g[34]), .oBufG(g1[34]), .iBufP(p[34]), .oBufP(p1[34]));
GP_Adder gp1Adder35 (.iGi_j1(g[35]), .iPi_j1(p[35]), .iGj_k(g[34]), .iPj_k( p[34]), .oGi_k(g1[35]), .oPi_k(p1[35]));
GP_Buf   gp1Buf36   (.iBufG( g[36]), .oBufG(g1[36]), .iBufP(p[36]), .oBufP(p1[36]));
GP_Adder gp1Adder37 (.iGi_j1(g[37]), .iPi_j1(p[37]), .iGj_k(g[36]), .iPj_k( p[36]), .oGi_k(g1[37]), .oPi_k(p1[37]));
GP_Buf   gp1Buf38   (.iBufG( g[38]), .oBufG(g1[38]), .iBufP(p[38]), .oBufP(p1[38]));
GP_Adder gp1Adder39 (.iGi_j1(g[39]), .iPi_j1(p[39]), .iGj_k(g[38]), .iPj_k( p[38]), .oGi_k(g1[39]), .oPi_k(p1[39]));
GP_Buf   gp1Buf40   (.iBufG( g[40]), .oBufG(g1[40]), .iBufP(p[40]), .oBufP(p1[40]));
GP_Adder gp1Adder41 (.iGi_j1(g[41]), .iPi_j1(p[41]), .iGj_k(g[40]), .iPj_k( p[40]), .oGi_k(g1[41]), .oPi_k(p1[41]));
GP_Buf   gp1Buf42   (.iBufG( g[42]), .oBufG(g1[42]), .iBufP(p[42]), .oBufP(p1[42]));
GP_Adder gp1Adder43 (.iGi_j1(g[43]), .iPi_j1(p[43]), .iGj_k(g[42]), .iPj_k( p[42]), .oGi_k(g1[43]), .oPi_k(p1[43]));
GP_Buf   gp1Buf44   (.iBufG( g[44]), .oBufG(g1[44]), .iBufP(p[44]), .oBufP(p1[44]));
GP_Adder gp1Adder45 (.iGi_j1(g[45]), .iPi_j1(p[45]), .iGj_k(g[44]), .iPj_k( p[44]), .oGi_k(g1[45]), .oPi_k(p1[45]));
GP_Buf   gp1Buf46   (.iBufG( g[46]), .oBufG(g1[46]), .iBufP(p[46]), .oBufP(p1[46]));
GP_Adder gp1Adder47 (.iGi_j1(g[47]), .iPi_j1(p[47]), .iGj_k(g[46]), .iPj_k( p[46]), .oGi_k(g1[47]), .oPi_k(p1[47]));
GP_Buf   gp1Buf48   (.iBufG( g[48]), .oBufG(g1[48]), .iBufP(p[48]), .oBufP(p1[48]));
GP_Adder gp1Adder49 (.iGi_j1(g[49]), .iPi_j1(p[49]), .iGj_k(g[48]), .iPj_k( p[48]), .oGi_k(g1[49]), .oPi_k(p1[49]));
GP_Buf   gp1Buf50   (.iBufG( g[50]), .oBufG(g1[50]), .iBufP(p[50]), .oBufP(p1[50]));
GP_Adder gp1Adder51 (.iGi_j1(g[51]), .iPi_j1(p[51]), .iGj_k(g[50]), .iPj_k( p[50]), .oGi_k(g1[51]), .oPi_k(p1[51]));
GP_Buf   gp1Buf52   (.iBufG( g[52]), .oBufG(g1[52]), .iBufP(p[52]), .oBufP(p1[52]));
GP_Adder gp1Adder53 (.iGi_j1(g[53]), .iPi_j1(p[53]), .iGj_k(g[52]), .iPj_k( p[52]), .oGi_k(g1[53]), .oPi_k(p1[53]));
GP_Buf   gp1Buf54   (.iBufG( g[54]), .oBufG(g1[54]), .iBufP(p[54]), .oBufP(p1[54]));
GP_Adder gp1Adder55 (.iGi_j1(g[55]), .iPi_j1(p[55]), .iGj_k(g[54]), .iPj_k( p[54]), .oGi_k(g1[55]), .oPi_k(p1[55]));
GP_Buf   gp1Buf56   (.iBufG( g[56]), .oBufG(g1[56]), .iBufP(p[56]), .oBufP(p1[56]));
GP_Adder gp1Adder57 (.iGi_j1(g[57]), .iPi_j1(p[57]), .iGj_k(g[56]), .iPj_k( p[56]), .oGi_k(g1[57]), .oPi_k(p1[57]));
GP_Buf   gp1Buf58   (.iBufG( g[58]), .oBufG(g1[58]), .iBufP(p[58]), .oBufP(p1[58]));
GP_Adder gp1Adder59 (.iGi_j1(g[59]), .iPi_j1(p[59]), .iGj_k(g[58]), .iPj_k( p[58]), .oGi_k(g1[59]), .oPi_k(p1[59]));
GP_Buf   gp1Buf60   (.iBufG( g[60]), .oBufG(g1[60]), .iBufP(p[60]), .oBufP(p1[60]));
GP_Adder gp1Adder61 (.iGi_j1(g[61]), .iPi_j1(p[61]), .iGj_k(g[60]), .iPj_k( p[60]), .oGi_k(g1[61]), .oPi_k(p1[61]));
GP_Buf   gp1Buf62   (.iBufG( g[62]), .oBufG(g1[62]), .iBufP(p[62]), .oBufP(p1[62]));
GP_Adder gp1Adder63 (.iGi_j1(g[63]), .iPi_j1(p[63]), .iGj_k(g[62]), .iPj_k( p[62]), .oGi_k(g1[63]), .oPi_k(p1[63]));
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
GP_Buf   gp2Buf16   (.iBufG( g1[16]), .oBufG( g2[16]), .iBufP(p1[16]), .oBufP(p2[16]));
GP_Buf   gp2Buf17   (.iBufG( g1[17]), .oBufG( g2[17]), .iBufP(p1[17]), .oBufP(p2[17]));
GP_Buf   gp2Buf18   (.iBufG( g1[18]), .oBufG( g2[18]), .iBufP(p1[18]), .oBufP(p2[18]));
GP_Adder gp2Adder19 (.iGi_j1(g1[19]), .iPi_j1(p1[19]), .iGj_k(g1[17]), .iPj_k(p1[17]), .oGi_k(g2[19]), .oPi_k(p2[19]));
GP_Buf   gp2Buf20   (.iBufG( g1[20]), .oBufG( g2[20]), .iBufP(p1[20]), .oBufP(p2[20]));
GP_Buf   gp2Buf21   (.iBufG( g1[21]), .oBufG( g2[21]), .iBufP(p1[21]), .oBufP(p2[21]));
GP_Buf   gp2Buf22   (.iBufG( g1[22]), .oBufG( g2[22]), .iBufP(p1[22]), .oBufP(p2[22]));
GP_Adder gp2Adder23 (.iGi_j1(g1[23]), .iPi_j1(p1[23]), .iGj_k(g1[21]), .iPj_k(p1[21]), .oGi_k(g2[23]), .oPi_k(p2[23]));
GP_Buf   gp2Buf24   (.iBufG( g1[24]), .oBufG( g2[24]), .iBufP(p1[24]), .oBufP(p2[24]));
GP_Buf   gp2Buf25   (.iBufG( g1[25]), .oBufG( g2[25]), .iBufP(p1[25]), .oBufP(p2[25]));
GP_Buf   gp2Buf26   (.iBufG( g1[26]), .oBufG( g2[26]), .iBufP(p1[26]), .oBufP(p2[26]));
GP_Adder gp2Adder27 (.iGi_j1(g1[27]), .iPi_j1(p1[27]), .iGj_k(g1[25]), .iPj_k(p1[25]), .oGi_k(g2[27]), .oPi_k(p2[27]));
GP_Buf   gp2Buf28   (.iBufG( g1[28]), .oBufG( g2[28]), .iBufP(p1[28]), .oBufP(p2[28]));
GP_Buf   gp2Buf29   (.iBufG( g1[29]), .oBufG( g2[29]), .iBufP(p1[29]), .oBufP(p2[29]));
GP_Buf   gp2Buf30   (.iBufG( g1[30]), .oBufG( g2[30]), .iBufP(p1[30]), .oBufP(p2[30]));
GP_Adder gp2Adder31 (.iGi_j1(g1[31]), .iPi_j1(p1[31]), .iGj_k(g1[29]), .iPj_k(p1[29]), .oGi_k(g2[31]), .oPi_k(p2[31]));
GP_Buf   gp2Buf32   (.iBufG( g1[32]), .oBufG( g2[32]), .iBufP(p1[32]), .oBufP(p2[32]));
GP_Buf   gp2Buf33   (.iBufG( g1[33]), .oBufG( g2[33]), .iBufP(p1[33]), .oBufP(p2[33]));
GP_Buf   gp2Buf34   (.iBufG( g1[34]), .oBufG( g2[34]), .iBufP(p1[34]), .oBufP(p2[34]));
GP_Adder gp2Adder35 (.iGi_j1(g1[35]), .iPi_j1(p1[35]), .iGj_k(g1[33]), .iPj_k(p1[33]), .oGi_k(g2[35]), .oPi_k(p2[35]));
GP_Buf   gp2Buf36   (.iBufG( g1[36]), .oBufG( g2[36]), .iBufP(p1[36]), .oBufP(p2[36]));
GP_Buf   gp2Buf37   (.iBufG( g1[37]), .oBufG( g2[37]), .iBufP(p1[37]), .oBufP(p2[37]));
GP_Buf   gp2Buf38   (.iBufG( g1[38]), .oBufG( g2[38]), .iBufP(p1[38]), .oBufP(p2[38]));
GP_Adder gp2Adder39 (.iGi_j1(g1[39]), .iPi_j1(p1[39]), .iGj_k(g1[37]), .iPj_k(p1[37]), .oGi_k(g2[39]), .oPi_k(p2[39]));
GP_Buf   gp2Buf40   (.iBufG( g1[40]), .oBufG( g2[40]), .iBufP(p1[40]), .oBufP(p2[40]));
GP_Buf   gp2Buf41   (.iBufG( g1[41]), .oBufG( g2[41]), .iBufP(p1[41]), .oBufP(p2[41]));
GP_Buf   gp2Buf42   (.iBufG( g1[42]), .oBufG( g2[42]), .iBufP(p1[42]), .oBufP(p2[42]));
GP_Adder gp2Adder43 (.iGi_j1(g1[43]), .iPi_j1(p1[43]), .iGj_k(g1[41]), .iPj_k(p1[41]), .oGi_k(g2[43]), .oPi_k(p2[43]));
GP_Buf   gp2Buf44   (.iBufG( g1[44]), .oBufG( g2[44]), .iBufP(p1[44]), .oBufP(p2[44]));
GP_Buf   gp2Buf45   (.iBufG( g1[45]), .oBufG( g2[45]), .iBufP(p1[45]), .oBufP(p2[45]));
GP_Buf   gp2Buf46   (.iBufG( g1[46]), .oBufG( g2[46]), .iBufP(p1[46]), .oBufP(p2[46]));
GP_Adder gp2Adder47 (.iGi_j1(g1[47]), .iPi_j1(p1[47]), .iGj_k(g1[45]), .iPj_k(p1[45]), .oGi_k(g2[47]), .oPi_k(p2[47]));
GP_Buf   gp2Buf48   (.iBufG( g1[48]), .oBufG( g2[48]), .iBufP(p1[48]), .oBufP(p2[48]));
GP_Buf   gp2Buf49   (.iBufG( g1[49]), .oBufG( g2[49]), .iBufP(p1[49]), .oBufP(p2[49]));
GP_Buf   gp2Buf50   (.iBufG( g1[50]), .oBufG( g2[50]), .iBufP(p1[50]), .oBufP(p2[50]));
GP_Adder gp2Adder51 (.iGi_j1(g1[51]), .iPi_j1(p1[51]), .iGj_k(g1[49]), .iPj_k(p1[49]), .oGi_k(g2[51]), .oPi_k(p2[51]));
GP_Buf   gp2Buf52   (.iBufG( g1[52]), .oBufG( g2[52]), .iBufP(p1[52]), .oBufP(p2[52]));
GP_Buf   gp2Buf53   (.iBufG( g1[53]), .oBufG( g2[53]), .iBufP(p1[53]), .oBufP(p2[53]));
GP_Buf   gp2Buf54   (.iBufG( g1[54]), .oBufG( g2[54]), .iBufP(p1[54]), .oBufP(p2[54]));
GP_Adder gp2Adder55 (.iGi_j1(g1[55]), .iPi_j1(p1[55]), .iGj_k(g1[53]), .iPj_k(p1[53]), .oGi_k(g2[55]), .oPi_k(p2[55]));
GP_Buf   gp2Buf56   (.iBufG( g1[56]), .oBufG( g2[56]), .iBufP(p1[56]), .oBufP(p2[56]));
GP_Buf   gp2Buf57   (.iBufG( g1[57]), .oBufG( g2[57]), .iBufP(p1[57]), .oBufP(p2[57]));
GP_Buf   gp2Buf58   (.iBufG( g1[58]), .oBufG( g2[58]), .iBufP(p1[58]), .oBufP(p2[58]));
GP_Adder gp2Adder59 (.iGi_j1(g1[59]), .iPi_j1(p1[59]), .iGj_k(g1[57]), .iPj_k(p1[57]), .oGi_k(g2[59]), .oPi_k(p2[59]));
GP_Buf   gp2Buf60   (.iBufG( g1[60]), .oBufG( g2[60]), .iBufP(p1[60]), .oBufP(p2[60]));
GP_Buf   gp2Buf61   (.iBufG( g1[61]), .oBufG( g2[61]), .iBufP(p1[61]), .oBufP(p2[61]));
GP_Buf   gp2Buf62   (.iBufG( g1[62]), .oBufG( g2[62]), .iBufP(p1[62]), .oBufP(p2[62]));
GP_Adder gp2Adder63 (.iGi_j1(g1[63]), .iPi_j1(p1[63]), .iGj_k(g1[61]), .iPj_k(p1[61]), .oGi_k(g2[63]), .oPi_k(p2[63]));
//Insert the D-FlipFlops to form pipeline1 
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
GP_Buf   gp3Buf16   (.iBufG( g2_pp[16]), .oBufG( g3[16]), .iBufP(p2_pp[16]), .oBufP(p3[16]));
GP_Buf   gp3Buf17   (.iBufG( g2_pp[17]), .oBufG( g3[17]), .iBufP(p2_pp[17]), .oBufP(p3[17]));
GP_Buf   gp3Buf18   (.iBufG( g2_pp[18]), .oBufG( g3[18]), .iBufP(p2_pp[18]), .oBufP(p3[18]));
GP_Buf   gp3Buf19   (.iBufG( g2_pp[19]), .oBufG( g3[19]), .iBufP(p2_pp[19]), .oBufP(p3[19]));
GP_Buf   gp3Buf20   (.iBufG( g2_pp[20]), .oBufG( g3[20]), .iBufP(p2_pp[20]), .oBufP(p3[20]));
GP_Buf   gp3Buf21   (.iBufG( g2_pp[21]), .oBufG( g3[21]), .iBufP(p2_pp[21]), .oBufP(p3[21]));
GP_Buf   gp3Buf22   (.iBufG( g2_pp[22]), .oBufG( g3[22]), .iBufP(p2_pp[22]), .oBufP(p3[22]));
GP_Adder gp3Adder23 (.iGi_j1(g2_pp[23]), .iPi_j1(p2_pp[23]), .iGj_k(g2_pp[19]), .iPj_k(p2_pp[19]), .oGi_k(g3[23]), .oPi_k(p3[23]));
GP_Buf   gp3Buf24   (.iBufG( g2_pp[24]), .oBufG( g3[24]), .iBufP(p2_pp[24]), .oBufP(p3[24]));
GP_Buf   gp3Buf25   (.iBufG( g2_pp[25]), .oBufG( g3[25]), .iBufP(p2_pp[25]), .oBufP(p3[25]));
GP_Buf   gp3Buf26   (.iBufG( g2_pp[26]), .oBufG( g3[26]), .iBufP(p2_pp[26]), .oBufP(p3[26]));
GP_Buf   gp3Buf27   (.iBufG( g2_pp[27]), .oBufG( g3[27]), .iBufP(p2_pp[27]), .oBufP(p3[27]));
GP_Buf   gp3Buf28   (.iBufG( g2_pp[28]), .oBufG( g3[28]), .iBufP(p2_pp[28]), .oBufP(p3[28]));
GP_Buf   gp3Buf29   (.iBufG( g2_pp[29]), .oBufG( g3[29]), .iBufP(p2_pp[29]), .oBufP(p3[29]));
GP_Buf   gp3Buf30   (.iBufG( g2_pp[30]), .oBufG( g3[30]), .iBufP(p2_pp[30]), .oBufP(p3[30]));
GP_Adder gp3Adder31 (.iGi_j1(g2_pp[31]), .iPi_j1(p2_pp[31]), .iGj_k(g2_pp[27]), .iPj_k(p2_pp[27]), .oGi_k(g3[31]), .oPi_k(p3[31]));
GP_Buf   gp3Buf32   (.iBufG( g2_pp[32]), .oBufG( g3[32]), .iBufP(p2_pp[32]), .oBufP(p3[32]));
GP_Buf   gp3Buf33   (.iBufG( g2_pp[33]), .oBufG( g3[33]), .iBufP(p2_pp[33]), .oBufP(p3[33]));
GP_Buf   gp3Buf34   (.iBufG( g2_pp[34]), .oBufG( g3[34]), .iBufP(p2_pp[34]), .oBufP(p3[34]));
GP_Buf   gp3Buf35   (.iBufG( g2_pp[35]), .oBufG( g3[35]), .iBufP(p2_pp[35]), .oBufP(p3[35]));
GP_Buf   gp3Buf36   (.iBufG( g2_pp[36]), .oBufG( g3[36]), .iBufP(p2_pp[36]), .oBufP(p3[36]));
GP_Buf   gp3Buf37   (.iBufG( g2_pp[37]), .oBufG( g3[37]), .iBufP(p2_pp[37]), .oBufP(p3[37]));
GP_Buf   gp3Buf38   (.iBufG( g2_pp[38]), .oBufG( g3[38]), .iBufP(p2_pp[38]), .oBufP(p3[38]));
GP_Adder gp3Adder39 (.iGi_j1(g2_pp[39]), .iPi_j1(p2_pp[39]), .iGj_k(g2_pp[35]), .iPj_k(p2_pp[35]), .oGi_k(g3[39]), .oPi_k(p3[39]));
GP_Buf   gp3Buf40   (.iBufG( g2_pp[40]), .oBufG( g3[40]), .iBufP(p2_pp[40]), .oBufP(p3[40]));
GP_Buf   gp3Buf41   (.iBufG( g2_pp[41]), .oBufG( g3[41]), .iBufP(p2_pp[41]), .oBufP(p3[41]));
GP_Buf   gp3Buf42   (.iBufG( g2_pp[42]), .oBufG( g3[42]), .iBufP(p2_pp[42]), .oBufP(p3[42]));
GP_Buf   gp3Buf43   (.iBufG( g2_pp[43]), .oBufG( g3[43]), .iBufP(p2_pp[43]), .oBufP(p3[43]));
GP_Buf   gp3Buf44   (.iBufG( g2_pp[44]), .oBufG( g3[44]), .iBufP(p2_pp[44]), .oBufP(p3[44]));
GP_Buf   gp3Buf45   (.iBufG( g2_pp[45]), .oBufG( g3[45]), .iBufP(p2_pp[45]), .oBufP(p3[45]));
GP_Buf   gp3Buf46   (.iBufG( g2_pp[46]), .oBufG( g3[46]), .iBufP(p2_pp[46]), .oBufP(p3[46]));
GP_Adder gp3Adder47 (.iGi_j1(g2_pp[47]), .iPi_j1(p2_pp[47]), .iGj_k(g2_pp[43]), .iPj_k(p2_pp[43]), .oGi_k(g3[47]), .oPi_k(p3[47]));
GP_Buf   gp3Buf48   (.iBufG( g2_pp[48]), .oBufG( g3[48]), .iBufP(p2_pp[48]), .oBufP(p3[48]));
GP_Buf   gp3Buf49   (.iBufG( g2_pp[49]), .oBufG( g3[49]), .iBufP(p2_pp[49]), .oBufP(p3[49]));
GP_Buf   gp3Buf50   (.iBufG( g2_pp[50]), .oBufG( g3[50]), .iBufP(p2_pp[50]), .oBufP(p3[50]));
GP_Buf   gp3Buf51   (.iBufG( g2_pp[51]), .oBufG( g3[51]), .iBufP(p2_pp[51]), .oBufP(p3[51]));
GP_Buf   gp3Buf52   (.iBufG( g2_pp[52]), .oBufG( g3[52]), .iBufP(p2_pp[52]), .oBufP(p3[52]));
GP_Buf   gp3Buf53   (.iBufG( g2_pp[53]), .oBufG( g3[53]), .iBufP(p2_pp[53]), .oBufP(p3[53]));
GP_Buf   gp3Buf54   (.iBufG( g2_pp[54]), .oBufG( g3[54]), .iBufP(p2_pp[54]), .oBufP(p3[54]));
GP_Adder gp3Adder55 (.iGi_j1(g2_pp[55]), .iPi_j1(p2_pp[55]), .iGj_k(g2_pp[51]), .iPj_k(p2_pp[51]), .oGi_k(g3[55]), .oPi_k(p3[55]));
GP_Buf   gp3Buf56   (.iBufG( g2_pp[56]), .oBufG( g3[56]), .iBufP(p2_pp[56]), .oBufP(p3[56]));
GP_Buf   gp3Buf57   (.iBufG( g2_pp[57]), .oBufG( g3[57]), .iBufP(p2_pp[57]), .oBufP(p3[57]));
GP_Buf   gp3Buf58   (.iBufG( g2_pp[58]), .oBufG( g3[58]), .iBufP(p2_pp[58]), .oBufP(p3[58]));
GP_Buf   gp3Buf59   (.iBufG( g2_pp[59]), .oBufG( g3[59]), .iBufP(p2_pp[59]), .oBufP(p3[59]));
GP_Buf   gp3Buf60   (.iBufG( g2_pp[60]), .oBufG( g3[60]), .iBufP(p2_pp[60]), .oBufP(p3[60]));
GP_Buf   gp3Buf61   (.iBufG( g2_pp[61]), .oBufG( g3[61]), .iBufP(p2_pp[61]), .oBufP(p3[61]));
GP_Buf   gp3Buf62   (.iBufG( g2_pp[62]), .oBufG( g3[62]), .iBufP(p2_pp[62]), .oBufP(p3[62]));
GP_Adder gp3Adder63 (.iGi_j1(g2_pp[63]), .iPi_j1(p2_pp[63]), .iGj_k(g2_pp[59]), .iPj_k(p2_pp[59]), .oGi_k(g3[63]), .oPi_k(p3[63]));
//Stage 4
wire  [N-1:0] p4, g4;
GP_Buf   gp4Buf0   (.iBufG( g3[0]), .oBufG( g4[0]), .iBufP(p3[0]), .oBufP(p4[0]));
GP_Buf   gp4Buf1   (.iBufG( g3[1]), .oBufG( g4[1]), .iBufP(p3[1]), .oBufP(p4[1]));
GP_Buf   gp4Buf2   (.iBufG( g3[2]), .oBufG( g4[2]), .iBufP(p3[2]), .oBufP(p4[2]));
GP_Buf   gp4Buf3   (.iBufG( g3[3]), .oBufG( g4[3]), .iBufP(p3[3]), .oBufP(p4[3]));
GP_Buf   gp4Buf4   (.iBufG( g3[4]), .oBufG( g4[4]), .iBufP(p3[4]), .oBufP(p4[4]));
GP_Buf   gp4Buf5   (.iBufG( g3[5]), .oBufG( g4[5]), .iBufP(p3[5]), .oBufP(p4[5]));
GP_Buf   gp4Buf6   (.iBufG( g3[6]), .oBufG( g4[6]), .iBufP(p3[6]), .oBufP(p4[6]));
GP_Buf   gp4Buf7   (.iBufG( g3[7]), .oBufG( g4[7]), .iBufP(p3[7]), .oBufP(p4[7]));
GP_Buf   gp4Buf8   (.iBufG( g3[8]), .oBufG( g4[8]), .iBufP(p3[8]), .oBufP(p4[8]));
GP_Buf   gp4Buf9   (.iBufG( g3[9]), .oBufG( g4[9]), .iBufP(p3[9]), .oBufP(p4[9]));
GP_Buf   gp4Buf10   (.iBufG( g3[10]), .oBufG( g4[10]), .iBufP(p3[10]), .oBufP(p4[10]));
GP_Buf   gp4Buf11   (.iBufG( g3[11]), .oBufG( g4[11]), .iBufP(p3[11]), .oBufP(p4[11]));
GP_Buf   gp4Buf12   (.iBufG( g3[12]), .oBufG( g4[12]), .iBufP(p3[12]), .oBufP(p4[12]));
GP_Buf   gp4Buf13   (.iBufG( g3[13]), .oBufG( g4[13]), .iBufP(p3[13]), .oBufP(p4[13]));
GP_Buf   gp4Buf14   (.iBufG( g3[14]), .oBufG( g4[14]), .iBufP(p3[14]), .oBufP(p4[14]));
GP_Adder gp4Adder15 (.iGi_j1(g3[15]), .iPi_j1(p3[15]), .iGj_k(g3[7]), .iPj_k(p3[7]), .oGi_k(g4[15]), .oPi_k(p4[15]));
GP_Buf   gp4Buf16   (.iBufG( g3[16]), .oBufG( g4[16]), .iBufP(p3[16]), .oBufP(p4[16]));
GP_Buf   gp4Buf17   (.iBufG( g3[17]), .oBufG( g4[17]), .iBufP(p3[17]), .oBufP(p4[17]));
GP_Buf   gp4Buf18   (.iBufG( g3[18]), .oBufG( g4[18]), .iBufP(p3[18]), .oBufP(p4[18]));
GP_Buf   gp4Buf19   (.iBufG( g3[19]), .oBufG( g4[19]), .iBufP(p3[19]), .oBufP(p4[19]));
GP_Buf   gp4Buf20   (.iBufG( g3[20]), .oBufG( g4[20]), .iBufP(p3[20]), .oBufP(p4[20]));
GP_Buf   gp4Buf21   (.iBufG( g3[21]), .oBufG( g4[21]), .iBufP(p3[21]), .oBufP(p4[21]));
GP_Buf   gp4Buf22   (.iBufG( g3[22]), .oBufG( g4[22]), .iBufP(p3[22]), .oBufP(p4[22]));
GP_Buf   gp4Buf23   (.iBufG( g3[23]), .oBufG( g4[23]), .iBufP(p3[23]), .oBufP(p4[23]));
GP_Buf   gp4Buf24   (.iBufG( g3[24]), .oBufG( g4[24]), .iBufP(p3[24]), .oBufP(p4[24]));
GP_Buf   gp4Buf25   (.iBufG( g3[25]), .oBufG( g4[25]), .iBufP(p3[25]), .oBufP(p4[25]));
GP_Buf   gp4Buf26   (.iBufG( g3[26]), .oBufG( g4[26]), .iBufP(p3[26]), .oBufP(p4[26]));
GP_Buf   gp4Buf27   (.iBufG( g3[27]), .oBufG( g4[27]), .iBufP(p3[27]), .oBufP(p4[27]));
GP_Buf   gp4Buf28   (.iBufG( g3[28]), .oBufG( g4[28]), .iBufP(p3[28]), .oBufP(p4[28]));
GP_Buf   gp4Buf29   (.iBufG( g3[29]), .oBufG( g4[29]), .iBufP(p3[29]), .oBufP(p4[29]));
GP_Buf   gp4Buf30   (.iBufG( g3[30]), .oBufG( g4[30]), .iBufP(p3[30]), .oBufP(p4[30]));
GP_Adder gp4Adder31 (.iGi_j1(g3[31]), .iPi_j1(p3[31]), .iGj_k(g3[23]), .iPj_k(p3[23]), .oGi_k(g4[31]), .oPi_k(p4[31]));
GP_Buf   gp4Buf32   (.iBufG( g3[32]), .oBufG( g4[32]), .iBufP(p3[32]), .oBufP(p4[32]));
GP_Buf   gp4Buf33   (.iBufG( g3[33]), .oBufG( g4[33]), .iBufP(p3[33]), .oBufP(p4[33]));
GP_Buf   gp4Buf34   (.iBufG( g3[34]), .oBufG( g4[34]), .iBufP(p3[34]), .oBufP(p4[34]));
GP_Buf   gp4Buf35   (.iBufG( g3[35]), .oBufG( g4[35]), .iBufP(p3[35]), .oBufP(p4[35]));
GP_Buf   gp4Buf36   (.iBufG( g3[36]), .oBufG( g4[36]), .iBufP(p3[36]), .oBufP(p4[36]));
GP_Buf   gp4Buf37   (.iBufG( g3[37]), .oBufG( g4[37]), .iBufP(p3[37]), .oBufP(p4[37]));
GP_Buf   gp4Buf38   (.iBufG( g3[38]), .oBufG( g4[38]), .iBufP(p3[38]), .oBufP(p4[38]));
GP_Buf   gp4Buf39   (.iBufG( g3[39]), .oBufG( g4[39]), .iBufP(p3[39]), .oBufP(p4[39]));
GP_Buf   gp4Buf40   (.iBufG( g3[40]), .oBufG( g4[40]), .iBufP(p3[40]), .oBufP(p4[40]));
GP_Buf   gp4Buf41   (.iBufG( g3[41]), .oBufG( g4[41]), .iBufP(p3[41]), .oBufP(p4[41]));
GP_Buf   gp4Buf42   (.iBufG( g3[42]), .oBufG( g4[42]), .iBufP(p3[42]), .oBufP(p4[42]));
GP_Buf   gp4Buf43   (.iBufG( g3[43]), .oBufG( g4[43]), .iBufP(p3[43]), .oBufP(p4[43]));
GP_Buf   gp4Buf44   (.iBufG( g3[44]), .oBufG( g4[44]), .iBufP(p3[44]), .oBufP(p4[44]));
GP_Buf   gp4Buf45   (.iBufG( g3[45]), .oBufG( g4[45]), .iBufP(p3[45]), .oBufP(p4[45]));
GP_Buf   gp4Buf46   (.iBufG( g3[46]), .oBufG( g4[46]), .iBufP(p3[46]), .oBufP(p4[46]));
GP_Adder gp4Adder47 (.iGi_j1(g3[47]), .iPi_j1(p3[47]), .iGj_k(g3[39]), .iPj_k(p3[39]), .oGi_k(g4[47]), .oPi_k(p4[47]));
GP_Buf   gp4Buf48   (.iBufG( g3[48]), .oBufG( g4[48]), .iBufP(p3[48]), .oBufP(p4[48]));
GP_Buf   gp4Buf49   (.iBufG( g3[49]), .oBufG( g4[49]), .iBufP(p3[49]), .oBufP(p4[49]));
GP_Buf   gp4Buf50   (.iBufG( g3[50]), .oBufG( g4[50]), .iBufP(p3[50]), .oBufP(p4[50]));
GP_Buf   gp4Buf51   (.iBufG( g3[51]), .oBufG( g4[51]), .iBufP(p3[51]), .oBufP(p4[51]));
GP_Buf   gp4Buf52   (.iBufG( g3[52]), .oBufG( g4[52]), .iBufP(p3[52]), .oBufP(p4[52]));
GP_Buf   gp4Buf53   (.iBufG( g3[53]), .oBufG( g4[53]), .iBufP(p3[53]), .oBufP(p4[53]));
GP_Buf   gp4Buf54   (.iBufG( g3[54]), .oBufG( g4[54]), .iBufP(p3[54]), .oBufP(p4[54]));
GP_Buf   gp4Buf55   (.iBufG( g3[55]), .oBufG( g4[55]), .iBufP(p3[55]), .oBufP(p4[55]));
GP_Buf   gp4Buf56   (.iBufG( g3[56]), .oBufG( g4[56]), .iBufP(p3[56]), .oBufP(p4[56]));
GP_Buf   gp4Buf57   (.iBufG( g3[57]), .oBufG( g4[57]), .iBufP(p3[57]), .oBufP(p4[57]));
GP_Buf   gp4Buf58   (.iBufG( g3[58]), .oBufG( g4[58]), .iBufP(p3[58]), .oBufP(p4[58]));
GP_Buf   gp4Buf59   (.iBufG( g3[59]), .oBufG( g4[59]), .iBufP(p3[59]), .oBufP(p4[59]));
GP_Buf   gp4Buf60   (.iBufG( g3[60]), .oBufG( g4[60]), .iBufP(p3[60]), .oBufP(p4[60]));
GP_Buf   gp4Buf61   (.iBufG( g3[61]), .oBufG( g4[61]), .iBufP(p3[61]), .oBufP(p4[61]));
GP_Buf   gp4Buf62   (.iBufG( g3[62]), .oBufG( g4[62]), .iBufP(p3[62]), .oBufP(p4[62]));
GP_Adder gp4Adder63 (.iGi_j1(g3[63]), .iPi_j1(p3[63]), .iGj_k(g3[55]), .iPj_k(p3[55]), .oGi_k(g4[63]), .oPi_k(p4[63]));
//Insert the D-FlipFlops to form pipeline2 
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
//Pipeline the p for the sum 
wire [N-1:0] p_pp2;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP2 (
  .clk(clk),
  .resetn(resetn),
  .D(p_pp1),
  .Q(p_pp2)
);
wire wValidPP2;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay2 (
  .clk(clk), 
  .resetn(resetn), 
  .D(wValidPP1), 
  .Q(wValidPP2) 
);
wire wCarryInPP2;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay2 (
  .clk(clk), 
  .resetn(resetn), 
  .D(iCarryInPP1), 
  .Q(wCarryInPP2) 
);
//Stage 5
wire  [N-1:0] p5, g5;
GP_Buf   gp5Buf0   (.iBufG( g4_pp[0]), .oBufG( g5[0]), .iBufP(p4_pp[0]), .oBufP(p5[0]));
GP_Buf   gp5Buf1   (.iBufG( g4_pp[1]), .oBufG( g5[1]), .iBufP(p4_pp[1]), .oBufP(p5[1]));
GP_Buf   gp5Buf2   (.iBufG( g4_pp[2]), .oBufG( g5[2]), .iBufP(p4_pp[2]), .oBufP(p5[2]));
GP_Buf   gp5Buf3   (.iBufG( g4_pp[3]), .oBufG( g5[3]), .iBufP(p4_pp[3]), .oBufP(p5[3]));
GP_Buf   gp5Buf4   (.iBufG( g4_pp[4]), .oBufG( g5[4]), .iBufP(p4_pp[4]), .oBufP(p5[4]));
GP_Buf   gp5Buf5   (.iBufG( g4_pp[5]), .oBufG( g5[5]), .iBufP(p4_pp[5]), .oBufP(p5[5]));
GP_Buf   gp5Buf6   (.iBufG( g4_pp[6]), .oBufG( g5[6]), .iBufP(p4_pp[6]), .oBufP(p5[6]));
GP_Buf   gp5Buf7   (.iBufG( g4_pp[7]), .oBufG( g5[7]), .iBufP(p4_pp[7]), .oBufP(p5[7]));
GP_Buf   gp5Buf8   (.iBufG( g4_pp[8]), .oBufG( g5[8]), .iBufP(p4_pp[8]), .oBufP(p5[8]));
GP_Buf   gp5Buf9   (.iBufG( g4_pp[9]), .oBufG( g5[9]), .iBufP(p4_pp[9]), .oBufP(p5[9]));
GP_Buf   gp5Buf10   (.iBufG( g4_pp[10]), .oBufG( g5[10]), .iBufP(p4_pp[10]), .oBufP(p5[10]));
GP_Buf   gp5Buf11   (.iBufG( g4_pp[11]), .oBufG( g5[11]), .iBufP(p4_pp[11]), .oBufP(p5[11]));
GP_Buf   gp5Buf12   (.iBufG( g4_pp[12]), .oBufG( g5[12]), .iBufP(p4_pp[12]), .oBufP(p5[12]));
GP_Buf   gp5Buf13   (.iBufG( g4_pp[13]), .oBufG( g5[13]), .iBufP(p4_pp[13]), .oBufP(p5[13]));
GP_Buf   gp5Buf14   (.iBufG( g4_pp[14]), .oBufG( g5[14]), .iBufP(p4_pp[14]), .oBufP(p5[14]));
GP_Buf   gp5Buf15   (.iBufG( g4_pp[15]), .oBufG( g5[15]), .iBufP(p4_pp[15]), .oBufP(p5[15]));
GP_Buf   gp5Buf16   (.iBufG( g4_pp[16]), .oBufG( g5[16]), .iBufP(p4_pp[16]), .oBufP(p5[16]));
GP_Buf   gp5Buf17   (.iBufG( g4_pp[17]), .oBufG( g5[17]), .iBufP(p4_pp[17]), .oBufP(p5[17]));
GP_Buf   gp5Buf18   (.iBufG( g4_pp[18]), .oBufG( g5[18]), .iBufP(p4_pp[18]), .oBufP(p5[18]));
GP_Buf   gp5Buf19   (.iBufG( g4_pp[19]), .oBufG( g5[19]), .iBufP(p4_pp[19]), .oBufP(p5[19]));
GP_Buf   gp5Buf20   (.iBufG( g4_pp[20]), .oBufG( g5[20]), .iBufP(p4_pp[20]), .oBufP(p5[20]));
GP_Buf   gp5Buf21   (.iBufG( g4_pp[21]), .oBufG( g5[21]), .iBufP(p4_pp[21]), .oBufP(p5[21]));
GP_Buf   gp5Buf22   (.iBufG( g4_pp[22]), .oBufG( g5[22]), .iBufP(p4_pp[22]), .oBufP(p5[22]));
GP_Buf   gp5Buf23   (.iBufG( g4_pp[23]), .oBufG( g5[23]), .iBufP(p4_pp[23]), .oBufP(p5[23]));
GP_Buf   gp5Buf24   (.iBufG( g4_pp[24]), .oBufG( g5[24]), .iBufP(p4_pp[24]), .oBufP(p5[24]));
GP_Buf   gp5Buf25   (.iBufG( g4_pp[25]), .oBufG( g5[25]), .iBufP(p4_pp[25]), .oBufP(p5[25]));
GP_Buf   gp5Buf26   (.iBufG( g4_pp[26]), .oBufG( g5[26]), .iBufP(p4_pp[26]), .oBufP(p5[26]));
GP_Buf   gp5Buf27   (.iBufG( g4_pp[27]), .oBufG( g5[27]), .iBufP(p4_pp[27]), .oBufP(p5[27]));
GP_Buf   gp5Buf28   (.iBufG( g4_pp[28]), .oBufG( g5[28]), .iBufP(p4_pp[28]), .oBufP(p5[28]));
GP_Buf   gp5Buf29   (.iBufG( g4_pp[29]), .oBufG( g5[29]), .iBufP(p4_pp[29]), .oBufP(p5[29]));
GP_Buf   gp5Buf30   (.iBufG( g4_pp[30]), .oBufG( g5[30]), .iBufP(p4_pp[30]), .oBufP(p5[30]));
GP_Adder gp5Adder31 (.iGi_j1(g4_pp[31]), .iPi_j1(p4_pp[31]), .iGj_k(g4_pp[15]), .iPj_k(p4_pp[15]), .oGi_k(g5[31]), .oPi_k(p5[31]));
GP_Buf   gp5Buf32   (.iBufG( g4_pp[32]), .oBufG( g5[32]), .iBufP(p4_pp[32]), .oBufP(p5[32]));
GP_Buf   gp5Buf33   (.iBufG( g4_pp[33]), .oBufG( g5[33]), .iBufP(p4_pp[33]), .oBufP(p5[33]));
GP_Buf   gp5Buf34   (.iBufG( g4_pp[34]), .oBufG( g5[34]), .iBufP(p4_pp[34]), .oBufP(p5[34]));
GP_Buf   gp5Buf35   (.iBufG( g4_pp[35]), .oBufG( g5[35]), .iBufP(p4_pp[35]), .oBufP(p5[35]));
GP_Buf   gp5Buf36   (.iBufG( g4_pp[36]), .oBufG( g5[36]), .iBufP(p4_pp[36]), .oBufP(p5[36]));
GP_Buf   gp5Buf37   (.iBufG( g4_pp[37]), .oBufG( g5[37]), .iBufP(p4_pp[37]), .oBufP(p5[37]));
GP_Buf   gp5Buf38   (.iBufG( g4_pp[38]), .oBufG( g5[38]), .iBufP(p4_pp[38]), .oBufP(p5[38]));
GP_Buf   gp5Buf39   (.iBufG( g4_pp[39]), .oBufG( g5[39]), .iBufP(p4_pp[39]), .oBufP(p5[39]));
GP_Buf   gp5Buf40   (.iBufG( g4_pp[40]), .oBufG( g5[40]), .iBufP(p4_pp[40]), .oBufP(p5[40]));
GP_Buf   gp5Buf41   (.iBufG( g4_pp[41]), .oBufG( g5[41]), .iBufP(p4_pp[41]), .oBufP(p5[41]));
GP_Buf   gp5Buf42   (.iBufG( g4_pp[42]), .oBufG( g5[42]), .iBufP(p4_pp[42]), .oBufP(p5[42]));
GP_Buf   gp5Buf43   (.iBufG( g4_pp[43]), .oBufG( g5[43]), .iBufP(p4_pp[43]), .oBufP(p5[43]));
GP_Buf   gp5Buf44   (.iBufG( g4_pp[44]), .oBufG( g5[44]), .iBufP(p4_pp[44]), .oBufP(p5[44]));
GP_Buf   gp5Buf45   (.iBufG( g4_pp[45]), .oBufG( g5[45]), .iBufP(p4_pp[45]), .oBufP(p5[45]));
GP_Buf   gp5Buf46   (.iBufG( g4_pp[46]), .oBufG( g5[46]), .iBufP(p4_pp[46]), .oBufP(p5[46]));
GP_Buf   gp5Buf47   (.iBufG( g4_pp[47]), .oBufG( g5[47]), .iBufP(p4_pp[47]), .oBufP(p5[47]));
GP_Buf   gp5Buf48   (.iBufG( g4_pp[48]), .oBufG( g5[48]), .iBufP(p4_pp[48]), .oBufP(p5[48]));
GP_Buf   gp5Buf49   (.iBufG( g4_pp[49]), .oBufG( g5[49]), .iBufP(p4_pp[49]), .oBufP(p5[49]));
GP_Buf   gp5Buf50   (.iBufG( g4_pp[50]), .oBufG( g5[50]), .iBufP(p4_pp[50]), .oBufP(p5[50]));
GP_Buf   gp5Buf51   (.iBufG( g4_pp[51]), .oBufG( g5[51]), .iBufP(p4_pp[51]), .oBufP(p5[51]));
GP_Buf   gp5Buf52   (.iBufG( g4_pp[52]), .oBufG( g5[52]), .iBufP(p4_pp[52]), .oBufP(p5[52]));
GP_Buf   gp5Buf53   (.iBufG( g4_pp[53]), .oBufG( g5[53]), .iBufP(p4_pp[53]), .oBufP(p5[53]));
GP_Buf   gp5Buf54   (.iBufG( g4_pp[54]), .oBufG( g5[54]), .iBufP(p4_pp[54]), .oBufP(p5[54]));
GP_Buf   gp5Buf55   (.iBufG( g4_pp[55]), .oBufG( g5[55]), .iBufP(p4_pp[55]), .oBufP(p5[55]));
GP_Buf   gp5Buf56   (.iBufG( g4_pp[56]), .oBufG( g5[56]), .iBufP(p4_pp[56]), .oBufP(p5[56]));
GP_Buf   gp5Buf57   (.iBufG( g4_pp[57]), .oBufG( g5[57]), .iBufP(p4_pp[57]), .oBufP(p5[57]));
GP_Buf   gp5Buf58   (.iBufG( g4_pp[58]), .oBufG( g5[58]), .iBufP(p4_pp[58]), .oBufP(p5[58]));
GP_Buf   gp5Buf59   (.iBufG( g4_pp[59]), .oBufG( g5[59]), .iBufP(p4_pp[59]), .oBufP(p5[59]));
GP_Buf   gp5Buf60   (.iBufG( g4_pp[60]), .oBufG( g5[60]), .iBufP(p4_pp[60]), .oBufP(p5[60]));
GP_Buf   gp5Buf61   (.iBufG( g4_pp[61]), .oBufG( g5[61]), .iBufP(p4_pp[61]), .oBufP(p5[61]));
GP_Buf   gp5Buf62   (.iBufG( g4_pp[62]), .oBufG( g5[62]), .iBufP(p4_pp[62]), .oBufP(p5[62]));
GP_Adder gp5Adder63 (.iGi_j1(g4_pp[63]), .iPi_j1(p4_pp[63]), .iGj_k(g4_pp[47]), .iPj_k(p4_pp[47]), .oGi_k(g5[63]), .oPi_k(p5[63]));
//Stage 6
wire  [N-1:0] p6, g6;
GP_Buf   gp6Buf0   (.iBufG( g5[0]), .oBufG( g6[0]), .iBufP(p5[0]), .oBufP(p6[0]));
GP_Buf   gp6Buf1   (.iBufG( g5[1]), .oBufG( g6[1]), .iBufP(p5[1]), .oBufP(p6[1]));
GP_Buf   gp6Buf2   (.iBufG( g5[2]), .oBufG( g6[2]), .iBufP(p5[2]), .oBufP(p6[2]));
GP_Buf   gp6Buf3   (.iBufG( g5[3]), .oBufG( g6[3]), .iBufP(p5[3]), .oBufP(p6[3]));
GP_Buf   gp6Buf4   (.iBufG( g5[4]), .oBufG( g6[4]), .iBufP(p5[4]), .oBufP(p6[4]));
GP_Buf   gp6Buf5   (.iBufG( g5[5]), .oBufG( g6[5]), .iBufP(p5[5]), .oBufP(p6[5]));
GP_Buf   gp6Buf6   (.iBufG( g5[6]), .oBufG( g6[6]), .iBufP(p5[6]), .oBufP(p6[6]));
GP_Buf   gp6Buf7   (.iBufG( g5[7]), .oBufG( g6[7]), .iBufP(p5[7]), .oBufP(p6[7]));
GP_Buf   gp6Buf8   (.iBufG( g5[8]), .oBufG( g6[8]), .iBufP(p5[8]), .oBufP(p6[8]));
GP_Buf   gp6Buf9   (.iBufG( g5[9]), .oBufG( g6[9]), .iBufP(p5[9]), .oBufP(p6[9]));
GP_Buf   gp6Buf10   (.iBufG( g5[10]), .oBufG( g6[10]), .iBufP(p5[10]), .oBufP(p6[10]));
GP_Buf   gp6Buf11   (.iBufG( g5[11]), .oBufG( g6[11]), .iBufP(p5[11]), .oBufP(p6[11]));
GP_Buf   gp6Buf12   (.iBufG( g5[12]), .oBufG( g6[12]), .iBufP(p5[12]), .oBufP(p6[12]));
GP_Buf   gp6Buf13   (.iBufG( g5[13]), .oBufG( g6[13]), .iBufP(p5[13]), .oBufP(p6[13]));
GP_Buf   gp6Buf14   (.iBufG( g5[14]), .oBufG( g6[14]), .iBufP(p5[14]), .oBufP(p6[14]));
GP_Buf   gp6Buf15   (.iBufG( g5[15]), .oBufG( g6[15]), .iBufP(p5[15]), .oBufP(p6[15]));
GP_Buf   gp6Buf16   (.iBufG( g5[16]), .oBufG( g6[16]), .iBufP(p5[16]), .oBufP(p6[16]));
GP_Buf   gp6Buf17   (.iBufG( g5[17]), .oBufG( g6[17]), .iBufP(p5[17]), .oBufP(p6[17]));
GP_Buf   gp6Buf18   (.iBufG( g5[18]), .oBufG( g6[18]), .iBufP(p5[18]), .oBufP(p6[18]));
GP_Buf   gp6Buf19   (.iBufG( g5[19]), .oBufG( g6[19]), .iBufP(p5[19]), .oBufP(p6[19]));
GP_Buf   gp6Buf20   (.iBufG( g5[20]), .oBufG( g6[20]), .iBufP(p5[20]), .oBufP(p6[20]));
GP_Buf   gp6Buf21   (.iBufG( g5[21]), .oBufG( g6[21]), .iBufP(p5[21]), .oBufP(p6[21]));
GP_Buf   gp6Buf22   (.iBufG( g5[22]), .oBufG( g6[22]), .iBufP(p5[22]), .oBufP(p6[22]));
GP_Buf   gp6Buf23   (.iBufG( g5[23]), .oBufG( g6[23]), .iBufP(p5[23]), .oBufP(p6[23]));
GP_Buf   gp6Buf24   (.iBufG( g5[24]), .oBufG( g6[24]), .iBufP(p5[24]), .oBufP(p6[24]));
GP_Buf   gp6Buf25   (.iBufG( g5[25]), .oBufG( g6[25]), .iBufP(p5[25]), .oBufP(p6[25]));
GP_Buf   gp6Buf26   (.iBufG( g5[26]), .oBufG( g6[26]), .iBufP(p5[26]), .oBufP(p6[26]));
GP_Buf   gp6Buf27   (.iBufG( g5[27]), .oBufG( g6[27]), .iBufP(p5[27]), .oBufP(p6[27]));
GP_Buf   gp6Buf28   (.iBufG( g5[28]), .oBufG( g6[28]), .iBufP(p5[28]), .oBufP(p6[28]));
GP_Buf   gp6Buf29   (.iBufG( g5[29]), .oBufG( g6[29]), .iBufP(p5[29]), .oBufP(p6[29]));
GP_Buf   gp6Buf30   (.iBufG( g5[30]), .oBufG( g6[30]), .iBufP(p5[30]), .oBufP(p6[30]));
GP_Buf   gp6Buf31   (.iBufG( g5[31]), .oBufG( g6[31]), .iBufP(p5[31]), .oBufP(p6[31]));
GP_Buf   gp6Buf32   (.iBufG( g5[32]), .oBufG( g6[32]), .iBufP(p5[32]), .oBufP(p6[32]));
GP_Buf   gp6Buf33   (.iBufG( g5[33]), .oBufG( g6[33]), .iBufP(p5[33]), .oBufP(p6[33]));
GP_Buf   gp6Buf34   (.iBufG( g5[34]), .oBufG( g6[34]), .iBufP(p5[34]), .oBufP(p6[34]));
GP_Buf   gp6Buf35   (.iBufG( g5[35]), .oBufG( g6[35]), .iBufP(p5[35]), .oBufP(p6[35]));
GP_Buf   gp6Buf36   (.iBufG( g5[36]), .oBufG( g6[36]), .iBufP(p5[36]), .oBufP(p6[36]));
GP_Buf   gp6Buf37   (.iBufG( g5[37]), .oBufG( g6[37]), .iBufP(p5[37]), .oBufP(p6[37]));
GP_Buf   gp6Buf38   (.iBufG( g5[38]), .oBufG( g6[38]), .iBufP(p5[38]), .oBufP(p6[38]));
GP_Buf   gp6Buf39   (.iBufG( g5[39]), .oBufG( g6[39]), .iBufP(p5[39]), .oBufP(p6[39]));
GP_Buf   gp6Buf40   (.iBufG( g5[40]), .oBufG( g6[40]), .iBufP(p5[40]), .oBufP(p6[40]));
GP_Buf   gp6Buf41   (.iBufG( g5[41]), .oBufG( g6[41]), .iBufP(p5[41]), .oBufP(p6[41]));
GP_Buf   gp6Buf42   (.iBufG( g5[42]), .oBufG( g6[42]), .iBufP(p5[42]), .oBufP(p6[42]));
GP_Buf   gp6Buf43   (.iBufG( g5[43]), .oBufG( g6[43]), .iBufP(p5[43]), .oBufP(p6[43]));
GP_Buf   gp6Buf44   (.iBufG( g5[44]), .oBufG( g6[44]), .iBufP(p5[44]), .oBufP(p6[44]));
GP_Buf   gp6Buf45   (.iBufG( g5[45]), .oBufG( g6[45]), .iBufP(p5[45]), .oBufP(p6[45]));
GP_Buf   gp6Buf46   (.iBufG( g5[46]), .oBufG( g6[46]), .iBufP(p5[46]), .oBufP(p6[46]));
GP_Buf   gp6Buf47   (.iBufG( g5[47]), .oBufG( g6[47]), .iBufP(p5[47]), .oBufP(p6[47]));
GP_Buf   gp6Buf48   (.iBufG( g5[48]), .oBufG( g6[48]), .iBufP(p5[48]), .oBufP(p6[48]));
GP_Buf   gp6Buf49   (.iBufG( g5[49]), .oBufG( g6[49]), .iBufP(p5[49]), .oBufP(p6[49]));
GP_Buf   gp6Buf50   (.iBufG( g5[50]), .oBufG( g6[50]), .iBufP(p5[50]), .oBufP(p6[50]));
GP_Buf   gp6Buf51   (.iBufG( g5[51]), .oBufG( g6[51]), .iBufP(p5[51]), .oBufP(p6[51]));
GP_Buf   gp6Buf52   (.iBufG( g5[52]), .oBufG( g6[52]), .iBufP(p5[52]), .oBufP(p6[52]));
GP_Buf   gp6Buf53   (.iBufG( g5[53]), .oBufG( g6[53]), .iBufP(p5[53]), .oBufP(p6[53]));
GP_Buf   gp6Buf54   (.iBufG( g5[54]), .oBufG( g6[54]), .iBufP(p5[54]), .oBufP(p6[54]));
GP_Buf   gp6Buf55   (.iBufG( g5[55]), .oBufG( g6[55]), .iBufP(p5[55]), .oBufP(p6[55]));
GP_Buf   gp6Buf56   (.iBufG( g5[56]), .oBufG( g6[56]), .iBufP(p5[56]), .oBufP(p6[56]));
GP_Buf   gp6Buf57   (.iBufG( g5[57]), .oBufG( g6[57]), .iBufP(p5[57]), .oBufP(p6[57]));
GP_Buf   gp6Buf58   (.iBufG( g5[58]), .oBufG( g6[58]), .iBufP(p5[58]), .oBufP(p6[58]));
GP_Buf   gp6Buf59   (.iBufG( g5[59]), .oBufG( g6[59]), .iBufP(p5[59]), .oBufP(p6[59]));
GP_Buf   gp6Buf60   (.iBufG( g5[60]), .oBufG( g6[60]), .iBufP(p5[60]), .oBufP(p6[60]));
GP_Buf   gp6Buf61   (.iBufG( g5[61]), .oBufG( g6[61]), .iBufP(p5[61]), .oBufP(p6[61]));
GP_Buf   gp6Buf62   (.iBufG( g5[62]), .oBufG( g6[62]), .iBufP(p5[62]), .oBufP(p6[62]));
GP_Adder gp6Adder63 (.iGi_j1(g5[63]), .iPi_j1(p5[63]), .iGj_k(g5[31]), .iPj_k(p5[31]), .oGi_k(g6[63]), .oPi_k(p6[63]));
//Insert the D-FlipFlops to form pipeline3 
wire  [N-1:0] p6_pp, g6_pp;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P3 (
  .clk(clk),
  .resetn(resetn),
  .D(p6),
  .Q(p6_pp)
);

FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G3 (
  .clk(clk),
  .resetn(resetn),
  .D(g6),
  .Q(g6_pp)
);
//Pipeline the p for the sum 
wire [N-1:0] p_pp3;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP3 (
  .clk(clk),
  .resetn(resetn),
  .D(p_pp2),
  .Q(p_pp3)
);
wire wValidPP3;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay3 (
  .clk(clk), 
  .resetn(resetn), 
  .D(wValidPP2), 
  .Q(wValidPP3) 
);
wire wCarryInPP3;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay3 (
  .clk(clk), 
  .resetn(resetn), 
  .D(iCarryInPP2), 
  .Q(wCarryInPP3) 
);
//Stage 7
wire  [N-1:0] p7, g7;
GP_Buf   gp7Buf0   (.iBufG( g6_pp[0]), .oBufG( g7[0]), .iBufP(p6_pp[0]), .oBufP(p7[0]));
GP_Buf   gp7Buf1   (.iBufG( g6_pp[1]), .oBufG( g7[1]), .iBufP(p6_pp[1]), .oBufP(p7[1]));
GP_Buf   gp7Buf2   (.iBufG( g6_pp[2]), .oBufG( g7[2]), .iBufP(p6_pp[2]), .oBufP(p7[2]));
GP_Buf   gp7Buf3   (.iBufG( g6_pp[3]), .oBufG( g7[3]), .iBufP(p6_pp[3]), .oBufP(p7[3]));
GP_Buf   gp7Buf4   (.iBufG( g6_pp[4]), .oBufG( g7[4]), .iBufP(p6_pp[4]), .oBufP(p7[4]));
GP_Buf   gp7Buf5   (.iBufG( g6_pp[5]), .oBufG( g7[5]), .iBufP(p6_pp[5]), .oBufP(p7[5]));
GP_Buf   gp7Buf6   (.iBufG( g6_pp[6]), .oBufG( g7[6]), .iBufP(p6_pp[6]), .oBufP(p7[6]));
GP_Buf   gp7Buf7   (.iBufG( g6_pp[7]), .oBufG( g7[7]), .iBufP(p6_pp[7]), .oBufP(p7[7]));
GP_Buf   gp7Buf8   (.iBufG( g6_pp[8]), .oBufG( g7[8]), .iBufP(p6_pp[8]), .oBufP(p7[8]));
GP_Buf   gp7Buf9   (.iBufG( g6_pp[9]), .oBufG( g7[9]), .iBufP(p6_pp[9]), .oBufP(p7[9]));
GP_Buf   gp7Buf10   (.iBufG( g6_pp[10]), .oBufG( g7[10]), .iBufP(p6_pp[10]), .oBufP(p7[10]));
GP_Buf   gp7Buf11   (.iBufG( g6_pp[11]), .oBufG( g7[11]), .iBufP(p6_pp[11]), .oBufP(p7[11]));
GP_Buf   gp7Buf12   (.iBufG( g6_pp[12]), .oBufG( g7[12]), .iBufP(p6_pp[12]), .oBufP(p7[12]));
GP_Buf   gp7Buf13   (.iBufG( g6_pp[13]), .oBufG( g7[13]), .iBufP(p6_pp[13]), .oBufP(p7[13]));
GP_Buf   gp7Buf14   (.iBufG( g6_pp[14]), .oBufG( g7[14]), .iBufP(p6_pp[14]), .oBufP(p7[14]));
GP_Buf   gp7Buf15   (.iBufG( g6_pp[15]), .oBufG( g7[15]), .iBufP(p6_pp[15]), .oBufP(p7[15]));
GP_Buf   gp7Buf16   (.iBufG( g6_pp[16]), .oBufG( g7[16]), .iBufP(p6_pp[16]), .oBufP(p7[16]));
GP_Buf   gp7Buf17   (.iBufG( g6_pp[17]), .oBufG( g7[17]), .iBufP(p6_pp[17]), .oBufP(p7[17]));
GP_Buf   gp7Buf18   (.iBufG( g6_pp[18]), .oBufG( g7[18]), .iBufP(p6_pp[18]), .oBufP(p7[18]));
GP_Buf   gp7Buf19   (.iBufG( g6_pp[19]), .oBufG( g7[19]), .iBufP(p6_pp[19]), .oBufP(p7[19]));
GP_Buf   gp7Buf20   (.iBufG( g6_pp[20]), .oBufG( g7[20]), .iBufP(p6_pp[20]), .oBufP(p7[20]));
GP_Buf   gp7Buf21   (.iBufG( g6_pp[21]), .oBufG( g7[21]), .iBufP(p6_pp[21]), .oBufP(p7[21]));
GP_Buf   gp7Buf22   (.iBufG( g6_pp[22]), .oBufG( g7[22]), .iBufP(p6_pp[22]), .oBufP(p7[22]));
GP_Buf   gp7Buf23   (.iBufG( g6_pp[23]), .oBufG( g7[23]), .iBufP(p6_pp[23]), .oBufP(p7[23]));
GP_Buf   gp7Buf24   (.iBufG( g6_pp[24]), .oBufG( g7[24]), .iBufP(p6_pp[24]), .oBufP(p7[24]));
GP_Buf   gp7Buf25   (.iBufG( g6_pp[25]), .oBufG( g7[25]), .iBufP(p6_pp[25]), .oBufP(p7[25]));
GP_Buf   gp7Buf26   (.iBufG( g6_pp[26]), .oBufG( g7[26]), .iBufP(p6_pp[26]), .oBufP(p7[26]));
GP_Buf   gp7Buf27   (.iBufG( g6_pp[27]), .oBufG( g7[27]), .iBufP(p6_pp[27]), .oBufP(p7[27]));
GP_Buf   gp7Buf28   (.iBufG( g6_pp[28]), .oBufG( g7[28]), .iBufP(p6_pp[28]), .oBufP(p7[28]));
GP_Buf   gp7Buf29   (.iBufG( g6_pp[29]), .oBufG( g7[29]), .iBufP(p6_pp[29]), .oBufP(p7[29]));
GP_Buf   gp7Buf30   (.iBufG( g6_pp[30]), .oBufG( g7[30]), .iBufP(p6_pp[30]), .oBufP(p7[30]));
GP_Buf   gp7Buf31   (.iBufG( g6_pp[31]), .oBufG( g7[31]), .iBufP(p6_pp[31]), .oBufP(p7[31]));
GP_Buf   gp7Buf32   (.iBufG( g6_pp[32]), .oBufG( g7[32]), .iBufP(p6_pp[32]), .oBufP(p7[32]));
GP_Buf   gp7Buf33   (.iBufG( g6_pp[33]), .oBufG( g7[33]), .iBufP(p6_pp[33]), .oBufP(p7[33]));
GP_Buf   gp7Buf34   (.iBufG( g6_pp[34]), .oBufG( g7[34]), .iBufP(p6_pp[34]), .oBufP(p7[34]));
GP_Buf   gp7Buf35   (.iBufG( g6_pp[35]), .oBufG( g7[35]), .iBufP(p6_pp[35]), .oBufP(p7[35]));
GP_Buf   gp7Buf36   (.iBufG( g6_pp[36]), .oBufG( g7[36]), .iBufP(p6_pp[36]), .oBufP(p7[36]));
GP_Buf   gp7Buf37   (.iBufG( g6_pp[37]), .oBufG( g7[37]), .iBufP(p6_pp[37]), .oBufP(p7[37]));
GP_Buf   gp7Buf38   (.iBufG( g6_pp[38]), .oBufG( g7[38]), .iBufP(p6_pp[38]), .oBufP(p7[38]));
GP_Buf   gp7Buf39   (.iBufG( g6_pp[39]), .oBufG( g7[39]), .iBufP(p6_pp[39]), .oBufP(p7[39]));
GP_Buf   gp7Buf40   (.iBufG( g6_pp[40]), .oBufG( g7[40]), .iBufP(p6_pp[40]), .oBufP(p7[40]));
GP_Buf   gp7Buf41   (.iBufG( g6_pp[41]), .oBufG( g7[41]), .iBufP(p6_pp[41]), .oBufP(p7[41]));
GP_Buf   gp7Buf42   (.iBufG( g6_pp[42]), .oBufG( g7[42]), .iBufP(p6_pp[42]), .oBufP(p7[42]));
GP_Buf   gp7Buf43   (.iBufG( g6_pp[43]), .oBufG( g7[43]), .iBufP(p6_pp[43]), .oBufP(p7[43]));
GP_Buf   gp7Buf44   (.iBufG( g6_pp[44]), .oBufG( g7[44]), .iBufP(p6_pp[44]), .oBufP(p7[44]));
GP_Buf   gp7Buf45   (.iBufG( g6_pp[45]), .oBufG( g7[45]), .iBufP(p6_pp[45]), .oBufP(p7[45]));
GP_Buf   gp7Buf46   (.iBufG( g6_pp[46]), .oBufG( g7[46]), .iBufP(p6_pp[46]), .oBufP(p7[46]));
GP_Adder gp7Adder47 (.iGi_j1(g6_pp[47]), .iPi_j1(p6_pp[47]), .iGj_k(g6_pp[31]), .iPj_k(p6_pp[31]), .oGi_k(g7[47]), .oPi_k(p7[47]));
GP_Buf   gp7Buf48   (.iBufG( g6_pp[48]), .oBufG( g7[48]), .iBufP(p6_pp[48]), .oBufP(p7[48]));
GP_Buf   gp7Buf49   (.iBufG( g6_pp[49]), .oBufG( g7[49]), .iBufP(p6_pp[49]), .oBufP(p7[49]));
GP_Buf   gp7Buf50   (.iBufG( g6_pp[50]), .oBufG( g7[50]), .iBufP(p6_pp[50]), .oBufP(p7[50]));
GP_Buf   gp7Buf51   (.iBufG( g6_pp[51]), .oBufG( g7[51]), .iBufP(p6_pp[51]), .oBufP(p7[51]));
GP_Buf   gp7Buf52   (.iBufG( g6_pp[52]), .oBufG( g7[52]), .iBufP(p6_pp[52]), .oBufP(p7[52]));
GP_Buf   gp7Buf53   (.iBufG( g6_pp[53]), .oBufG( g7[53]), .iBufP(p6_pp[53]), .oBufP(p7[53]));
GP_Buf   gp7Buf54   (.iBufG( g6_pp[54]), .oBufG( g7[54]), .iBufP(p6_pp[54]), .oBufP(p7[54]));
GP_Buf   gp7Buf55   (.iBufG( g6_pp[55]), .oBufG( g7[55]), .iBufP(p6_pp[55]), .oBufP(p7[55]));
GP_Buf   gp7Buf56   (.iBufG( g6_pp[56]), .oBufG( g7[56]), .iBufP(p6_pp[56]), .oBufP(p7[56]));
GP_Buf   gp7Buf57   (.iBufG( g6_pp[57]), .oBufG( g7[57]), .iBufP(p6_pp[57]), .oBufP(p7[57]));
GP_Buf   gp7Buf58   (.iBufG( g6_pp[58]), .oBufG( g7[58]), .iBufP(p6_pp[58]), .oBufP(p7[58]));
GP_Buf   gp7Buf59   (.iBufG( g6_pp[59]), .oBufG( g7[59]), .iBufP(p6_pp[59]), .oBufP(p7[59]));
GP_Buf   gp7Buf60   (.iBufG( g6_pp[60]), .oBufG( g7[60]), .iBufP(p6_pp[60]), .oBufP(p7[60]));
GP_Buf   gp7Buf61   (.iBufG( g6_pp[61]), .oBufG( g7[61]), .iBufP(p6_pp[61]), .oBufP(p7[61]));
GP_Buf   gp7Buf62   (.iBufG( g6_pp[62]), .oBufG( g7[62]), .iBufP(p6_pp[62]), .oBufP(p7[62]));
GP_Buf   gp7Buf63   (.iBufG( g6_pp[63]), .oBufG( g7[63]), .iBufP(p6_pp[63]), .oBufP(p7[63]));
//Stage 8
wire  [N-1:0] p8, g8;
GP_Buf   gp8Buf0   (.iBufG( g7[0]), .oBufG( g8[0]), .iBufP(p7[0]), .oBufP(p8[0]));
GP_Buf   gp8Buf1   (.iBufG( g7[1]), .oBufG( g8[1]), .iBufP(p7[1]), .oBufP(p8[1]));
GP_Buf   gp8Buf2   (.iBufG( g7[2]), .oBufG( g8[2]), .iBufP(p7[2]), .oBufP(p8[2]));
GP_Buf   gp8Buf3   (.iBufG( g7[3]), .oBufG( g8[3]), .iBufP(p7[3]), .oBufP(p8[3]));
GP_Buf   gp8Buf4   (.iBufG( g7[4]), .oBufG( g8[4]), .iBufP(p7[4]), .oBufP(p8[4]));
GP_Buf   gp8Buf5   (.iBufG( g7[5]), .oBufG( g8[5]), .iBufP(p7[5]), .oBufP(p8[5]));
GP_Buf   gp8Buf6   (.iBufG( g7[6]), .oBufG( g8[6]), .iBufP(p7[6]), .oBufP(p8[6]));
GP_Buf   gp8Buf7   (.iBufG( g7[7]), .oBufG( g8[7]), .iBufP(p7[7]), .oBufP(p8[7]));
GP_Buf   gp8Buf8   (.iBufG( g7[8]), .oBufG( g8[8]), .iBufP(p7[8]), .oBufP(p8[8]));
GP_Buf   gp8Buf9   (.iBufG( g7[9]), .oBufG( g8[9]), .iBufP(p7[9]), .oBufP(p8[9]));
GP_Buf   gp8Buf10   (.iBufG( g7[10]), .oBufG( g8[10]), .iBufP(p7[10]), .oBufP(p8[10]));
GP_Buf   gp8Buf11   (.iBufG( g7[11]), .oBufG( g8[11]), .iBufP(p7[11]), .oBufP(p8[11]));
GP_Buf   gp8Buf12   (.iBufG( g7[12]), .oBufG( g8[12]), .iBufP(p7[12]), .oBufP(p8[12]));
GP_Buf   gp8Buf13   (.iBufG( g7[13]), .oBufG( g8[13]), .iBufP(p7[13]), .oBufP(p8[13]));
GP_Buf   gp8Buf14   (.iBufG( g7[14]), .oBufG( g8[14]), .iBufP(p7[14]), .oBufP(p8[14]));
GP_Buf   gp8Buf15   (.iBufG( g7[15]), .oBufG( g8[15]), .iBufP(p7[15]), .oBufP(p8[15]));
GP_Buf   gp8Buf16   (.iBufG( g7[16]), .oBufG( g8[16]), .iBufP(p7[16]), .oBufP(p8[16]));
GP_Buf   gp8Buf17   (.iBufG( g7[17]), .oBufG( g8[17]), .iBufP(p7[17]), .oBufP(p8[17]));
GP_Buf   gp8Buf18   (.iBufG( g7[18]), .oBufG( g8[18]), .iBufP(p7[18]), .oBufP(p8[18]));
GP_Buf   gp8Buf19   (.iBufG( g7[19]), .oBufG( g8[19]), .iBufP(p7[19]), .oBufP(p8[19]));
GP_Buf   gp8Buf20   (.iBufG( g7[20]), .oBufG( g8[20]), .iBufP(p7[20]), .oBufP(p8[20]));
GP_Buf   gp8Buf21   (.iBufG( g7[21]), .oBufG( g8[21]), .iBufP(p7[21]), .oBufP(p8[21]));
GP_Buf   gp8Buf22   (.iBufG( g7[22]), .oBufG( g8[22]), .iBufP(p7[22]), .oBufP(p8[22]));
GP_Adder gp8Adder23 (.iGi_j1(g7[23]), .iPi_j1(p7[23]), .iGj_k(g7[15]), .iPj_k(p7[15]), .oGi_k(g8[23]), .oPi_k(p8[23]));
GP_Buf   gp8Buf24   (.iBufG( g7[24]), .oBufG( g8[24]), .iBufP(p7[24]), .oBufP(p8[24]));
GP_Buf   gp8Buf25   (.iBufG( g7[25]), .oBufG( g8[25]), .iBufP(p7[25]), .oBufP(p8[25]));
GP_Buf   gp8Buf26   (.iBufG( g7[26]), .oBufG( g8[26]), .iBufP(p7[26]), .oBufP(p8[26]));
GP_Buf   gp8Buf27   (.iBufG( g7[27]), .oBufG( g8[27]), .iBufP(p7[27]), .oBufP(p8[27]));
GP_Buf   gp8Buf28   (.iBufG( g7[28]), .oBufG( g8[28]), .iBufP(p7[28]), .oBufP(p8[28]));
GP_Buf   gp8Buf29   (.iBufG( g7[29]), .oBufG( g8[29]), .iBufP(p7[29]), .oBufP(p8[29]));
GP_Buf   gp8Buf30   (.iBufG( g7[30]), .oBufG( g8[30]), .iBufP(p7[30]), .oBufP(p8[30]));
GP_Buf   gp8Buf31   (.iBufG( g7[31]), .oBufG( g8[31]), .iBufP(p7[31]), .oBufP(p8[31]));
GP_Buf   gp8Buf32   (.iBufG( g7[32]), .oBufG( g8[32]), .iBufP(p7[32]), .oBufP(p8[32]));
GP_Buf   gp8Buf33   (.iBufG( g7[33]), .oBufG( g8[33]), .iBufP(p7[33]), .oBufP(p8[33]));
GP_Buf   gp8Buf34   (.iBufG( g7[34]), .oBufG( g8[34]), .iBufP(p7[34]), .oBufP(p8[34]));
GP_Buf   gp8Buf35   (.iBufG( g7[35]), .oBufG( g8[35]), .iBufP(p7[35]), .oBufP(p8[35]));
GP_Buf   gp8Buf36   (.iBufG( g7[36]), .oBufG( g8[36]), .iBufP(p7[36]), .oBufP(p8[36]));
GP_Buf   gp8Buf37   (.iBufG( g7[37]), .oBufG( g8[37]), .iBufP(p7[37]), .oBufP(p8[37]));
GP_Buf   gp8Buf38   (.iBufG( g7[38]), .oBufG( g8[38]), .iBufP(p7[38]), .oBufP(p8[38]));
GP_Adder gp8Adder39 (.iGi_j1(g7[39]), .iPi_j1(p7[39]), .iGj_k(g7[31]), .iPj_k(p7[31]), .oGi_k(g8[39]), .oPi_k(p8[39]));
GP_Buf   gp8Buf40   (.iBufG( g7[40]), .oBufG( g8[40]), .iBufP(p7[40]), .oBufP(p8[40]));
GP_Buf   gp8Buf41   (.iBufG( g7[41]), .oBufG( g8[41]), .iBufP(p7[41]), .oBufP(p8[41]));
GP_Buf   gp8Buf42   (.iBufG( g7[42]), .oBufG( g8[42]), .iBufP(p7[42]), .oBufP(p8[42]));
GP_Buf   gp8Buf43   (.iBufG( g7[43]), .oBufG( g8[43]), .iBufP(p7[43]), .oBufP(p8[43]));
GP_Buf   gp8Buf44   (.iBufG( g7[44]), .oBufG( g8[44]), .iBufP(p7[44]), .oBufP(p8[44]));
GP_Buf   gp8Buf45   (.iBufG( g7[45]), .oBufG( g8[45]), .iBufP(p7[45]), .oBufP(p8[45]));
GP_Buf   gp8Buf46   (.iBufG( g7[46]), .oBufG( g8[46]), .iBufP(p7[46]), .oBufP(p8[46]));
GP_Buf   gp8Buf47   (.iBufG( g7[47]), .oBufG( g8[47]), .iBufP(p7[47]), .oBufP(p8[47]));
GP_Buf   gp8Buf48   (.iBufG( g7[48]), .oBufG( g8[48]), .iBufP(p7[48]), .oBufP(p8[48]));
GP_Buf   gp8Buf49   (.iBufG( g7[49]), .oBufG( g8[49]), .iBufP(p7[49]), .oBufP(p8[49]));
GP_Buf   gp8Buf50   (.iBufG( g7[50]), .oBufG( g8[50]), .iBufP(p7[50]), .oBufP(p8[50]));
GP_Buf   gp8Buf51   (.iBufG( g7[51]), .oBufG( g8[51]), .iBufP(p7[51]), .oBufP(p8[51]));
GP_Buf   gp8Buf52   (.iBufG( g7[52]), .oBufG( g8[52]), .iBufP(p7[52]), .oBufP(p8[52]));
GP_Buf   gp8Buf53   (.iBufG( g7[53]), .oBufG( g8[53]), .iBufP(p7[53]), .oBufP(p8[53]));
GP_Buf   gp8Buf54   (.iBufG( g7[54]), .oBufG( g8[54]), .iBufP(p7[54]), .oBufP(p8[54]));
GP_Adder gp8Adder55 (.iGi_j1(g7[55]), .iPi_j1(p7[55]), .iGj_k(g7[47]), .iPj_k(p7[47]), .oGi_k(g8[55]), .oPi_k(p8[55]));
GP_Buf   gp8Buf56   (.iBufG( g7[56]), .oBufG( g8[56]), .iBufP(p7[56]), .oBufP(p8[56]));
GP_Buf   gp8Buf57   (.iBufG( g7[57]), .oBufG( g8[57]), .iBufP(p7[57]), .oBufP(p8[57]));
GP_Buf   gp8Buf58   (.iBufG( g7[58]), .oBufG( g8[58]), .iBufP(p7[58]), .oBufP(p8[58]));
GP_Buf   gp8Buf59   (.iBufG( g7[59]), .oBufG( g8[59]), .iBufP(p7[59]), .oBufP(p8[59]));
GP_Buf   gp8Buf60   (.iBufG( g7[60]), .oBufG( g8[60]), .iBufP(p7[60]), .oBufP(p8[60]));
GP_Buf   gp8Buf61   (.iBufG( g7[61]), .oBufG( g8[61]), .iBufP(p7[61]), .oBufP(p8[61]));
GP_Buf   gp8Buf62   (.iBufG( g7[62]), .oBufG( g8[62]), .iBufP(p7[62]), .oBufP(p8[62]));
GP_Buf   gp8Buf63   (.iBufG( g7[63]), .oBufG( g8[63]), .iBufP(p7[63]), .oBufP(p8[63]));
//Insert the D-FlipFlops to form pipeline4 
wire  [N-1:0] p8_pp, g8_pp;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P4 (
  .clk(clk),
  .resetn(resetn),
  .D(p8),
  .Q(p8_pp)
);

FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G4 (
  .clk(clk),
  .resetn(resetn),
  .D(g8),
  .Q(g8_pp)
);
//Pipeline the p for the sum 
wire [N-1:0] p_pp4;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP4 (
  .clk(clk),
  .resetn(resetn),
  .D(p_pp3),
  .Q(p_pp4)
);
wire wValidPP4;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay4 (
  .clk(clk), 
  .resetn(resetn), 
  .D(wValidPP3), 
  .Q(wValidPP4) 
);
wire wCarryInPP4;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay4 (
  .clk(clk), 
  .resetn(resetn), 
  .D(iCarryInPP3), 
  .Q(wCarryInPP4) 
);
//Stage 9
wire  [N-1:0] p9, g9;
GP_Buf   gp9Buf0   (.iBufG( g8_pp[0]), .oBufG( g9[0]), .iBufP(p8_pp[0]), .oBufP(p9[0]));
GP_Buf   gp9Buf1   (.iBufG( g8_pp[1]), .oBufG( g9[1]), .iBufP(p8_pp[1]), .oBufP(p9[1]));
GP_Buf   gp9Buf2   (.iBufG( g8_pp[2]), .oBufG( g9[2]), .iBufP(p8_pp[2]), .oBufP(p9[2]));
GP_Buf   gp9Buf3   (.iBufG( g8_pp[3]), .oBufG( g9[3]), .iBufP(p8_pp[3]), .oBufP(p9[3]));
GP_Buf   gp9Buf4   (.iBufG( g8_pp[4]), .oBufG( g9[4]), .iBufP(p8_pp[4]), .oBufP(p9[4]));
GP_Buf   gp9Buf5   (.iBufG( g8_pp[5]), .oBufG( g9[5]), .iBufP(p8_pp[5]), .oBufP(p9[5]));
GP_Buf   gp9Buf6   (.iBufG( g8_pp[6]), .oBufG( g9[6]), .iBufP(p8_pp[6]), .oBufP(p9[6]));
GP_Buf   gp9Buf7   (.iBufG( g8_pp[7]), .oBufG( g9[7]), .iBufP(p8_pp[7]), .oBufP(p9[7]));
GP_Buf   gp9Buf8   (.iBufG( g8_pp[8]), .oBufG( g9[8]), .iBufP(p8_pp[8]), .oBufP(p9[8]));
GP_Buf   gp9Buf9   (.iBufG( g8_pp[9]), .oBufG( g9[9]), .iBufP(p8_pp[9]), .oBufP(p9[9]));
GP_Buf   gp9Buf10   (.iBufG( g8_pp[10]), .oBufG( g9[10]), .iBufP(p8_pp[10]), .oBufP(p9[10]));
GP_Adder gp9Adder11 (.iGi_j1(g8_pp[11]), .iPi_j1(p8_pp[11]), .iGj_k(g8_pp[7]), .iPj_k(p8_pp[7]), .oGi_k(g9[11]), .oPi_k(p9[11]));
GP_Buf   gp9Buf12   (.iBufG( g8_pp[12]), .oBufG( g9[12]), .iBufP(p8_pp[12]), .oBufP(p9[12]));
GP_Buf   gp9Buf13   (.iBufG( g8_pp[13]), .oBufG( g9[13]), .iBufP(p8_pp[13]), .oBufP(p9[13]));
GP_Buf   gp9Buf14   (.iBufG( g8_pp[14]), .oBufG( g9[14]), .iBufP(p8_pp[14]), .oBufP(p9[14]));
GP_Buf   gp9Buf15   (.iBufG( g8_pp[15]), .oBufG( g9[15]), .iBufP(p8_pp[15]), .oBufP(p9[15]));
GP_Buf   gp9Buf16   (.iBufG( g8_pp[16]), .oBufG( g9[16]), .iBufP(p8_pp[16]), .oBufP(p9[16]));
GP_Buf   gp9Buf17   (.iBufG( g8_pp[17]), .oBufG( g9[17]), .iBufP(p8_pp[17]), .oBufP(p9[17]));
GP_Buf   gp9Buf18   (.iBufG( g8_pp[18]), .oBufG( g9[18]), .iBufP(p8_pp[18]), .oBufP(p9[18]));
GP_Adder gp9Adder19 (.iGi_j1(g8_pp[19]), .iPi_j1(p8_pp[19]), .iGj_k(g8_pp[15]), .iPj_k(p8_pp[15]), .oGi_k(g9[19]), .oPi_k(p9[19]));
GP_Buf   gp9Buf20   (.iBufG( g8_pp[20]), .oBufG( g9[20]), .iBufP(p8_pp[20]), .oBufP(p9[20]));
GP_Buf   gp9Buf21   (.iBufG( g8_pp[21]), .oBufG( g9[21]), .iBufP(p8_pp[21]), .oBufP(p9[21]));
GP_Buf   gp9Buf22   (.iBufG( g8_pp[22]), .oBufG( g9[22]), .iBufP(p8_pp[22]), .oBufP(p9[22]));
GP_Buf   gp9Buf23   (.iBufG( g8_pp[23]), .oBufG( g9[23]), .iBufP(p8_pp[23]), .oBufP(p9[23]));
GP_Buf   gp9Buf24   (.iBufG( g8_pp[24]), .oBufG( g9[24]), .iBufP(p8_pp[24]), .oBufP(p9[24]));
GP_Buf   gp9Buf25   (.iBufG( g8_pp[25]), .oBufG( g9[25]), .iBufP(p8_pp[25]), .oBufP(p9[25]));
GP_Buf   gp9Buf26   (.iBufG( g8_pp[26]), .oBufG( g9[26]), .iBufP(p8_pp[26]), .oBufP(p9[26]));
GP_Adder gp9Adder27 (.iGi_j1(g8_pp[27]), .iPi_j1(p8_pp[27]), .iGj_k(g8_pp[23]), .iPj_k(p8_pp[23]), .oGi_k(g9[27]), .oPi_k(p9[27]));
GP_Buf   gp9Buf28   (.iBufG( g8_pp[28]), .oBufG( g9[28]), .iBufP(p8_pp[28]), .oBufP(p9[28]));
GP_Buf   gp9Buf29   (.iBufG( g8_pp[29]), .oBufG( g9[29]), .iBufP(p8_pp[29]), .oBufP(p9[29]));
GP_Buf   gp9Buf30   (.iBufG( g8_pp[30]), .oBufG( g9[30]), .iBufP(p8_pp[30]), .oBufP(p9[30]));
GP_Buf   gp9Buf31   (.iBufG( g8_pp[31]), .oBufG( g9[31]), .iBufP(p8_pp[31]), .oBufP(p9[31]));
GP_Buf   gp9Buf32   (.iBufG( g8_pp[32]), .oBufG( g9[32]), .iBufP(p8_pp[32]), .oBufP(p9[32]));
GP_Buf   gp9Buf33   (.iBufG( g8_pp[33]), .oBufG( g9[33]), .iBufP(p8_pp[33]), .oBufP(p9[33]));
GP_Buf   gp9Buf34   (.iBufG( g8_pp[34]), .oBufG( g9[34]), .iBufP(p8_pp[34]), .oBufP(p9[34]));
GP_Adder gp9Adder35 (.iGi_j1(g8_pp[35]), .iPi_j1(p8_pp[35]), .iGj_k(g8_pp[31]), .iPj_k(p8_pp[31]), .oGi_k(g9[35]), .oPi_k(p9[35]));
GP_Buf   gp9Buf36   (.iBufG( g8_pp[36]), .oBufG( g9[36]), .iBufP(p8_pp[36]), .oBufP(p9[36]));
GP_Buf   gp9Buf37   (.iBufG( g8_pp[37]), .oBufG( g9[37]), .iBufP(p8_pp[37]), .oBufP(p9[37]));
GP_Buf   gp9Buf38   (.iBufG( g8_pp[38]), .oBufG( g9[38]), .iBufP(p8_pp[38]), .oBufP(p9[38]));
GP_Buf   gp9Buf39   (.iBufG( g8_pp[39]), .oBufG( g9[39]), .iBufP(p8_pp[39]), .oBufP(p9[39]));
GP_Buf   gp9Buf40   (.iBufG( g8_pp[40]), .oBufG( g9[40]), .iBufP(p8_pp[40]), .oBufP(p9[40]));
GP_Buf   gp9Buf41   (.iBufG( g8_pp[41]), .oBufG( g9[41]), .iBufP(p8_pp[41]), .oBufP(p9[41]));
GP_Buf   gp9Buf42   (.iBufG( g8_pp[42]), .oBufG( g9[42]), .iBufP(p8_pp[42]), .oBufP(p9[42]));
GP_Adder gp9Adder43 (.iGi_j1(g8_pp[43]), .iPi_j1(p8_pp[43]), .iGj_k(g8_pp[39]), .iPj_k(p8_pp[39]), .oGi_k(g9[43]), .oPi_k(p9[43]));
GP_Buf   gp9Buf44   (.iBufG( g8_pp[44]), .oBufG( g9[44]), .iBufP(p8_pp[44]), .oBufP(p9[44]));
GP_Buf   gp9Buf45   (.iBufG( g8_pp[45]), .oBufG( g9[45]), .iBufP(p8_pp[45]), .oBufP(p9[45]));
GP_Buf   gp9Buf46   (.iBufG( g8_pp[46]), .oBufG( g9[46]), .iBufP(p8_pp[46]), .oBufP(p9[46]));
GP_Buf   gp9Buf47   (.iBufG( g8_pp[47]), .oBufG( g9[47]), .iBufP(p8_pp[47]), .oBufP(p9[47]));
GP_Buf   gp9Buf48   (.iBufG( g8_pp[48]), .oBufG( g9[48]), .iBufP(p8_pp[48]), .oBufP(p9[48]));
GP_Buf   gp9Buf49   (.iBufG( g8_pp[49]), .oBufG( g9[49]), .iBufP(p8_pp[49]), .oBufP(p9[49]));
GP_Buf   gp9Buf50   (.iBufG( g8_pp[50]), .oBufG( g9[50]), .iBufP(p8_pp[50]), .oBufP(p9[50]));
GP_Adder gp9Adder51 (.iGi_j1(g8_pp[51]), .iPi_j1(p8_pp[51]), .iGj_k(g8_pp[47]), .iPj_k(p8_pp[47]), .oGi_k(g9[51]), .oPi_k(p9[51]));
GP_Buf   gp9Buf52   (.iBufG( g8_pp[52]), .oBufG( g9[52]), .iBufP(p8_pp[52]), .oBufP(p9[52]));
GP_Buf   gp9Buf53   (.iBufG( g8_pp[53]), .oBufG( g9[53]), .iBufP(p8_pp[53]), .oBufP(p9[53]));
GP_Buf   gp9Buf54   (.iBufG( g8_pp[54]), .oBufG( g9[54]), .iBufP(p8_pp[54]), .oBufP(p9[54]));
GP_Buf   gp9Buf55   (.iBufG( g8_pp[55]), .oBufG( g9[55]), .iBufP(p8_pp[55]), .oBufP(p9[55]));
GP_Buf   gp9Buf56   (.iBufG( g8_pp[56]), .oBufG( g9[56]), .iBufP(p8_pp[56]), .oBufP(p9[56]));
GP_Buf   gp9Buf57   (.iBufG( g8_pp[57]), .oBufG( g9[57]), .iBufP(p8_pp[57]), .oBufP(p9[57]));
GP_Buf   gp9Buf58   (.iBufG( g8_pp[58]), .oBufG( g9[58]), .iBufP(p8_pp[58]), .oBufP(p9[58]));
GP_Adder gp9Adder59 (.iGi_j1(g8_pp[59]), .iPi_j1(p8_pp[59]), .iGj_k(g8_pp[55]), .iPj_k(p8_pp[55]), .oGi_k(g9[59]), .oPi_k(p9[59]));
GP_Buf   gp9Buf60   (.iBufG( g8_pp[60]), .oBufG( g9[60]), .iBufP(p8_pp[60]), .oBufP(p9[60]));
GP_Buf   gp9Buf61   (.iBufG( g8_pp[61]), .oBufG( g9[61]), .iBufP(p8_pp[61]), .oBufP(p9[61]));
GP_Buf   gp9Buf62   (.iBufG( g8_pp[62]), .oBufG( g9[62]), .iBufP(p8_pp[62]), .oBufP(p9[62]));
GP_Buf   gp9Buf63   (.iBufG( g8_pp[63]), .oBufG( g9[63]), .iBufP(p8_pp[63]), .oBufP(p9[63]));
//Stage 10
wire  [N-1:0] p10, g10;
GP_Buf   gp10Buf0   (.iBufG( g9[0]), .oBufG( g10[0]), .iBufP(p9[0]), .oBufP(p10[0]));
GP_Buf   gp10Buf1   (.iBufG( g9[1]), .oBufG( g10[1]), .iBufP(p9[1]), .oBufP(p10[1]));
GP_Buf   gp10Buf2   (.iBufG( g9[2]), .oBufG( g10[2]), .iBufP(p9[2]), .oBufP(p10[2]));
GP_Buf   gp10Buf3   (.iBufG( g9[3]), .oBufG( g10[3]), .iBufP(p9[3]), .oBufP(p10[3]));
GP_Buf   gp10Buf4   (.iBufG( g9[4]), .oBufG( g10[4]), .iBufP(p9[4]), .oBufP(p10[4]));
GP_Adder gp10Adder5 (.iGi_j1(g9[5]), .iPi_j1(p9[5]), .iGj_k(g9[3]), .iPj_k(p9[3]), .oGi_k(g10[5]), .oPi_k(p10[5]));
GP_Buf   gp10Buf6   (.iBufG( g9[6]), .oBufG( g10[6]), .iBufP(p9[6]), .oBufP(p10[6]));
GP_Buf   gp10Buf7   (.iBufG( g9[7]), .oBufG( g10[7]), .iBufP(p9[7]), .oBufP(p10[7]));
GP_Buf   gp10Buf8   (.iBufG( g9[8]), .oBufG( g10[8]), .iBufP(p9[8]), .oBufP(p10[8]));
GP_Adder gp10Adder9 (.iGi_j1(g9[9]), .iPi_j1(p9[9]), .iGj_k(g9[7]), .iPj_k(p9[7]), .oGi_k(g10[9]), .oPi_k(p10[9]));
GP_Buf   gp10Buf10   (.iBufG( g9[10]), .oBufG( g10[10]), .iBufP(p9[10]), .oBufP(p10[10]));
GP_Buf   gp10Buf11   (.iBufG( g9[11]), .oBufG( g10[11]), .iBufP(p9[11]), .oBufP(p10[11]));
GP_Buf   gp10Buf12   (.iBufG( g9[12]), .oBufG( g10[12]), .iBufP(p9[12]), .oBufP(p10[12]));
GP_Adder gp10Adder13 (.iGi_j1(g9[13]), .iPi_j1(p9[13]), .iGj_k(g9[11]), .iPj_k(p9[11]), .oGi_k(g10[13]), .oPi_k(p10[13]));
GP_Buf   gp10Buf14   (.iBufG( g9[14]), .oBufG( g10[14]), .iBufP(p9[14]), .oBufP(p10[14]));
GP_Buf   gp10Buf15   (.iBufG( g9[15]), .oBufG( g10[15]), .iBufP(p9[15]), .oBufP(p10[15]));
GP_Buf   gp10Buf16   (.iBufG( g9[16]), .oBufG( g10[16]), .iBufP(p9[16]), .oBufP(p10[16]));
GP_Adder gp10Adder17 (.iGi_j1(g9[17]), .iPi_j1(p9[17]), .iGj_k(g9[15]), .iPj_k(p9[15]), .oGi_k(g10[17]), .oPi_k(p10[17]));
GP_Buf   gp10Buf18   (.iBufG( g9[18]), .oBufG( g10[18]), .iBufP(p9[18]), .oBufP(p10[18]));
GP_Buf   gp10Buf19   (.iBufG( g9[19]), .oBufG( g10[19]), .iBufP(p9[19]), .oBufP(p10[19]));
GP_Buf   gp10Buf20   (.iBufG( g9[20]), .oBufG( g10[20]), .iBufP(p9[20]), .oBufP(p10[20]));
GP_Adder gp10Adder21 (.iGi_j1(g9[21]), .iPi_j1(p9[21]), .iGj_k(g9[19]), .iPj_k(p9[19]), .oGi_k(g10[21]), .oPi_k(p10[21]));
GP_Buf   gp10Buf22   (.iBufG( g9[22]), .oBufG( g10[22]), .iBufP(p9[22]), .oBufP(p10[22]));
GP_Buf   gp10Buf23   (.iBufG( g9[23]), .oBufG( g10[23]), .iBufP(p9[23]), .oBufP(p10[23]));
GP_Buf   gp10Buf24   (.iBufG( g9[24]), .oBufG( g10[24]), .iBufP(p9[24]), .oBufP(p10[24]));
GP_Adder gp10Adder25 (.iGi_j1(g9[25]), .iPi_j1(p9[25]), .iGj_k(g9[23]), .iPj_k(p9[23]), .oGi_k(g10[25]), .oPi_k(p10[25]));
GP_Buf   gp10Buf26   (.iBufG( g9[26]), .oBufG( g10[26]), .iBufP(p9[26]), .oBufP(p10[26]));
GP_Buf   gp10Buf27   (.iBufG( g9[27]), .oBufG( g10[27]), .iBufP(p9[27]), .oBufP(p10[27]));
GP_Buf   gp10Buf28   (.iBufG( g9[28]), .oBufG( g10[28]), .iBufP(p9[28]), .oBufP(p10[28]));
GP_Adder gp10Adder29 (.iGi_j1(g9[29]), .iPi_j1(p9[29]), .iGj_k(g9[27]), .iPj_k(p9[27]), .oGi_k(g10[29]), .oPi_k(p10[29]));
GP_Buf   gp10Buf30   (.iBufG( g9[30]), .oBufG( g10[30]), .iBufP(p9[30]), .oBufP(p10[30]));
GP_Buf   gp10Buf31   (.iBufG( g9[31]), .oBufG( g10[31]), .iBufP(p9[31]), .oBufP(p10[31]));
GP_Buf   gp10Buf32   (.iBufG( g9[32]), .oBufG( g10[32]), .iBufP(p9[32]), .oBufP(p10[32]));
GP_Adder gp10Adder33 (.iGi_j1(g9[33]), .iPi_j1(p9[33]), .iGj_k(g9[31]), .iPj_k(p9[31]), .oGi_k(g10[33]), .oPi_k(p10[33]));
GP_Buf   gp10Buf34   (.iBufG( g9[34]), .oBufG( g10[34]), .iBufP(p9[34]), .oBufP(p10[34]));
GP_Buf   gp10Buf35   (.iBufG( g9[35]), .oBufG( g10[35]), .iBufP(p9[35]), .oBufP(p10[35]));
GP_Buf   gp10Buf36   (.iBufG( g9[36]), .oBufG( g10[36]), .iBufP(p9[36]), .oBufP(p10[36]));
GP_Adder gp10Adder37 (.iGi_j1(g9[37]), .iPi_j1(p9[37]), .iGj_k(g9[35]), .iPj_k(p9[35]), .oGi_k(g10[37]), .oPi_k(p10[37]));
GP_Buf   gp10Buf38   (.iBufG( g9[38]), .oBufG( g10[38]), .iBufP(p9[38]), .oBufP(p10[38]));
GP_Buf   gp10Buf39   (.iBufG( g9[39]), .oBufG( g10[39]), .iBufP(p9[39]), .oBufP(p10[39]));
GP_Buf   gp10Buf40   (.iBufG( g9[40]), .oBufG( g10[40]), .iBufP(p9[40]), .oBufP(p10[40]));
GP_Adder gp10Adder41 (.iGi_j1(g9[41]), .iPi_j1(p9[41]), .iGj_k(g9[39]), .iPj_k(p9[39]), .oGi_k(g10[41]), .oPi_k(p10[41]));
GP_Buf   gp10Buf42   (.iBufG( g9[42]), .oBufG( g10[42]), .iBufP(p9[42]), .oBufP(p10[42]));
GP_Buf   gp10Buf43   (.iBufG( g9[43]), .oBufG( g10[43]), .iBufP(p9[43]), .oBufP(p10[43]));
GP_Buf   gp10Buf44   (.iBufG( g9[44]), .oBufG( g10[44]), .iBufP(p9[44]), .oBufP(p10[44]));
GP_Adder gp10Adder45 (.iGi_j1(g9[45]), .iPi_j1(p9[45]), .iGj_k(g9[43]), .iPj_k(p9[43]), .oGi_k(g10[45]), .oPi_k(p10[45]));
GP_Buf   gp10Buf46   (.iBufG( g9[46]), .oBufG( g10[46]), .iBufP(p9[46]), .oBufP(p10[46]));
GP_Buf   gp10Buf47   (.iBufG( g9[47]), .oBufG( g10[47]), .iBufP(p9[47]), .oBufP(p10[47]));
GP_Buf   gp10Buf48   (.iBufG( g9[48]), .oBufG( g10[48]), .iBufP(p9[48]), .oBufP(p10[48]));
GP_Adder gp10Adder49 (.iGi_j1(g9[49]), .iPi_j1(p9[49]), .iGj_k(g9[47]), .iPj_k(p9[47]), .oGi_k(g10[49]), .oPi_k(p10[49]));
GP_Buf   gp10Buf50   (.iBufG( g9[50]), .oBufG( g10[50]), .iBufP(p9[50]), .oBufP(p10[50]));
GP_Buf   gp10Buf51   (.iBufG( g9[51]), .oBufG( g10[51]), .iBufP(p9[51]), .oBufP(p10[51]));
GP_Buf   gp10Buf52   (.iBufG( g9[52]), .oBufG( g10[52]), .iBufP(p9[52]), .oBufP(p10[52]));
GP_Adder gp10Adder53 (.iGi_j1(g9[53]), .iPi_j1(p9[53]), .iGj_k(g9[51]), .iPj_k(p9[51]), .oGi_k(g10[53]), .oPi_k(p10[53]));
GP_Buf   gp10Buf54   (.iBufG( g9[54]), .oBufG( g10[54]), .iBufP(p9[54]), .oBufP(p10[54]));
GP_Buf   gp10Buf55   (.iBufG( g9[55]), .oBufG( g10[55]), .iBufP(p9[55]), .oBufP(p10[55]));
GP_Buf   gp10Buf56   (.iBufG( g9[56]), .oBufG( g10[56]), .iBufP(p9[56]), .oBufP(p10[56]));
GP_Adder gp10Adder57 (.iGi_j1(g9[57]), .iPi_j1(p9[57]), .iGj_k(g9[55]), .iPj_k(p9[55]), .oGi_k(g10[57]), .oPi_k(p10[57]));
GP_Buf   gp10Buf58   (.iBufG( g9[58]), .oBufG( g10[58]), .iBufP(p9[58]), .oBufP(p10[58]));
GP_Buf   gp10Buf59   (.iBufG( g9[59]), .oBufG( g10[59]), .iBufP(p9[59]), .oBufP(p10[59]));
GP_Buf   gp10Buf60   (.iBufG( g9[60]), .oBufG( g10[60]), .iBufP(p9[60]), .oBufP(p10[60]));
GP_Adder gp10Adder61 (.iGi_j1(g9[61]), .iPi_j1(p9[61]), .iGj_k(g9[59]), .iPj_k(p9[59]), .oGi_k(g10[61]), .oPi_k(p10[61]));
GP_Buf   gp10Buf62   (.iBufG( g9[62]), .oBufG( g10[62]), .iBufP(p9[62]), .oBufP(p10[62]));
GP_Buf   gp10Buf63   (.iBufG( g9[63]), .oBufG( g10[63]), .iBufP(p9[63]), .oBufP(p10[63]));
//Insert the D-FlipFlops to form pipeline5 
wire  [N-1:0] p10_pp, g10_pp;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P5 (
  .clk(clk),
  .resetn(resetn),
  .D(p10),
  .Q(p10_pp)
);

FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G5 (
  .clk(clk),
  .resetn(resetn),
  .D(g10),
  .Q(g10_pp)
);
//Pipeline the p for the sum 
wire [N-1:0] p_pp5;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP5 (
  .clk(clk),
  .resetn(resetn),
  .D(p_pp4),
  .Q(p_pp5)
);
wire wValidPP5;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay5 (
  .clk(clk), 
  .resetn(resetn), 
  .D(wValidPP4), 
  .Q(wValidPP5) 
);
wire wCarryInPP5;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay5 (
  .clk(clk), 
  .resetn(resetn), 
  .D(iCarryInPP4), 
  .Q(wCarryInPP5) 
);
//Stage 11
wire  [N-1:0] p11, g11;
GP_Buf   gp11Buf0   (.iBufG( g10_pp[0]), .oBufG( g11[0]), .iBufP(p10_pp[0]), .oBufP(p11[0]));
GP_Buf   gp11Buf1   (.iBufG( g10_pp[1]), .oBufG( g11[1]), .iBufP(p10_pp[1]), .oBufP(p11[1]));
GP_Adder gp11Adder2 (.iGi_j1(g10_pp[2]), .iPi_j1(p10_pp[2]), .iGj_k(g10_pp[1]), .iPj_k(p10_pp[1]), .oGi_k(g11[2]), .oPi_k(p11[2]));
GP_Buf   gp11Buf3   (.iBufG( g10_pp[3]), .oBufG( g11[3]), .iBufP(p10_pp[3]), .oBufP(p11[3]));
GP_Adder gp11Adder4 (.iGi_j1(g10_pp[4]), .iPi_j1(p10_pp[4]), .iGj_k(g10_pp[3]), .iPj_k(p10_pp[3]), .oGi_k(g11[4]), .oPi_k(p11[4]));
GP_Buf   gp11Buf5   (.iBufG( g10_pp[5]), .oBufG( g11[5]), .iBufP(p10_pp[5]), .oBufP(p11[5]));
GP_Adder gp11Adder6 (.iGi_j1(g10_pp[6]), .iPi_j1(p10_pp[6]), .iGj_k(g10_pp[5]), .iPj_k(p10_pp[5]), .oGi_k(g11[6]), .oPi_k(p11[6]));
GP_Buf   gp11Buf7   (.iBufG( g10_pp[7]), .oBufG( g11[7]), .iBufP(p10_pp[7]), .oBufP(p11[7]));
GP_Adder gp11Adder8 (.iGi_j1(g10_pp[8]), .iPi_j1(p10_pp[8]), .iGj_k(g10_pp[7]), .iPj_k(p10_pp[7]), .oGi_k(g11[8]), .oPi_k(p11[8]));
GP_Buf   gp11Buf9   (.iBufG( g10_pp[9]), .oBufG( g11[9]), .iBufP(p10_pp[9]), .oBufP(p11[9]));
GP_Adder gp11Adder10 (.iGi_j1(g10_pp[10]), .iPi_j1(p10_pp[10]), .iGj_k(g10_pp[9]), .iPj_k(p10_pp[9]), .oGi_k(g11[10]), .oPi_k(p11[10]));
GP_Buf   gp11Buf11   (.iBufG( g10_pp[11]), .oBufG( g11[11]), .iBufP(p10_pp[11]), .oBufP(p11[11]));
GP_Adder gp11Adder12 (.iGi_j1(g10_pp[12]), .iPi_j1(p10_pp[12]), .iGj_k(g10_pp[11]), .iPj_k(p10_pp[11]), .oGi_k(g11[12]), .oPi_k(p11[12]));
GP_Buf   gp11Buf13   (.iBufG( g10_pp[13]), .oBufG( g11[13]), .iBufP(p10_pp[13]), .oBufP(p11[13]));
GP_Adder gp11Adder14 (.iGi_j1(g10_pp[14]), .iPi_j1(p10_pp[14]), .iGj_k(g10_pp[13]), .iPj_k(p10_pp[13]), .oGi_k(g11[14]), .oPi_k(p11[14]));
GP_Buf   gp11Buf15   (.iBufG( g10_pp[15]), .oBufG( g11[15]), .iBufP(p10_pp[15]), .oBufP(p11[15]));
GP_Adder gp11Adder16 (.iGi_j1(g10_pp[16]), .iPi_j1(p10_pp[16]), .iGj_k(g10_pp[15]), .iPj_k(p10_pp[15]), .oGi_k(g11[16]), .oPi_k(p11[16]));
GP_Buf   gp11Buf17   (.iBufG( g10_pp[17]), .oBufG( g11[17]), .iBufP(p10_pp[17]), .oBufP(p11[17]));
GP_Adder gp11Adder18 (.iGi_j1(g10_pp[18]), .iPi_j1(p10_pp[18]), .iGj_k(g10_pp[17]), .iPj_k(p10_pp[17]), .oGi_k(g11[18]), .oPi_k(p11[18]));
GP_Buf   gp11Buf19   (.iBufG( g10_pp[19]), .oBufG( g11[19]), .iBufP(p10_pp[19]), .oBufP(p11[19]));
GP_Adder gp11Adder20 (.iGi_j1(g10_pp[20]), .iPi_j1(p10_pp[20]), .iGj_k(g10_pp[19]), .iPj_k(p10_pp[19]), .oGi_k(g11[20]), .oPi_k(p11[20]));
GP_Buf   gp11Buf21   (.iBufG( g10_pp[21]), .oBufG( g11[21]), .iBufP(p10_pp[21]), .oBufP(p11[21]));
GP_Adder gp11Adder22 (.iGi_j1(g10_pp[22]), .iPi_j1(p10_pp[22]), .iGj_k(g10_pp[21]), .iPj_k(p10_pp[21]), .oGi_k(g11[22]), .oPi_k(p11[22]));
GP_Buf   gp11Buf23   (.iBufG( g10_pp[23]), .oBufG( g11[23]), .iBufP(p10_pp[23]), .oBufP(p11[23]));
GP_Adder gp11Adder24 (.iGi_j1(g10_pp[24]), .iPi_j1(p10_pp[24]), .iGj_k(g10_pp[23]), .iPj_k(p10_pp[23]), .oGi_k(g11[24]), .oPi_k(p11[24]));
GP_Buf   gp11Buf25   (.iBufG( g10_pp[25]), .oBufG( g11[25]), .iBufP(p10_pp[25]), .oBufP(p11[25]));
GP_Adder gp11Adder26 (.iGi_j1(g10_pp[26]), .iPi_j1(p10_pp[26]), .iGj_k(g10_pp[25]), .iPj_k(p10_pp[25]), .oGi_k(g11[26]), .oPi_k(p11[26]));
GP_Buf   gp11Buf27   (.iBufG( g10_pp[27]), .oBufG( g11[27]), .iBufP(p10_pp[27]), .oBufP(p11[27]));
GP_Adder gp11Adder28 (.iGi_j1(g10_pp[28]), .iPi_j1(p10_pp[28]), .iGj_k(g10_pp[27]), .iPj_k(p10_pp[27]), .oGi_k(g11[28]), .oPi_k(p11[28]));
GP_Buf   gp11Buf29   (.iBufG( g10_pp[29]), .oBufG( g11[29]), .iBufP(p10_pp[29]), .oBufP(p11[29]));
GP_Adder gp11Adder30 (.iGi_j1(g10_pp[30]), .iPi_j1(p10_pp[30]), .iGj_k(g10_pp[29]), .iPj_k(p10_pp[29]), .oGi_k(g11[30]), .oPi_k(p11[30]));
GP_Buf   gp11Buf31   (.iBufG( g10_pp[31]), .oBufG( g11[31]), .iBufP(p10_pp[31]), .oBufP(p11[31]));
GP_Adder gp11Adder32 (.iGi_j1(g10_pp[32]), .iPi_j1(p10_pp[32]), .iGj_k(g10_pp[31]), .iPj_k(p10_pp[31]), .oGi_k(g11[32]), .oPi_k(p11[32]));
GP_Buf   gp11Buf33   (.iBufG( g10_pp[33]), .oBufG( g11[33]), .iBufP(p10_pp[33]), .oBufP(p11[33]));
GP_Adder gp11Adder34 (.iGi_j1(g10_pp[34]), .iPi_j1(p10_pp[34]), .iGj_k(g10_pp[33]), .iPj_k(p10_pp[33]), .oGi_k(g11[34]), .oPi_k(p11[34]));
GP_Buf   gp11Buf35   (.iBufG( g10_pp[35]), .oBufG( g11[35]), .iBufP(p10_pp[35]), .oBufP(p11[35]));
GP_Adder gp11Adder36 (.iGi_j1(g10_pp[36]), .iPi_j1(p10_pp[36]), .iGj_k(g10_pp[35]), .iPj_k(p10_pp[35]), .oGi_k(g11[36]), .oPi_k(p11[36]));
GP_Buf   gp11Buf37   (.iBufG( g10_pp[37]), .oBufG( g11[37]), .iBufP(p10_pp[37]), .oBufP(p11[37]));
GP_Adder gp11Adder38 (.iGi_j1(g10_pp[38]), .iPi_j1(p10_pp[38]), .iGj_k(g10_pp[37]), .iPj_k(p10_pp[37]), .oGi_k(g11[38]), .oPi_k(p11[38]));
GP_Buf   gp11Buf39   (.iBufG( g10_pp[39]), .oBufG( g11[39]), .iBufP(p10_pp[39]), .oBufP(p11[39]));
GP_Adder gp11Adder40 (.iGi_j1(g10_pp[40]), .iPi_j1(p10_pp[40]), .iGj_k(g10_pp[39]), .iPj_k(p10_pp[39]), .oGi_k(g11[40]), .oPi_k(p11[40]));
GP_Buf   gp11Buf41   (.iBufG( g10_pp[41]), .oBufG( g11[41]), .iBufP(p10_pp[41]), .oBufP(p11[41]));
GP_Adder gp11Adder42 (.iGi_j1(g10_pp[42]), .iPi_j1(p10_pp[42]), .iGj_k(g10_pp[41]), .iPj_k(p10_pp[41]), .oGi_k(g11[42]), .oPi_k(p11[42]));
GP_Buf   gp11Buf43   (.iBufG( g10_pp[43]), .oBufG( g11[43]), .iBufP(p10_pp[43]), .oBufP(p11[43]));
GP_Adder gp11Adder44 (.iGi_j1(g10_pp[44]), .iPi_j1(p10_pp[44]), .iGj_k(g10_pp[43]), .iPj_k(p10_pp[43]), .oGi_k(g11[44]), .oPi_k(p11[44]));
GP_Buf   gp11Buf45   (.iBufG( g10_pp[45]), .oBufG( g11[45]), .iBufP(p10_pp[45]), .oBufP(p11[45]));
GP_Adder gp11Adder46 (.iGi_j1(g10_pp[46]), .iPi_j1(p10_pp[46]), .iGj_k(g10_pp[45]), .iPj_k(p10_pp[45]), .oGi_k(g11[46]), .oPi_k(p11[46]));
GP_Buf   gp11Buf47   (.iBufG( g10_pp[47]), .oBufG( g11[47]), .iBufP(p10_pp[47]), .oBufP(p11[47]));
GP_Adder gp11Adder48 (.iGi_j1(g10_pp[48]), .iPi_j1(p10_pp[48]), .iGj_k(g10_pp[47]), .iPj_k(p10_pp[47]), .oGi_k(g11[48]), .oPi_k(p11[48]));
GP_Buf   gp11Buf49   (.iBufG( g10_pp[49]), .oBufG( g11[49]), .iBufP(p10_pp[49]), .oBufP(p11[49]));
GP_Adder gp11Adder50 (.iGi_j1(g10_pp[50]), .iPi_j1(p10_pp[50]), .iGj_k(g10_pp[49]), .iPj_k(p10_pp[49]), .oGi_k(g11[50]), .oPi_k(p11[50]));
GP_Buf   gp11Buf51   (.iBufG( g10_pp[51]), .oBufG( g11[51]), .iBufP(p10_pp[51]), .oBufP(p11[51]));
GP_Adder gp11Adder52 (.iGi_j1(g10_pp[52]), .iPi_j1(p10_pp[52]), .iGj_k(g10_pp[51]), .iPj_k(p10_pp[51]), .oGi_k(g11[52]), .oPi_k(p11[52]));
GP_Buf   gp11Buf53   (.iBufG( g10_pp[53]), .oBufG( g11[53]), .iBufP(p10_pp[53]), .oBufP(p11[53]));
GP_Adder gp11Adder54 (.iGi_j1(g10_pp[54]), .iPi_j1(p10_pp[54]), .iGj_k(g10_pp[53]), .iPj_k(p10_pp[53]), .oGi_k(g11[54]), .oPi_k(p11[54]));
GP_Buf   gp11Buf55   (.iBufG( g10_pp[55]), .oBufG( g11[55]), .iBufP(p10_pp[55]), .oBufP(p11[55]));
GP_Adder gp11Adder56 (.iGi_j1(g10_pp[56]), .iPi_j1(p10_pp[56]), .iGj_k(g10_pp[55]), .iPj_k(p10_pp[55]), .oGi_k(g11[56]), .oPi_k(p11[56]));
GP_Buf   gp11Buf57   (.iBufG( g10_pp[57]), .oBufG( g11[57]), .iBufP(p10_pp[57]), .oBufP(p11[57]));
GP_Adder gp11Adder58 (.iGi_j1(g10_pp[58]), .iPi_j1(p10_pp[58]), .iGj_k(g10_pp[57]), .iPj_k(p10_pp[57]), .oGi_k(g11[58]), .oPi_k(p11[58]));
GP_Buf   gp11Buf59   (.iBufG( g10_pp[59]), .oBufG( g11[59]), .iBufP(p10_pp[59]), .oBufP(p11[59]));
GP_Adder gp11Adder60 (.iGi_j1(g10_pp[60]), .iPi_j1(p10_pp[60]), .iGj_k(g10_pp[59]), .iPj_k(p10_pp[59]), .oGi_k(g11[60]), .oPi_k(p11[60]));
GP_Buf   gp11Buf61   (.iBufG( g10_pp[61]), .oBufG( g11[61]), .iBufP(p10_pp[61]), .oBufP(p11[61]));
GP_Adder gp11Adder62 (.iGi_j1(g10_pp[62]), .iPi_j1(p10_pp[62]), .iGj_k(g10_pp[61]), .iPj_k(p10_pp[61]), .oGi_k(g11[62]), .oPi_k(p11[62]));
GP_Buf   gp11Buf63   (.iBufG( g10_pp[63]), .oBufG( g11[63]), .iBufP(p10_pp[63]), .oBufP(p11[63]));
//Output the sum
wire wValidPP6;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay6 (
  .clk(clk), 
  .resetn(resetn), 
  .D(wValidPP5), 
  .Q(wValidPP6) 
);
wire wValidPP7;
FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay7 (
  .clk(clk), 
  .resetn(resetn), 
  .D(wValidPP6), 
  .Q(wValidPP7) 
);
assign oZ[0] = p_pp5[0];
generate for (i=1; i<N; i=i+1 ) begin 
    assign oZ [i] = p_pp5[i]^ g11[i-1]; 
end endgenerate                       
assign oCarryOut = g11[N-1];         
assign oReady    = wValidPP7;          

endmodule 
