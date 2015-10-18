// sequenceを記述する
// sequenceは、テストベクタ・テストシナリオとも呼んだりします。sequence記述のお勧めは、
// 
//     baseとなるsequenceクラスを定義して、そこに「共通記述」を埋め込む
//     sequence毎に異なる記述を、1番をextendsしたクラスとして定義することで、記述量の削減を行う
// 
// --- sample_seq_lib.sv
// 最初のクラス、sample_base_seqを定義して、共通となる記述を埋め込みます。
// このクラスを virtual class とすることで、このクラス自体を直接使う（インスタンス）できないようにしています。
// いくつかポイントを書いておきます。
// 
//     function new
//      do_not_randomize =　1ですが、これはbuilt-inメソッドであるrandomize()が使えないmodelsim-ase用の設定値です。商用シミュレーターを使用していて、randomize()メソッドの使えるシミュレータでは、do_not_randomizeの行を削除します。
//     virtual task pre_body()、post_body()
//         sequenceは、task body() が自動で呼ばれます。pre_bodyは、名前の通り、bodyを呼ぶ前に呼ばれるメソッドです。ここで、raise_objectionを行います。これは、オブジェクションメカニズムと呼ばれる仕組みで、UVMはobjectionが空だとすぐにSimulationを停止させてしまいます。一見面倒な仕組みに見えますが、UVMでは複数のテストベクタ・テストシナリオ動作を考慮しており、それぞれの処理完了タイミングは一般に異なります。オブジェクションメカニズムを使うことにより、例えば３つのsequenceを実行すると、３回raise_objectionされます。そして、sequenceが終わる毎にdrop_objectionされ、３回dropされるとrun_phaseが終了します。
//     class write_seq
//         sample_base_seqから拡張しているので、do_not_randomizeは「super.new」で実施されるし、pre_body, post_bodyは引き継がれるので記述不要。
//         task bodyを記述して、スティミュラスを定義します。
//             req という名前のメンバは、下記記述の１行目、「uvm_sequence #(sample_seq_item)」で指定している、sample_seq_itemという型になっています。これを生成します。
//                 `uvm_create(req)
//             生成したreqは、sample_seq_itemなので、sample_seq_itemに定義していたメンバに値をセットします。
//                 req.write <=　1'b1; // write
//                 req.addr <=　8'h10; // address
//                 req.data <=　8'h55; // data
//             値をセットしたreqを、sequencer経由でdriverに送るのが、`uvm_send(req)です。
// 
// なお、商用シミュレーターを使用していて、randomize()メソッドが使える場合には、通常以下のようにします。
// 
//     sample_seq_itemの各メンバは、rand宣言する
//     `uvm_create(req)、`uvm_send(req)を使用しないで、
//         `uvm_do(req) または
//         `uvm_do_with(req, { constraints }
//     を使用します。
// 
// 家の環境ではrandomize()メソッドが使えず、記述の検証が行えないため、詳細は記述しません。
virtual class sample_base_seq extends uvm_sequence #(sample_seq_item);

   ///
   function new(string name="sample_base_seq");
      super.new(name);
      //do_not_randomize = 1;
   endfunction

   ///
   virtual task pre_body();
      if (starting_phase!=null) begin
         `uvm_info(get_type_name(),
                 $sformatf("%s pre_body() raising %s objection",
                           get_sequence_path(),
                           starting_phase.get_name()), UVM_MEDIUM);
         starting_phase.raise_objection(this);
      end
   endtask

   // Drop the objection in the post_body so the objection is removed when
   // the root sequence is complete.
   virtual task post_body();
      if (starting_phase!=null) begin
         `uvm_info(get_type_name(),
                   $sformatf("%s post_body() dropping %s objection",
                             get_sequence_path(),
                             starting_phase.get_name()), UVM_MEDIUM);
         starting_phase.drop_objection(this);
      end
   endtask

endclass


//------------------------------------------------------------------------
class write_seq extends sample_base_seq;

  `uvm_object_utils(write_seq)

   ///
   function new (string name="write_seq");
      super.new(name);
   endfunction

   ///
   virtual task body();
      $display("Hello SEQ");
      `uvm_create(req)
      req.write <= 1'b1;
      req.addr  <= 8'h10;
      req.data  <= 8'h55;
      `uvm_send(req)
      #1000;
   endtask

endclass
