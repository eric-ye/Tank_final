
module  tank ( input Reset, frame_clk, ball_hit,
					input [15:0] keycode, firekey, 
					input [9:0] tXcenter, tYcenter, otherTankX, otherTankY,
               output [9:0] tankX, tankY );
    logic [15:0] keycoded;
    logic [9:0] Tank_X_Pos, Tank_X_Motion, Tank_Y_Pos, Tank_Y_Motion, Tank_Size;
	 
    //parameter [9:0] Ball_X_Center=320;  // Center position on the X axis CHANGE TANK X CENTER TO SOME VALUE 
    //parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Tank_X_Min=1;       // Leftmost point on the X axis
    parameter [9:0] Tank_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Tank_Y_Min=1;       // Topmost point on the Y axis
    parameter [9:0] Tank_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Tank_X_Step=2;      // Step size on the X axis
    parameter [9:0] Tank_Y_Step=2;      // Step size on the Y axis
	 parameter [9:0] balls = 0;   

    //assign Ball_Size = 2;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"

    always_ff @ (posedge Reset or posedge frame_clk )
	 //to do - add in out of bounds detection, collision detection
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 

            Tank_Y_Motion <= 10'd0; //Ball_Y_Step;
				Tank_X_Motion <= 10'd0; //Ball_X_Step;
				Tank_Y_Pos <= tYcenter; ///some value on the left or right side
				Tank_X_Pos <= tXcenter;
        end
        else 
        begin 
				 keycoded <= keycode;

				 
				 if(keycoded == 16'h001A) //if we press W
				    begin  
						if ( (Tank_Y_Pos - Tank_Size) <= Tank_Y_Min )  // Ball is at the top edge, BOUNCE!
						begin
							//do nothing, tank would be out of bounds
						end	
						else
							Tank_Y_Pos <= Tank_Y_Pos - Tank_Y_Step; //one keypress = 1 step
					end
				 else if(keycoded == 16'h0004) //if we press A
					begin
					  if ( (Tank_X_Pos - Tank_Size) <= Tank_X_Min ) 
					  begin

					  end	
					  else		
							Tank_X_Pos <= Tank_X_Pos - Tank_X_Step; //one keypress = 1 step
				     end
					end
				 else if (keycoded == 16'h0016) //if we press S
					begin
					 if ( (Tank_Y_Pos + Tank_Size) >= Tank_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					 begin

					 end	
					  else
				     begin
					   Tank_Y_Pos <= Tank_Y_Pos + Tank_Y_Step;

					  end	
					end
				 else if (keycoded == 16'h0007) // if we press D
					begin
					if ( (Tank_X_Pos + Tank_Size) >= Tank_X_Max )  // Ball is at the right edge, BOUNCE!
					begin
		
					end
					  else
				     begin
						Tank_X_Pos <= Tank_X_Step; 

				     end
					end
				
				
					if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max ) or
						( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min ) or
						( (Ball_X_Pos + Ball_Size) >= Ball_X_Max ) or 
						( (Ball_X_Pos - Ball_Size) >= Ball_X_Min )// Ball is about to pass an edge, reset
					 begin
										Ball_Size = 0;
										Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
										Ball_X_Motion <= 10'd0; //Ball_X_Step;
										Ball_Y_Pos <= 0;
										Ball_X_Pos <= 0;
					 end		
					 if ( (Tank_Y_Pos >= otherTankY) and (Tank_Y_Pos <= otherTankY)) and
						( (Tank_X_Pos >= otherTankX) and (Tank_X_Pos <= otherTankX)) //collide with tank, reset, send damage signal to tank module (need to add + or - tankSiZe/2)
					 begin
					 
					 end
					 
				end	 
			/*	 else if (keycoded == 16'h0016) //if we press S
					begin
					 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					 begin
						Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1); 
						Ball_X_Motion <= balls; 
					 end	
					  else
				     begin
					   Ball_Y_Motion <= Ball_Y_Step;
						Ball_X_Motion <= balls;
					  end	
					end
				 else if (keycoded == 16'h0007) // if we press D
					begin
					if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the right edge, BOUNCE!
					begin
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1); 
					  Ball_Y_Motion <= balls; 
					end
					  else
				     begin
						Ball_X_Motion <= Ball_X_Step; 
						Ball_Y_Motion <= balls; 
				     end
					end
				

				/*unique case (keycode)
					16'h001A :
					begin
							Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);//W
							Ball_X_Motion <= balls;
					end
					16'h0004 :  
					begin
							Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);//A
							Ball_Y_Motion <= balls;
					end
					16'h0016 : 
					begin
							Ball_Y_Motion <= Ball_Y_Step;//S
							Ball_X_Motion <= balls;
					end
					16'h0007 : 
					 begin
							Ball_X_Motion <= Ball_X_Step;//D
							Ball_Y_Motion <= balls;
					 end
					endcase*/

				 

				 TankX <= Tank_X_Pos;
				 TankY <= Tank_Y_Pos;
	
			
		end  
    end
       
   // assign BallX = Ball_X_Pos;
   
   // assign BallY = Ball_Y_Pos;
   
   // assign BallS = Ball_Size;
    

endmodule
