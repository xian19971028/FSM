module FSM (clk, reset, cancel, inputmoney, ticketnum, des_state, ini_state );

input  clk, reset, cancel;
input[7:0]	inputmoney  ;
input[2:0]  ticketnum, des_state, ini_state ;

reg finish ;
reg[7:0] totalneedmoney, ticketmoney, inputmoney_sum, stillneed, givebackmoney ;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

reg [1:0] curr_state;
reg [1:0] next_state;

initial begin
	curr_state = S0 ;
	totalneedmoney = 8'b00000000 ;
	ticketmoney = 8'b00000000 ; 
	inputmoney_sum = 8'b00000000 ; 
	stillneed = 8'b00000000 ; 
	givebackmoney = 8'b00000000 ;

end
// state reg
always@(posedge clk or posedge reset) begin
	if (reset) begin
		curr_state = S0 ;
		totalneedmoney = 8'b00000000 ;
		ticketmoney = 8'b00000000 ; 
		inputmoney_sum = 8'b00000000 ; 
		stillneed = 8'b00000000 ; 
		givebackmoney = 8'b00000000 ;
	end
	else begin    
		curr_state = next_state ;
		finish = 1'b0 ;
	end
end
// next state logic    

always@( curr_state or finish or posedge cancel  )
  case (curr_state)
    S0:
		if (finish) next_state = S1;
		else     next_state = S0;
			  
    S1: 
		if(cancel) next_state = S0;
		else if (finish) next_state = S2;
        else     next_state = S1;
			  
    S2:
		if(cancel) next_state = S3;
		else if (finish) next_state = S3;
        else     next_state = S2;
			  
	S3:
		if (finish) next_state = S0;
        else     next_state = S3;
			  
    default:   	
		next_state = S0;
  endcase    

// output logic
always@(inputmoney or ticketnum or des_state or ini_state or curr_state or reset or finish ) begin
  case (curr_state)
    S0: begin
			if( des_state == 3'b001 && ini_state == 3'b001 )  ticketmoney = 8'b00000101 ; //  5
			else if( des_state == 3'b001 && ini_state == 3'b010 ) ticketmoney = 8'b00001010 ; // 10
			else if( des_state == 3'b001 && ini_state == 3'b011 ) ticketmoney = 8'b00001111 ; // 15
			else if( des_state == 3'b001 && ini_state == 3'b100 ) ticketmoney = 8'b00010100 ; // 20
			else if( des_state == 3'b001 && ini_state == 3'b101 ) ticketmoney = 8'b00011001 ; // 25
			
			else if( des_state == 3'b010 && ini_state == 3'b001 ) ticketmoney = 8'b00001010 ; // 10
			else if( des_state == 3'b010 && ini_state == 3'b010 ) ticketmoney = 8'b00000101 ; //  5
			else if( des_state == 3'b010 && ini_state == 3'b011 ) ticketmoney = 8'b00001010 ; // 10
			else if( des_state == 3'b010 && ini_state == 3'b100 ) ticketmoney = 8'b00001111 ; // 15
			else if( des_state == 3'b010 && ini_state == 3'b101 ) ticketmoney = 8'b00010100 ; // 20

			else if( des_state == 3'b011 && ini_state == 3'b001 ) ticketmoney = 8'b00001111 ; // 15
			else if( des_state == 3'b011 && ini_state == 3'b010 ) ticketmoney = 8'b00001010 ; // 10
			else if( des_state == 3'b011 && ini_state == 3'b011 ) ticketmoney = 8'b00000101 ; //  5
			else if( des_state == 3'b011 && ini_state == 3'b100 ) ticketmoney = 8'b00001010 ; // 10
			else if( des_state == 3'b011 && ini_state == 3'b101 ) ticketmoney = 8'b00001111 ; // 15
			
			else if( des_state == 3'b100 && ini_state == 3'b001 ) ticketmoney = 8'b00010100 ; // 20
			else if( des_state == 3'b100 && ini_state == 3'b010 ) ticketmoney = 8'b00001111 ; // 15
			else if( des_state == 3'b100 && ini_state == 3'b011 ) ticketmoney = 8'b00001010 ; // 10
			else if( des_state == 3'b100 && ini_state == 3'b100 ) ticketmoney = 8'b00000101 ; //  5
			else if( des_state == 3'b100 && ini_state == 3'b101 ) ticketmoney = 8'b00001010 ; // 10
			
			else if( des_state == 3'b101 && ini_state == 3'b001 ) ticketmoney = 8'b00011001 ; // 25
			else if( des_state == 3'b101 && ini_state == 3'b010 ) ticketmoney = 8'b00010100 ; // 20
			else if( des_state == 3'b101 && ini_state == 3'b011 ) ticketmoney = 8'b00001111 ; // 15
			else if( des_state == 3'b101 && ini_state == 3'b100 ) ticketmoney = 8'b00001010 ; // 10
			else if( des_state == 3'b101 && ini_state == 3'b101 ) ticketmoney = 8'b00000101 ; //  5
			finish = 1'b1 ;

	end
    S1: begin
		if( reset == 1'b0 ) begin
			totalneedmoney = ticketmoney * ticketnum ;
			finish = 1'b1 ;
		end
	end
    S2: begin
		if( reset == 1'b0 && cancel != 1'b1 ) begin
			inputmoney_sum = inputmoney_sum + inputmoney ;
			if( inputmoney_sum >= totalneedmoney ) begin
				finish = 1'b1 ;
				stillneed = totalneedmoney - inputmoney_sum ;
				
			end
			else begin
				stillneed = totalneedmoney - inputmoney_sum ;
				$display( "give%d stillneed%d",inputmoney_sum, stillneed  );
				finish = 1'b1 ;
			end

			
		end
		
	end
	
	S3: begin
		if( reset == 1'b0 && cancel != 1'b1 ) begin
			givebackmoney = inputmoney_sum - totalneedmoney ;
			$display( "charge%d ticketnum%d, ticketprice%d",givebackmoney, ticketnum, ticketmoney  );
			finish = 1'b1 ;
		end
		else if( reset == 1'b0 && cancel == 1'b1 )begin
			$display( "giveback %d ",inputmoney_sum  );
			finish = 1'b1 ;
		end
		
	end
	
  endcase
 end
  
endmodule
