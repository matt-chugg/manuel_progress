
// record to hold a location and monster
record monster_item {
	string mp_monster_id;
	string mp_monster_name;
	string mp_location_name;
	string mp_zone_name;
	int mp_factoids;
	float mp_frequency;
	boolean mp_semirare;
	boolean mp_boss;
	boolean mp_special;
	string mp_information;
};

// record to hold special info
record special_monster_item {
	string mp_type;
	string mp_info;
};

// record to hold progress
record progress {
	int casually;
	int thoroughly;
	int exhaustively;
};

// global progress, updated whenever the page is hit
progress mp_progress;




void update_progress(buffer page_data) {
	// filter\=([1-3])?\'\>([0-9]*)?\screatures
	//matcher progress_matcher = create_matcher("filter\=([1-3])?\'\>([0-9]*)?\screatures",page_data);
	matcher progress_matcher = create_matcher("filter\=([1-3])?\'\>([0-9]*)? creatures",page_data);
	
	while (find(progress_matcher)){
		switch {
			case group(progress_matcher,1) == "1":
				mp_progress.casually = group(progress_matcher,2).to_int();
				break;
		
			case group(progress_matcher,1) == "2":
				mp_progress.thoroughly = group(progress_matcher,2).to_int();
				break;
				
			case group(progress_matcher,1) == "3":
				mp_progress.exhaustively = group(progress_matcher,2).to_int();
				break;
		
		}

	
	}
}

monster_item[int] add_extra_monsters(monster_item[int] monster_items) {
	boolean [string][string][string][monster] extramonsters; int index = count(monster_items);

	// brickos pretty much unconditional
	extramonsters["BRICKO Monsters"]["BRICKO"][""] = $monsters[BRICKO Airship, BRICKO Bat, BRICKO Cathedral, BRICKO Elephant, BRICKO Gargantuchicken, BRICKO Octopus, BRICKO Ooze, BRICKO Oyster, BRICKO Python, BRICKO Turtle, BRICKO Vacuum Cleaner];
	
	
	// transmission from planet Xi
	extramonsters["KoL Con"]["transmission from planet Xi"][""]  = $monsters[holographic army, They, Xiblaxian political prisoner];
	
	
	
	// holidays wandering monsters
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && holiday() != "Feast of Boris")) {
		extramonsters["Wanderering Monsters"]["Feast of Boris"]["Wandering: every 25-35 turns"] = $monsters[Candied Yam Golem, Malevolent Tofurkey, Possessed Can of Cranberry Sauce, Stuffing Golem];
	}
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && holiday() != "El Dia De Los Muertos Borrachos")) {
		extramonsters["Wanderering Monsters"]["El Dia de Los Muertos Borrachos"]["Wandering: every 25-35 turns"] = $monsters[Novio Cad&aacute;ver, Padre Cad&aacute;ver, Novia Cad&aacute;ver, Persona Inocente Cad&aacute;ver];
	}
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && holiday() != "Talk Like a Pirate Day")) {
		extramonsters["Wanderering Monsters"]["Talk like a pirate day"]["Wandering: every 25-35 turns."] = $monsters[Ambulatory Pirate, Migratory Pirate, Peripatetic Pirate];
	}
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Bees Hate You")) {
		extramonsters["Wanderering Monsters"]["path: Bees Hate You"]["Wandering: every 15-20 turns."] = $monsters[beebee gunners,moneybee,mumblebee,beebee queue,bee swarm,buzzerker,Beebee King,bee thoven,Queen Bee];
	}
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Heavy Rains")) {
		extramonsters["Wanderering Monsters"]["path: Heavy Rains"]["Wandering: every 15-20 turns."] = $monsters[giant isopod, gourmet gourami, freshwater bonefish, alley catfish, piranhadon, giant tardigrade, aquaconda, storm cow];
	}
	
	
	//
	
	// free combat from familiar
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && !have_familiar($familiar[Mini-Hipster]))) {
		extramonsters["Familiar Combats"]["Mini-Hipster"]["The odds of encountering a free combat are 50/40/30/20/10/10/10"] = $monsters[angry bassist, blue-haired girl, evil ex-girlfriend, peeved roommate, random scenester];
    }
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && !have_familiar($familiar[Artistic Goth Kid]))) {
		extramonsters["Familiar Combats"]["Artistic Goth Kid"]["The odds of encountering a free combat are 50/40/30/20/10/10/10"] = $monsters[Black Crayon Beast, Black Crayon Beetle, Black Crayon Constellation, Black Crayon Crimbo Elf, Black Crayon Demon, Black Crayon Elemental, Black Crayon Fish, Black Crayon Flower, Black Crayon Frat Orc, Black Crayon Goblin, Black Crayon Golem, Black Crayon Hippy, Black Crayon Hobo, Black Crayon Man, Black Crayon Manloid, Black Crayon Mer-kin, Black Crayon Penguin, Black Crayon Pirate, Black Crayon Shambling Monstrosity, Black Crayon Slime, Black Crayon Spiraling Shape, Black Crayon Undead Thing];
	}
	
	
	
	
	// cleesh
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && !have_skill($skill[CLEESH]))) {
		extramonsters["Skills"]["CLEESH"]["Use skill CLEESH in combat"] = $monsters[Frog, Newt, Salamander];
	}
	
	
	
	// deck of every card
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && item_amount($item[Deck of Every Card]) ==0)) {
		extramonsters["Deck of Every Card "]["Deck of Every Card"]["card \"IV - The Emperor\""] = $monsters[The Emperor];
		extramonsters["Deck of Every Card "]["Deck of Every Card"]["card \"Green Card\""] = $monsters[legal alien];
	}
	
	
	// odd and even ascensions // show ALL hole in the sky monsters unless mskc_mp_hide_unavailable_areas == true
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true)) {		
		if((my_ascensions() % 2) == 0) {
			// odd ascensions
			extramonsters["Beanstalk"]["The Hole in the Sky (odd ascension)"]["Only available in odd ascensions"] = $monsters[Axe Wound,Beaver,Box,Bush,Camel's Toe,Flange,Honey Pot,Little Man in the Canoe,Muff];
		} else {
			// even ascensions+
			extramonsters["Beanstalk"]["The Hole in the Sky (even ascension)"]["Only available in even ascensions"]  = $monsters[Burrowing Bishop,Family Jewels,Hooded Warrior,Junk,One-Eyed Willie,Pork Sword,Skinflute,Trouser Snake,Twig and Berries];
		}
	}
	
	
	
	// show path specific monsters when not in that path
	// boss bat
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Actually Ed the Undying")) {		
		// boss bat boss replacment
		extramonsters["BatHole"]["The Boss Bat's Lair"]["Replaces boss bat in Actually Ed the Undying"] = $monsters[Boss Bat?];
		extramonsters["Knob"]["Throne Room"]["Replaces knob goblin king in Actually Ed the Undying"] = $monsters[New Knob Goblin King];
		extramonsters["Cyrpt"]["Haert of the Cyrpt"]["Replaces Bonerdagon in Actually Ed the Undying"] = $monsters[Donerbagon];
		extramonsters["McLarge"]["Mist-Shrouded Peak"]["Replaces Groar in Actually Ed the Undying"] = $monsters[Your winged yeti];
		extramonsters["Sorceress"]["The Naughty Sorceress' Chamber"]["Replaces The Naughty Sorceress in Actually Ed the Undying"] = $monsters[You the Adventurer];
		
		

	}
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Heavy Rains")) {		
		// boss bat boss replacment
		extramonsters["BatHole"]["The Boss Bat's Lair"]["Replaces boss bat in Heavy Rains"] = $monsters[Aquabat];
		extramonsters["Knob"]["Throne Room"]["Replaces knob goblin king in Heavy Rains"] = $monsters[Aquagoblin];
		extramonsters["Cyrpt"]["Haert of the Cyrpt"]["Replaces Bonerdagon in Heavy Rains"] = $monsters[Auqadargon];
		extramonsters["McLarge"]["Mist-Shrouded Peak"]["Replaces Groar in Heavy Rains"] = $monsters[Gurgle];
		extramonsters["HiddenCity"]["A Massive Ziggurat"]["Replaces Protector Spectre in Heavy Rains"] = $monsters[Protector Spurt];
		extramonsters["Plains"]["Inside the Palindome"]["Replaces Dr. Awkward in Heavy Rains"] = $monsters[Dr. Aquard];
		extramonsters["IsleWar"]["The Battlefield (Hippy Uniform)"]["Replaces The Man in Heavy Rains"] =$monsters[The Aquaman];
		extramonsters["IsleWar"]["The Battlefield (Frat Uniform)"]["Replaces The Big Wisniewski in Heavy Rains"] =   $monsters[Big Wisnaqua];
		extramonsters["Sorceress"]["The Naughty Sorceress' Chamber"]["Replaces The Naughty Sorceress in Heavy Rains"] = $monsters[The Rain King];
		
		
		

	}
	
	// show things that have been replaced by being in a path
	// boss bat
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() == "Actually Ed the Undying")) {		
		//extramonsters["BatHole"]["The Boss Bat's Lair"]["Not available because you are in a special path"] = $monsters[Boss Bat];
		
		
	}
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() == "Actually Ed the Undying")) {		
		//extramonsters["BatHole"]["The Boss Bat's Lair"]["Not available because you are in a special path"] = $monsters[Boss bat];

		
	}
	

	
	
	foreach z,l,i,mob in extramonsters {
		monster_item m;
			
		m.mp_monster_id = mob.id; 
		m.mp_monster_name = mob.to_string();
		m.mp_zone_name = z;	m.mp_location_name = l;
		m.mp_factoids = monster_factoids_available(mob,true);
		m.mp_frequency = 0;
		m.mp_semirare = false; m.mp_boss = false; m.mp_special = true;
		m.mp_information = i;
		monster_items[index] = m;
		index+=1;
	}
	

 
	return monster_items;

 }

monster_item[int] get_monsters() {
	int i = 0; monster_item[int] monster_items;
	
	// load special monster data
	special_monster_item[string] special_monsters; file_to_map("mskc_mp_monsters.txt",special_monsters);

	
	foreach l in $locations[] {

		// hide some inaccessible areas
		if(get_property("mskc_mp_hide_unavailable_areas") == true) {
			// paths
			if(l.zone == "Mothership" && my_path() != "Bugbear Invasion") {continue;}
			if(l.zone == "KOL High School" && my_path() != "KOLHS") {continue;}
			if(l == $location[The Secret Council Warehouse] && my_path() != "Actually Ed the Undying") {continue;}
			// other
			if(l.zone == "Rift" && (my_level() != 4 || my_level() != 5 || my_ascensions() == 0)) {continue;}
			
			// finished events
			if($locations[Shivering Timbers, A Skeleton Invasion!,The Cannon Museum,Grim Grimacite Site,A Pile of Old Servers,The Haunted Sorority House,A Stinking Abyssal Portal,A Scorching Abyssal Portal,A Freezing Abyssal Portal,An Unsettling Abyssal Portal,A Terrifying Abyssal Portal,A Yawning Abyssal Portal,The Space Odyssey Discotheque,The Spirit World,Some Scattered Smoking Debris,A Crater Full of Space Beasts] contains l) {continue;}
			
			// twitch
			if(l.zone == "Twitch" && get_property( "timeTowerAvailable" ) != "true") {continue;}
			
			// little canadia 
			if((l.zone == "Little Canadia" || l.parent == "Little Canadia") && !canadia_available()) {continue;}
			
			// MusSign
			if(l.zone == "MusSign" && !knoll_available()) {continue;}
			//mox
			if(l.zone == "MoxSign" && !(gnomads_available() && get_property("lastDesertUnlock") == my_ascensions())) {continue;}

			// knoll
			if($locations[The Degrassi Knoll Restroom,The Degrassi Knoll Bakery,The Degrassi Knoll Gym,The Degrassi Knoll Garage] contains l) {
				if(!(my_sign() != "Mongoose" && my_sign() != "Wallaby" && my_sign() != "Vole")) {
					continue;
				}
			}
			
			// removed areas
			if(l.parent.to_lower_case() == "removed" ) {continue;}
		}
	
		// get all monsters in location
		float [monster] mobs = appearance_rates(l);
	
	


		// skip location if there is nothing useful there
		if(count(mobs) < 1) {continue;}
			
		// compile monster data into record
		foreach mob, freq in mobs {
			// remove non combats and ultra rares
			if(mob == $monster[none] ||  freq == -1 ) {continue;}

			monster_item m;
			
			m.mp_monster_id = mob.id;
			m.mp_monster_name = mob.to_string();
			m.mp_location_name = l.to_string();
			m.mp_zone_name = l.zone;
			m.mp_factoids = monster_factoids_available(mob,true);
			m.mp_frequency = freq;
			m.mp_semirare = index_of(mob.attributes.to_lower_case(),"semirare") > -1;
			m.mp_boss = mob.boss;
			m.mp_special = false;
			m.mp_information = "";
			
			// check for special cases
			string mal = mob.to_string()+"@"+l.to_string();

			if(special_monsters contains mal) {
				
				// removed or unfactoidable
				if(special_monsters[mal].mp_type.to_lower_case() == "removed" || special_monsters[mal].mp_type.to_lower_case() == "nofactoid") {
					continue;
				}

				
				// override boss record
				if(special_monsters[mal].mp_type.to_lower_case() == "boss") {
					m.mp_boss = true;
				}
				
				// set special flag
				if(special_monsters[mal].mp_type.to_lower_case() == "special") {
					m.mp_special = true;
				}
				
				
				
				// add any extra information
				m.mp_information = special_monsters[mal].mp_info;
			
			}
			
			// store the monster after adding all records
			monster_items[i] = m; i=i+1;
		}
	
	}
	
	// add extras
	
	monster_items = add_extra_monsters(monster_items);
	
	
	// return full list of monsters
	return monster_items;
}


void handle_ajax(string[string] fields) {

	// hit mm pages if requested
	if(fields["request"] == "monsters" && fields["pages"] != "") {
		print("Hitting manuel... (que?)");
		foreach i, page in split_string(fields["pages"], ",") {
			print(page);
			update_progress(visit_url("questlog.php?which=6&vl=" + page.to_lower_case()));
		}
	}
	
    // get list of monsters if requested
    if(fields["request"] == "monsters") {
		monster_item[int] monster_items = get_monsters();
		// send record as json
		writeln("{\"status\":\"ok\",\"data\":" + monster_items.to_json() + ",\"progress\":" + mp_progress.to_json() + "}");
        return;    
	}
	
	
	if(fields["request"] == "settings") {
		
		set_property("mskc_mp_hide_completed_areas",fields["mskc_mp_hide_completed_areas"]);
		set_property("mskc_mp_hide_nearly_completed_areas",fields["mskc_mp_hide_nearly_completed_areas"]);
		set_property("mskc_mp_hide_unavailable_areas",fields["mskc_mp_hide_unavailable_areas"]);
		
		writeln("{\"status\":\"ok\",\"data\":\"nothing to say\"}");
		return;
	}

	
	writeln("{\"status\":\"error\",\"data\":\"Unknown Request\"}");
}



string render_settings() {
	// mskc_mp_show_removed_areas 
	// mskc_mp_hide_completed_areas
	// mskc_mp_hide_nearly_completed_areas

	
	
	
	
	string settings = "<div id=\"mp_settings\">";
	settings += "<span><input type=\"checkbox\"  id=\"mskc_mp_hide_completed_areas\" " + (get_property("mskc_mp_hide_completed_areas") == true ? "checked" : "") + "/><label for=\"mskc_mp_hide_completed_areas\">Hide 100% complete areas (mskc_mp_hide_completed_areas).</label></span>";
	settings += "<span><input type=\"checkbox\"  id=\"mskc_mp_hide_nearly_completed_areas\" " + (get_property("mskc_mp_hide_nearly_completed_areas") == true ? "checked" : "") + "/><label for=\"mskc_mp_hide_nearly_completed_areas\">Hide nearly complete areas (ignore semi-rare, boss, one-time etc) (mskc_mp_hide_nearly_completed_areas).</label></span>";
	settings += "<span><input type=\"checkbox\"  id=\"mskc_mp_hide_unavailable_areas\" " + (get_property("mskc_mp_hide_unavailable_areas") == true ? "checked" : "") + "/><label for=\"mskc_mp_hide_unavailable_areas\">Hide areas and mobs you cannot access (experimental) (mskc_mp_hide_unavailable_areas).</label></span>";
	settings += "<span><a href=\"\" class=\"save_settings\">Save</a><a  href=\"\" class=\"close_settings\">Cancel</a></span>";
	settings += "</div>";

	return settings;
}

/*
 * Output the basic html structure for the page, 
 * not a lot to do really, mostly handled by ajax functions
 */
void render_page() {
    // start head
    writeln("<!DOCTYPE html>"); write_header();

    // css styles
    writeln("<link rel=\"stylesheet\" href=\"mp_assets/css/mp.css\" />");
	writeln("<link rel=\"stylesheet\" href=\"mp_assets/css/tipr.css\" />");
    // javascript
    writeln("<script src=\"//ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js\"></script>");
	writeln("<script src=\"mp_assets/js/tipr.min.js\"></script>");
    writeln("<script src=\"mp_assets/js/mp.js\"></script>");

    // </head><body>
    finish_header();

    // header and content div
    writeln("<header><h1>Manuel Progress R:" + svn_info( "matt-chugg-manuel_progress.git-trunk" ).revision + " - <span id=\"mp_progress\">0 : 0 : 0</span></h1><a id=\"jumpout\">-></a><a class=\"mp_refresh\">refresh all</a><a class=\"mp_settings\">settings</a><div class=\"clear\">&nbsp;</div>" + render_settings() + "</header>");
	string content_class="";
	if (get_property("mskc_mp_hide_completed_areas") == true) {content_class += "hide_completed_areas ";}
	
	content_class = content_class + (get_property("mskc_mp_hide_nearly_completed_areas") == true ? "hide_nearly_completed_areas " : "" );
    writeln("<div id=\"content\" class=\"" + content_class + "\"></div>");
    
    // end the page
    finish_page();
}


/*
 * Main
 * Check for ajax and handle otherwise output the whole page
 */
void mm_main() {
	
	mp_progress.casually = 0; mp_progress.thoroughly = 0; mp_progress.exhaustively = 0;
    fields = form_fields();
    if(fields["ajax"] == "true") {
        handle_ajax(fields); return;
    }
    render_page();
}  