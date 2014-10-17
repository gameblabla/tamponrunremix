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

PROCESS titlescreen() // The Titlescreen
local
flash_time;

BEGIN
	flash_time = 0;
	
	clear_screen();
	let_me_alone();

	title_graph(); // Put the background
	flag();
	
	play_song(song_game_2,-1);
	
	Controls();
	
	LOOP
	delete_text(ALL_TEXT);
	
		flash_time++;
		if (flash_time < 30) 
			if (save.langage == 0)
			write(font_titlescreen,160,174,4,"TOUCH TO START");
			else
			write(font_titlescreen,160,174,4,"APPUYEZ POUR COMMENCER");
			end
		else
			if (flash_time > 60) 
			flash_time = 0;
			end
		end
	
		if (save.langage == 0)
			write(0,160,212,4,"Copyright 2014 Gameblabla");
			write(0,160,223,4,"Sound: Jesus Latra, SLiVeR (with changes)");
			write(0,160,233,4,"License : tinyurl.com/ot594pq");
		else
			write(0,160,212,4,"Copyright 2014 Gameblabla");
			write(0,160,223,4,"Sound: Jesus Latra, SLiVeR (avec changement)");
			write(0,160,233,4,"License : tinyurl.com/ot594pq");
		end
	

		
		if (wait_pad < 17)
			wait_pad++;
		end
		
		if (wait_pad > 15)
		
			if ((touch_state == 1) and ((mmx > 230 and mmx < 310 and mmy > 30 and mmy < 96) || (mmx2 > 230 and mmx2 < 310 and mmy2 > 40 and mmy2 < 96) ) )
				touch_state = 2;
				
				if (save.langage == 0)
					save.langage = 1;
				else
					save.langage = 0;
				end
				
				if (save.langage == 0)
					title_graph = fpg1;
					game_graph = fpg2;
				else
					title_graph = fpg1_fr;
					game_graph = fpg2_fr;
				end
			elseif ((touch_state == 1 || b1_state == 1) )
				wait_pad = 0;
				gameplay();
			end
		
		end
		
		
		

	 frame;
	end
	
END




PROCESS flag() // The Titlescreen
BEGIN
	file = game_graph;
	graph = 36;
	x = 160+108;
	y = 120-38;
	z = -1;
	
	LOOP
	
		if (save.langage == 0)
			graph = 36;
		elseif (save.langage == 1)
			graph = 37;
		end

	 frame;
	end
	
END


PROCESS title_graph() // The Titlescreen
BEGIN
	file = title_graph;
	graph = 1;
	x = 160;
	y = 120;
	
	LOOP

	 frame;
	end
	
END

