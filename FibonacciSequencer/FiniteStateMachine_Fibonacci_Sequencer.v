//THE FSM CODE

module FSM #(parameter PREDEFINED = 4'b0100)(input START, Clk, output reg Done, output wire [3:0] data);

reg [1:0] wrt_addr,rd_addr1,rd_addr2;
reg wrt_en, load_data;
reg [2:0] alu_opcode;
//wire [3:0] data;
wire zero_flag;
integer count;

datapath D0 (wrt_addr, wrt_en, load_data, Clk, rd_addr1,rd_addr2, alu_opcode, count, data, zero_flag);


always
begin
  #50
  if(START==1'b0)
    begin
    alu_opcode = 3'b000;
    Done = 1'b0;
    end
end

initial
  begin
    assign Done = 1'b0;
    //STEPS TO INITIALIZE NUM1 AND NUM2 TO 1 AND 1
    
    //step 1 (store 1 to R1)
    wrt_en = 1'b1; //enable to write to registers
    count = 4'b0001; //make count 1 so that we can store 1 in both rightmost registers
    wrt_addr = 2'b00; //storing to R1
    load_data = 1'b1; //storing not "data" but count
    rd_addr1 = 2'b00;
    rd_addr2 = 2'b00;
    alu_opcode = 3'b000;
    
    //TIMING
    //================
    #100;
    //================
    
    //step 2 (store 0 to R2)
    
    count = 4'b0000; //make count = 0
    wrt_addr = 2'b01; //store count (0) to R2
    
    //TIMING
    //================
    #100;
    //================
    
    
    //STEPS TO COUNT FIBONACCI
    
    //STARTING LOOP
    for(count=4'b1111; count!=0; count = count - 1)
    begin
      //step 1 (R3<-R1)
      rd_addr2 = 2'b00; //choose the value of rightmost register for R1
      alu_opcode = 3'b101; //just to make the ALU output equal to R1
      wrt_addr = 2'b10; //write to R3
      load_data = 1'b0; //choose from "data" output, not the count
      
      //TIMING
      //================
      #100;
      //================
    
      //step 2 (R1<-R1+R2)
      rd_addr1 = 2'b01;
      rd_addr2 = 2'b00;
      alu_opcode = 3'b110;
      
      //TIMING
      //================
      #100;
      //================
      
   
   wrt_addr= 2'b00;
   
  
   
   
   
   //TIMING
      //================
      #100;
      //================
      
  
   //step 3 (R2<-R3)
  
    rd_addr2 = 2'b10;
  
    alu_opcode = 3'b101;
  
    
  
    
//TIMING
      //================
      #100;
      //================
      
      wrt_addr = 2'b01;
      
      //TIMING
      //================
      #100;
      //================
      
    end
    
    assign Done = 1'b1;
    
  end
endmodule

//========================================================================

//THE ALU CODE


module ALU(input [3:0] R1,R2, input [2:0] alu_opcode, output [3:0] F, output zero_flag);
assign F = (alu_opcode==3'b000) ? 4'b0000:
		   (alu_opcode==3'b001) ? 4'b0001:
		   (alu_opcode==3'b010) ? R1+1:
		   (alu_opcode==3'b011) ? R1-1:
		   (alu_opcode==3'b100) ? 4'bXXXX: /*Load is 1 here*/
		   (alu_opcode==3'b101) ? R1:
		   (alu_opcode==3'b110) ? R1+R2:
		   (alu_opcode==3'b111) ? R2:
        4'bXXXX;
assign zero_flag = (F==4'b0000) ? 1'b1: 1'b0;
endmodule

//========================================================================

//THE REGISTER CODE

module register_4_bit(input [3:0] D, input Clk, output reg[3:0] Q);

always @ (posedge Clk)
begin
  Q=D;
end
endmodule

//========================================================================

//THE DECODER CODE

module decoder_2_1(input [1:0] wrt_addr, output [3:0] REG);
  
assign REG = (wrt_addr==2'b00) ? 4'b0001:
             (wrt_addr==2'b01) ? 4'b0010:
             (wrt_addr==2'b10) ? 4'b0100:
             (wrt_addr==2'b11) ? 4'b1000:
             4'bXXXX;
endmodule

//========================================================================

//THE 2-1 MULTIPLEXER CODE

module mux_2_1(input [3:0] A,B, input S, output [3:0] F);
  
assign F = (S == 1'b0) ? A : ((S == 1'b1) ? B : 4'bXXXX);

endmodule

//========================================================================

//THE 4-1 MULTIPLEXER CODE

module mux_4_1(input [3:0] A,B,C,D, input [1:0] S, output [3:0] F);
  
assign F = (S==2'b00) ? A:
           (S==2'b01) ? B:
           (S==2'b10) ? C:
           (S==2'b11) ? D:
           4'bXXXX;

endmodule

//========================================================================

//TESTBENCH FOR FSM

module FSM_TB();
  
reg START, Clk;
wire Done;
wire [3:0] Data;

FSM DUT(START, Clk, Done, Data);

always
#50 Clk = !Clk;

initial
  begin
    
Clk = 1'b1;
    
START = 1'b1;
  end
endmodule
