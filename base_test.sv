class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  apb_env 	   env;
  apb_sequence seqnce;
  
  function new(string name="base_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env		= apb_env     ::type_id::create("env",	 this);
    seqnce	= apb_sequence::type_id::create("seqnce");
  endfunction
  
 task run_phase(uvm_phase phase);
    phase.raise_objection(this);
   seqnce.start(env.agent.sqr);
    phase.drop_objection(this);
  endtask : run_phase
  
  virtual function void final_phase(uvm_phase phase);
    super.final_phase(phase);

    uvm_top.print_topology();
  endfunction

endclass: base_test
  
  