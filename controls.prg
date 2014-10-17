/*
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
*/


process Controls()
local
i , graph_screen;
begin
		//hand();
		controlador(0);
	loop

		if(os_id==1003 and !focus_status) 
			salir_android();
		end
		
		if(os_id==1003)
			mmx = multi_info (1, "X");
			mmy = multi_info (1, "X");
			mmx2 = multi_info (0, "X");
			mmy2 = multi_info (0, "Y");
		else
			mmx = mouse.x;
			mmy = mouse.y;
		end

		
		if (key(_esc)) // PC // Quittez le jeu
			EXIT(0,0);
		end
		

	   if (key(_F12) ) 
			save.screedn += 1;
			for(i=0;i<2;i++)
				frame;
			end	
			graph_screen=screen_get(); // grabs the screen and sets it as the program graphic
			png_save(0,graph_screen,"scr_"+save.screedn+".png"); // saves the graphic as a png with a
			map_unload(0,graph_screen);  //frees the graphic
			for(i=0;i<10;i++)
				frame;
			end	
       end

		
			/* BUTTON 1 CONTROL FOR PLAYER 1*/
			
			
		if (b1_state == 0) // Si il n'y a aucune pression
		
			if (p[0].botones[4] || key(_space))
				b1_state = 1;
				b_control = 1;
			end
			
		elseif (b1_state == 1) // Si l'utilisateur vient d'apputer
		
			if (p[0].botones[4] || key(_space))
				b1_time++;
			else
				b1_time = 0;
				b1_state = 0;
			end
			
			if (b1_time > 1)
				b1_time = 0;
				b1_state = 2;
			end
		elseif (b1_state == 2) // Si il presse
		
			if (p[0].botones[4] || key(_space))
			else
				b1_time = 0;
				b1_state = 3;
			end
		elseif (b1_state == 3) // Si il vient de lacher
				b1_time++;
				if (b1_time > 1)
					b1_time = 0;
					b1_state = 0;
				end
		end
		
		if (b2_state == 0) // Si il n'y a aucune pression
		
			if (p[0].botones[5] || key(_control))
				b2_state = 1;
				b_control = 1;
			end
			
		elseif (b2_state == 1) // Si l'utilisateur vient d'apputer
		
			if (p[0].botones[5] || key(_control))
				b2_time++;
			else
				b2_time = 0;
				b2_state = 0;
			end
			
			if (b2_time > 1)
				b2_time = 0;
				b2_state = 2;
			end
		elseif (b2_state == 2) // Si il presse
		
			if (p[0].botones[5] || key(_control))
			else
				b2_time = 0;
				b2_state = 3;
			end
		elseif (b2_state == 3) // Si il vient de lacher
				b2_time++;
				if (b2_time > 1)
					b2_time = 0;
					b2_state = 0;
				end
		end
	   
			/* TOUCHSCREEN CONTROL FOR PLAYER 1*/
			
			
		if (touch_state == 0) // Si il n'y a aucune pression
			B1_PRESSED = 0;
		
			if(os_id==1003)
				if ((multi_info(0, "ACTIVE") > 0))
					B1_PRESSED = 1;
					touch_state = 1;
					xm = mmx;
					ym = mmy;
				elseif ((multi_info(1, "ACTIVE") > 0))
					B1_PRESSED = 1;
					touch_state = 1;
					xm = mmx2;
					ym = mmy2;
				elseif ((multi_info(2, "ACTIVE") > 0))
					B1_PRESSED = 1;
					touch_state = 1;
					xm = mmx2;
					ym = mmy2;
				end
			else
				if (mouse.left)
					B1_PRESSED = 1;
					touch_state = 1;
					xm = mmx;
					ym = mmy;
				end
			end
			
		elseif (touch_state == 1) // Si l'utilisateur vient d'apputer
		
			if(os_id==1003)
				if ((multi_info(0, "ACTIVE") > 0))
					touch_time++;
					xm = mmx;
					ym = mmy;
				elseif ((multi_info(1, "ACTIVE") > 0))
					touch_time++;	
					xm = mmx2;
					ym = mmy2;
				elseif ((multi_info(2, "ACTIVE") > 0))
					touch_time++;	
					xm = mmx2;
					ym = mmy2;
				else
					touch_time = 0;
					touch_state = 0;
				end
			else
				if (mouse.left)
					touch_time++;
					xm = mmx;
					ym = mmy;
				else
					touch_time = 0;
					touch_state = 0;
				end
			end
			
			if (touch_time > 3)
				touch_time = 0;
				touch_state = 2;
			end
		elseif (touch_state == 2) // Si il presse
		
			if(os_id==1003)
				if ((multi_info(0, "ACTIVE") > 0))
					xm = mmx;
					ym = mmy;
				elseif ((multi_info(1, "ACTIVE") > 0))
					xm = mmx2;
					ym = mmy2;	
				elseif ((multi_info(2, "ACTIVE") > 0))
					xm = mmx2;
					ym = mmy2;
				else
					touch_time = 0;
					touch_state = 3;
					B1_PRESSED = 0;
				end
			else
				if (mouse.left)
					touch_time++;
					xm = mmx;
					ym = mmy;
				else
					touch_time = 0;
					touch_state = 0;
				end
			end
			
		elseif (touch_state == 3) // Si il vient de lacher
				touch_time++;
				if (touch_time > 5)
					touch_time = 0;
					touch_state = 0;
				end
		end
		
		
		

		
	  frame;
	end
END



function salir_android();
begin
	pause_game();
	while(!focus_status) frame; end
	resume_game();
end


function pause_game();
local
i;
begin
	signal(ALL_PROCESS,s_freeze);
	if(exists(father)) signal(father,s_wakeup); end
	from i=0 to 9;
		timer_store[i]=timer[i];
	end
	pause_song();
end


function resume_game();
local
i;
begin
	signal(ALL_PROCESS,s_wakeup);
	from i=0 to 9;
		timer[i]=timer_store[i];
	end
	resume_song();
end


process shell(string caca);
begin
	let_me_alone();
		if(is_playing_song())
		stop_song();
		end;
	exec(_P_WAIT, caca, 0, 0);
	exit();
end
