User
module elevator(input clk,rst,inG,in1,in2,in3,in4,in5,in6,in7,inopen,inclose, output open,close,up,down);

parameter IDLE=4'd8,OPEN=4'd9,CLOSE=4'd10,UP=4'd11,DOWN=4'd12,WAIT=4'd13;
parameter G=3'd0,F1=3'd1,F2=3'd2,F3=3'd3,F4=3'd4,F5=3'd5,F6=3'd6,F7=3'd7;

reg[3:0] pstate,nstate;
reg[2:0] pfloor,nfloor;
reg[6:0] count;
reg reached,overload=0,dir=1;

//present state

always@(posedge clk or negedge rst)

begin
 pstate<=rst?nstate:IDLE;
if(!rst) pfloor=G;
  else if(pstate==OPEN)
     pfloor=nfloor;
end

//next state

always@(*)begin
nstate=IDLE;
case(pstate)

IDLE:begin
    if(inopen
      nstate=OPEN;
    else if(pfloor<nfloor)
      nstate=UP;
    else if(pfloor>nfloor)
      nstate=DOWN;  
else if(pfloor==nfloor)
 begin   
 if(inG|in1|in2|in3|in4|in5|in6|in7)    
    nstate=OPEN;
      end   
else nstate=IDLE;
    end

OPEN:begin
    if(inclose)
      nstate=CLOSE; 
else nstate=WAIT;   
  end

CLOSE:begin
    if(inopen)  
  nstate=OPEN;
    else nstate=IDLE;    
  end

UP:begin    
if(reached)
      nstate=OPEN;
    else nstate=UP;  
 end

DOWN:begin  
if(reached) 
  nstate=OPEN;
    else nstate=DOWN;  
 end

WAIT:begin  
if(overload)
      nstate=WAIT;  
else nstate=CLOSE;  
  end

default: nstate=IDLE;
endcase 
end

//next floor
always @(*) begin 
if(pstate==IDLE)
begin
  repeat(2)
 if(dir)
begin
    
case(pfloor)
    G:nfloor=in1?F1:in2?F2:in3?F3:in4?F4:in5?F5:in6?F6:in7?F7:G;
    F1:begin nfloor=in2?F2:in3?F3:in4?F4:in5?F5:in6?F6:in7?F7:F1;   
if(!(in2||in3||in4||in5||in6||in7)) dir=0;end
    F2:begin nfloor=in3?F3:in4?F4:in5?F5:in6?F6:in7?F7:F2;
    if(!(in3||in4||in5||in6||in7)) dir=0;end
    F3:begin nfloor=in4?F4:in5?F5:in6?F6:in7?F7:F3; 
if(!(in4||in5||in6||in7)) dir=0;end 
F4:begin nfloor=in5?F5:in6?F6:in7?F7:F4;
    if(!(in5||in6||in7)) dir=0;end  
F5:begin nfloor=in6?F6:in7?F7:F5;   
if(!(in6||in7)) dir=0;end   
F6:begin nfloor=in7?F7:F6;
    if(!in7) dir=0;end
    F7:begin nfloor=F7;
 if(!in7)dir=0;end  
default:nfloor=G;   
endcase 
end  
else 
begin
    
case(pfloor)
    F7:nfloor=in6?F6:in5?F5:in4?F4:in3?F3:in2?F2:in1?F1:inG?G:F7;
    F6:begin nfloor=in5?F5:in4?F4:in3?F3:in2?F2:in1?F1:inG?G:F6;
    if(!(inG||in1||in2||in3||in4||in5)) dir=1;end
    F5:begin nfloor=in4?F4:in3?F3:in2?F2:in1?F1:inG?G:F5;
    if(!(inG||in1||in2||in3||in4)) dir=1;end    
F4:begin nfloor=in3?F3:in2?F2:in1?F1:inG?G:F4;  
if(!(inG||in1||in2||in3)) dir=1;end 
F3:begin nfloor=in2?F2:in1?F1:inG?G:F3;
    if(!(inG||in1||in2)) dir=1;end  
F2:begin nfloor=in1?F1:inG?G:F2;
    if(!(inG||in1)) dir=1;end
    F1:begin nfloor=inG?G:F1;
    if(!inG) dir=1;end  
G:begin nfloor=G;
 if(!inG)dir=1;end
    default:nfloor=G;
    endcase 
end
end 
end

//counter

always@(posedge clk)
begin
if(nstate==UP) 
begin
  count<=count+1; 
   if(count==(nfloor-pfloor)*1)
begin    
count<=0;reached=1;
end 
end
 
else if(nstate==DOWN) 
begin  
 count<=count+1;   
 if(count==(pfloor-nfloor)*1)begin 
  count<=0;reached=1;
end
 end
 
else 
begin  
  count<=0;  
  reached<=0;
 end
end
//output

assign 
open=pstate==OPEN;
assign close=pstate==CLOSE;
assign up=pstate==UP;
assign down=pstate==DOWN;
endmodule
