`timescale 1ns / 1ps

module bcd_to_segment_tb();

    parameter DELAY = 10;
    parameter COUNT = 20;
    parameter TIME = (COUNT * DELAY);
    
    reg [3:0] bcd_data;
    wire [7:0] seg_data;
    integer i;
    
    bcd_to_segment DUT (
        .bcd_data(bcd_data),
        .seg_data(seg_data)
    );
    
    initial begin
        bcd_data <= 0;
        #TIME $finish;
    end
    
    always begin
        for (i = 0; i < COUNT; i = i + 1) begin
            #(DELAY) bcd_data = (bcd_data + 1) % 11;
        end
    end
    
endmodule
