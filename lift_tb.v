module elevator_tb;

  // Parameters
  parameter PERIOD = 10; // Clock period
  
  // Signals
  reg clk = 0; // Clock
  reg rst = 1; // Reset signal
  
  reg inG, in1, in2, in3, in4, in5, in6, in7; // Floor input signals
  reg inopen, inclose; // Open and close signals
  
  wire open, close, up, down; // Output signals
  
  // Instantiate the elevator module
  elevator DUT(
    .clk(clk),
    .rst(rst),
    .inG(inG),
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .in4(in4),
    .in5(in5),
    .in6(in6),
    .in7(in7),
    .inopen(inopen),
    .inclose(inclose),
    .open(open),
    .close(close),
    .up(up),
    .down(down)
  );
  
  // Clock generation
  always # (PERIOD / 2) clk = ~clk;
  
  // Reset generation
  initial begin
    #PERIOD rst = 0;
    #PERIOD rst = 1;
  end
  
  // Test scenario
  initial begin
    // Test case 1: Open the door
    inopen = 1;
    #20;
    
    // Test case 2: Close the door
    inopen = 0;
    inclose = 1;
    #20;
    
    // Test case 3: Request to go to floor 3
    in3 = 1;
    #20;
    
    // Test case 4: Request to go to ground floor
    inG = 1;
    #20;
    
    // Test case 5: Overload detected
    inG = 1;
    inopen = 1;
    #20;
    inclose = 1;
    #20;
    inopen = 0;
    in1 = 1; // Simulate someone pressing button on first floor
    #20;
    
    // End simulation
    $finish;
  end

endmodule
