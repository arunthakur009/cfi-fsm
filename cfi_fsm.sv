module cfi_fsm (
    input  logic        clk,
    input  logic        rst,

    input  logic [31:0] packet,

    output logic [1:0] state
);

localparam IDLE  = 2'd0;
localparam CHECK = 2'd1;
localparam ERROR = 2'd2;

localparam CMD_SET  = 8'h01;
localparam CMD_JUMP = 8'h02;
localparam CMD_LPAD = 8'h03;

logic [23:0] label;

wire [7:0]  cmd  = packet[31:24];
wire [23:0] data = packet[23:0];

always_ff @(posedge clk or posedge rst) begin

    if (rst) begin
        state <= IDLE;
        label <= 24'd0;
    end

    else begin

        case (state)

        IDLE: begin

            if (cmd == CMD_SET) begin
                label <= data;
                state <= IDLE;
            end

            else if (cmd == CMD_JUMP) begin
                state <= CHECK;
            end

            else begin
                state <= IDLE;
            end

        end

        CHECK: begin

            if (cmd == CMD_LPAD && data == label)
                state <= IDLE;
            else
                state <= ERROR;

        end

        ERROR: begin
            state <= ERROR;
        end

        default:
            state <= ERROR;

        endcase

    end

end

endmodule