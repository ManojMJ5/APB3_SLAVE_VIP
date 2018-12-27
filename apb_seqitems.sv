class apb_seqitems extends uvm_sequence_item;
  `uvm_object_utils(apb_seqitems)
  
  typedef enum {READ, WRITE} rw_enum;
  
  randc bit [31:0] addr;
  randc bit [31:0] wdata;
  	    bit [31:0] rdata; 
  	    bit pwrite;
  rand rw_enum rw_cmd;
 bit rst_n;
 bit pslverr;
 bit pready;
  
  function new(string name="apb_seqitems");
    super.new(name);
  endfunction
  
  virtual function void do_copy(uvm_object rhs);
    apb_seqitems _rhs;
    if(!$cast(_rhs,rhs)) begin
      `uvm_error(get_name(),"CAST FAILED")
    end
    super.do_copy(rhs);
    this.addr	 = _rhs.addr;
    this.wdata	 = _rhs.wdata;
    this.rdata	 = _rhs.rdata;
    this.rw_cmd	 = _rhs.rw_cmd;
    this.pslverr = _rhs.pslverr;
  endfunction : do_copy
  
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_string("rw_cmd",rw_cmd.name());
    printer.print_int("addr",addr,$bits(addr));
    printer.print_int("wdata",wdata,$bits(wdata));
    printer.print_int("rdata",rdata,$bits(rdata));
    printer.print_int("pslverr",pslverr,$bits(pslverr));
  endfunction : do_print
  
  function string convert2string();
    string s;
    s=$sformatf("rw_cmd=%s addr=%0h wdata=%0h rdata=%0h",rw_cmd.name(),addr,wdata,rdata);
    return(s);
  endfunction : convert2string
  
  function string output2string();
    return($sformatf("rdata=%0h wdata=%0h",rdata,wdata));
  endfunction : output2string
  
endclass : apb_seqitems
            
  
  
  
