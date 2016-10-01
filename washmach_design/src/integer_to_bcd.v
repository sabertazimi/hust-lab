`timescale 1ns / 1ps

// integer to 8421 code
module integer_to_bcd
(
    input [3:0] int_data,
    output reg [3:0] bcd_data
);
    
    always @(int_data) begin
        case (int_data)
            0: bcd_data <= 4'b0000;
            1: bcd_data <= 4'b0001;
            2: bcd_data <= 4'b0010;
            3: bcd_data <= 4'b0011;
            4: bcd_data <= 4'b0100;
            5: bcd_data <= 4'b0101;
            6: bcd_data <= 4'b0110;
            7: bcd_data <= 4'b0111;
            8: bcd_data <= 4'b1000;
            9: bcd_data <= 4'b1001;
            default: bcd_data <= 4'b1010;
        endcase
    end
endmodule