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


PROCESS gameplay() 
local
flash_time;
i , random;
tampon_r; 
BEGIN
	let_me_alone();
	
	fade_off();
	for (i=0;i<15;i++)
		frame;
	end
	fade_on();	

	delete_text(ALL_TEXT);
	clear_screen();
	
	// Draw Background
	fond_grey(); 
	ground(); 
	
	// Draw and Manage Player
	girl_player();
	
	// Create Lamp objects
	lamp(480);
	lamp(640);
	
	// Manage touch screen controls
	touch_screen_controls();
	
	// If not playing with a pad then draw touch screen controls
	if (b_control == 0)
		jump_button();
		fire_button();
	end
	
	// Draw Tampon HUD
	tampon_x();
	
	// Create an enemy and a box of tampon
	enemy_dude_1();
	box_tampon();
	
	/*
	Set all the variables to their
	default states.
	*/
	
	for (i=0;i<5;i++)
		enemy_state[i] = 0;
		enemy_x[i] = 0;
		enemy_y[i] = 0;
	end
	
	save.score = 0;
	tampon = 64;
	tampon_time = 0;
	fire_b = 0; 
	jump_b = 0;
	
	touch_state = 2;
	b1_state = 2;
	b2_state = 2;
	b1_time =  0;
	b2_time = 0;
	start_time = 0;
	
	dude_time = 0;
	dude_2_on = 0;  
	dude_3_on = 0; 
	dude_4_on = 0;
	
	// Detect buttons
	Controls();
	
	LOOP
		// Delete all texts on screen. Used to refresh the game
		delete_text(ALL_TEXT);
		// Shows your score and highscore
		write(font,4,4,0,"SCORE: "+save.score+"");
		write(font,4,18,0,"HIGHSCORE: "+save.highscore+"");
		
		/* 
		If actual score greater than your highscore
		then set highscore to your score.
		*/
		if (save.score > save.highscore)
			save.highscore = save.score;
		end
		
		/* 
		Shows how many tampons you have
		and it flickers ig you have less than 10 tampons
		*/
		if (tampon > 10)
			write(font,4,36,0,"   x "+tampon+"");
		else
			flash_time++;
			if (flash_time < 30) 
				if (tampon > -1)
				write(font,4,36,0,"   x "+tampon+"");
				else
				write(font,4,36,0,"   x 0 ");
				end
			else
				if (flash_time > 60) 
				flash_time = 0;
				end
			end
		end

		// If running out of tampons then it's gameover
		if (tampon < 1)
			gameover();
		end

		
		tampon_time++;
		
		/*
		After 30 seconds , put between 0 and 3 tampon boxes
		*/
		if (tampon_time >  60*30)
			random = rand(0,3);
			for (i=0;i<random;i++)
				box_tampon();
			end
			tampon_time = rand(-120,120);
		end
		
		/*
		Incrase variable dude_time if the enemies
		have not all appeared yet.
		*/
		if (dude_4_on == 0)
			dude_time++;
		end
		
		/*
		Second dude appears after 7 secs,
		third one after 15 secs and last one
		after 20 secs.
		*/
		if (dude_time > 60*7 and dude_2_on == 0)
			dude_2_on = 1;
		elseif (dude_time > 60*15 and dude_3_on == 0)
			dude_3_on = 1;
		elseif (dude_time > 60*20 and dude_4_on == 0)
			dude_4_on = 1;
		end
			
		/*
		If dude_x_on is equal 1 then
		create them.
		*/	
			
		if (dude_2_on == 1)
			enemy_dude_2();
			dude_2_on = 2;
		end
			
		if (dude_3_on == 1)
			enemy_dude_3();
			dude_3_on = 2;
		end
			
		if (dude_4_on == 1)
			enemy_dude_4();
			dude_4_on = 2;
		end


		if (start_time < 30)
			start_time++;
		end
		
	 frame;
	end
	
END


PROCESS gameover() 
local
flash_time, i;
wait_local=0;
BEGIN

	let_me_alone();
	
	fade_off();
	for (i=0;i<15;i++)
		frame;
	end
	fade_on();	
			
	delete_text(ALL_TEXT);
	clear_screen();

	Controls();
	
	// Draw Background Gameover
	gameover_screen();
	
	// Draw the buttons on screen
	again_button();
	share_button();
	
	/*
	Set all the variables to their
	default states.
	*/
	mmx = 0;
	mmy = 0;
	mmx2 = 0;
	mmy2 = 0;
	
	touch_state = 2;
	b1_state = 2;
	b2_state = 2;
	b1_time =  0;
	b2_time = 0;
	
	// Play Game over GFX
	play_wav(gameover_wav,0);
	
	// Save Structure save (see plantilla.prg) to a file named Savefile
	Save("Savefile",save);
	
	LOOP
		delete_text(ALL_TEXT);
		
		// Draws your Highscore on screen
		write(font,160,220,4,"HIGHSCORE: "+save.highscore+"");
	
		// For touch screens
		if (touch_state == 1)
			if ( (mmy2 > 60 and mmy2 < 130) and (mmx2 > 88 and mmx2 < 230) )
				touch_state = 2;
				gameplay();
			elseif ( (mmy2 > 132 and mmy2 < 190) and  (mmx2 > 88 and mmx2 < 230) )
				if (save.langage == 0)
				exec(_P_NOWAIT, "https://twitter.com/intent/tweet?text= I scored "+save.score+" pts in Tampon Run Remix ! #tamponrunremix", 0, 0);
				else
				exec(_P_NOWAIT, "https://twitter.com/intent/tweet?text= J'ai eu "+save.score+" pts dans Tampon Run Remix ! #tamponrunremix", 0, 0);
				end
				touch_state = 2;
			end
		end
			
		// For pads and keyboard	
		if (p[0].botones[2] || key(_up))
		
			let_me_alone();
			clear_screen();
			gameplay();
		elseif (p[0].botones[3] || key(_down))
		
			if (save.langage == 0)
				exec(_P_NOWAIT, "https://twitter.com/intent/tweet?text= I scored "+save.score+" pts in Tampon Run Remix ! #tamponrunremix", 0, 0);
			else
				exec(_P_NOWAIT, "https://twitter.com/intent/tweet?text= J'ai eu "+save.score+" pts dans Tampon Run Remix ! #tamponrunremix", 0, 0);
			end
			//exec(_P_NOWAIT, "x-www-browser https://twitter.com/intent/tweet?text= I scored "+save.score+" pts in Tampon Run Remix ! #tamponrunremix &", 0, 0);
		end
		
		
	 frame;
	end
END

PROCESS touch_screen_controls()
local 
i;
fire_time , jump_time;
BEGIN

	loop
	
		if (jump_b == 1)
			jump_time++;
			
			if (jump_time > 6)
				jump_time = 0;
				jump_b = 0;
			end
		end
		
		if (fire_b == 1)
			fire_time++;
			
			if (fire_time > 6)
				fire_time = 0;
				fire_b = 0;
			end
		end
	
		/*
		multi_info(0, "ACTIVE") is to know if a position (on a touch screen is active)
		multi_info (i, "X") returns the X corrdinates of a finger (i can be 0 up to 10 generally)
		*/
		
		for (i=0;i<4;i++)
			if (multi_info(i, "ACTIVE") > 0)
				if (multi_info (i, "X") < 105)
					jump_b = 1;
				elseif (multi_info (i, "X") > 235)
					fire_b = 1;
				end
			end
		end
	
		frame;
	end
end


PROCESS girl_player() 
local
girl_time = 0, jump = 0 , jump_high = 0;
attack = 0;
i = 0;
BEGIN
	file = game_graph;
	graph = 15;
	x = -48;
	y = 172;
	z = 0;
	
	LOOP
	
		if (x < 60)
			x = x + 2;
		end
		
		player_x = x;
		player_y = y;
		
		// For collisions between the girl and the 4 enemies
		for (i=0;i<4;i++)
			if ((x + 24 > enemy_x[i] + 4) and (x < enemy_x[i] + 16) and (y + 32 > enemy_y[i] + 8) and (y < enemy_y[i] + 32) and enemy_state[i] == 0)
				tampon -= 2;
				enemy_state[i] = 1;
			end
		end
		
		/*
		Manage jumping of the player character.
		Jump == 0 means the player is on the ground
		Jump == 1 means it's jumping
		Jump == 2 means it's falling to the ground
		
		jump_high is here to know how many pixels
		it jumped.
		*/
		switch ( jump )
			case 0:
				if (jump_b == 1 || b1_state == 1 and start_time > 25)
					play_wav(jump_wav,0);
					jump = 1;
					b1_state = 2;
				end
			end
			case 1:
				y = y - 3;
				jump_high = jump_high + 3;
				if (jump_high > 60)
				jump = 2;
				end
			end
			case 2:
				y = y + 3;
				jump_high = jump_high - 3;
				if (jump_high < 1)
				jump_high = 0;
				jump = 0;
				end
			end
		end
		
		
		/*
		Manage throwing tampo,s
		attack == 0 means the player is not attacking
		attack == 1 means it's attacking after 5/60 frames per second.
		
		tampon_projectile(x+10,y) is the projectile created.
		x and y here are the coordinates of the player.
		*/
		switch ( attack )
			case 0:
				if (girl_time > 4)
					girl_time = 0;
					graph=graph+1;
					if (graph > 18)
						graph=15;
					end
				end
				
				if (fire_b == 1 || b2_state == 1 and tampon > -1 and start_time > 25)
					girl_time = 0;
					graph = 25;
					b2_state = 2;
					attack = 1;
					//play_wav(throw_wav,0);
				end
				
			end
			case 1:
				
				if (girl_time > 5)
					girl_time = 0;
					graph=graph+1;
					
					if (graph == 26)
						tampon_projectile(x+10,y);
					end
					
					if (graph > 26)
						attack = 0;
						graph = 15;
						tampon -= 1;
					end
				end
				
			end
		end
	
	
		girl_time++;
		

		
		
		
	 frame;
	end
END


PROCESS box_tampon() 
BEGIN

	file = game_graph;
	graph = 27;
	x = rand (360,440);
	y = rand (120,150);
	size = 150;
	z = 0;
	
	LOOP
		angle = angle + 1000;
		x = x - 3;
		
		/*
		If Tampon box colliding player then play its sound effect , give between 7 and 28 tampons
		and then it kills itself.
		*/
		if ((x + 24 > player_x) and (x < player_x + 32) and (y + 24 > player_y) and (y < player_y + 32))
			stop_wav(0);
			stop_wav(1);
			stop_wav(2);
			play_wav(got_wav,0);
			tampon += rand(7,28);
			signal(id, s_kill);
		end
		
		if (x < -48)
			signal(id, s_kill);
		end
		
	 frame;
	end
	
END

process enemy_dude_1() 
local
anim_time = 0;
BEGIN
	file = game_graph;
	graph = 11;
	x = 700;
	y = 172;
	z =	-1;
	enemy_state[0] = 0;
	
	LOOP
		anim_time++;
		enemy_x[0] = x;
		enemy_y[0] = y;
		
		x = x - 4;
		
		if (x < -16)
			enemy_state[0] = 0;
			x = rand(360,440);
		end
		
		if (anim_time > 5)
			anim_time = 0;
			graph=graph+1;
			if (graph > 14)
				graph=11;
			end
		end
		
	 frame;
	end
END


process enemy_dude_2() 
local
anim_time = 0;
BEGIN
	file = game_graph;
	graph = 11;
	x = rand(500,800);
	y = 172;
	z =	-1;
	enemy_state[1] = 0;
	LOOP
		anim_time++;
		enemy_x[1] = x;
		enemy_y[1] = y;
		
		x = x - 3;
		
		if (x < -16)
			enemy_state[1] = 0;
			x = rand(500,800);
		end
		
		if (anim_time > 5)
			anim_time = 0;
			graph=graph+1;
			if (graph > 14)
				graph=11;
			end
		end
		
	 frame;
	end
END


process enemy_dude_3() 
local
anim_time = 0;
BEGIN
	file = game_graph;
	graph = 11;
	x = rand(320,400);
	y = 172;
	z =	-1;
	enemy_state[2] = 0;
	LOOP
		anim_time++;
		enemy_x[2] = x;
		enemy_y[2] = y;
		
		x = x - 3;
		
		if (x < -16)
			enemy_state[2] = 0;
			x = rand(320,400);
		end
		
		if (anim_time > 5)
			anim_time = 0;
			graph=graph+1;
			if (graph > 14)
				graph=11;
			end
		end
		
	 frame;
	end
END



process enemy_dude_4() 
local
anim_time = 0;
BEGIN
	file = game_graph;
	graph = 11;
	x = rand(500,900);
	y = 172;
	z =	-1;
	enemy_state[3] = 0;
	LOOP
		anim_time++;
		enemy_x[3] = x;
		enemy_y[3] = y;
		
		x = x - 3;
		
		if (x < -16)
			enemy_state[3] = 0;
			x = rand(500,900);
		end
		
		if (anim_time > 5)
			anim_time = 0;
			graph=graph+1;
			if (graph > 14)
				graph=11;
			end
		end
		
	 frame;
	end
END

PROCESS tampon_projectile(x,y) 
local
anim_time = 0;
BEGIN
	file = game_graph;
	graph = 6;
	z	=	-1;
	
	LOOP
		anim_time++;
		x = x + 4;
		
		// If projectile out of screen then kill it
		if (x > 340)
			signal(id, s_kill);
		end
		
		
		/*
		If colliding an enemy then play its sound effect , create a process boy_dead
		at the corrdinates of the enemy killed , kill the active anemy and create another one.
		Add one to score then kill the projectile in question.
		*/
		
		
        if ((x + 32 > enemy_x[0]) and (x < enemy_x[0] + 32) and (y + 8 > enemy_y[0]) and (y < enemy_y[0] + 32))
			play_wav(hit_wav,0);
			enemy_state[0] = 0;
			boy_dead(enemy_x[0],enemy_y[0]);
			signal(get_id(type enemy_dude_1), s_kill);
			enemy_dude_1();
			save.score = save.score + 1;
			signal(id, s_kill);
        end
		
        if ((x + 32 > enemy_x[1]) and (x < enemy_x[1] + 32) and (y + 8 > enemy_y[1]) and (y < enemy_y[1] + 32))
			play_wav(hit_wav,0);
			enemy_state[1] = 0;	
			boy_dead(enemy_x[1],enemy_y[1]);
			signal(get_id(type enemy_dude_2), s_kill);
			enemy_dude_2();
			save.score = save.score + 1;
			signal(id, s_kill);
        end
		
        if ((x + 32 > enemy_x[2]) and (x < enemy_x[2] + 32) and (y + 8 > enemy_y[2]) and (y < enemy_y[2] + 32))
			play_wav(hit_wav,0);
			enemy_state[2] = 0;
			boy_dead(enemy_x[2],enemy_y[2]);
			signal(get_id(type enemy_dude_3), s_kill);
			enemy_dude_3();
			save.score = save.score + 1;
			signal(id, s_kill);
        end
		
        if ((x + 32 > enemy_x[3]) and (x < enemy_x[3] + 32) and (y + 8 > enemy_y[3]) and (y < enemy_y[3] + 32))
			play_wav(hit_wav,0);
			enemy_state[3] = 0;
			boy_dead(enemy_x[3],enemy_y[3]);
			signal(get_id(type enemy_dude_4), s_kill);
			enemy_dude_4();
			save.score = save.score + 1;
			signal(id, s_kill);
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

PROCESS boy_dead(x,y) 
BEGIN
	file = game_graph;
	graph = 12;
	size = 100;
	z = 4;
	
	LOOP
		x=x+1;
		y=y-2;
		angle = angle + 4000;
		size = size - 1;
		if (size < 1)
			signal(id, s_kill);
		end
		
	 frame;
	end
	
END

PROCESS fond_grey() 
BEGIN
	file = game_graph;
	graph = 4;
	x = 160;
	y = 93;
	z=5;
	LOOP

	 frame;
	end
	
END

PROCESS gameover_screen() 
BEGIN
	file = title_graph;
	graph = 9;
	x = 160;
	y = 120;
	z=5;
	LOOP

	 frame;
	end
	
END

PROCESS tampon_x() 
BEGIN
	file = game_graph;
	graph = 35;
	x = 16;
	y = 40;
	z=0;
	LOOP

	 frame;
	end
	
END


PROCESS again_button() 
BEGIN
	file = game_graph;
	graph = 29;
	x = 160;
	y = 100;
	z=1;
	LOOP

	 frame;
	end
	
END

PROCESS share_button() 
BEGIN
	file = game_graph;
	graph = 30;
	x = 160;
	y = 160;
	z=1;
	LOOP

	 frame;
	end
	
END

PROCESS ground() 
BEGIN

	file = game_graph;
	graph = 23;
	x = 320;
	y = 213;
	z = 4;
	
	LOOP
		lamp_x = x;
		x = x - 2;
		
		if (x < 1)
			x = 320;
		end
		
	 frame;
	end
	
END


PROCESS lamp(x) 
local
x_default = 0;
BEGIN

	file = game_graph;
	graph = 24;
	x_default = lamp_x+240;
	y = 132;
	z = 3;
	
	LOOP
		x = x - 2;
		
		if (x < -48)
			x = x_default;
			if ( ((lamp_x-x)>(-80)) or ((lamp_x+x)<80))
				x = x - (lamp_x-x);
			end
		end
		
	 frame;
	end
	
END












PROCESS fire_button() 
BEGIN
	file = game_graph;
	graph = 31;
	x = 293;
	y = 214;
	z=-3;
	LOOP
		if (fire_b == 1)
			graph = 32;
		else	
			graph = 31;
		end
	

	 frame;
	end
	
END


PROCESS jump_button() 
BEGIN
	file = game_graph;
	graph = 33;
	x = 27;
	y = 214;
	z=-3;
	LOOP
	
		if (jump_b == 1)
			graph = 34;
		else	
			graph = 33;
		end

	 frame;
	end
	
END




