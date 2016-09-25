`timescale 1ns / 1ps

module time_displayer
#(parameter WIDTH = 32)
(
    input clk_src,
    input [(WIDTH-1):0] sec_data,
    input [(WIDTH-1):0] min_data,
    input [(WIDTH-1):0] hour_data,
    output reg [7:0] anodes,
    output reg [7:0] cnodes
);

    reg [2:0] count; // 2^3 = 8
    wire [15:0] sec_seg, min_seg, hour_seg;
    
    time_to_segment SEC_SEG (
        .time_data(sec_data),
        .seg_data(sec_seg)
    );
    
    time_to_segment MIN_SEG (
        .time_data(min_data),
        .seg_data(min_seg)
    );
        
    time_to_segment HOUR_SEG (
        .time_data(hour_data),
        .seg_data(hour_seg)
    );
    
    initial begin
        count <= 0;
        anodes <= 0;
        cnodes <= 0;
    end
    
    always @(posedge clk_src) begin
        count = count + 1;
    end
    
    always @(count) begin
        case (count)
            3'b000: begin
            anodes = 8'b11111110;
            cnodes = sec_seg[7:0];
        end
        3'b001: begin
            anodes = 8'b11111101;
            cnodes = sec_seg[15:8];
        end
        3'b010:  begin
            anodes = 8'b11111011;
            cnodes = 8'b10111111;
        end
        3'b011: begin
            anodes = 8'b11110111;
            cnodes = min_seg[7:0];
        end
        3'b100: begin
            anodes = 8'b11101111;
            cnodes = min_seg[15:8];
        end
        3'b101: begin
            anodes = 8'b11011111;
            cnodes = 8'b10111111;
        end
        3'b110: begin
            anodes = 8'b10111111;
            cnodes = hour_seg[7:0];
        end
        3'b111: begin
            anodes = 8'b01111111;
            cnodes = hour_seg[15:8];
        end
        default: begin
            anodes = 8'b11111110;
            cnodes = 8'b11111111;
        end
        endcase
    end
    
endmodule