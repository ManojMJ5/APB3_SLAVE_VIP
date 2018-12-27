class apb_sb_comparator extends uvm_component;
  `uvm_component_utils(apb_sb_comparator)
  
  uvm_analysis_export 	#(apb_seqitems) in_data;
  uvm_analysis_export 	#(apb_seqitems) out_data;
  uvm_tlm_analysis_fifo #(apb_seqitems) expfifo;
  uvm_tlm_analysis_fifo #(apb_seqitems) outfifo;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_data= new("in_data",	this);
    out_data= new("out_data",	this);
    expfifo= new("expfifo",	this);
    outfifo= new("outfifo",	this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    in_data.connect(expfifo.analysis_export);
    out_data.connect(outfifo.analysis_export);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    apb_seqitems exp_tr, out_tr;
    forever begin
      expfifo.get(exp_tr);
      outfifo.get(out_tr);
     // exp_tr.print();
      //out_tr.print();
      if(out_tr.rw_cmd == apb_seqitems::READ)
        begin
          if(out_tr.pslverr == 1'b0)
            begin
          		if((out_tr.rdata == exp_tr.rdata) && (out_tr.addr == exp_tr.addr) && (out_tr.rw_cmd == exp_tr.rw_cmd))
            		begin
           				 PASS();
           				`uvm_info("PASS",$sformatf("Actual=%s expected=%s\n",out_tr.output2string(),exp_tr.output2string()),UVM_HIGH)
           			end
              	else
          			begin
       		 			ERROR();
              			`uvm_error("ERROR",$sformatf("Actual=%s expected=%s\n",out_tr.output2string(),exp_tr.output2string())) 
          		end
            end
          else
            begin
              ERROR();
              `uvm_info("OPERATION FAILED",$sformatf("PSLVERR IS HIGH OPERATION FAILED"),UVM_HIGH)
            end
        end
      else if(out_tr.rw_cmd == apb_seqitems::WRITE)
        begin
          if(out_tr.pslverr == 1'b0)
            begin
          		if((out_tr.wdata == exp_tr.wdata)&& (out_tr.addr == exp_tr.addr) && (out_tr.rw_cmd == exp_tr.rw_cmd)) begin
            		PASS();
           			`uvm_info("PASS",$sformatf("Actual=%s expected=%s\n",out_tr.output2string(),exp_tr.output2string()),UVM_HIGH)
          			end
      		   else
          			begin
       		 			ERROR();
              			`uvm_error("ERROR",$sformatf("Actual=%s expected=%s\n",out_tr.output2string(),exp_tr.output2string())) 
          			end
       		 end
          else
            begin
              ERROR();
               `uvm_info("OPERATION FAILED",$sformatf("PSLVERR IS HIGH OPERATION FAILED"),UVM_HIGH)
            end
     end
    end
  endtask
  
  int VECT_CNT, PASS_CNT, ERROR_CNT;
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if(VECT_CNT && ~ERROR_CNT) begin
      `uvm_info(get_type_name(),$sformatf("\n\n\n*** TEST PASSED - %0d vectors ran, %0d vectors passed ***\n",VECT_CNT, PASS_CNT), UVM_LOW)
    end
    else begin
      `uvm_info(get_type_name(),$sformatf("\n\n\n*** TEST FAILED - %0d vectors ran, %0d vectors passed ***\n",VECT_CNT, PASS_CNT), UVM_LOW)
    end
  endfunction
  
  function void PASS();
    VECT_CNT++;
    PASS_CNT++;
  endfunction
  
  
 function void ERROR();
 	 
 	VECT_CNT++;
 	ERROR_CNT++;
 endfunction
  
endclass : apb_sb_comparator   
      
