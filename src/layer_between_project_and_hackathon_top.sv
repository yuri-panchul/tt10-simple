`include "swap_bits.svh"

module layer_between_project_and_hackathon_top
(
    input        clock,
    input        reset,

    output       tm1638_clk,
    output       tm1638_stb,

    input        tm1638_dio_in,
    output       tm1638_dio_out,
    output       tm1638_dio_out_en,

    output       vga_hsync,
    output       vga_vsync,

    output [1:0] vga_red,
    output [1:0] vga_green,
    output [1:0] vga_blue,

    output       sticky_failure
);

    //------------------------------------------------------------------------

    localparam clk_mhz = 25;

    // TODO: Think how to use this signal for self-diagnostics
    assign sticky_failure = 1'b0;

    //------------------------------------------------------------------------

    wire [7:0] key;
    wire [7:0] led;

    // A dynamic seven-segment display

    wire [7:0] abcdefgh;
    wire [7:0] digit;

    // LCD screen interface

    wire [8:0] x;
    wire [8:0] y;

    wire [4:0] red;
    wire [5:0] green;
    wire [4:0] blue;

    //------------------------------------------------------------------------

    wire display_on;

    `define REDUCE_COLOR_TO_2_BITS(c)  \
        (display_on ? { c [$left (c)], | c [$left (c) - 1:0] } : '0)

    assign vga_red   = `REDUCE_COLOR_TO_2_BITS ( red   );
    assign vga_green = `REDUCE_COLOR_TO_2_BITS ( green );
    assign vga_blue  = `REDUCE_COLOR_TO_2_BITS ( blue  );

    //------------------------------------------------------------------------

    hackathon_top i_hackathon_top (.*);

    //------------------------------------------------------------------------

    wire [7:0]  hgfedcba;
    `SWAP_BITS (hgfedcba, abcdefgh);

    //------------------------------------------------------------------------

    tm1638_board_controller
    # (
        .clk_mhz          ( clk_mhz           ),
        .w_digit          ( 8                 ),
        .w_seg            ( 8                 )
    )
    i_tm1638
    (
        .clk              ( clock             ),
        .rst              ( reset             ),
        .hgfedcba         ,
        .digit            ,
        .ledr             ( led               ),
        .keys             ( key               ),

        .sio_clk          ( tm1638_clk        ),
        .sio_stb          ( tm1638_stb        ),

        .sio_data_in      ( tm1638_dio_in     ),
        .sio_data_out     ( tm1638_dio_out    ),
        .sio_data_out_en  ( tm1638_dio_out_en )
    );

    //------------------------------------------------------------------------

    wire [9:0] hpos; assign x = hpos [$left (x):0];
    wire [9:0] vpos; assign y = vpos [$left (y):0];
    wire unused_pixel_clk;

    vga
    # (
        .CLK_MHZ     ( clk_mhz   ),
        .PIXEL_MHZ   ( clk_mhz   )
    )
    i_vga
    (
        .clk         ( clock     ),
        .rst         ( reset     ),

        .hsync       ( vga_hsync ),
        .vsync       ( vga_vsync ),

        .display_on  ,

        .hpos        ,
        .vpos        ,

        .pixel_clk   ( unused_pixel_clk )
    );

endmodule
