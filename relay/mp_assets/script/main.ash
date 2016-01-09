
// record to hold a location and monster
record monster_item {
	string mp_monster_id;
	string mp_monster_name;
	string mp_location_name;
	string mp_zone_name;
	int mp_factoids;
};

 monster_item[int] get_monsters() {
	int i = 0; monster_item[int] monster_items;
	foreach l in $locations[] {
		// get all monsters in location
		float [monster] mobs = appearance_rates(l);
	
		// tidy up the mob list 
		foreach mob in mobs {
			// remove non combats
			if(mob == $monster[none]  ) {remove mobs[mob];}
		}
	
		// skip location if there is nothing useful there
		if(count(mobs) < 1) {continue;}
			

		// compile monster data into record
		foreach mob in mobs {
			monster_item m;
			m.mp_monster_id = mob.id;
			m.mp_monster_name = mob.manuel_name;
			m.mp_location_name = l.to_string();
			m.mp_zone_name = l.zone;
			m.mp_factoids = monster_factoids_available(mob,true);
			monster_items[i] = m;
			i=i+1;
		}
	}

	return monster_items;

}


void handle_ajax(string[string] fields) {

	// hit mm pages if requested
	if(fields["request"] == "monsters" && fields["pages"] != "") {
		print("Hitting the manuel");
		foreach i, page in split_string(fields["pages"], ",") {
			print(page);
			visit_url( "questlog.php?which=6&vl=" + page.to_lower_case() );
		}
		
	}
	
    			
    if(fields["request"] == "monsters") {
		monster_item[int] monster_items = get_monsters();
		
		// send record as json
		writeln("{\"status\":\"ok\",\"data\":" + monster_items.to_json() + "}");
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

    // javascript
    writeln("<script src=\"//ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js\"></script>");
    writeln("<script src=\"mp_assets/js/mp.js\"></script>");

    // </head><body>
    finish_header();

    // header and content div
    writeln("<header><h1>Manuel Progress R:" + svn_info( "matt-chugg-manuel_progress.git-trunk" ).revision + "</h1><a id=\"jumpout\">-></a><a class=\"mp_refresh\">refresh all</a><div class=\"clear\">&nbsp;</div></header>");
    writeln("<div id=\"content\"></div>");
    
    // end the page
    finish_page();
}


/*
 * Main
 * Check for ajax and handle otherwise output the whole page
 */
void mm_main() {
    fields = form_fields();
    if(fields["ajax"] == "true") {
        handle_ajax(fields); return;
    }
    render_page();
}  