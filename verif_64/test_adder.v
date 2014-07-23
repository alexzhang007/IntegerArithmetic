//Author      : Alex Zhang (cgzhangwei@gmail.com)
//Date        : Jun. 16. 2014
//Description : Create the testbench
module test;
reg         clk;
reg         resetn;
reg [63:0]   rX;
reg [63:0]   rY;
reg [64:0]   rXAddY;
wire [63:0]  wZ;
wire        wCarryOut;
reg         rValid;
wire        wReady;

event start_sim_evt;
event end_sim_evt;

Adder64BitBrentKung  Adder_64x64(
  .clk(clk),
  .resetn(resetn),
  //Instruction Fetech (IF)
  .iValid(rValid),
  .iX(rX),
  .iY(rY),
  .iCarryIn(1'b0),
  .oZ(wZ),
  .oCarryOut(wCarryOut),
  .oReady(wReady)
);

always @(*) begin 
   rXAddY = rValid ? rX + rY : 0;
end 



initial begin 
    basic;
end 
initial begin 
    $fsdbDumpfile("./out/adder.fsdb");
    $fsdbDumpvars(0, test);
end 

task basic ;
    begin 
        $display("Start MAI IP testing.");
        #1;
        fork
            drive_clock;
            reset_unit;
            drive_sim;
            monitor_sim;
        join 
    end 
endtask 
task monitor_sim;
   begin 
   @(end_sim_evt);
   #10;
   $display("Test End");
   $finish;
   end 
endtask
task reset_unit;
    begin 
        #5;
        resetn = 1;
        #10;
        resetn = 0;
//Reset the reg variable 
        rX  = 0;
        rY  = 0;
        rValid = 1'b0;
        #20;
        resetn = 1;
        ->start_sim_evt;
        $display("Reset is done");
        end
endtask 
task  drive_clock;
    begin 
        clk = 0;
        forever begin 
        #5 clk = ~clk;
        end 
    end 
endtask
task  drive_sim;
    @(start_sim_evt);
   
    @(posedge clk);
    rValid <= 1'b1;
    rX     <= 64'hFFFF_FFF1;
    rY     <= 64'hFF00_110C;
    @(posedge clk);
    rValid <= 1'b1;
    rX     <= 64'hFF;
    rY     <= 64'hFF;
    @(posedge clk);
    rValid <= 1'b0;
    rX     <= 64'h0;
    rY     <= 64'h0;
    repeat (100) @(posedge clk);

    ->end_sim_evt;
endtask 

endmodule 
