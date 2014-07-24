#!/usr/bin/perl -w
#Author      : Alex Zhang (cgzhnagwei@gmail.com)
#Date        : Jul.23.2014
#Description : Brent-Kung N bit adder Impletionation
#Notice      : A propagation delay of 2log2N-2 levels. 2 Stages are formed a pipeline.
#Usage       : gen_brent_kung_adder.pl N Name
#              parameter N is the N bits input. 
#              parameter Name is the output file name. 
#              Support the 64bits, 32bits adder
#
my $nNumArgs;
my $nBits;
my $oFileName;
my $sDateInfo= `date +%m-%d-%Y`;

$nNumArgs  = $#ARGV +1;
if ($nNumArgs==1) {
    $nBits     = $ARGV[0];
    $oFileName = "Adder".$nBits."BitBrentKung.v";
}elsif ($nNumArgs ==2) {
    $nBits     = $ARGV[0];
    $oFileName = $ARGV[1];
}elsif ($nNumArgs ==0) {
    print "Missing the Bits info\n";
    exit;
}
open (OUT, ">$oFileName") || die "Cannot open output file $oFileName !!!\n";

printf OUT "//Author    : Alex Zhang (cgzhangwei\@gmail.com)\n";
printf OUT "//Date      : $sDateInfo\n";

#Output the macro define
printf OUT "`define WIDTH $nBits\n";
printf OUT "module Adder$nBits"."BitBrentKung(\n";
printf OUT "clk, resetn,\n";
printf OUT "iValid,iCarryIn,\n";
printf OUT "iX,iY,\n";
printf OUT "oZ,oCarryOut,oReady\n";
printf OUT ");\n";
printf OUT "input  clk;\n";
printf OUT "input  resetn;\n";
printf OUT "input  iValid;\n";
printf OUT "input  iCarryIn;\n";
printf OUT "input  iX;\n";
printf OUT "input  iY;\n";
printf OUT "output oZ;\n";
printf OUT "output oCarryOut;\n";
printf OUT "output oReady;\n";
printf OUT "parameter N=$nBits;\n";

printf OUT "wire [N-1:0] iX;\n";
printf OUT "wire [N-1:0] iY;\n";
printf OUT "wire [N-1:0] oZ;\n";
printf OUT "wire         oReady;\n";
printf OUT "wire         oCarryOut;\n";

##input D-FlipFlop 
printf OUT "//Input DFF\n";
printf OUT "wire [N-1:0] p0,g0,wX,wY;\n";

printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_X ( \n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iX), \n";
printf OUT "  .Q(wX) \n";
printf OUT ");\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_Y ( \n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iY), \n";
printf OUT "  .Q(wY) \n";
printf OUT "); \n";

printf OUT "wire wValidPP1;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay1 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iValid), \n";
printf OUT "  .Q(wValidPP1) \n";
printf OUT ");\n";
printf OUT "wire wCarryInPP1;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay1 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iCarryIn), \n";
printf OUT "  .Q(wCarryInPP1) \n";
printf OUT ");\n";

printf OUT "genvar i;         \n";
printf OUT "generate for (i=0; i<N; i++) begin :pg_cla\n";
printf OUT "    assign p0[i] = wX[i]^wY[i];\n";
printf OUT "    assign g0[i] = wX[i]&wY[i];\n";
printf OUT "end endgenerate \n";

#Stage 0
printf OUT "//Insert the D-FlipFlops to form pipeline \n";
printf OUT "wire  [N-1:0] p, g;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P0 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p0),\n";
printf OUT "  .Q(p)\n";
printf OUT ");\n";
printf OUT "\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G0 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(g0),\n";
printf OUT "  .Q(g)\n";
printf OUT ");\n";
#Stage 1
##Start the Forward-prefix computation
#Add the odd element with the even element 
printf OUT "//Stage 1\n";
printf OUT "wire [N-1:0] p1, g1;\n";
my $id;
for (my $k=0; $k<$nBits; $k+=2 ) {
    $id=$k+1;
    printf OUT "GP_Buf   gp1Buf$k   (.iBufG( g[$k]), .oBufG(g1[$k]), .iBufP(p[$k]), .oBufP(p1[$k]));\n";
    printf OUT "GP_Adder gp1Adder$id (.iGi_j1(g[$id]), .iPi_j1(p[$id]), .iGj_k(g[$k]), .iPj_k( p[$k]), .oGi_k(g1[$id]), .oPi_k(p1[$id]));\n";
}

#Stage 2
##Add the 3, 7, 11, 15 (+4) element with the (-2) element
my $pos;
my $prev;
printf OUT "//Stage 2\n";
printf OUT "wire  [N-1:0] p2, g2;\n";
$id=0;
$pos=4;
$prev=2;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k+1)%$pos ==0 ) {
        $id ++;
        my $k2 = $pos*$id-1;
        my $k3 = $k2-$prev;
        printf OUT "GP_Adder gp2Adder$k2 (.iGi_j1(g1[$k2]), .iPi_j1(p1[$k2]), .iGj_k(g1[$k3]), .iPj_k(p1[$k3]), .oGi_k(g2[$k2]), .oPi_k(p2[$k2]));\n";

    } else {
        printf OUT "GP_Buf   gp2Buf$k   (.iBufG( g1[$k]), .oBufG( g2[$k]), .iBufP(p1[$k]), .oBufP(p2[$k]));\n";
    } 
}

#Insert the D-FF to form pipeline 
printf OUT "//Insert the D-FlipFlops to form pipeline1 \n";
printf OUT "wire  [N-1:0] p2_pp, g2_pp;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P1 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p2),\n";
printf OUT "  .Q(p2_pp)\n";
printf OUT ");\n";
printf OUT "\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G1 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(g2),\n";
printf OUT "  .Q(g2_pp)\n";
printf OUT ");\n";
printf OUT "//Pipeline the p for the sum \n";
printf OUT "wire [N-1:0] p_pp1;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP1 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p),\n";
printf OUT "  .Q(p_pp1)\n";
printf OUT ");\n";

##Stage 3
##Add the 7, 15 (+8) element with -4 element
printf OUT "//Stage 3\n";
printf OUT "wire  [N-1:0] p3, g3;\n";
$id=0;
$pos=8;
$prev=4;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k+1)%$pos ==0 ) {
        $id ++;
        my $k2 = $pos*$id-1;
        my $k3 = $k2-$prev;
        printf OUT "GP_Adder gp3Adder$k2 (.iGi_j1(g2_pp[$k2]), .iPi_j1(p2_pp[$k2]), .iGj_k(g2_pp[$k3]), .iPj_k(p2_pp[$k3]), .oGi_k(g3[$k2]), .oPi_k(p3[$k2]));\n";
    } else {
        printf OUT "GP_Buf   gp3Buf$k   (.iBufG( g2_pp[$k]), .oBufG( g3[$k]), .iBufP(p2_pp[$k]), .oBufP(p3[$k]));\n";
    } 
}


##Stage 4
##Add the 15, 31, 47, 63 (+16) element with -8 element
printf OUT "//Stage 4\n";
printf OUT "wire  [N-1:0] p4, g4;\n";
$id=0;
$pos=16;
$prev=8;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k+1)%$pos ==0 ) {
        $id ++;
        my $k2 = $pos*$id-1;
        my $k3 = $k2-$prev;
        printf OUT "GP_Adder gp4Adder$k2 (.iGi_j1(g3[$k2]), .iPi_j1(p3[$k2]), .iGj_k(g3[$k3]), .iPj_k(p3[$k3]), .oGi_k(g4[$k2]), .oPi_k(p4[$k2]));\n";
    } else {
        printf OUT "GP_Buf   gp4Buf$k   (.iBufG( g3[$k]), .oBufG( g4[$k]), .iBufP(p3[$k]), .oBufP(p4[$k]));\n";
    } 
}
#Insert the D-FF to form pipeline 
printf OUT "//Insert the D-FlipFlops to form pipeline2 \n";
printf OUT "wire  [N-1:0] p4_pp, g4_pp;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P2 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p4),\n";
printf OUT "  .Q(p4_pp)\n";
printf OUT ");\n";
printf OUT "\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G2 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(g4),\n";
printf OUT "  .Q(g4_pp)\n";
printf OUT ");\n";
printf OUT "//Pipeline the p for the sum \n";
printf OUT "wire [N-1:0] p_pp2;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP2 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p_pp1),\n";
printf OUT "  .Q(p_pp2)\n";
printf OUT ");\n";

printf OUT "wire wValidPP2;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay2 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(wValidPP1), \n";
printf OUT "  .Q(wValidPP2) \n";
printf OUT ");\n";
printf OUT "wire wCarryInPP2;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay2 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iCarryInPP1), \n";
printf OUT "  .Q(wCarryInPP2) \n";
printf OUT ");\n";
##Stage 5
##Add the 31, 63 (+32) element with -16 element
printf OUT "//Stage 5\n";
printf OUT "wire  [N-1:0] p5, g5;\n";
$id=0;
$pos=32;
$prev=16;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k+1)%$pos ==0 ) {
        $id ++;
        my $k2 = $pos*$id-1;
        my $k3 = $k2-$prev;
        printf OUT "GP_Adder gp5Adder$k2 (.iGi_j1(g4_pp[$k2]), .iPi_j1(p4_pp[$k2]), .iGj_k(g4_pp[$k3]), .iPj_k(p4_pp[$k3]), .oGi_k(g5[$k2]), .oPi_k(p5[$k2]));\n";
    } else {
        printf OUT "GP_Buf   gp5Buf$k   (.iBufG( g4_pp[$k]), .oBufG( g5[$k]), .iBufP(p4_pp[$k]), .oBufP(p5[$k]));\n";
    } 
}

if ($nBits == 64 ) {
##Stage 6
#Add the 63 (+64) element with -32 element
    printf OUT "//Stage 6\n";
    printf OUT "wire  [N-1:0] p6, g6;\n";
    $id=0;
    $pos=64;
    $prev=32;
    for (my $k=0; $k<$nBits; $k=$k+1 ) {
        if ( ($k+1)%$pos ==0 ) {
            $id ++;
            my $k2 = $pos*$id-1;
            my $k3 = $k2-$prev;
            printf OUT "GP_Adder gp6Adder$k2 (.iGi_j1(g5[$k2]), .iPi_j1(p5[$k2]), .iGj_k(g5[$k3]), .iPj_k(p5[$k3]), .oGi_k(g6[$k2]), .oPi_k(p6[$k2]));\n";
        } else {
            printf OUT "GP_Buf   gp6Buf$k   (.iBufG( g5[$k]), .oBufG( g6[$k]), .iBufP(p5[$k]), .oBufP(p6[$k]));\n";
        } 
    }
#Insert the D-FF to form pipeline 
printf OUT "//Insert the D-FlipFlops to form pipeline3 \n";
printf OUT "wire  [N-1:0] p6_pp, g6_pp;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P3 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p6),\n";
printf OUT "  .Q(p6_pp)\n";
printf OUT ");\n";
printf OUT "\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G3 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(g6),\n";
printf OUT "  .Q(g6_pp)\n";
printf OUT ");\n";
printf OUT "//Pipeline the p for the sum \n";
printf OUT "wire [N-1:0] p_pp3;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP3 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p_pp2),\n";
printf OUT "  .Q(p_pp3)\n";
printf OUT ");\n";
printf OUT "wire wValidPP3;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay3 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(wValidPP2), \n";
printf OUT "  .Q(wValidPP3) \n";
printf OUT ");\n";
printf OUT "wire wCarryInPP3;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay3 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iCarryInPP2), \n";
printf OUT "  .Q(wCarryInPP3) \n";
printf OUT ");\n";

##Start the Backward-prefix computation
##Stage 7
#Add the 48 element with the -16 element for the N-1 element
printf OUT "//Stage 7\n";
printf OUT "wire  [N-1:0] p7, g7;\n";
$id=0;
$pos=16;
$prev=16;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k+1)%$pos ==0 ) {
        $id ++;
        if ($id==3) {
            my $k2 = $pos*$id-1;
            my $k3 = $k2-$prev;
            printf OUT "GP_Adder gp7Adder$k2 (.iGi_j1(g6_pp[$k2]), .iPi_j1(p6_pp[$k2]), .iGj_k(g6_pp[$k3]), .iPj_k(p6_pp[$k3]), .oGi_k(g7[$k2]), .oPi_k(p7[$k2]));\n";
        } else {
            printf OUT "GP_Buf   gp7Buf$k   (.iBufG( g6_pp[$k]), .oBufG( g7[$k]), .iBufP(p6_pp[$k]), .oBufP(p7[$k]));\n";
        }
    } else {
        printf OUT "GP_Buf   gp7Buf$k   (.iBufG( g6_pp[$k]), .oBufG( g7[$k]), .iBufP(p6_pp[$k]), .oBufP(p7[$k]));\n";
    } 
}
##Stage8 
#Add the 48 element with the -8 element for the N-1 element
printf OUT "//Stage 8\n";
printf OUT "wire  [N-1:0] p8, g8;\n";
$id=0;
$pos=8;
$prev=8;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k+1)%$pos ==0 ) {
            $id ++;
            if (($id>2) && ($id<8) && ($id%2==1) ) {
            my $k2 = $pos*$id-1;
            my $k3 = $k2-$prev;
            printf OUT "GP_Adder gp8Adder$k2 (.iGi_j1(g7[$k2]), .iPi_j1(p7[$k2]), .iGj_k(g7[$k3]), .iPj_k(p7[$k3]), .oGi_k(g8[$k2]), .oPi_k(p8[$k2]));\n";
        } else {
            printf OUT "GP_Buf   gp8Buf$k   (.iBufG( g7[$k]), .oBufG( g8[$k]), .iBufP(p7[$k]), .oBufP(p8[$k]));\n";
        }
    } else {
        printf OUT "GP_Buf   gp8Buf$k   (.iBufG( g7[$k]), .oBufG( g8[$k]), .iBufP(p7[$k]), .oBufP(p8[$k]));\n";
    } 
}
#Insert the D-FF to form pipeline 
printf OUT "//Insert the D-FlipFlops to form pipeline4 \n";
printf OUT "wire  [N-1:0] p8_pp, g8_pp;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P4 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p8),\n";
printf OUT "  .Q(p8_pp)\n";
printf OUT ");\n";
printf OUT "\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G4 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(g8),\n";
printf OUT "  .Q(g8_pp)\n";
printf OUT ");\n";
printf OUT "//Pipeline the p for the sum \n";
printf OUT "wire [N-1:0] p_pp4;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP4 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p_pp3),\n";
printf OUT "  .Q(p_pp4)\n";
printf OUT ");\n";
printf OUT "wire wValidPP4;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay4 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(wValidPP3), \n";
printf OUT "  .Q(wValidPP4) \n";
printf OUT ");\n";
printf OUT "wire wCarryInPP4;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay4 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iCarryInPP3), \n";
printf OUT "  .Q(wCarryInPP4) \n";
printf OUT ");\n";

##Stage 9 
#Add  3  7 (11)  15 (19)  23 (27) 31 (35) 39 (43) 47 (51) 55 (59)  element ($k+1)%4
#id      1  2    3    4   5   6   7   8
printf OUT "//Stage 9\n";
printf OUT "wire  [N-1:0] p9, g9;\n";
$id=0;
$pos=4;
$prev=4;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k>3) && ($k+1)%$pos ==0 ) {
        $id ++;
        if ($id%2==0) {
            my $k2 = $pos*($id+1)-1;
            my $k3 = $k2-$prev;
            printf OUT "GP_Adder gp9Adder$k2 (.iGi_j1(g8_pp[$k2]), .iPi_j1(p8_pp[$k2]), .iGj_k(g8_pp[$k3]), .iPj_k(p8_pp[$k3]), .oGi_k(g9[$k2]), .oPi_k(p9[$k2]));\n";
        } else {
            printf OUT "GP_Buf   gp9Buf$k   (.iBufG( g8_pp[$k]), .oBufG( g9[$k]), .iBufP(p8_pp[$k]), .oBufP(p9[$k]));\n";
        }
    } else {
        printf OUT "GP_Buf   gp9Buf$k   (.iBufG( g8_pp[$k]), .oBufG( g9[$k]), .iBufP(p8_pp[$k]), .oBufP(p9[$k]));\n";
    } 
}
##Stage 10 
#Add the 3 (5) 7 (9) 11 (13) 15 (17) 19 (21) 23 (25) 27 (29) 31 (33) 35 37   element 2n+1
#id      1  2  3  4   5  6 
printf OUT "//Stage 10\n";
printf OUT "wire  [N-1:0] p10, g10;\n";
$id=0;
$pos=2;
$prev=2;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k>2) && ($k+1)%$pos ==0 ) {
        $id ++;
        if ($id%2==0) {
            my $k2 = $pos*($id)+1;
            my $k3 = $k2-$prev;
            printf OUT "GP_Adder gp10Adder$k2 (.iGi_j1(g9[$k2]), .iPi_j1(p9[$k2]), .iGj_k(g9[$k3]), .iPj_k(p9[$k3]), .oGi_k(g10[$k2]), .oPi_k(p10[$k2]));\n";
        } else {
            printf OUT "GP_Buf   gp10Buf$k   (.iBufG( g9[$k]), .oBufG( g10[$k]), .iBufP(p9[$k]), .oBufP(p10[$k]));\n";
        }
    } else {
        printf OUT "GP_Buf   gp10Buf$k   (.iBufG( g9[$k]), .oBufG( g10[$k]), .iBufP(p9[$k]), .oBufP(p10[$k]));\n";
    } 
}
#Insert the D-FF to form pipeline 
printf OUT "//Insert the D-FlipFlops to form pipeline5 \n";
printf OUT "wire  [N-1:0] p10_pp, g10_pp;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P5 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p10),\n";
printf OUT "  .Q(p10_pp)\n";
printf OUT ");\n";
printf OUT "\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G5 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(g10),\n";
printf OUT "  .Q(g10_pp)\n";
printf OUT ");\n";
printf OUT "//Pipeline the p for the sum \n";
printf OUT "wire [N-1:0] p_pp5;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP5 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p_pp4),\n";
printf OUT "  .Q(p_pp5)\n";
printf OUT ");\n";

printf OUT "wire wValidPP5;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay5 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(wValidPP4), \n";
printf OUT "  .Q(wValidPP5) \n";
printf OUT ");\n";
printf OUT "wire wCarryInPP5;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay5 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iCarryInPP4), \n";
printf OUT "  .Q(wCarryInPP5) \n";
printf OUT ");\n";

##Stage 11 
#Add the 48 element with the -16 element for the N-1 element
printf OUT "//Stage 11\n";
printf OUT "wire  [N-1:0] p11, g11;\n";
$id=0;
$pos=2;
$prev=1;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( $k>1 && ($k)%$pos ==0 ) {
        $id ++;
        my $k2 = $pos*$id;
        my $k3 = $k2-$prev;
        printf OUT "GP_Adder gp11Adder$k2 (.iGi_j1(g10_pp[$k2]), .iPi_j1(p10_pp[$k2]), .iGj_k(g10_pp[$k3]), .iPj_k(p10_pp[$k3]), .oGi_k(g11[$k2]), .oPi_k(p11[$k2]));\n";
    } else {
        printf OUT "GP_Buf   gp11Buf$k   (.iBufG( g10_pp[$k]), .oBufG( g11[$k]), .iBufP(p10_pp[$k]), .oBufP(p11[$k]));\n";
    } 
}

##Output the sum 
#
printf OUT "//Output the sum\n";
printf OUT "wire wValidPP6;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay6 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(wValidPP5), \n";
printf OUT "  .Q(wValidPP6) \n";
printf OUT ");\n";
printf OUT "wire wValidPP7;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay7 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(wValidPP6), \n";
printf OUT "  .Q(wValidPP7) \n";
printf OUT ");\n";
printf OUT "assign oZ[0] = p_pp5[0];\n";
printf OUT "generate for (i=1; i<N; i=i+1 ) begin   \n";
printf OUT "    assign oZ [i] = p_pp5[i]^ g11[i-1]; \n";
printf OUT "end endgenerate                         \n";
printf OUT "assign oCarryOut = g11[N-1];            \n";
printf OUT "assign oReady    = wValidPP7;           \n";

} elsif ($nBits == 32) {
  print "Not Stage 6 for 32bit Adder in Forward-prefix computation.";
##Start the Backward-prefix computation
##Stage 6 
#Add  3  7 11  15 19  (23) 27 31 
printf OUT "//Stage 6\n";
printf OUT "wire  [N-1:0] p6, g6;\n";
$id=0;
$pos=8;
$prev=8;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k+1)%$pos ==0 ) {
        $id ++;
        if ($id==3) {
            my $k2 = $pos*$id-1;
            my $k3 = $k2-$prev;
            printf OUT "GP_Adder gp6Adder$k2 (.iGi_j1(g5[$k2]), .iPi_j1(p5[$k2]), .iGj_k(g5[$k3]), .iPj_k(p5[$k3]), .oGi_k(g6[$k2]), .oPi_k(p6[$k2]));\n";
        } else {
            printf OUT "GP_Buf   gp6Buf$k   (.iBufG( g5[$k]), .oBufG( g6[$k]), .iBufP(p5[$k]), .oBufP(p6[$k]));\n";
        }
    } else {
        printf OUT "GP_Buf   gp6Buf$k   (.iBufG( g5[$k]), .oBufG( g6[$k]), .iBufP(p5[$k]), .oBufP(p6[$k]));\n";
    } 
}
#Insert the D-FF to form pipeline 
printf OUT "//Insert the D-FlipFlops to form pipeline3 \n";
printf OUT "wire  [N-1:0] p6_pp, g6_pp;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P3 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p6),\n";
printf OUT "  .Q(p6_pp)\n";
printf OUT ");\n";
printf OUT "\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G3 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(g6),\n";
printf OUT "  .Q(g6_pp)\n";
printf OUT ");\n";
printf OUT "//Pipeline the p for the sum \n";
printf OUT "wire [N-1:0] p_pp3;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP3 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p_pp2),\n";
printf OUT "  .Q(p_pp3)\n";
printf OUT ");\n";
printf OUT "wire wValidPP3;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay3 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(wValidPP2), \n";
printf OUT "  .Q(wValidPP3) \n";
printf OUT ");\n";
printf OUT "wire wCarryInPP3;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay3 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iCarryInPP2), \n";
printf OUT "  .Q(wCarryInPP3) \n";
printf OUT ");\n";


##Stage 7 
#Add  3  7 (11)  15 (19)  23 (27) 31 (35) 39 (43) 47 (51) 55 (59)  element ($k+1)%4
#id      1  2    3    4   5   6   7   8
printf OUT "//Stage 7\n";
printf OUT "wire  [N-1:0] p7, g7;\n";
$id=0;
$pos=4;
$prev=4;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k>3) && ($k+1)%$pos ==0 ) {
        $id ++;
        if ($id%2==0) {
            my $k2 = $pos*($id+1)-1;
            my $k3 = $k2-$prev;
            printf OUT "GP_Adder gp7Adder$k2 (.iGi_j1(g6_pp[$k2]), .iPi_j1(p6_pp[$k2]), .iGj_k(g6_pp[$k3]), .iPj_k(p6_pp[$k3]), .oGi_k(g7[$k2]), .oPi_k(p7[$k2]));\n";
        } else {
            printf OUT "GP_Buf   gp7Buf$k   (.iBufG( g6_pp[$k]), .oBufG( g7[$k]), .iBufP(p6_pp[$k]), .oBufP(p7[$k]));\n";
        }
    } else {
        printf OUT "GP_Buf   gp7Buf$k   (.iBufG( g6_pp[$k]), .oBufG( g7[$k]), .iBufP(p6_pp[$k]), .oBufP(p7[$k]));\n";
    } 
}

##Stage 8 
#Add the 3 (5) 7 (9) 11 (13) 15 (17) 19 (21) 23 (25) 27 (29) 31 (33) 35 37   element 2n+1
#id      1  2  3  4   5  6 
printf OUT "//Stage 8\n";
printf OUT "wire  [N-1:0] p8, g8\n";
$id=0;
$pos=2;
$prev=2;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( ($k>2) && ($k+1)%$pos ==0 ) {
        $id ++;
        if ($id%2==0) {
            my $k2 = $pos*($id)+1;
            my $k3 = $k2-$prev;
            printf OUT "GP_Adder gp8Adder$k2 (.iGi_j1(g7[$k2]), .iPi_j1(p7[$k2]), .iGj_k(g7[$k3]), .iPj_k(p7[$k3]), .oGi_k(g8[$k2]), .oPi_k(p8[$k2]));\n";
        } else {
            printf OUT "GP_Buf   gp8Buf$k   (.iBufG( g7[$k]), .oBufG( g8[$k]), .iBufP(p7[$k]), .oBufP(p8[$k]));\n";
        }
    } else {
        printf OUT "GP_Buf   gp8Buf$k   (.iBufG( g7[$k]), .oBufG( g8[$k]), .iBufP(p7[$k]), .oBufP(p8[$k]));\n";
    } 
}
#Insert the D-FF to form pipeline 
printf OUT "//Insert the D-FlipFlops to form pipeline4 \n";
printf OUT "wire  [N-1:0] p8_pp, g8_pp;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_P4 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p8),\n";
printf OUT "  .Q(p8_pp)\n";
printf OUT ");\n";
printf OUT "\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_G4 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(g8),\n";
printf OUT "  .Q(g8_pp)\n";
printf OUT ");\n";
printf OUT "//Pipeline the p for the sum \n";
printf OUT "wire [N-1:0] p_pp4;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(N)) FFD_SumP4 (\n";
printf OUT "  .clk(clk),\n";
printf OUT "  .resetn(resetn),\n";
printf OUT "  .D(p_pp3),\n";
printf OUT "  .Q(p_pp4)\n";
printf OUT ");\n";
printf OUT "wire wValidPP4;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_Delay4 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(wValidPP3), \n";
printf OUT "  .Q(wValidPP4) \n";
printf OUT ");\n";
printf OUT "wire wCarryInPP4;\n";
printf OUT "FFD_POSEDGE_ASYNC_RESET #(.SIZE(1)) FFD_CarryInDelay4 (\n";
printf OUT "  .clk(clk), \n";
printf OUT "  .resetn(resetn), \n";
printf OUT "  .D(iCarryInPP3), \n";
printf OUT "  .Q(wCarryInPP4) \n";
printf OUT ");\n";

##Stage 9 
printf OUT "//Stage 9\n";
printf OUT "wire  [N-1:0] p9, g9;\n";
$id=0;
$pos=2;
$prev=1;
for (my $k=0; $k<$nBits; $k=$k+1 ) {
    if ( $k>1 && ($k)%$pos ==0 ) {
        $id ++;
        my $k2 = $pos*$id;
        my $k3 = $k2-$prev;
        printf OUT "GP_Adder gp9Adder$k2 (.iGi_j1(g8_pp[$k2]), .iPi_j1(p8_pp[$k2]), .iGj_k(g8_pp[$k3]), .iPj_k(p8_pp[$k3]), .oGi_k(g9[$k2]), .oPi_k(p9[$k2]));\n";
    } else {
        printf OUT "GP_Buf   gp9Buf$k   (.iBufG( g8_pp[$k]), .oBufG( g9[$k]), .iBufP(p8_pp[$k]), .oBufP(p9[$k]));\n";
    } 
}
##Output the sum 
printf OUT "//Output the sum\n";
printf OUT "assign oZ[0] = p_pp4[0];\n";
printf OUT "generate for (i=1; i<N; i=i+1 ) begin \n";
printf OUT "    assign oZ [i] = p_pp4[i]^ g9[i-1]; \n";
printf OUT "end endgenerate                       \n";
printf OUT "assign oCarryOut = g9[N-1];         \n";
printf OUT "assign oReady    = wValidPP4;          \n";

} else {
  print "Not support in the script!!!";
  exit(1);
}
## 
#

printf OUT "endmodule \n";

close (OUT);

