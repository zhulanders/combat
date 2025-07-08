module bullet(input logic Reset, GReset, frame_clk, tank,
				input logic [7:0] keycode,
				input logic [9:0] TankX, TankY, TankXMot, TankYMot,
				output logic [9:0] BulletX, BulletY, BulletSize);
				
	logic [9:0] Bullet_X_Pos, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_Motion, Bullet_Size;
	 
    parameter [9:0] Bullet_X_Center=0;  // Center position on the X axis
    parameter [9:0] Bullet_Y_Center=0;  // Center position on the Y axis
    parameter [9:0] Bullet_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bullet_X_Step=1;      // Step size on the X axis
    parameter [9:0] Bullet_Y_Step=1;      // Step size on the Y axis

    assign Bullet_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk or posedge GReset )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Bullet_Y_Motion <= 10'd0; //Ball_Y_Step;
				Bullet_X_Motion <= 10'd0; //Ball_X_Step;
				Bullet_Y_Pos <= Bullet_Y_Center;
				Bullet_X_Pos <= Bullet_X_Center;
        end
		  else if(GReset)
		  begin
				Bullet_Y_Motion <= 10'd0; //Ball_Y_Step;
				Bullet_X_Motion <= 10'd0; //Ball_X_Step;
				Bullet_Y_Pos <= Bullet_Y_Center;
				Bullet_X_Pos <= Bullet_X_Center;
		  end
           
        else
		  
        begin
				if (keycode == 8'h09 || keycode == 8'h33)
				begin
		  case (keycode)
					8'h09 : begin
								if (tank == 1'b0)
								begin
									if(~(TankXMot == 0) || ~(TankYMot == 0))
									begin
										Bullet_X_Pos <= TankX;
										Bullet_Y_Pos <= TankY;
										Bullet_X_Motion <= TankXMot;
										Bullet_Y_Motion <= TankYMot;
									end
								end
								 else
								begin
								
								Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);  // Update Bullet position
								Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
								end
							  end
					        
					8'h33 : begin
							  if (tank == 1'b1)
							  begin
								if(~(TankXMot == 0) || ~(TankYMot == 0))
									begin
										Bullet_X_Pos <= TankX;
										Bullet_Y_Pos <= TankY;
										Bullet_X_Motion <= TankXMot;
										Bullet_Y_Motion <= TankYMot;
									end
							  end
							   else
								begin
								
								Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);  // Update Bullet position
								Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
								end
							  end
					default: ;
			   endcase 
				end
				 

					  
				 
				 else
				 begin
				 
				 Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);  // Update Bullet position
				 Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
				 end
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign BulletX = Bullet_X_Pos;
   
    assign BulletY = Bullet_Y_Pos;
   
    assign BulletSize = Bullet_Size;
    

endmodule

