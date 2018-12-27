`define MON vintf.MONITOR.monitor_cb
class apb_imonitor extends uvm_monitor;
  `uvm_component_utils(apb_imonitor)
  
  virtual apb_if vintf;
  
  uvm_analysis_port#(apb_seqitems) m_port;
  apb_seqitems item,temp;
  

  function new(string name="apb_imonitor",uvm_component parent);
    super.new(name,parent);
    m_port = new("m_port",this);
  endfunction
    
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      if(!(uvm_config_db#(virtual apb_if)::get(this,"","vintf",vintf))) begin
        `uvm_error("NO VINTF",{"There is no virtual interface handle for:",get_full_name(),".vintf"})
    end
    endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      do begin
       @(`MON);
      end
      while(`MON.psel !== 1'b1 || `MON.penable !== 1'b0);
      item = apb_seqitems::type_id::create("item");
    
      item.rw_cmd 	= (`MON.pwrite)? apb_seqitems::WRITE : apb_seqitems::READ;
      item.addr		= `MON.paddr;
      item.rst_n	= vintf.rst_n;
      @(`MON);
      if(`MON.penable !== 1'b1)
        begin
          `uvm_error("APB PROTOCOL VIOLATION","SETUP cycle not followed by ENABLE cycle")
        end
      @(`MON);
      item.wdata   =`MON.pwdata;
      item.rdata   =`MON.prdata;
      item.pslverr = `MON.pslverr;
      item.pready  = `MON.pready;
      `uvm_info(get_type_name(),$sformatf("Got Transaction %s",item.convert2string()),UVM_HIGH)
       //cg.sample();
      m_port.write(item);
    
    end
  endtask
endclass
