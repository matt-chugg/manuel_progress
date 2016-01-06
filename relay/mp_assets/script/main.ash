

void mm_main(fields) {
	fields = ;
	
	if(fields["ajax"] == "true") {
	
	
	} else {
		writeln("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">");
		write_header();
		// css styles
		writeln("<link rel=\"stylesheet\" href=\"mm_assets/css/mm.css\" />");
		
		// javascript
		writeln("<script src=\"//ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js\"></script>");
		writeln("<script src=\"mm_assets/js/mm_assets.js\"></script>");
		finish_header();
		

		writeln("<header><h1>mmChecker r" + svn_info( "mafiachit" ).revision . "</h1></header>");
		finish_page();
	}
}  