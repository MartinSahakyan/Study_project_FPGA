module mux (
    input   logic           i_mux_sel,
    input   logic   [1:0]   i_mux_in,
    output  logic           o_mux_out
);
    
    always_comb begin
        if (i_mux_sel == 0) begin
            o_mux_out = i_mux_in[0];
        end else begin
            o_mux_out = i_mux_in[1];
        end

        // o_mux_out = i_mux_sel ? i_mux_in[1] : i_mux_in[0];
    end

endmodule


module mux_tb ();

    logic          mux_sel;
    logic   [1:0]  mux_in;
    logic          mux_out;


    mux
    mux_0
    (
        .i_mux_sel  ( mux_sel ),
        .i_mux_in   ( mux_in  ),
        .o_mux_out  ( mux_out )
    );


    initial begin
        mux_sel = '0;
        mux_in  = '0;

        #10;
        mux_in = 2'b01;
        #10;
        mux_sel = '1;
        #10;
        mux_sel = '0;
        #10;
        mux_sel = '1;
        #10;
        mux_sel = '0;
        $stop;
    end



endmodule