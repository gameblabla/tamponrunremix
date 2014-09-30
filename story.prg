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


PROCESS story() 
local
flash_time;
BEGIN
	flash_time = 0;
	scenario = 2;
	
	b1_state = 2;
	touch_state = 2;
	
	clear_screen();
	let_me_alone();

	scenar_graph(); // Put the background
	
	Controls();
	
	barrier();
	vague();
	girl();
	
	play_song(song_game,-1);
	
	
	LOOP
		delete_text(ALL_TEXT);
	
		if (touch_state == 1 || b1_state == 1)
			touch_state = 2;
			b1_state = 2;
			scenario = scenario + 1;
			scenario_kill();	
			
		end
		
		
		

	 frame;
	end
	
END


PROCESS scenar_graph() // Scenes
BEGIN
	file = title_graph;
	graph = scenario;
	x = 160;
	y = 120;
	z = 5;
	
	LOOP
		graph = scenario;
		
	 frame;
	end
	
END



PROCESS scenario_kill()
BEGIN
	switch ( scenario )
		case 3:
			signal(get_id(type barrier), s_kill);
			signal(get_id(type vague), s_kill);
			signal(get_id(type girl), s_kill);
			tampon();
			exclamation_1();
			exclamation_2();
		end
		case 4:
			signal(get_id(type tampon), s_kill);
			signal(get_id(type exclamation_1), s_kill);
			signal(get_id(type exclamation_2), s_kill);
			tampon_2();
			girl_2();
		end
		case 5:
			signal(get_id(type tampon_2), s_kill);
			signal(get_id(type girl_2), s_kill);
			text_1();
		end
		case 6:
			signal(get_id(type text_1), s_kill);
			tampon_big();
			girl_ride();
		end
		case 7:
			signal(get_id(type tampon_big), s_kill);
			signal(get_id(type girl_ride), s_kill);
		end
		case 8:
			girl_stand();
		end
		case 9:
			gameplay();
		end
	end
end



PROCESS tampon_big() 
local
anim_time;
BEGIN
	file = game_graph;
	graph = 6;
	x = -112;
	y = 160;
	z = 0;
	size = 1200;
	
	LOOP
		anim_time++;
		x = x + 2;
		
		if (anim_time > 8)
			anim_time = 0;
			graph=graph+1;
			if (graph > 9)
				graph=6;
			end
		end
		
	 frame;
	end
END


PROCESS girl_ride() 
BEGIN
	file = game_graph;
	graph = 22;
	x = 0;
	y = 105;
	z = -2;
	size = 200;
	
	LOOP
		x = x + 2;
	 frame;
	end
END


PROCESS tampon_2() 
local
anim_time;
BEGIN
	file = game_graph;
	graph = 6;
	x = 160;
	y = 0;
	z = 0;
	
	LOOP
		anim_time++;
		
		if (y < 145)
			y = y+ 2;
		else
			girl_scenario_tampon = 1;
		end
		
		if (anim_time > 8)
			anim_time = 0;
			graph=graph+1;
			if (graph > 9)
				graph=6;
			end
		end
		
	 frame;
	end
END


PROCESS girl_2() 
local
girl_time;
BEGIN
	file = game_graph;
	graph = 19;
	x = 160;
	y = 140;
	z = 2;
	
	LOOP
		
		if (girl_scenario_tampon == 1)
			graph = 20;
		end
		
	 frame;
	end
END



PROCESS girl_stand() 
local
girl_time;
BEGIN
	file = game_graph;
	graph = 15;
	x = 150;
	y = 188;
	z = 0;
	
	LOOP
		girl_time++;
		
		if (girl_time > 4)
			girl_time = 0;
			graph=graph+1;
			if (graph > 18)
				graph=15;
			end
		end
		
	 frame;
	end
END


PROCESS girl() 
local
girl_time;
BEGIN
	file = game_graph;
	graph = 15;
	x = -96;
	y = 190;
	z = 0;
	
	LOOP
		girl_time++;
		x = x + 3;
		
		if (girl_time > 2)
			girl_time = 0;
			graph=graph+1;
			if (graph > 18)
				graph=15;
			end
		end
		
	 frame;
	end
END


PROCESS tampon() 
local
anim_time;
BEGIN
	file = game_graph;
	graph = 6;
	x = 160;
	y = 160;
	z = 0;
	
	LOOP
		anim_time++;
		
		if (anim_time > 8)
			anim_time = 0;
			graph=graph+1;
			if (graph > 9)
				graph=6;
			end
		end
		
	 frame;
	end
END


PROCESS text_1() 
local
anim_time;
BEGIN
	file = game_graph;
	graph = 21;
	x = 110;
	y = 128;
	z = 0;
	
	LOOP
		anim_time++;
		
		if (anim_time < 16)
			graph = 0;
		elseif (anim_time < 32)
			graph = 21;
		end
		
		if (anim_time > 48)
			anim_time = 0;
		end
		
	 frame;
	end
END



PROCESS exclamation_1() 
local
anim_time;
BEGIN
	file = game_graph;
	graph = 3;
	x = 250;
	y = 120;
	z = 0;
	
	LOOP
		anim_time++;
		
		if (anim_time < 16)
			graph = 0;
		elseif (anim_time < 32)
			graph = 3;
		end
		
		if (anim_time > 48)
			anim_time = 0;
		end
		
	 frame;
	end
END



PROCESS exclamation_2() 
local
anim_time;
BEGIN
	file = game_graph;
	graph = 2;
	x = 90;
	y = 100;
	z = 0;
	
	LOOP
		anim_time++;
		
		if (anim_time < 24)
			graph = 0;
		elseif (anim_time < 48)
			graph = 2;
		end
		
		if (anim_time > 72)
			anim_time = 0;
		end
		
	 frame;
	end
END

PROCESS vague()
BEGIN
	file = game_graph;
	graph = 10;
	x = -264;
	y = 158;
	z = 1;
	
	LOOP
		x = x + 3;
	 frame;
	end
END


PROCESS barrier() 
BEGIN
	file = game_graph;
	graph = 1;
	x = 160;
	y = 182;
	z = -1;
	
	LOOP

	 frame;
	end
END
