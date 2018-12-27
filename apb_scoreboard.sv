class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  
  uvm_analysis_export #(apb_seqitems) in_data;
  uvm_analysis_export #(apb_seqitems) out_data;
  apb_sb_predictor 					  prd;
  apb_sb_comparator					  cmp;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_data  = new("in_data",	this);
    out_data = new("out_data",	this);
    prd =  apb_sb_predictor::type_id::create("prd", this);
    cmp = apb_sb_comparator::type_id::create("cmp", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    in_data.connect			(prd.analysis_export);
    out_data.connect		(cmp.out_data);
    prd.results_ap.connect	(cmp.in_data);
  endfunction
  
endclass : apb_scoreboard