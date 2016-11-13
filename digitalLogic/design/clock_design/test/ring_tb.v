`timescale 1ns / 1ps

module ring_tb();

    parameter DELAY = 10;
    parameter TIME = 200;
    
    reg sig_ring;
    reg sig_step;
    wire alarm;

    ring DUT (
        .sig_ring(sig_ring),
        .sig_step(sig_step),
        .alarm(alarm)
    );
    
    initial begin
        sig_ring <= 0;
        sig_step <= 0;
        #TIME $finish;
    end
    
    always begin
        #DELAY sig_step <= ~sig_step;
    end
    
    always begin
        #DELAY sig_ring <= 1;
        #(DELAY) sig_ring <= 0;
        #(TIME-3*DELAY);
    end
endmodule
