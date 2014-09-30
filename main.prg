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

/*
Rename it to 'plantilla.prg' if you are using it with PixPlantilla.
Without modifications , it needs the following files from PixPlantilla (BennuGD).
controles.pr-, savepath.pr-, resolucioname.pr-.
*/


program tamponrunr;

import "mod_dir";
import "mod_draw";
import "mod_grproc";
import "mod_map";
import "mod_mouse";
import "mod_multi";
import "mod_proc";
import "mod_rand";
import "mod_say";
import "mod_time";
import "mod_screen";
import "mod_scroll";
import "mod_sound";
import "mod_string";
import "mod_text"; 
import "mod_timers";
import "mod_video";
import "mod_wm";
import "mod_file";
import "mod_joy";
import "mod_math";
import "mod_sys";
import "mod_regex";
import "mod_key";

global
	posibles_jugadores;
	struct p[100];
		botones[7];
		control;
	end
	joysticks[10];
	
	ancho;
	alto;
	accion;
	foo;
	string lang_string;
	//utilizadas por lenguaje y savepath
	string savegamedir;
	string developerpath="/.gameblabla/tampon";
	struct ops;
		test=0;
	end
	global_resolution=1;
	arcade_mode;
	
	width , height , panoramico , bpp;
	alto_pantalla , ancho_pantalla;

	LEFT_PRESSED , RIGHT_PRESSED , UP_PRESSED , DOWN_PRESSED , B1_PRESSED , B2_PRESSED;
	touch_state, touch_time, mmx, mmy;

	title_y = -64;
	showing_mode = 0;
	wait_pad;

	font , font_titlescreen;
	fpg1 , fpg2;
	player_x , player_y;
	tampon=63;

	sound1 , sound2 , sound3;
	xm,ym;
	mmx2,mmy2;
	
	scenario , song_game;
	girl_scenario_tampon;
	lamp_x;
	
    struct save
        score=0;
        highscore=0;
        langage = 0; // 0 = English , 1 = French
		langage_set = 1;
		screedn = 0;
    end
	
	dude_2_on , dude_3_on , dude_4_on , dude_time;
	
	enemy_x[6] = -80;
	enemy_y[6] = -80;
	enemy_state[6];
	tampon_time;
	
	fire_b = 0, jump_b = 0;
	b1_state,b1_time;
	b2_state,b2_time;
	b_control=0;
	
	timer_store[100];
	start_time = 0;
	got_wav,hit_wav,jump_wav,gameover_wav,throw_wav;
	fpg1_fr, fpg2_fr;
	title_graph,game_graph;
	
begin

	set_fps(60,0);
	
	width=320;
	height=240;
	panoramico=1;
	bpp=16; // Set the color depth , 16 bits is a bit faster than 32 bits

	configurar_controles(); // Configure controls , need to be run only one time (Needed for controllers and OUYA)
	
	resolucioname(width,height,panoramico);
	set_mode(width,height,bpp);
	
	Load("Savefile",save);
	
	fpg1 = load_fpg ("titlescreen.fpg") ;
	fpg2 = load_fpg ("game.fpg") ;
	
	fpg1_fr = load_fpg ("titlescreen_fr.fpg") ;
	fpg2_fr = load_fpg ("game_fr.fpg") ;
	
	if (save.langage == 0)
		title_graph = fpg1;
		game_graph = fpg2;
	else
		title_graph = fpg1_fr;
		game_graph = fpg2_fr;
	end
	
	font = load_fnt("font.fpg");
	font_titlescreen = load_fnt("font_text.fpg");
	
	song_game = load_song("beethoven.ogg");	
	
    got_wav = load_wav("got.wav");
    hit_wav = load_wav("hit.wav");
	jump_wav = load_wav("jump.wav");
	//throw_wav = load_wav("throw.wav");
    gameover_wav = load_wav("gameover.wav");
	
	Load("Savefile",save);
	
	loop
		titlescreen();
	frame;
	end
END



include "titlescreen.prg"
include "controls.prg"
include "story.prg"
include "game.prg"

include "controles.pr-";
include "savepath.pr-";
include "resolucioname.pr-";
