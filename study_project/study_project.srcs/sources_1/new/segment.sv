module segment(
    input           [9:0]   i_segment,
    output  logic           o_AN3_out,
    output  logic           o_AN0_out,
    output  logic           o_AN1_out,
    output  logic           o_AN2_out,
    output  logic           o_AN4_out,
    output  logic           o_AN5_out,
    output  logic           o_AN6_out,
    output  logic           o_AN7_out,
    
    output  logic   [6:0]   o_segmentlight_out
);

    always_comb o_AN3_out = (|i_segment) ? 1'b0 : 1'b1;
    always_comb begin
        o_AN0_out = '1;
        o_AN1_out = '1;
        o_AN2_out = '1;
        o_AN4_out = '1;
        o_AN5_out = '1;
        o_AN6_out = '1;
        o_AN7_out = '1;
    end

    always_comb begin
        case (i_segment)
           10'b00_00_00_00_01 : o_segmentlight_out = 7'b1000000;
           10'b00_00_00_00_10 : o_segmentlight_out = 7'b1111001;
           10'b00_00_00_01_00 : o_segmentlight_out = 7'b0100100;
           10'b00_00_00_10_00 : o_segmentlight_out = 7'b0110000;
           10'b00_00_01_00_00 : o_segmentlight_out = 7'b0011001;
           10'b00_00_10_00_00 : o_segmentlight_out = 7'b0010010;
           10'b00_01_00_00_00 : o_segmentlight_out = 7'b0000011;
           10'b00_10_00_00_00 : o_segmentlight_out = 7'b1111000;
           10'b01_00_00_00_00 : o_segmentlight_out = 7'b0000000;
           10'b10_00_00_00_00 : o_segmentlight_out = 7'b0010000; 
           default : o_segmentlight_out = '1;
        endcase
    end
    
    
endmodule