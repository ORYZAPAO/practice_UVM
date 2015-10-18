class sample_test extends uvm_test;

  `uvm_component_utils(sample_test)

   sample_env env;  /// uvm_env 継承のクラス
                    ///この中で，さらに uvm_agentを呼び出す
   
   //`uvm_new_func
   function new (string name="sample_test", uvm_component parent=null);
      super.new(name,parent);
   endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = sample_env::type_id::create("env", this);  //注意
  endfunction

  task run_phase(uvm_phase phase);
     begin
     //phase.raise_objection(this);
     $display("Hello World\n");
     uvm_report_info("ENV", "Hello ENV");
     //phase.drop_objection(this);     
     end     
  endtask

endclass // test
