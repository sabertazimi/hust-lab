module data_to_segment
#(parameter DATA_WIDTH = 32)
(
    input [(DATA_WIDTH-1):0] data,
    output [(DATA_WIDTH*2)-1:0] seg_data
);
    
    integer_to_segment trans1 (
        .int_data(data[3:0]),
        .seg_data(seg_data[7:0])
    );
    
    integer_to_segment trans2 (
        .int_data(data[7:4]),
        .seg_data(seg_data[15:8])
    );
    
    integer_to_segment trans3 (
        .int_data(data[11:8]),
        .seg_data(seg_data[23:16])
    );
    
    integer_to_segment trans4 (
        .int_data(data[15:12]),
        .seg_data(seg_data[31:24])
    );
    
    integer_to_segment trans5 (
        .int_data(data[19:16]),
        .seg_data(seg_data[39:32])
    );
    
    integer_to_segment trans6 (
        .int_data(data[23:20]),
        .seg_data(seg_data[47:40])
    );
    
    integer_to_segment trans7 (
        .int_data(data[27:24]),
        .seg_data(seg_data[55:48])
    );
    
    integer_to_segment trans8 (
        .int_data(data[31:28]),
        .seg_data(seg_data[63:56])
    );
    
endmodule