// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Mon Jun 16 20:21:13 2025
// Host        : DESKTOP-7JRIDGE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               E:/Especializacion_fiuba/MyS/TP_FINAL/sintesis/TP_FINAL/TP_FINAL.srcs/sources_1/bd/system/ip/system_ila_0_0/system_ila_0_0_stub.v
// Design      : system_ila_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "ila,Vivado 2018.1" *)
module system_ila_0_0(clk, probe0, probe1)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[11:0],probe1[11:0]" */;
  input clk;
  input [11:0]probe0;
  input [11:0]probe1;
endmodule
