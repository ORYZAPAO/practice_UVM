// sequence���L�q����
// sequence�́A�e�X�g�x�N�^�E�e�X�g�V�i���I�Ƃ��Ă񂾂肵�܂��Bsequence�L�q�̂����߂́A
// 
//     base�ƂȂ�sequence�N���X���`���āA�����Ɂu���ʋL�q�v�𖄂ߍ���
//     sequence���ɈقȂ�L�q���A1�Ԃ�extends�����N���X�Ƃ��Ē�`���邱�ƂŁA�L�q�ʂ̍팸���s��
// 
// --- sample_seq_lib.sv
// �ŏ��̃N���X�Asample_base_seq���`���āA���ʂƂȂ�L�q�𖄂ߍ��݂܂��B
// ���̃N���X�� virtual class �Ƃ��邱�ƂŁA���̃N���X���̂𒼐ڎg���i�C���X�^���X�j�ł��Ȃ��悤�ɂ��Ă��܂��B
// �������|�C���g�������Ă����܂��B
// 
//     function new
//      do_not_randomize =�@1�ł����A�����built-in���\�b�h�ł���randomize()���g���Ȃ�modelsim-ase�p�̐ݒ�l�ł��B���p�V�~�����[�^�[���g�p���Ă��āArandomize()���\�b�h�̎g����V�~�����[�^�ł́Ado_not_randomize�̍s���폜���܂��B
//     virtual task pre_body()�Apost_body()
//         sequence�́Atask body() �������ŌĂ΂�܂��Bpre_body�́A���O�̒ʂ�Abody���ĂԑO�ɌĂ΂�郁�\�b�h�ł��B�����ŁAraise_objection���s���܂��B����́A�I�u�W�F�N�V�������J�j�Y���ƌĂ΂��d�g�݂ŁAUVM��objection���󂾂Ƃ�����Simulation���~�����Ă��܂��܂��B�ꌩ�ʓ|�Ȏd�g�݂Ɍ����܂����AUVM�ł͕����̃e�X�g�x�N�^�E�e�X�g�V�i���I������l�����Ă���A���ꂼ��̏��������^�C�~���O�͈�ʂɈقȂ�܂��B�I�u�W�F�N�V�������J�j�Y�����g�����Ƃɂ��A�Ⴆ�΂R��sequence�����s����ƁA�R��raise_objection����܂��B�����āAsequence���I��閈��drop_objection����A�R��drop������run_phase���I�����܂��B
//     class write_seq
//         sample_base_seq����g�����Ă���̂ŁAdo_not_randomize�́usuper.new�v�Ŏ��{����邵�Apre_body, post_body�͈����p�����̂ŋL�q�s�v�B
//         task body���L�q���āA�X�e�B�~�����X���`���܂��B
//             req �Ƃ������O�̃����o�́A���L�L�q�̂P�s�ځA�uuvm_sequence #(sample_seq_item)�v�Ŏw�肵�Ă���Asample_seq_item�Ƃ����^�ɂȂ��Ă��܂��B����𐶐����܂��B
//                 `uvm_create(req)
//             ��������req�́Asample_seq_item�Ȃ̂ŁAsample_seq_item�ɒ�`���Ă��������o�ɒl���Z�b�g���܂��B
//                 req.write <=�@1'b1; // write
//                 req.addr <=�@8'h10; // address
//                 req.data <=�@8'h55; // data
//             �l���Z�b�g����req���Asequencer�o�R��driver�ɑ���̂��A`uvm_send(req)�ł��B
// 
// �Ȃ��A���p�V�~�����[�^�[���g�p���Ă��āArandomize()���\�b�h���g����ꍇ�ɂ́A�ʏ�ȉ��̂悤�ɂ��܂��B
// 
//     sample_seq_item�̊e�����o�́Arand�錾����
//     `uvm_create(req)�A`uvm_send(req)���g�p���Ȃ��ŁA
//         `uvm_do(req) �܂���
//         `uvm_do_with(req, { constraints }
//     ���g�p���܂��B
// 
// �Ƃ̊��ł�randomize()���\�b�h���g�����A�L�q�̌��؂��s���Ȃ����߁A�ڍׂ͋L�q���܂���B
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
