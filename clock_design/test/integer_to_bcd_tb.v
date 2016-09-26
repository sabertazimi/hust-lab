`timescale 1ns / 1ps

module integer_to_bcd_tb();

    parameter DELAY = 10;
    parameter COUNT = 20;
    parameter TIME = (COUNT * DELAY);
    
    reg [3:0] int_data;
    wire [3:0] bcd_data;
    integer i;
    
    integer_to_bcd DUT (
        .int_data(int_data),
        .bcd_data(bcd_data)
    );
    
    initial begin
        int_data <= 0;
        #TIME $finish;
    end
    
    always begin
        for (i = 0; i < COUNT; i = i + 1) begin
            #(DELAY) int_data = (int_data + 1) % 10;
        end
    end

endmodule
