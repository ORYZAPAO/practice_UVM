module tb_top;

   // UVM class library
   `include "./uvm-1.2/src/uvm_macros.svh"
   import uvm_pkg::*;

   // uvm user code
   `include "sample_model.svh"
   `include "sample_test.sv"

   logic      clk;
   logic      rstz;
   sample_if  vif(clk,rstz);

   // clk
   initial begin
      clk <= 1'b1;
      #100;
      forever #50 clk <= ~clk;
   end

   // rstz
   initial begin
      rstz     <= 1'b0;
      #80 rstz <= 1'b1;
   end

  initial begin
    ///run_test("test");
    uvm_config_db #(virtual sample_if)::set(uvm_root::get(), "*.env.*", "vif", vif);
    run_test();
  end
endmodule

