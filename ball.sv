//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk, 
					input [15:0] keycode, firekey,
					input [1:0] tankdir,
					input [9:0] parentX, parentY, otherX, otherY, tank_size,//pipe in signal for tank location (X,Y) for both tanks, as well as direction for ball fire
               output [9:0] BallX, BallY, BallS,
					output hit, ball_fire);
    logic [15:0] keycoded;
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
  //  parameter [9:0] Ball_X_Start = parentX;  // Center position on the X axis
   // parameter [9:0] Ball_Y_Start = parentY;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=1;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=1;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=20;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=20;      // Step size on the Y axis
	 parameter [9:0] balls = 0;   
      assign Ball_X_Start = parentX;
		assign Ball_Y_Start = parentY;
    //assign Ball_Size = 10;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"

    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
				//Ball_Size <= 0;
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= 0;
				Ball_X_Pos <= 0;
				hit <= 1'b0;
				ball_fire <= 1'b0;
				
		  end
        else 
        begin 
				 keycoded <= keycode;
				 hit <= 1'b0;
	
			 if(keycoded == 16'h0009) //if we press FIRE (TBD) F key
				    begin
					   if (ball_fire == 1'b0)   
						begin
							Ball_Y_Pos <= Ball_Y_Start;
							Ball_X_Pos <= Ball_X_Start;

							ball_fire <= 1'b1;
							unique case (tankdir)
								2'b00 : //up
								begin
									Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1); 
									Ball_X_Motion <= balls; 
								end
								2'b01 : //left
								begin
									Ball_Y_Motion <= balls;
									Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1); 
								end
								2'b10 : //down
								begin
									Ball_Y_Motion <= Ball_Y_Step;
									Ball_X_Motion <= balls;
								end
								2'b11 : //right
								begin
									Ball_Y_Motion <= balls;
									Ball_X_Motion <= Ball_X_Step; 
								end
							endcase
							
				   	end	 
			end
			 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
			 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);	 
			 BallX <= Ball_X_Pos;
			 BallY <= Ball_Y_Pos;
						

					
			
	/*				if ( ((Ball_Y_Pos + Ball_Size >= Ball_Y_Max ) ||
						 (Ball_Y_Pos - Ball_Size <= Ball_Y_Min ) ||
						 (Ball_X_Pos + Ball_Size >= Ball_X_Max ) || 
						 (Ball_X_Pos - Ball_Size <= Ball_X_Min )) && Ball_Size !=0 )// Ball is about to pass an edge, reset // should these conditions be OR statements rather than and cause any 1 of them could be true and we would want to reset????
					 begin
										Ball_Size <= 0;
										Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
										Ball_X_Motion <= 10'd0; //Ball_X_Step;
										Ball_Y_Pos <= 0;
										Ball_X_Pos <= 0;
					 end		
					 if ( (Ball_Y_Pos >= otherY - tank_size/2) && (Ball_Y_Pos <= otherY + tank_size/2) &&
						 (Ball_X_Pos >= otherX - tank_size/2) && (Ball_X_Pos <= otherX + tank_size/2) && Ball_Size !=0) //collide with tank, reset, send damage signal to tank module (may need to add + or - ball_step)
					 begin
						hit <= 1'b1;
						Ball_Y_Pos <= 0;
						Ball_X_Pos <= 0;
						Ball_Size <= 0;
						Ball_Y_Motion <= 10'd0; 
						Ball_X_Motion <= 10'd0; 
					 end
					 Ball_Size <= Ball_Size;
				    end	 */
		
		    
			

			
		
    end

	 end		
  //  assign BallX = Ball_X_Pos;
   
   // assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule
