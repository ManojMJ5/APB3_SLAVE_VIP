class apb_iagent extends uvm_agent;
  `uvm_component_utils(apb_iagent)
  
  apb_sequencer sqr;
  apb_driver 	drv;
  apb_imonitor  imon;
  
  function new(string name="apb_iagent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    sqr  = apb_sequencer::type_id::create("sqr",this);
    drv  = apb_driver::type_id::create("drv", this);
    imon = apb_imonitor::type_id::create("mon", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
  
endclass