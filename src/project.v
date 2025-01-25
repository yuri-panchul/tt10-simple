/*
 * Copyright (c) 2024 Tiny Tapeout and Verilog Meetup
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_yuri_panchul_and_gate
(
    input  [7:0] ui_in,    // Dedicated inputs
    output [7:0] uo_out,   // Dedicated outputs
    input  [7:0] uio_in,   // IOs: Input path
    output [7:0] uio_out,  // IOs: Output path
    output [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input        ena,      // always 1 when the design is powered, so you can ignore it
    input        clk,      // clock
    input        rst_n     // reset_n - low to reset
);

    /*

    Dummy

    logic       tm1638_clk;
    logic       tm1638_stb;

    logic       tm1638_dio_in;
    logic       tm1638_dio_out;
    logic       tm1638_dio_out_en;

    logic       vga_hsync;
    logic       vga_vsync;

    logic [1:0] vga_red;
    logic [1:0] vga_green;
    logic [1:0] vga_blue;

    logic       sticky_failure;

    always @ (posedge clk)
    begin
        tm1638_clk <= { 2 { tm1638_dio_in } };
        tm1638_stb <= tm1638_dio_in;

        tm1638_dio_out <= tm1638_dio_in;
        tm1638_dio_out_en <= tm1638_dio_in;

        vga_hsync <= tm1638_dio_in;
        vga_vsync <= tm1638_dio_in;

        vga_red <= { 2 { tm1638_dio_in } };
        vga_green <= { 2 { tm1638_dio_in } };
        vga_blue <= { 2 { tm1638_dio_in } };

        sticky_failure <= tm1638_dio_in;
    end
    */

    //------------------------------------------------------------------------

    wire       tm1638_clk;
    wire       tm1638_stb;

    wire       tm1638_dio_in;
    wire       tm1638_dio_out;
    wire       tm1638_dio_out_en;

    wire       vga_hsync;
    wire       vga_vsync;

    wire [1:0] vga_red;
    wire [1:0] vga_green;
    wire [1:0] vga_blue;

    wire       sticky_failure;

    //------------------------------------------------------------------------

    layer_between_project_and_hackathon_top i_layer
    (
        .clock (   clk   ),
        .reset ( ~ rst_n ),
        .*
    );

    //------------------------------------------------------------------------

    // All output pins must be assigned. If not used, assign to 0.

    assign uio_out [7]    = tm1638_stb;
    assign uio_out [6]    = tm1638_clk;

    assign uio_oe  [7:6]  = '1;

    assign tm1638_dio_in  = uio_in [5];
    assign uio_out [5]    = tm1638_dio_out;
    assign uio_oe  [5]    = tm1638_dio_out_en;

    assign uio_out [4]    = sticky_failure;
    assign uio_oe  [4]    = '1;

    assign uio_out [3:0]  = '0;
    assign uio_oe  [3:0]  = '0;

    //------------------------------------------------------------------------

    assign uo_out  [0]    = vga_red   [1];
    assign uo_out  [1]    = vga_green [1];
    assign uo_out  [2]    = vga_blue  [1];
    assign uo_out  [3]    = vga_vsync    ;
    assign uo_out  [4]    = vga_red   [0];
    assign uo_out  [5]    = vga_green [0];
    assign uo_out  [6]    = vga_blue  [0];
    assign uo_out  [7]    = vga_hsync    ;

    //------------------------------------------------------------------------

    // List all unused inputs to prevent warnings
    wire _unused = & { ena, ui_in, uio_in [7:6], uio_in [4:0], 1'b0 };

endmodule
