module harzard_unit
(
    input [4:0] rsD, rtD, rsE, rtE,
    input [4:0] writeregE, writeregM, writeregW,
    input regwriteE, regwriteM, regwriteW,
    input memtoregE, memtoregM
    input branchD,
    output forwardAD, forwardBD,
    output [1:0] forwardAE, forwardBE,  // 3 to 1
    output stallF, stallD, flushE
);

    wire lwstallD, branchstallD;

    assign forwardAD = rsD && (rsD == writeregM) && regwriteM    // ME => ID
    assign forwardBD = rtD && (rtD == writeregM) && regwriteM    // ME => ID

    always @ ( * ) begin    // ME => EX, WB => EX
        forwardAE = 2'b00;
        forwardBE = 2'b00;

        if (rsE != 0) begin
            if (rsE == writeregM && regwriteM) begin
                forwardAE = 2'b10;
            end else if (rsE == writeregW && regwriteW) begin
                forwardAE = 2'b01;
            end
        end

        if (rtE != 0) begin
            if (rtE == writeregM && regwriteM) begin
                forwardBE = 2'b10;
            end else if (rtE == writeregW && regwriteW) begin
                forwardBE = 2'b01;
            end
        end
    end

    assign lwstallD = memtoregE && (rtE == rsD || rtE == rtD)   // lw(rt)
    assign branchstallD = branchD && (
                (regwriteE && (writeregE == rsD || writeregE == rtD))     // branch taken: stall previous instructions
                || (memtoregM && (writeregM == rsD || writeregM == rtD))  // branch taken: stall previous instructions  
            );

    assign stallD = (lwstallD || branchstallD);
    assign stallF = stallD;
    assign flushE = stallD;

endmodule // harzard_unit
