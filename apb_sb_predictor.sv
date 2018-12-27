class apb_sb_predictor extends uvm_subscriber #(apb_seqitems);
  `uvm_component_utils(apb_sb_predictor)
  
  uvm_analysis_port #(apb_seqitems) results_ap;
        logic [31:0] read_data;
      logic [31:0] write_data;
      logic  [7:0] addr;
      reg [31:0] mem [256];
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    results_ap = new("results_ap",this);
  endfunction
  
  function void write(apb_seqitems t);
    apb_seqitems exp_tr; 
    exp_tr=sb_calc_exp(t);
    results_ap.write(exp_tr);
  endfunction
  
  extern function apb_seqitems sb_calc_exp(apb_seqitems t);
    
endclass
    
    function apb_seqitems apb_sb_predictor::sb_calc_exp(apb_seqitems t);

      
      apb_seqitems tr;
      
      tr = apb_seqitems::type_id::create("tr");
      addr = t.addr;
      write_data = t.wdata;
      read_data  = t.rdata;
     // t.print();
      `uvm_info(get_type_name(),t.convert2string(),UVM_HIGH)
      
      case(t.rw_cmd)
        apb_seqitems::READ  : read_data = mem[t.addr];
        apb_seqitems::WRITE : mem[t.addr]=write_data;
      endcase
      
      tr.copy(t);
     // tr.print();
      tr.rdata = read_data;
      tr.wdata = write_data;
      tr.addr  = addr;
     // $display("mem[%0d]=%0d",addr,mem[addr]);
      //tr.print();
      return(tr);
    endfunction
      
      
      
      