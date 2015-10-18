//
// uvm_test継承のクラスから呼び出される
//
class sample_env extends uvm_env;

  `uvm_component_utils(sample_env)

   sample_agent     agent;   // uvm_agent継承クラスを呼び出す．
                             //   この中で，uvm_driver継承クラスを呼び出す
                             //             uvm_monitor   
                             //             uvm_sequencer
   
   ///
   function new (string name, uvm_component parent);
      super.new(name,parent);
      agent = sample_agent::type_id::create("agent", this);
   endfunction

   ///
   task run_phase(uvm_phase phase);
      uvm_report_info("ENV", "Hello ENV");
   endtask

endclass
