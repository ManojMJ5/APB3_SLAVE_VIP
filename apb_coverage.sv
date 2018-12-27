class coverage extends uvm_component;
  `uvm_component_utils(coverage)
  
  virtual apb_if vintf;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    cg=new();
  endfunction
  
  covergroup cg;
    option.per_instance=1;
    covergroup_paddr 	:coverpoint vintf.paddr{bins a ={0,[1:20]};}
    covergroup_pwrite	:coverpoint vintf.pwrite{bins pwrite_zero ={0}; bins pwrite_one={1};}
    covergroup_psel  	:coverpoint vintf.psel{bins b3 ={1};}
    covergroup_penable 	:coverpoint vintf.penable{bins b4 ={1};}
    covergroup_rdata	:coverpoint vintf.prdata{bins b5 ={0,[1:50]};}
    covergroup_pwdata	:coverpoint vintf.pwdata{bins a ={0,[1:50]};}
  endgroup
  
  virtual function void build_phase(uvm_phase phase);
    if(!(uvm_config_db#(virtual apb_if)::get(this,"","vintf",vintf))) begin
       `uvm_error("NO VINTF",{"No virtual interface for",get_type_name(),".vintf"})
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vintf.clk);
      cg.sample();
    end
  endtask
  
endclass