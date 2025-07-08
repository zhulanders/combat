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


module  color_mapper ( input logic       [9:0] Tank1X, Tank1Y, Tank2X, Tank2Y, DrawX, DrawY, Tank_Size, BulletX, BulletY, BulletX2, BulletY2, BulletSize,
							  input clk,
							  input logic blank,
                       output logic [3:0]  Red, Green, Blue,
							  output logic GameOver
							  );
    
    logic tank1_on;
	 logic tank2_on;
	 logic bullet_on;
	 logic bullet2_on;
	 logic neg_clk;
	 logic [3:0] tank1_q, tank1_red, tank1_green, tank1_blue, background_red, background_green, background_blue, background_q, tank2_q, tank2_red, tank2_green, tank2_blue;
	 logic [9:0] tank1_addr;
	 logic [9:0] tank2_addr;
	 logic [18:0] background_addr;
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int Dist1X, Dist1Y, Dist2X, Dist2Y, Size, DistBX, DistBY, DistBX2, DistBY2, BSize;
	 assign Dist1X = DrawX - Tank1X;
    assign Dist1Y = DrawY - Tank1Y;
	 assign Dist2X = DrawX - Tank2X;
    assign Dist2Y = DrawY - Tank2Y;
	 assign DistBX = DrawX - BulletX;
	 assign DistBY = DrawY - BulletY;
	 assign DistBX2 = DrawX - BulletX2;
	 assign DistBY2 = DrawY - BulletY2;
    assign Size = 16 ;
	assign BSize = 2;
	 assign tank1_addr = (DrawX - Tank1X + 16) + (DrawY - Tank1Y + 16)*32;
	 assign tank2_addr = (DrawX - Tank2X + 16) + (DrawY - Tank2Y + 16)*32; 
	 assign background_addr = ((DrawX * 640) / 640) + (((DrawY * 480) / 480) * 640);
	 assign neg_clk = ~clk;
    always_comb
    begin:Ball_on_proc
       if ( ( Dist1X*Dist1X + Dist1Y*Dist1Y) <= (Size * Size) ) 
            tank1_on = 1'b1;
       else 
            tank1_on = 1'b0;

		 if ( ( Dist2X*Dist2X + Dist2Y*Dist2Y) <= (Size * Size) ) 
            tank2_on = 1'b1;
       else 
            tank2_on = 1'b0;

		 if ( ( DistBX*DistBX + DistBY*DistBY) <= (BSize * BSize) )
				bullet_on = 1'b1;
		 else
				bullet_on = 1'b0;
		 if ( ( DistBX2*DistBX2 + DistBY2*DistBY2) <= (BSize * BSize) )
				bullet2_on = 1'b1;
		 else
				bullet2_on = 1'b0;
	end
//	 if (tank1_on && bullet2_on)
//			begin
//				GameOver = 1'b1;
//			end
//				
//	 else if (tank2_on == 1'b1 && bullet_on == 1'b1)
//			 begin
//			 GameOver = 1'b1;
//			 end
//	 else
//	 begin
//		GameOver = 1'b0;
//	 end
//    end
    
       
    //always_comb
    //begin:RGB_Display
    //   if ((ball_on == 1'b1)) 
    //    begin 
    //        Red = 8'hff;
    //        Green = 8'h55;
    //        Blue = 8'h00;
    //    end       
    //    else 
    //    begin 
    //        Red = 8'h00; 
    //        Green = 8'h00;
    //        Blue = 8'h7f - DrawX[9:3];
    //    end      
    //end 
	 
	 always_ff @ (posedge clk)
	 begin
		
		Red <= 4'h0;
		Green <= 4'h0;
		Blue <= 4'h0;
		if (blank) 
		begin
	
			
			if (tank1_on == 1'b1)
			 begin
					Red <= tank1_red;
					Green <= tank1_green;
					Blue <= tank1_blue;
					if (tank1_red == 4'h0 && tank1_blue == 4'h0 && tank1_green == 4'hF)
					begin
						Red <= background_red;
						Green <= background_green;
						Blue <= background_blue;
					end
			 end
			if (bullet_on == 1'b1)
			begin
				Red <= 4'h0;
				Green <= 4'h0;
				Blue <= 4'h0;
			end
			
			if (tank2_on == 1'b1)
			 begin
					Red <= tank2_red;
					Green <= tank2_green;
					Blue <= tank2_blue;
					if (tank2_red == 4'h0 && tank2_blue == 4'h0 && tank2_green == 4'hF)
					begin
						
						Red <= background_red;
						Green <= background_green;
						Blue <= background_blue;
					end
			 end
			if (bullet2_on == 1'b1)
			begin
				Red <= 4'h0;
				Green <= 4'h0;
				Blue <= 4'h0;
			end
			if (tank1_on == 1'b0 && tank2_on ==1'b0 && bullet_on == 1'b0 && bullet2_on == 1'b0)
			 begin
					Red <= background_red;
					Green <= background_green;
					Blue <= background_blue;
			end
	end
end
tile001_rom tile001_rom (
			.clock   (neg_clk),
			.address (tank1_addr),
			.q       (tank1_q));
tile001_palette tile001_palette (
	.index (tank1_q),
	.red   (tank1_red),
	.green (tank1_green),
	.blue  (tank1_blue)
);
tile007_rom tile007_rom (
			.clock   (neg_clk),
			.address (tank2_addr),
			.q       (tank2_q));
tile007_palette tile007_palette (
	.index (tank2_q),
	.red   (tank2_red),
	.green (tank2_green),
	.blue  (tank2_blue)
);
background_rom background_rom (
	.clock   (neg_clk),
	.address (background_addr),
	.q       (background_q)
);

background_palette background_palette (
	.index (background_q),
	.red   (background_red),
	.green (background_green),
	.blue  (background_blue)
);			
endmodule
