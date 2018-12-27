`include "CYCLE.sv"

interface apb_if(input logic clk,rst_n);
  logic 		psel;
  logic 		penable;
  logic 		pwrite;
  logic [31:0]	pwdata;
  logic [31:0]	prdata;
  logic [31:0]	paddr;
  logic         pready;
  logic         pslverr;

  clocking driver_cb @(posedge clk or negedge rst_n);
  //default input #1 output `TDRIVE;
  output psel;
  output penable;
  output pwrite;
  output paddr;
  output pwdata;
  input  pready;
endclocking

 clocking monitor_cb @(posedge clk or negedge rst_n);
//  default input #1 output `TDRIVE;
  input psel;
  input penable;
  input pwrite;
  input pwdata;
  input prdata;
  input paddr;
  input pslverr;
  input pready;
endclocking
    
  modport DRIVER  (clocking driver_cb);
  modport MONITOR (clocking monitor_cb);

endinterface
