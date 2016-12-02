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


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, BallS, //TankX, TankY, TankS? 
                       output logic [7:0]  Red, Green, Blue );
    
    //logic ball_on;
	 //logic tank_on;
	 logic shape_on;
	 logic[10:0] shape_x = 300;
	 logic[10:0] shape_y = 300;
	 logic[10:0] shape_size_x = 10;
	 logic[10:0] shape_size_y = 10;
	 
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
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
	 assign DistXt = DrawX - TankX;
	 assign DistYt = DrawY - TankY;
    assign Size = BallS;
	/********************************************************************************************************  
    always_comb
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 

	 always_comb
    begin:Tank_on_proc
        if ( ( DistXt*DistYt) <= (Size * Size) ) 
            tank_on = 1'b1;
        else 
            tank_on = 1'b0;
     end  
	 
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
		  
        else 
        begin 
            Red = 8'h3f; 
            Green = 8'h00;
            Blue = 8'h3f - DrawX[9:3];
        end      
    end 
    ******************************************************************************************************************************************/
	 
	 always_comb
	 begin: Ball _on_proc
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
	end
					
endmodule
