
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

monster_item[int] add_unseen_monsters(monster_item[int] monster_items) {
	boolean[monster] seen_monsters;
	foreach i,mob in monster_items {
		monster sm = to_monster(mob.mp_monster_name);
		seen_monsters[sm] = true;
	}
	

	int index = count(monster_items);
	foreach mob in $monsters[] {
		string l = "other";
		
		// still ignore ultrarare
		if(index_of(mob.attributes.to_lower_case(),"ultrarare") > -1) {
			l = "No Factoid - UR";
		}
		
		if($monsters[All-Hallow's Steve,X-32-F Combat Training Snowman,the frattlesnake,general seal,The Hermit,wild seahorse,Edwing Abbidriel] contains mob) {
			l = "No Factoid - ?";
		}
		
		// old content
		//tower
		if($monsters[Beer Batter,best-selling novelist,Big Meat Golem,Bowling Cricket,Bronze Chef,collapsed mineshaft golem,concert pianist,darkness,El Diablo,Electron Submarine,endangered inflatable white tiger,Enraged Cow,fancy bath slug,Fickle Finger of F8,Flaming Samurai,giant bee,Giant Desktop Globe,giant fried egg,Ice Cube,malevolent crop circle,possessed pipe-organ,Pretty Fly,Tyrannosaurus Tex,Vicious Easel] contains mob) {
			l = "No Factoid - old content";
		}
		// road to white citadel
		if($monsters[angry raccoon puppet,eXtreme Sports Orcs] contains mob) {
			l = "No Factoid - old content";
		}
		
		// nightstands
		if($monsters[animated nightstand (mahogany combat),animated nightstand (mahogany noncombat),animated nightstand (white combat),animated nightstand (white noncombat)] contains mob) {
			l = "No Factoid - old content";
		}
		
		if($monsters[possessed wine rack (obsolete),ancient protector spirit (obsolete),Astronomer (obsolete),possessed wine rack (obsolete),skeletal sommelier (obsolete)] contains mob) {
			l = "No Factoid - old content";
		}
		
		// old ferns tower
		if($monsters[giant pair of tweezers]  contains mob) {
			l = "No Factoid - old content";
		}
		
		// butts
		if($monsters[CDMoyer's Butt,Jick's Butt,Riff's Butt,Multi Czar's Butt,Riff's Butt,Hotstuff's Butt] contains mob) {
			l = "other butts";
		}
		
		if($monsters[mutant gila monster,mutant rattlesnake,mutant saguaro,swarm of mutant fire ants] contains mob) {
			l = "Halloween XX";
		}
		
		if($monsters[Inebriated Tofurkey,Hammered Yam Golem,Plastered Can of Cranberry Sauce,Soused Stuffing Golem] contains mob) {
			l = "Drunksgiving";
		}
		
		
		//Ed the Undying
		if($monsters[Ed the Undying (1),Ed the Undying (2),Ed the Undying (3),Ed the Undying (4),Ed the Undying (5),Ed the Undying (6),Ed the Undying (7)]  contains mob) {
			l = "Ed versions";
		}
		
		
		
		// old tower
		if($monsters[Beer Batter, best-selling novelist, Big Meat Golem, Bowling Cricket, Bronze Chef, collapsed mineshaft golem, concert pianist, darkness, El Diablo, Electron Submarine, endangered inflatable white tiger, Enraged Cow, fancy bath slug, Fickle Finger of F8, Flaming Samurai, giant bee, Giant Desktop Globe, giant fried egg, Ice Cube, malevolent crop circle, possessed pipe-organ, Pretty Fly, Tyrannosaurus Tex, Vicious Easel]  contains mob) {
			l = "Old Tower";
		}
	
	
		if(!(seen_monsters contains mob)) {
			monster_item m;
			m.mp_monster_id = mob.id; 
			m.mp_monster_name = mob.to_string();
			m.mp_zone_name = "Unknown";	m.mp_location_name = l;
			m.mp_factoids = monster_factoids_available(mob,true);
			m.mp_frequency = 0;
			m.mp_semirare = false; m.mp_boss = false; m.mp_special = true;
			m.mp_information = "?";
			monster_items[index] = m;
			index+=1;
		}
	}
	
	return monster_items;
}

monster_item[int] add_extra_monsters(monster_item[int] monster_items) {
	boolean [string][string][string][monster] extramonsters; int index = count(monster_items);

	// brickos pretty much unconditional
	extramonsters["BRICKO Monsters"]["BRICKO"][""] = $monsters[BRICKO Airship, BRICKO Bat, BRICKO Cathedral, BRICKO Elephant, BRICKO Gargantuchicken, BRICKO Octopus, BRICKO Ooze, BRICKO Oyster, BRICKO Python, BRICKO Turtle, BRICKO Vacuum Cleaner];
	
	// black pudding
	extramonsters["MISC"]["Food"]["Occurs randomly when eating black puddings"] = $monsters[black pudding];
	
	// family of kobolds
	extramonsters["MISC"]["Item"]["Occurs when multi-using 100 d4 at once (which are consumed)."] = $monsters[family of kobolds];
	
	// butts
	extramonsters["MISC"]["Butts"]["portable photocopier"] = $monsters[your butt,somebody else's butt];
	
	// The Lower Chambers ed
	extramonsters["Pyramid"]["The Lower Chambers"]["Boss."] = $monsters[Ed the Undying];
	
	// deck of every card
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && item_amount($item[Deck of Every Card]) ==0)) {
		extramonsters["MISC"]["Deck of Every Card"]["card \"IV - The Emperor\""] = $monsters[The Emperor];
		extramonsters["MISC"]["Deck of Every Card"]["card \"Green Card\""] = $monsters[legal alien];
	}
	
	// cleesh
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && !have_skill($skill[CLEESH]))) {
		extramonsters["MISC"]["Skill: CLEESH"]["Use skill CLEESH in combat"] = $monsters[Frog, Newt, Salamander];
	}
	
	// unleash nanites
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && !have_familiar($familiar[Nanorhino]))) {
		extramonsters["MISC"]["Skill: Unleash Nanites"][""] = $monsters[little blob of gray goo,largish blob of gray goo,enormous blob of gray goo];
	}
	
	// skull dozer
	extramonsters["MISC"]["A Bone Garden"]["6th visit"] = $monsters[skulldozer];
	extramonsters["MISC"]["Item"]["use shaking skull"] = $monsters[skulldozer];
	
	// transmission from planet Xi
	extramonsters["KoL Con"]["transmission from planet Xi"][""]  = $monsters[holographic army, They, Xiblaxian political prisoner];
	
	// holidays wandering monsters
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && holiday() != "Feast of Boris")) {
		extramonsters["Wandering Monsters"]["Feast of Boris"]["Wandering: every 25-35 turns"] = $monsters[Candied Yam Golem, Malevolent Tofurkey, Possessed Can of Cranberry Sauce, Stuffing Golem];
	}
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && holiday() != "El Dia De Los Muertos Borrachos")) {
		extramonsters["Wandering Monsters"]["El Dia de Los Muertos Borrachos"]["Wandering: every 25-35 turns"] = $monsters[Novio Cad&aacute;ver, Padre Cad&aacute;ver, Novia Cad&aacute;ver, Persona Inocente Cad&aacute;ver];
	}
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && holiday() != "Talk Like a Pirate Day")) {
		extramonsters["Wandering Monsters"]["Talk like a pirate day"]["Wandering: every 25-35 turns."] = $monsters[Ambulatory Pirate, Migratory Pirate, Peripatetic Pirate];
	}
	
	// nemesis wandering monsters
	extramonsters["Wandering Monsters"]["Nemesis assassins"]["thugs sent after you by your Nemesis."] = $monsters[menacing thug,Mob Penguin hitman,hunting seal,Argarggagarg the Dire Hellseal,turtle trapper,Safari Jack\, Small-Game Hunter,evil spaghetti cult assassin,Yakisoba the Executioner,b&eacute;arnaise zombie,Heimandatz\, Nacho Golem,flock of seagulls,Jocko Homo,mariachi bandolero,The Mariachi With No Name];
	
	// Spelunky Area
	extramonsters["Spelunky Area"]["Non combat"]["Occurs at The Mines, The Jungle, and The Ice Caves. Attack the shopkeeper"] = $monsters[shopkeeper];
	
	
	// free combat from familiar
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && !have_familiar($familiar[Mini-Hipster]))) {
		extramonsters["Familiar Combats"]["Mini-Hipster"]["The odds of encountering a free combat are 50/40/30/20/10/10/10"] = $monsters[angry bassist, blue-haired girl, evil ex-girlfriend, peeved roommate, random scenester];
    }
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && !have_familiar($familiar[Artistic Goth Kid]))) {
		extramonsters["Familiar Combats"]["Artistic Goth Kid"]["The odds of encountering a free combat are 50/40/30/20/10/10/10"] = $monsters[Black Crayon Beast, Black Crayon Beetle, Black Crayon Constellation, Black Crayon Crimbo Elf, Black Crayon Demon, Black Crayon Elemental, Black Crayon Fish, Black Crayon Flower, Black Crayon Frat Orc, Black Crayon Goblin, Black Crayon Golem, Black Crayon Hippy, Black Crayon Hobo, Black Crayon Man, Black Crayon Manloid, Black Crayon Mer-kin, Black Crayon Penguin, Black Crayon Pirate, Black Crayon Shambling Monstrosity, Black Crayon Slime, Black Crayon Spiraling Shape, Black Crayon Undead Thing];
	}
	
	// and slime tube monster to slime tube
	extramonsters["Clan Basement"]["The Slime Tube"]["Any of the slime tube monsters.."] = $monsters[Slime Tube monster];
	
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

	// bees hate you
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Bees Hate You")) {
		// wanderers
		extramonsters["path: Bees Hate You"]["Wanderering Monsters"]["Wandering: every 15-20 turns."] = $monsters[beebee gunners,moneybee,mumblebee,beebee queue,bee swarm,buzzerker,Beebee King,bee thoven,Queen Bee];
	}
	
	// heavy rains
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Heavy Rains")) {
		// wanderers
		extramonsters["path: Heavy Rains"]["Wanderering Monsters"]["Wandering: every 15-20 turns."] = $monsters[giant isopod, gourmet gourami, freshwater bonefish, alley catfish, piranhadon, giant tardigrade, aquaconda, storm cow];
		
		// boss replacements
		extramonsters["path: Heavy Rains"]["The Boss Bat's Lair"]["Replaces boss bat in Heavy Rains"] = $monsters[Aquabat];
		extramonsters["path: Heavy Rains"]["Throne Room"]["Replaces knob goblin king in Heavy Rains"] = $monsters[Aquagoblin];
		extramonsters["path: Heavy Rains"]["Haert of the Cyrpt"]["Replaces Bonerdagon in Heavy Rains"] = $monsters[Auqadargon];
		extramonsters["path: Heavy Rains"]["Mist-Shrouded Peak"]["Replaces Groar in Heavy Rains"] = $monsters[Gurgle];
		extramonsters["path: Heavy Rains"]["A Massive Ziggurat"]["Replaces Protector Spectre in Heavy Rains"] = $monsters[Protector Spurt];
		extramonsters["path: Heavy Rains"]["Inside the Palindome"]["Replaces Dr. Awkward in Heavy Rains"] = $monsters[Dr. Aquard];
		extramonsters["path: Heavy Rains"]["The Battlefield (Hippy Uniform)"]["Replaces The Man in Heavy Rains"] =$monsters[The Aquaman];
		extramonsters["path: Heavy Rains"]["The Battlefield (Frat Uniform)"]["Replaces The Big Wisniewski in Heavy Rains"] =   $monsters[Big Wisnaqua];
		extramonsters["path: Heavy Rains"]["The Naughty Sorceress' Chamber"]["Replaces The Naughty Sorceress in Heavy Rains"] = $monsters[The Rain King];
		extramonsters["path: Heavy Rains"]["Summoning Chamber"]["Replaces Lord Spookyraven during a Heavy Rains Ascension."] = $monsters[Lord Soggyraven];
	}
	
	// ed the undying
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Actually Ed the Undying")) {		
		// boss replacement
		extramonsters["path: Actually Ed the Undying"]["The Boss Bat's Lair"]["Replaces boss bat in Actually Ed the Undying"] = $monsters[Boss Bat?];
		extramonsters["path: Actually Ed the Undying"]["Throne Room"]["Replaces knob goblin king in Actually Ed the Undying"] = $monsters[New Knob Goblin King];
		extramonsters["path: Actually Ed the Undying"]["Haert of the Cyrpt"]["Replaces Bonerdagon in Actually Ed the Undying"] = $monsters[Donerbagon];
		extramonsters["path: Actually Ed the Undying"]["Mist-Shrouded Peak"]["Replaces Groar in Actually Ed the Undying"] = $monsters[Your winged yeti];
		extramonsters["path: Actually Ed the Undying"]["The Naughty Sorceress' Chamber"]["Replaces The Naughty Sorceress in Actually Ed the Undying"] = $monsters[You the Adventurer];
	}
	
	// zombie slayer
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Zombie Slayer")) {
		extramonsters["path: Zombie Slayer"]["Wanderering Monsters"]["Wandering: every ? turns based on level ?"] = $monsters[Norville Rogers,Peacannon,Scott the Miner,Father McGruber,Herman East\, Relivinator,Angry Space Marine,Deputy Nick Soames & Earl,Father Nikolai Ravonovich,Charity the Zombie Hunter,Special Agent Wallace Burke Corrigan,Hank North\, Photojournalist,rag-tag band of survivors,The Free Man,Wesley J. "Wes" Campbell,zombie-huntin' feller];
		extramonsters["path: Zombie Slayer"]["The Naughty Sorceress' Chamber"]["Replaces The Naughty Sorceress in Zombie Slayer"] = $monsters[Rene C. Corman];
	}
	
	//Way of the Stunning Fist
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Way of the Stunning Fist")) {
		extramonsters["path: Way of the Stunning Fist"]["The Black Market"]["Beat up the shopkeeper"] = $monsters[Wu Tang the Betrayer];
	}
	
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_class().to_string() != "Seal Clubber")) {
		// summon seals
		extramonsters["Seal Clubber"]["Infernal Seals (lesser)"]["figurine of a cute baby seal"] = $monsters[broodling seal];
		extramonsters["Seal Clubber"]["Infernal Seals (lesser)"]["figurine of an armored seal"] = $monsters[Centurion of Sparky];
		extramonsters["Seal Clubber"]["Infernal Seals (lesser)"]["figurine of an ancient seal"] = $monsters[hermetic seal];
		extramonsters["Seal Clubber"]["Infernal Seals (lesser)"]["figurine of a wretched-looking seal"] = $monsters[Spawn of Wally];
		
		extramonsters["Seal Clubber"]["Infernal Seals (greater)"]["figurine of a charred seal"] = $monsters[heat seal];
		extramonsters["Seal Clubber"]["Infernal Seals (greater)"]["figurine of a cold seal"] = $monsters[navy seal];
		extramonsters["Seal Clubber"]["Infernal Seals (greater)"]["figurine of a stinking seal"] = $monsters[Servant of Grodstank];
		extramonsters["Seal Clubber"]["Infernal Seals (greater)"]["figurine of a shadowy seal"] = $monsters[shadow of Black Bubbles];
		extramonsters["Seal Clubber"]["Infernal Seals (greater)"]["figurine of a sleek seal"] = $monsters[watertight seal];
		extramonsters["Seal Clubber"]["Infernal Seals (greater)"]["figurine of a slippery seal"] = $monsters[wet seal];
		
	}

	//Avatar of Boris
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Avatar of Boris")) {
		extramonsters["path: Avatar of Boris"]["Itznotyerzitz Mine"][""] = $monsters[Mountain man];
		extramonsters["path: Avatar of Boris"]["The Naughty Sorceress' Chamber"]["Replaces The Naughty Sorceress in Avatar of Boris"] = $monsters[The Avatar of Sneaky Pete];
		extramonsters["path: Avatar of Boris"]["The Luter's Grave"]["Plains, quest: Your Minstrel Stamps"] = $monsters[The Luter];
	}
	
	//Avatar of Jarlsberg
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Avatar of Jarlsberg")) {
		extramonsters["path: Avatar of Jarlsberg"]["The Naughty Sorceress' Chamber"]["?"] = $monsters[clancy,The Avatar of Boris];
	}
	
	//Avatar of Sneaky Pete
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Avatar of Sneaky Pete")) {
		extramonsters["path: Avatar of Sneaky Pete"]["The Naughty Sorceress' Chamber"]["?"] = $monsters[The Avatar of Jarlsberg];
	}
	
	//Avatar of West of Loathing
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Avatar of West of Loathing")) {
		extramonsters["path: Avatar of West of Loathing"]["Wanderering Monsters (level 1-5)"]["every 15-20 adventures"] = $monsters[furious cow,emaciated rodeo clown,aggressive grass snake];
		extramonsters["path: Avatar of West of Loathing"]["Wanderering Monsters (level 6-8)"]["every 15-20 adventures"] = $monsters[furious giant cow,menacing rodeo clown,prince snake];
		extramonsters["path: Avatar of West of Loathing"]["Wanderering Monsters (level 9+)"]["every 15-20 adventures"] = $monsters[ungulith,grizzled rodeo clown,king snake];
	}
	
	//Bugbear Invasion
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "Bugbear Invasion")) {
		extramonsters["path: Bugbear Invasion"]["The Sleazy Back Alley"][""] = $monsters[scavenger bugbear];
		extramonsters["path: Bugbear Invasion"]["The Spooky Forest"][""] = $monsters[hypodermic bugbear];
		extramonsters["path: Bugbear Invasion"]["The Bat Hole (All zones except the Lair)"][""] = $monsters[batbugbear];
		extramonsters["path: Bugbear Invasion"]["Laboratory"][""] = $monsters[bugbear scientist];
		extramonsters["path: Bugbear Invasion"]["The Defiled Nook or The Misspelled Cemetary"][""] = $monsters[bugaboo];
		extramonsters["path: Bugbear Invasion"]["Lair of the Ninja Snowmen"][""] = $monsters[Black Ops Bugbear];
		extramonsters["path: Bugbear Invasion"]["The Penultimate Fantasy Airship"][""] = $monsters[Battlesuit Bugbear Type];
		extramonsters["path: Bugbear Invasion"]["The Haunted Gallery"][""] = $monsters[ancient unspeakable bugbear];
		extramonsters["path: Bugbear Invasion"]["The Battlefield (Frat Warrior Fatigues) or Bombed Hippy Camp or Bombed Frat House"][""] = $monsters[trendy bugbear chef];
	}
	
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_path() != "You, Robot")) {
		
		extramonsters["path: You, Robot"]["The Boss Bat's Lair"]["Replaces boss bat in You, Robot"] = $monsters[Boss Bot];
		extramonsters["path: You, Robot"]["Throne Room"]["Replaces knob goblin king in You, Robot"] = $monsters[Gobot King];
		extramonsters["path: You, Robot"]["Haert of the Cyrpt"]["Replaces Bonerdagon in You, Robot"] = $monsters[Robonerdagon];
		extramonsters["path: You, Robot"]["Mist-Shrouded Peak"]["Replaces Groar in  You, Robot"] = $monsters[Groarbot];
		extramonsters["path: You, Robot"]["The Naughty Sorceress' Chamber"]["Replaces The Naughty Sorceress in You, Robot"] = $monsters[Nautomatic Sorceress];
		
		extramonsters["path: You, Robot"]["Dr. Awkward's Office"]["Replaces Dr. Awkward in You, Robot"] = $monsters[Tobias J. Saibot];
		extramonsters["path: You, Robot"]["Summoning Chamber"]["Replaces Lord Spookyraven in You, Robot"] = $monsters[Lord Cyberraven];
		extramonsters["path: You, Robot"]["A Massive Ziggurat"]["Replaces Protector Spectre in You, Robot"] = $monsters[Protector S. P. E. C. T. R. E.];
		extramonsters["path: You, Robot"][" The Hippy Camp (Wartime)"]["Replaces The Big Wisniewski in You, Robot"] = $monsters[The Artificial Wisniewski];
		extramonsters["path: You, Robot"]["The Orcish Frat House (Wartime)"]["Replaces The Man in You, Robot"] = $monsters[The Android];

	}
	
	// various removed things 
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true)) {
		// rock thing from july
		extramonsters["Events"]["Rock thing, 2009"][""] = $monsters[rock homunculus,rock snake,clod hopper];
		
		//swarm of fudgewasps
		extramonsters["The Candy Diorama"]["Fudge Mountain"]["choice:Fudge Mountain Breakdown"] = $monsters[swarm of fudgewasps];
	}
	
	// nemesis
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_class().to_string() != "Seal Clubber")) {
		extramonsters["Volcano"]["Lair: Seal Clubber"][""] = $monsters[hellseal guardian,Gorgolok\, the Demonic Hellseal,Gorgolok\, the Infernal Seal (Inner Sanctum),Gorgolok\, the Infernal Seal (The Nemesis\' Lair),Gorgolok\, the Infernal Seal (Volcanic Cave)];
	}
	
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_class().to_string() != "Turtle Tamer")) {
		extramonsters["Volcano"]["Lair: Turtle Tamer"][""] = $monsters[warehouse worker,Stella\, the Demonic Turtle Poacher,Stella\, the Turtle Poacher (Inner Sanctum),Stella\, the Turtle Poacher (The Nemesis\' Lair),Stella\, the Turtle Poacher (Volcanic Cave)];
	}
	
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_class().to_string() != "Pastamancer")) {
		extramonsters["Volcano"]["Lair: Pastamancer"][""] = $monsters[evil spaghetti cult zealot,Spaghetti Demon,Spaghetti Elemental (Inner Sanctum),Spaghetti Elemental (The Nemesis' Lair),Spaghetti Elemental (Volcanic Cave)];
	}
	
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_class().to_string() != "Sauceror")) {
		extramonsters["Volcano"]["Lair: Sauceror"][""] = $monsters[security slime,Lumpy\, the Demonic Sauceblob,Lumpy\, the Sinister Sauceblob (Inner Sanctum),Lumpy\, the Sinister Sauceblob (The Nemesis' Lair),Lumpy\, the Sinister Sauceblob (Volcanic Cave)];
	}
	
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_class().to_string() != "Disco Bandit")) {
		extramonsters["Volcano"]["Lair: Disco Bandit"][""] = $monsters[daft punk,Demon of New Wave,Spirit of New Wave (Inner Sanctum),Spirit of New Wave (The Nemesis' Lair),Spirit of New Wave (Volcanic Cave)];
	}
	
	if(!(get_property("mskc_mp_hide_unavailable_areas")==true && my_class().to_string() != "Accordion Thief")) {
		extramonsters["Volcano"]["Lair: Accordion Thief"][""] = $monsters[mariachi bruiser,Somerset Lopez\, Demon Mariachi,Somerset Lopez\, Dread Mariachi (The Nemesis\' Lair),Somerset Lopez\, Dread Mariachi (Volcanic Cave),Somerset Lopez\, Dread Mariachi (Inner Sanctum)];
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

		// ignore nemesis lair, added back in later per class
		if(l == $location[The Nemesis' Lair]) {
			continue;
		}
	
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
			
			// dungeons of doom and enourmous greter than
			if(l == $location[The Enormous Greater-Than Sign] && get_property("lastPlusSignUnlock").to_int() == my_ascensions() ) {
				continue;
			}
			if(l == $location[The Dungeons of Doom] && get_property("lastPlusSignUnlock").to_int() < my_ascensions()) {
				continue;
			}
			
			// road to the white citadel
			if(l == $location[The Road to the White Citadel] && (get_property("questG02Whitecastle") == "unstarted" || get_property("questG02Whitecastle") == "step10" || get_property("questG02Whitecastle") == "finished")) {
				continue;
			}
			
			// Whitey's Grove
			if(l == $location[Whitey's Grove] && (get_property("questG02Whitecastle") == "unstarted" && (get_property("questL11Palindome") == "unstarted" || get_property("questL11Palindome") == "step1" || get_property("questL11Palindome") == "step2" || get_property("questL11Palindome") == "step3"))) {
				continue;
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
	
	// add monsters that aren't location based but in kols data file of monsters
	monster_items = add_unseen_monsters(monster_items);

	
	
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