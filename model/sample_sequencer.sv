//    UVM�̃X�e�B�~�����X�i�e�X�g�p�^���j�����܂ł̗�����������Ă������Ƃ͂ƂĂ��d�v�ł��B
//        sequence����
//            sequence_item��
//            sequencer�ɓn��
//        sequencer���󂯎���āA
//        driver�ɓn��
//
//    �Ƃ�������ɂȂ�܂��B
class sample_sequencer extends uvm_sequencer #(sample_seq_item);

   `uvm_component_utils(sample_sequencer)

   ///
   function new (string name, uvm_component parent);
      super.new(name, parent);
      //do_not_randomize =�@1;
      //do_not_randomize =�@1�ł����A
      // �����built-in���\�b�h�ł���randomize()���g���Ȃ�modelsim-ase�p�̐ݒ�l�ł��B
      // ���p�V�~�����[�^�[���g�p���Ă��āArandomize()���\�b�h�̎g����V�~�����[�^�ł́A
      // do_not_randomize�̍s���폜���܂��B
   endfunction

   ///   
   task run_phase(uvm_phase phase);
      uvm_report_info("SEQR", "Hi");
   endtask

endclass
