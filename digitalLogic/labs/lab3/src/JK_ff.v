module JK_ff(J,K,Q,Qbar,cp,reset);
    input J,K,cp,reset;
    output reg Q,Qbar;
    always @(negedge cp)
    if(reset) begin
    Q=0;
    Qbar=1;
    end else
    begin
    Q=(J&~Q)|(~K&Q);
    Qbar=~Q;
    end
endmodule