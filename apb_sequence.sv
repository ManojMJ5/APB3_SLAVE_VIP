class apb_sequence extends uvm_sequence#(apb_seqitems);
  `uvm_object_utils(apb_sequence)
  
  function new(string name="apb_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(100) begin
      `uvm_info(get_type_name(),"Starting the sequence",UVM_HIGH)
      `uvm_do_with(req,{addr inside {[0:20]}; wdata inside {[0:50]}; rw_cmd dist {WRITE:=4, READ:=8};})
    end
  endtask : body
  
endclass : apb_sequence