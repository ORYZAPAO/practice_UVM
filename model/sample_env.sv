//
// uvm_test�p���̃N���X����Ăяo�����
//
class sample_env extends uvm_env;

  `uvm_component_utils(sample_env)

   sample_agent     agent;   // uvm_agent�p���N���X���Ăяo���D
                             //   ���̒��ŁCuvm_driver�p���N���X���Ăяo��
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
