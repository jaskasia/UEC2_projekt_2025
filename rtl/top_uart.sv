module top_uart (
        input logic clk,
        input logic rst,
        input logic rx,
        input logic [7:0] data_in,
        input logic data_ready,
        output logic [7:0] data_out,
        output logic tx
    );

    logic [7:0] r_data;
    logic [7:0] w_data;
    logic rx_empty;
    logic wr_uart;
    logic rd_uart;
    logic [7:0] data_out_nxt;


    assign rd_uart = !rx_empty;

    // UART + FIFO
    uart #(
        .DBIT(8),
        .SB_TICK(16),
        .DVSR(54),
        .DVSR_BIT(7),
        .FIFO_W(1)
    ) u_uart (
        .clk,
        .reset(rst),
        .rd_uart,
        .wr_uart,
        .rx,
        .tx,
        .w_data,
        .tx_full(),
        .rx_empty,
        .r_data
    );

    logic [7:0] w_data_nxt;
    logic wr_uart_nxt;

    always_ff @(posedge clk) begin
        if (rst) begin
            w_data <= 0;
            wr_uart <= 0;
        end else begin
            w_data <= w_data_nxt;
            wr_uart <= wr_uart_nxt;
        end
    end

    always_comb begin
        if (data_ready) begin
            w_data_nxt = data_in;
            wr_uart_nxt = 1'b1;
        end else begin
            wr_uart_nxt = 1'b0;
            w_data_nxt = '0;
        end
    end


    always_comb begin
        if (!rx_empty) begin
            data_out_nxt = r_data[7:0];
        end else begin
            data_out_nxt = data_out;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            data_out <= 0;
        end else begin
            data_out <= data_out_nxt;
        end
    end

endmodule
