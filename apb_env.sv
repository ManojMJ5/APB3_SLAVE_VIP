class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_iagent agent;
  apb_scoreboard scb;
  coverage cov;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = 	apb_iagent::type_id::create("agent",this);
    scb	  = apb_scoreboard::type_id::create("scb",this);
    cov	  =       coverage::type_id::create("cov",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    agent.drv.d_port.connect(scb.in_data);
    agent.imon.m_port.connect(scb.out_data);
  endfunction
  
endclass : apb_env
  
