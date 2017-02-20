/**
 * @module alu
 * @param DATA_WIDTH data width
 * @input srcA A port data
 * @input srcB B port data
 * @input aluop operation code
 * @ouput aluout calculation result
 * @output zero equal flag
 * @output of signed overflow flag
 * @output uof unsigned overflow flag
 */
module alu
#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] srcA,
    input [DATA_WIDTH-1:0] srcB,
    input [3:0] aluop,
    output reg [DATA_WIDTH-1:0] aluout,
    output zero,
    output of,
    output uof
);

    wire signed [DATA_WIDTH-1:0] signed_srcA;
    wire signed [DATA_WIDTH-1:0] signed_srcB;
    
    assign signed_srcA <= $signed(srcA);
    assign signed_srcB <= $signed(srcB);

    always @ ( * ) begin
        case (aluop)
            4'd0: aluout <= srcA << srcB;
            4'd1: aluout <= srcA >>> srcB;
            4'd2: aluout <= srcA >> srcB;
            4'd3: aluout <= srcA * srcB;
            4'd4: aluout <= srcA / srcB;
            4'd5: aluout <= srcA + srcB;  // awesome tip
            4'd6: aluout <= srcA - srcB;
            4'd7: aluout <= srcA & srcB;
            4'd8: aluout <= srcA | srcB;
            4'd9: aluout <= srcA ^ srcB;
            4'd10: aluout <= ~(srcA | srcB);
            4'd11: aluout <= (signed_srcA < signed_srcB) 1 : 0;
            4'd12: aluout <= (srcA < srcB) 1 : 0;
            default: aluout <= 0;
        endcase
    end
    
    alu_flags FLAGS #(.DATA_WIDTH(DATA_WIDTH)) (
        .srcA(srcA),
        .srcB(srcB),
        .aluop(aluop),
        .zero(zero),
        .of(of),
        .uof(uof)
    );
    
endmodule // alu