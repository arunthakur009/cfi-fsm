`timescale 1ns/1ps

module tb_cfi_fsm;

logic clk;
logic rst;

logic [31:0] packet;

logic [1:0] state;

cfi_fsm dut(
    .clk(clk),
    .rst(rst),
    .packet(packet),
    .state(state)
);

always #5 clk = ~clk;

task send_packet(input [7:0] cmd,
                 input [23:0] data);
begin
    packet = {cmd, data};
    @(posedge clk);
    #1;    
end
endtask

initial begin

    clk = 0;
    rst = 1;
    packet = 0;

    #15;
    rst = 0;

    //---------------------------------
    // Test 1
    //---------------------------------

    $display("Test 1: valid sequence");

    send_packet(8'h01,24'hABCDEF); // SET
    send_packet(8'h02,24'd0);      // JUMP
    send_packet(8'h03,24'hABCDEF); // LPAD

    if(state==0)
        $display("PASS");
    else
        $display("FAIL");

    //---------------------------------
    // Test 2
    //---------------------------------

    $display("Test 2: wrong label");

    send_packet(8'h02,24'd0);
    send_packet(8'h03,24'h111111);

    if(state==2)
        $display("PASS");
    else
        $display("FAIL");

    //---------------------------------
    // Test 3
    //---------------------------------

    $display("Test 3: ERROR is sticky");

    send_packet(8'h01,24'h123456);

    if(state==2)
        $display("PASS");
    else
        $display("FAIL");

    $finish;

end

endmodule