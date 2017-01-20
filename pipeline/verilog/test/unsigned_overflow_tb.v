module test;
    
    reg [31:0] a1,b1;
    wire [31:0] out1;
    wire carry1;
    
    reg [31:0] a2,b2;
    wire [31:0] out2;
    wire carry2;
    
    assign {carry1, out1} = a1 + b1;
    assign {carry2, out2} = a2 - b2;
    
    always begin
        #10 a1 <= 32'h7fffffff; b1 <= 32'h80000000;
        #10 a1 <= 32'h7fffffff; b1 <= 32'h00000001;
        #10 a1 <= 32'h7fffffff; b1 <= 32'h80000001;
        #10 a1 <= 32'h80000000; b1 <= 32'h80000000;
        
        #10 a2 <= 32'hffffffff; b2 <= 32'h7fffffff;
        #10 a2 <= 32'hfffffffe; b2 <= 32'h7fffffff;
        #10 a2 <= 32'h80000000; b2 <= 32'hffffffff;
        #10 a2 <= 32'h7fffffff; b2 <= 32'h80000000;
        $finish;
    end
    
    always @ (*) begin
        $monitor("a1 = %d, b1 = %d, out1 = %d, carry1 = %d\n", a1, b1, out1, carry1);
    end
    
    always @ (*) begin
        $monitor("a2 = %d, b2 = %d, out2 = %d, carry2 = %d\n", a2, b2, out2, carry2);
    end
    
endmodule // test