module simulate;

reg clk, reset, cancel;
reg [7:0]	inputmoney ;
reg [2:0]  ticketnum, des_state, ini_state ;

initial begin
	cancel = 1'b0;
	inputmoney = 8'b00000000;
end

FSM FSM1 ( clk, reset, cancel, inputmoney, ticketnum, des_state, ini_state);

initial clk = 1'b0;

always #5 clk = ~clk ;

initial 
begin

	reset = 1 ;
	reset = 0 ;
	ini_state = 3'b001;
	des_state = 3'b100;
	ticketnum = 3'b011;
	#10
	inputmoney = 8'b00001010;
	#10
	inputmoney = 8'b00110010;
	
	#10
	reset = 1 ;
	#10
	reset = 0 ;
	ini_state = 3'b100;
	des_state = 3'b001;
	#10
	cancel = 1 ;
	#10
	cancel = 0 ;
	
	ini_state = 3'b011;
	des_state = 3'b001;
	ticketnum = 3'b101;
	#10
	inputmoney = 8'b00110010;
	#10
	inputmoney = 8'b00001010;
	#10
	inputmoney = 8'b00001010;
	#10
	inputmoney = 8'b00000001;
	#10
	cancel = 1 ;
	#10
	cancel = 0 ;
	ini_state = 3'b011;
	des_state = 3'b001;
	ticketnum = 3'b100;
	#10
	inputmoney = 8'b00110010;
	#10
	inputmoney = 8'b00001010;
end
endmodule
