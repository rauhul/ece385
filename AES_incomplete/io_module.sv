/*---------------------------------------------------------------------------
  --      io_module.sv                                                     --
  --      Christine Chen                                                   --
  --      10/23/2013                                                       --
  --                                                                       --
  --      For use with ECE 298 Experiment 9                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/
// Stores 8-bit data transmitted from Nios II into 128-bit registers for encrypted message and AES key


module io_module ( input  logic         clk,
                   input  logic         reset_n,
                   output logic   [1:0] to_sw_sig,
                   output logic  [31:0] to_sw_port,
                   input  logic   [1:0] to_hw_sig,
                   input  logic  [31:0] to_hw_port,
                   output logic [127:0] msg_en,
                   output logic [127:0] key,
                   input  logic [127:0] msg_de,
                   output logic         io_ready,
                   input  logic         aes_ready );

    enum logic [6:0] {  RESET, WAIT,

                        READ_MSG_0, READ_MSG_1, READ_MSG_2, READ_MSG_3,
                         ACK_MSG_0,  ACK_MSG_1,  ACK_MSG_2,  ACK_MSG_3,

                        READ_KEY_0, READ_KEY_1, READ_KEY_2, READ_KEY_3,
                         ACK_KEY_0,  ACK_KEY_1,  ACK_KEY_2,  ACK_KEY_3,

                        SEND_TO_AES, GET_FROM_AES,

                        SEND_BACK_0, SEND_BACK_1, SEND_BACK_2, SEND_BACK_3,
                          GOT_ACK_0,   GOT_ACK_1,   GOT_ACK_2,   GOT_ACK_3 } state, next_state;

    always @ (posedge clk, negedge reset_n) begin
        if (reset_n == 1'b0) begin
            state  <= RESET;
            msg_en <= 128'd0;
            key    <= 128'd0;
        end else begin
            state <= next_state;
            case (state)
                /* READ ENCRYPTED MSG ON CLK EDGE */
                READ_MSG_0: begin
                    msg_en[127:96] <= to_hw_port[31:0];
                end
                READ_MSG_1: begin
                    msg_en[ 95:64] <= to_hw_port[31:0];
                end
                READ_MSG_2: begin
                    msg_en[ 63:32] <= to_hw_port[31:0];
                end
                READ_MSG_3: begin
                    msg_en[ 31: 0] <= to_hw_port[31:0];
                end

                /* READ KEY ON CLK EDGE */
                READ_KEY_0: begin
                    key[127:96] <= to_hw_port[31:0];
                end
                READ_KEY_1: begin
                    key[ 95:64] <= to_hw_port[31:0];
                end
                READ_KEY_2: begin
                    key[ 63:32] <= to_hw_port[31:0];
                end
                READ_KEY_3: begin
                    key[ 31: 0] <= to_hw_port[31:0];
                end
            endcase
        end
    end

    // to hardware
    always_comb begin
        next_state = state;
        unique case (state)
            RESET: begin
                next_state = WAIT;
            end

            WAIT: begin
                unique case (to_hw_sig)
                    2'd1: next_state = READ_MSG_0;
                    2'd2: next_state = READ_KEY_0;
                    2'd3: next_state = SEND_TO_AES;
                    default: next_state = WAIT;
                endcase
            end

            /* READ MSG */
            READ_MSG_0: begin
                if (to_hw_sig == 2'd2)
                    next_state = ACK_MSG_0;
            end
            READ_MSG_1: begin
                if (to_hw_sig == 2'd2)
                    next_state = ACK_MSG_1;
            end
            READ_MSG_2: begin
                if (to_hw_sig == 2'd2)
                    next_state = ACK_MSG_2;
            end
            READ_MSG_3: begin
                if (to_hw_sig == 2'd2)
                    next_state = ACK_MSG_3;
            end

            /* ACK MSG */
            ACK_MSG_0: begin
                if (to_hw_sig == 2'd1)
                    next_state = READ_MSG_1;
            end
            ACK_MSG_1: begin
                if (to_hw_sig == 2'd1)
                    next_state = READ_MSG_2;
            end
            ACK_MSG_2: begin
                if (to_hw_sig == 2'd1)
                    next_state = READ_MSG_3;
            end
            ACK_MSG_3: begin
                if (to_hw_sig == 2'd0)
                    next_state = WAIT;
            end

            /* READ KEY */
            READ_KEY_0: begin
                if (to_hw_sig == 2'd1)
                    next_state = ACK_KEY_0;
            end
            READ_KEY_1: begin
                if (to_hw_sig == 2'd1)
                    next_state = ACK_KEY_1;
            end
            READ_KEY_2: begin
                if (to_hw_sig == 2'd1)
                    next_state = ACK_KEY_2;
            end
            READ_KEY_3: begin
                if (to_hw_sig == 2'd1)
                    next_state = ACK_KEY_3;
            end

            /* ACK KEY */
            ACK_KEY_0: begin
                if (to_hw_sig == 2'd2)
                    next_state = READ_KEY_1;
            end
            ACK_KEY_1: begin
                if (to_hw_sig == 2'd2)
                    next_state = READ_KEY_2;
            end
            ACK_KEY_2: begin
                if (to_hw_sig == 2'd2)
                    next_state = READ_KEY_3;
            end
            ACK_KEY_3: begin
                if (to_hw_sig == 2'd0)
                    next_state = WAIT;
            end

            /* IO -> AES -> IO */
            SEND_TO_AES: begin
                if (aes_ready == 1'd1)
                    next_state = GET_FROM_AES;
            end
            GET_FROM_AES: begin
                unique case (to_hw_sig)
                    2'd1: next_state = SEND_BACK_0;
                    2'd2: next_state = WAIT;
                    default: next_state = GET_FROM_AES;
                endcase
            end

            /* SEND BACK */
            SEND_BACK_0: begin
                if (to_hw_sig == 2'd2)
                    next_state = GOT_ACK_0;
            end
            SEND_BACK_1: begin
                if (to_hw_sig == 2'd2)
                    next_state = GOT_ACK_1;
            end
            SEND_BACK_2: begin
                if (to_hw_sig == 2'd2)
                    next_state = GOT_ACK_2;
            end
            SEND_BACK_3: begin
                if (to_hw_sig == 2'd2)
                    next_state = GOT_ACK_3;
            end

            /* GOT ACK */
            GOT_ACK_0: begin
                if (to_hw_sig == 2'd1)
                    next_state = SEND_BACK_1;
            end
            GOT_ACK_1: begin
                if (to_hw_sig == 2'd1)
                    next_state = SEND_BACK_2;
            end
            GOT_ACK_2: begin
                if (to_hw_sig == 2'd1)
                    next_state = SEND_BACK_3;
            end
            GOT_ACK_3: begin
                if (to_hw_sig == 2'd0)
                    next_state = WAIT;
            end
        endcase
    end

    // to software
    always_comb begin
        to_sw_port = 32'd0;
        to_sw_sig  =  2'd0;
        io_ready   =  1'b0;
        unique case (state)
            RESET: begin
                to_sw_sig = 2'd3;
            end
            WAIT: begin
                to_sw_sig = 2'd0;
            end

            /* READ MSG */
            READ_MSG_0: begin
                to_sw_sig = 2'd1;
            end
            READ_MSG_1: begin
                to_sw_sig = 2'd1;
            end
            READ_MSG_2: begin
                to_sw_sig = 2'd1;
            end
            READ_MSG_3: begin
                to_sw_sig = 2'd1;
            end

            /* ACK MSG */
            ACK_MSG_0: begin
                to_sw_sig = 2'd0;
            end
            ACK_MSG_1: begin
                to_sw_sig = 2'd0;
            end
            ACK_MSG_2: begin
                to_sw_sig = 2'd0;
            end
            ACK_MSG_3: begin
                to_sw_sig = 2'd0;
            end

            /* READ KEY */
            READ_KEY_0: begin
                to_sw_sig = 2'd1;
            end
            READ_KEY_1: begin
                to_sw_sig = 2'd1;
            end
            READ_KEY_2: begin
                to_sw_sig = 2'd1;
            end
            READ_KEY_3: begin
                to_sw_sig = 2'd1;
            end

            /* ACK KEY */
            ACK_KEY_0: begin
                to_sw_sig = 2'd0;
            end
            ACK_KEY_1: begin
                to_sw_sig = 2'd0;
            end
            ACK_KEY_2: begin
                to_sw_sig = 2'd0;
            end
            ACK_KEY_3: begin
                to_sw_sig = 2'd0;
            end

            /* IO -> AES -> IO */
            SEND_TO_AES: begin
               to_sw_sig = 2'd0;
               io_ready = 1'b1;
            end
            GET_FROM_AES: begin
               to_sw_sig = 2'd2;
            end

            /* READ MSG */
            SEND_BACK_0: begin
                to_sw_sig = 2'd1;
                to_sw_port[31:0] = msg_de[127:96];
            end
            SEND_BACK_1: begin
                to_sw_sig = 2'd1;
                to_sw_port[31:0] = msg_de[ 95: 64];
            end
            SEND_BACK_2: begin
                to_sw_sig = 2'd1;
                to_sw_port[31:0] = msg_de[ 63: 32];
            end
            SEND_BACK_3: begin
                to_sw_sig = 2'd1;
                to_sw_port[31:0] = msg_de[ 31:  0];
            end

            /* ACK MSG */
            GOT_ACK_0: begin
                to_sw_sig = 2'd0;
            end
            GOT_ACK_1: begin
                to_sw_sig = 2'd0;
            end
            GOT_ACK_2: begin
                to_sw_sig = 2'd0;
            end
            GOT_ACK_3: begin
                to_sw_sig = 2'd0;
            end
        endcase
    end
endmodule