class sample_seq_item extends uvm_sequence_item;

   byte     addr;
   byte     data;
   bit      write;

  `uvm_object_utils(sample_seq_item)

   ///
   function new (string name="sample_seq_item_inst");
      super.new(name);
   endfunction

endclass
