//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX1, BallY1, BallX2, BallY2, TankX1, TankY1, TankX2, TankY2, DrawX, DrawY, BallS1, BallS2, TankS, 
							  input ball_fire,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on;
	 logic tank_on;
	 logic ball_on2;
	 logic tank_on2;
	// logic shape_on;
	/* logic[10:0] shape_x = 300;
	 logic[10:0] shape_y = 300;
	 logic[10:0] shape_size_x = 10;
	 logic[10:0] shape_size_y = 10;*/
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - BallS) &&
       (DrawX <= BallX + BallS) &&
       (DrawY >= BallY - BallS) &&
       (DrawY <= BallY + BallS))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, DistXt, DistYt, Size;
	 assign DistX1 = DrawX - BallX1;
    assign DistY1 = DrawY - BallY1;
	 assign DistXt1 = DrawX - TankX1;
	 assign DistYt1 = DrawY - TankY1;
	 
	 assign DistX2 = DrawX - BallX2;
    assign DistY2 = DrawY - BallY2;
	 assign DistXt2 = DrawX - TankX2;
	 assign DistYt2 = DrawY - TankY2; 
	 
    assign Size = BallS1;
	 assign SizeT = TankS;	
    always_comb
    begin:Ball_on_proc1
       // if ( ( DistX1*DistX1 + DistY1*DistY1) <= (Size * Size) && Size !=0 )  
        //    ball_on = 1'b1;
			if((DrawX >= BallX1 - BallS1) && (DrawX < BallX1 + BallS1) && 
		      (DrawY >= BallY1 - BallS1) && (DrawY < BallY1 + BallS1) && (ball_fire == 1'b1))
			ball_on = 1'b1;		
        else 
            ball_on = 1'b0;
  //   end 

   // begin:Tank_on_proc1
		  if( (DrawX >= TankX1 - TankS/2) && (DrawX < TankX1 + TankS/2) &&
			   (DrawY >= TankY1 - TankS/2) && (DrawY < TankY1 + TankS/2))
            tank_on = 1'b1;
        else 
            tank_on = 1'b0;
 //    end  
	 
	 
//	 begin:Ball_on_proc2
        if ( ( DistX2*DistX2 + DistY2*DistY2) <= (BallS2 * BallS2) && BallS2 !=0 ) 
           ball_on2 = 1'b1;
		//if((DrawX >= BallX2 - BallS2/2) && (DrawX < BallX2 + BallS2/2) && 
		 //  (DrawY >= BallY2 - BallS2/2) && (DrawY < BallY2 + BallS2/2))
       //     ball_on2 = 1'b1;	
        else 
            ball_on2 = 1'b0;
 //    end 

 //   begin:Tank_on_proc2
		  if((DrawX >= TankX2 - TankS/2) && DrawX < TankX2 + TankS/2 &&
			   DrawY >= TankY2 - TankS/2 && DrawY < TankY2 + TankS/2)
            tank_on2 = 1'b1;
        else 
            tank_on2 = 1'b0;
//    end  
	 end
    always_comb
    begin:RGB_Display
		  if ((tank_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
        end
		  else if ((tank_on2 == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
        end 
        else if ((ball_on == 1'b1)) 
        begin 
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'hff;
        end
		  else if ((ball_on2 == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end 
        else 
        begin 
            Red = 8'h00; 
            Green = 8'h11;
            Blue = 8'h88;
        end      
    end 

	/* 
	 always_comb
	 begin: Ball_on_proc
			if(DrawX >= shape_x && DrawX < shape_x + shape_size_x &&
			   DrawY >= shape_y && DrawY < shape_y + shape_size_y)
	      begin
				shape_on = 1'b1; 
				shape_on2 = 1'b0;
			end
			else if (DrawX >= shape2_x && DrawX < shape2_x + shape2_size_x &&
			         DrawY >= shape2_y && DrawY < shape2_y + shape2_size_y)
						
			begin
			shape_on = 1'b0; 
			shape_on2 = 1'b1;
			end
			else
			begin 
				shape_on = 1'b0;
				shape2_on = 1'b0;
			end
	end
	
	always_comb
	begin:RGB_Display
		if((shape_on == 1'b1))
		begin
				Red = 8'h00;
				Green = 8'hff;
				Blue = 8'hff;
		end 
		else if((shape2_on == 1'b1))
		begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'h00;
		end 
		else 
		begin 
				Red = 8'h4f - DrawX[9:3];
				Green = 8'h00;
				Blue = 8'h44;
		end 
	end */
					
endmodule
