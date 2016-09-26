module time_to_segment_tb();

    parameter DELAY = 10;
    parameter COUNT = 20;
    parameter TIME = (COUNT * DELAY);

    reg [31:0] time_data;
    wire [15:0] seg_data;
    integer i;

    time_to_segment DUT (
        .time_data(time_data),
        .seg_data(seg_data)
    );

    initial begin
        time_data <= 0;
        #TIME $finish;
    end

    always begin
        for (i = 0; i < COUNT; i = i + 1) begin
            #(DELAY) time_data = (time_data + 1) % 20;
        end
    end

endmodule