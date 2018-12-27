`define DRIV vintf.DRIVER.driver_cb

class apb_driver extends uvm_driver#(apb_seqitems);
  `uvm_component_utils(apb_driver)
  
  virtual apb_if vintf;
  uvm_analysis_port#(apb_seqitems) d_port;
  
  function new(string name = "apb_driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    if(!(uvm_config_db#(virtual apb_if)::get(this,"","vintf",vintf))) begin
       `uvm_error("NO VINTF",{"No virtual interface for",get_type_name(),".vintf"})
    end
    d_port = new("d_port",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    `DRIV.psel 		<= '0;
    `DRIV.penable 	<= '0;
    
    forever begin
      @(`DRIV);
      
      seq_item_port.get_next_item(req);
      
      @(`DRIV);
      `uvm_info(get_type_name(),$sformatf("GOT Transacrion %s",req.convert2string()),UVM_HIGH)
      
      case(req.rw_cmd)
        apb_seqitems::READ  : drive_read(req.addr, req.rdata);
        apb_seqitems::WRITE : drive_write(req.addr, req.wdata);
      endcase

      seq_item_port.item_done();
      d_port.write(req);
    end
  endtask : run_phase
  
  virtual task drive_read(input bit [7:0] addr, output logic [31:0] rdata);
    `DRIV.paddr   <= addr;
    `DRIV.pwrite  <= '0;
    `DRIV.psel	  <= '1;
    @(`DRIV);
    `DRIV.penable <= '1;
    wait(`DRIV.pready == 1'b1);
    @(`DRIV);
    `DRIV.penable <= '0;
    `DRIV.psel	  <= '0;
  endtask : drive_read
    
  virtual task drive_write(input bit [7:0] addr, input bit [31:0] wdata);
    `DRIV.paddr   <= addr;
    `DRIV.pwdata  <= wdata;
    `DRIV.pwrite  <= '1;
    `DRIV.psel	  <= '1;
    @(`DRIV);
    `DRIV.penable <= '1;
     wait(`DRIV.pready == 1'b1);
     @(`DRIV);
    `DRIV.penable <= '0;
    `DRIV.psel	  <= '0;
  endtask : drive_write
  
endclass : apb_driver
      
      
      
      
  