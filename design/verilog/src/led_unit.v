module led_unit
#(parameter DATA_WIDTH = 32)
(
    input clk_src,
    input [(DATA_WIDTH-1):0] led_data,
    output reg [7:0] anodes,
    output reg [7:0] cnodes
);

    reg [2:0] count; // 2^3 = 8
    wire [(DATA_WIDTH*2)-1:0] seg_data;
    
    initial begin
        count <= 0;
        anodes <= 0;
        cnodes <= 0;
    end
    
    data_to_segment #(
        .DATA_WIDTH(DATA_WIDTH)
    ) data_to_segment (
        .data(led_data),
        .seg_data(seg_data)
    );

    always @(posedge clk_src) begin
        count = count + 1;
    end
    
    always @(count) begin
        case (count)
            3'b000: begin
            anodes = 8'b11111110;
            cnodes = seg_data[7:0];
        end
        3'b001: begin
            anodes = 8'b11111101;
            cnodes = seg_data[15:8];
        end
        3'b010:  begin
            anodes = 8'b11111011;
            cnodes = seg_data[23:16];
        end
        3'b011: begin
            anodes = 8'b11110111;
            cnodes = seg_data[31:24];
        end
        3'b100: begin
            anodes = 8'b11101111;
            cnodes = seg_data[39:32];
        end
        3'b101: begin
            anodes = 8'b11011111;
            cnodes = seg_data[47:40];
        end
        3'b110: begin
            anodes = 8'b10111111;
            cnodes = seg_data[55:48];
        end
        3'b111: begin
            anodes = 8'b01111111;
            cnodes = seg_data[63:56];
        end
        default: begin
            anodes = 8'b11111110;
            cnodes = 8'b11111111;
        end
        endcase
    end
    
endmodule