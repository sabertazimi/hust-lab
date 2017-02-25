/**
 * @module integer_to_segment
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief raw data to segment encoder
 * @param DATA_WIDTH data width
 * @input data raw decimal data (4 bit)
 * @output seg_data bit data for cnodes
 */
module integer_to_segment
(
    input [3:0] int_data,
    output reg [7:0] seg_data
);
    
    always @(int_data) begin
        case (int_data)
            4'b0000:    seg_data <= 8'b11000000;    // 0
            4'b0001:    seg_data <= 8'b11111001;    // 1
            4'b0010:    seg_data <= 8'b10100100;    // 2
            4'b0011:    seg_data <= 8'b10110000;    // 3
            4'b0100:    seg_data <= 8'b10011001;    // 4
            4'b0101:    seg_data <= 8'b10010010;    // 5
            4'b0110:    seg_data <= 8'b10000010;    // 6
            4'b0111:    seg_data <= 8'b11111000;    // 7
            4'b1000:    seg_data <= 8'b10000000;    // 8
            4'b1001:    seg_data <= 8'b10010000;    // 9
            4'b1010:    seg_data <= 8'b10001000;    // a
            4'b1011:    seg_data <= 8'b10000011;    // b
            4'b1100:    seg_data <= 8'b11000110;    // c
            4'b1101:    seg_data <= 8'b10100001;    // d
            4'b1110:    seg_data <= 8'b10000110;    // e
            4'b1111:    seg_data <= 8'b10001110;    // f
            default:    seg_data <= 8'b11111111;    // off
        endcase
    end
endmodule
