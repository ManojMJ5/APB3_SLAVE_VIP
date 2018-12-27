module apb_assertions(
	input		clk,
	input 		rst_n,
	input [7:0] 	paddr,
	input 	        pwrite,
	input 		psel,
	input 		penable,
	input [31:0] 	pwdata,
	input [31:0] 	prdata,
	input		pready
);
  
  	property check_reset;
      		@(posedge clk) !($isunknown(rst_n));
  	endproperty
  
  	PRESETn_IS_IN_KNWOWN_STATE: assert property (check_reset)
    		else $display($time,,"%m FAIL ASSERTIONS PRESET IS IN UNKNWON STATE");
    //  PRESETn_IS_IN_KNWOWN_STATE: cover property (check_reset);
      
  
  	property check_psel;
      		@(posedge clk) !($isunknown(psel));
 	endproperty
   
    PSEL_IS_IN_KNWOWN_STATE: assert property (check_psel) 
      else $display($time,,"%m FAIL ASSERTIONS PSEL IS IN UNKNWON STATE");
    //  PSEL_IS_IN_KNWOWN_STATE: cover property (check_psel);
  
  	property check_paddr;
     	 @(posedge clk) disable iff(rst_n)
      		$rose(psel) |-> !($isunknown(paddr));
        endproperty
      
      PADDR_IS_VALID_WHEN_PSEL_IS_HIGH: assert property (check_paddr) 
     else $display($time,,"%m FAIL ASSERTIONS PADDR IS NOT VALID");
      //  PADDR_IS_VALID_WHEN_PSEL_IS_HIGH: cover property (check_paddr); 
   
    property check_pwrite;
      @(posedge clk) disable iff(rst_n)
      $rose(psel) |-> !($isunknown(pwrite));
    endproperty
  
    PWRITE_IS_VALID_WHEN_PSEL_IS_HIGH: assert property (check_pwrite) 
    else $display($time,,"%m FAIL ASSERTIONS PWRITE IS NOT VALID");
     
    property check_penable;
      @(posedge clk) disable iff(rst_n)
      $rose(psel) |-> !($isunknown(penable)); 
    endproperty    
  
    PENABLE_IS_VALID_WHEN_PSEL_IS_HIGH: assert property (check_penable) 
     else $display($time,,"%m FAIL ASSERTIONS PENABLE IS NOT VALID");   
  
    property check_pwdata;
      @(posedge clk) disable iff(rst_n)
       $rose(psel) |-> !($isunknown(pwdata));
    endproperty 
            
    PWDATA_IS_VALID_WHEN_PSEL_IS_HIGH: assert property (check_pwdata) 
    else $display($time,,"%m FAIL ASSERTIONS PWDATA IS NOT VALID");   
    
    property check_protocol_cycle_delay_bw_psel_penable;
      @(posedge clk) disable iff(rst_n)
       $rose(psel) |=> $rose(penable);
    endproperty
         
    ONE_CYCLE_DELAY_BW_PSEL_PENABLE:assert property(check_protocol_cycle_delay_bw_psel_penable)
      else $display($time,,"%m FAIL PROTOCOL VIOLATION MORE THAN ONE CYCLE DELAY BW PSEL AND PENABLE"); 
           
    property check_penable_low_after_pready_is_high;
      @(posedge clk) disable iff(rst_n)
       $rose(pready) |=> $fell(penable);
    endproperty
     
    PENABLE_LOW_AFTER_PREADY_HIGH:assert property(check_penable_low_after_pready_is_high) 
    else $display($time,,"%m ASSERTION FAIL PENABLE IS NOT LOW AFTER PREADY IS HIGH");
     
    property check_protocol_penable;
      @(posedge clk) disable iff(rst_n)
       $rose(penable) |=> $fell(penable);
    endproperty
     
    PENABLE_PROTOCOL_RULE:assert property(check_protocol_penable)
     else $display($time,,"%m FAIL PROTOCOL VIOLATION OF PENABLE RULE");
           
endmodule
