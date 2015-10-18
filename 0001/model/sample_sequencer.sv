//    UVMのスティミュラス（テストパタン）発生までの流れを押さえておくことはとても重要です。
//        sequenceから
//            sequence_itemを
//            sequencerに渡す
//        sequencerが受け取って、
//        driverに渡す
//
//    という流れになります。
class sample_sequencer extends uvm_sequencer #(sample_seq_item);

   `uvm_component_utils(sample_sequencer)

   ///
   function new (string name, uvm_component parent);
      super.new(name, parent);
      //do_not_randomize =　1;
      //do_not_randomize =　1ですが、
      // これはbuilt-inメソッドであるrandomize()が使えないmodelsim-ase用の設定値です。
      // 商用シミュレーターを使用していて、randomize()メソッドの使えるシミュレータでは、
      // do_not_randomizeの行を削除します。
   endfunction

   ///   
   task run_phase(uvm_phase phase);
      uvm_report_info("SEQR", "Hi");
   endtask

endclass
