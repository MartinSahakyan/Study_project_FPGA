
module led_counter
(
    input                   i_clk,

    input                   i_but_reset,
    input                   i_but_play_stop,

    output  logic   [6:0]   o_led_segment,
    output  logic   [3:0]   o_led_digit,
    output  logic   [3:0]   o_led_digit_unused
);

/*--------------------------------------------------------------------------------------------------------------------*/

    logic   [2:0]   but_reset_shift;
    logic   [2:0]   but_play_stop_shift;


    always @(posedge i_clk) begin
        but_reset_shift     <= {but_reset_shift[1:0],     i_but_reset};
        but_play_stop_shift <= {but_play_stop_shift[1:0], i_but_play_stop};
    end


    logic   but_reset_sync;
    logic   but_play_stop_sync;

    always_comb but_reset_sync     = but_reset_shift[2];
    always_comb but_play_stop_sync = but_play_stop_shift[2];

/*--------------------------------------------------------------------------------------------------------------------*/

    logic   but_play_stop_sync_1;


    always @(posedge i_clk) begin
        if (but_reset_sync) begin
            but_play_stop_sync_1 <= 1'b0;
        end else begin
            but_play_stop_sync_1 <= but_play_stop_sync;
        end
    end

/*--------------------------------------------------------------------------------------------------------------------*/

    logic   state;

    localparam  RUN  = 1'b1;
    localparam  STOP = 1'b0;


    always @(posedge i_clk) begin
        if (but_reset_sync) begin
            state <= 1'b0;
        end else begin
            if (~but_play_stop_sync_1 & but_play_stop_sync) begin
                state <= ~state;
            end
        end
    end

/*--------------------------------------------------------------------------------------------------------------------*/

    localparam  DIGIT_COUNT_DELAY = 32'd10000000;


    logic   [31:0]  clk_div_cnt;
    logic           counter_incr;


    always @(posedge i_clk) begin
        if (clk_div_cnt >= DIGIT_COUNT_DELAY) begin
            clk_div_cnt <= '0;
        end else begin
            clk_div_cnt <= clk_div_cnt + 1'b1;
        end
    end


    always_comb counter_incr = (clk_div_cnt >= DIGIT_COUNT_DELAY);

/*--------------------------------------------------------------------------------------------------------------------*/

    logic   [3:0][3:0]  counter;
    logic   [3:0]       carry;


    always @(posedge i_clk) begin
        if (but_reset_sync) begin
            counter <= '0;
        end else begin
            if ((state == RUN) && counter_incr) begin
                for (int i = 0; i < 4; i++) begin
                    // Counter digit 0-3
                    if (carry[i]) begin
                        if (counter[i] >= 4'd9) begin
                            counter[i] <= '0;
                        end else begin
                            counter[i] <= counter[i] + 1'b1;
                        end
                    end
                end
            end
        end
    end


    always_comb begin
        carry[0] = 1'b1;
        carry[1] = (counter[0] >= 4'd9);
        carry[2] = (counter[1] >= 4'd9);
        carry[3] = (counter[2] >= 4'd9);
    end

/*--------------------------------------------------------------------------------------------------------------------*/

    localparam  DIGIT_SEL_DELAY = 32'd400000;

    logic   [31:0]  clk_div;


    always @(posedge i_clk) begin
        if (but_reset_sync) begin
            o_led_digit <= 4'b1110;
        end else begin
            if (clk_div >= DIGIT_SEL_DELAY) begin
                clk_div <= '0;
                o_led_digit <= {o_led_digit[2:0], o_led_digit[3]};
            end else begin
                clk_div <= clk_div + 1'b1;
            end
        end
    end

/*--------------------------------------------------------------------------------------------------------------------*/

    logic   [3:0]   selected_counter;


    always_comb begin
        case (o_led_digit)
            4'b1110: selected_counter = counter[0];
            4'b1101: selected_counter = counter[1];
            4'b1011: selected_counter = counter[2];
            4'b0111: selected_counter = counter[3];
            default: selected_counter = '0;
        endcase
    end

/*--------------------------------------------------------------------------------------------------------------------*/

    always_comb begin
        case (selected_counter)
            4'd0:    o_led_segment = 7'b1000000;
            4'd1:    o_led_segment = 7'b1111001;
            4'd2:    o_led_segment = 7'b0100100;
            4'd3:    o_led_segment = 7'b0110000;
            4'd4:    o_led_segment = 7'b0011001;
            4'd5:    o_led_segment = 7'b0010010;
            4'd6:    o_led_segment = 7'b0000011;
            4'd7:    o_led_segment = 7'b1111000;
            4'd8:    o_led_segment = 7'b0000000;
            4'd9:    o_led_segment = 7'b0010000;
            default: o_led_segment = '1;
        endcase
    end

    always_comb o_led_digit_unused = '1;

/*--------------------------------------------------------------------------------------------------------------------*/

endmodule : led_counter
