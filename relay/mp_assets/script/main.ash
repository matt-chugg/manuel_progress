
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

 monster_item[int] get_monsters() {
	int i = 0; monster_item[int] monster_items;
	
	// load special monster data
	special_monster_item[string] special_monsters; file_to_map("mskc_mp_monsters.txt",special_monsters);

	
	foreach l in $locations[] {
		// skip some locations completely
		// skip removed areas unless specific property says not to
		if(l.parent.to_lower_case() == "removed" && (get_property("mskc_mp_show_removed_areas") != true)) {continue;}
		
	
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
			m.mp_monster_name = mob.manuel_name;
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

			if(freq == 0 && special_monsters contains mal) {
				
				
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
	

	
	writeln("{\"status\":\"error\",\"data\":\"Unknown Request\"}");
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
    writeln("<header><h1>Manuel Progress R:" + svn_info( "matt-chugg-manuel_progress.git-trunk" ).revision + " - <span id=\"mp_progress\">0 : 0 : 0</span></h1><a id=\"jumpout\">-></a><a class=\"mp_refresh\">refresh all</a><div class=\"clear\">&nbsp;</div></header>");
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