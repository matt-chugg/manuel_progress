








function process_monster_list(data) {
    jQuery.each(data,function(key,value) {
        var zone_name = String(value.mp_zone_name);
        var location_name = String(value.mp_location_name);
        var monster_name = String(value.mp_monster_name);
        
        if(zone_name == "") {zone_name == "unknown zone";}
        if(location_name == "") {location_name == "unknown location";}
        if(monster_name == "") {return true;}
        
        // add / find the zone
        if(jQuery("#content>.zone[data-zonename=\"" + zone_name + "\"]").length === 0) {
            var zone = jQuery("<div><h2>" + zone_name + "<a class=\"mp_refresh\">refresh</a></h2></div>")
                .addClass("zone")
                .attr("data-zonename",zone_name);
            jQuery("#content").append(zone);
        }
        zone = jQuery("#content>.zone[data-zonename=\"" + zone_name + "\"]");
        if(zone.length != 1) {alert("Zone error"); return false;}
        
        
        // add/find location
        if(zone.children(".location[data-locationname=\"" + location_name + "\"]").length ===0) {
            var location = jQuery("<div><h2>" + location_name + "<a class=\"mp_refresh\" >refresh</a></h2></div>")
                .addClass("location")
                .attr("data-locationname",location_name);
            zone.append(location);
        }
        var location = zone.children(".location[data-locationname=\"" + location_name + "\"]");
        if(location.length != 1) {alert("location error"); return false;}
        
        
        // add/update the monster
        if(location.children(".monster[data-monstername=\"" + value.mp_monster_name + "\"]").length ===0) {
            var monster = jQuery("<div><h4>" + monster_name + "</h4><div class=\"progress\"><span class=\"one\"></span><span class=\"two\"></span><span class=\"three\"></span></div></div>")
                .addClass("monster")
                .attr("data-monstername",value.mp_monster_name)
                .attr("data-progress",value.mp_factoids);
            location.append(monster);
        }
        
        var monster = location.children(".monster[data-monstername=\"" + value.mp_monster_name + "\"]");
        if(monster.length != 1) {alert("monster error"); return false;}
        
        monster.attr("data-progress",value.mp_factoids);
        
        
        
        
    });
    
    
    //hide and show refresh
    jQuery(".zone,.location").each(function() {
        $l = jQuery(this);
        
        if($l.find(".monster[data-progress=1],.monster[data-progress=2],.monster[data-progress=0]").length==0) {
            $l.children("h2").find(".mp_refresh").hide();
        } else {
            $l.children("h2").find(".mp_refresh").show();
        }
    });
    
                    
}




function mp_update_monsters(updatepages) {
    jQuery("body").addClass("mp_wait");
    updatepages = updatepages || '';
    jQuery.ajax({
        dataType: "json",
        url: "relay_Manuel_Progress.ash",
        data: {"ajax": "true", "request": "monsters", "pages":updatepages},
        success: function(data) {
            if(data.status) {
                if(data.status == "ok") {
                    if(data.data) {process_monster_list(data.data);} else {alert("No data returned")}
                } else {
                    alert(data.status + " : " + data.data);
                }
            } else {
                // unknown response
                alert("unrecognised response, see console");
                console.log(data);
            }
            jQuery("body").removeClass("mp_wait");
            
        },
        async: true
    });
}













function mp_init() {
    // load mobs from kol
    mp_update_monsters("");
}




function mp_do_binds() {
    //show button to jump out of frame if in a frame
    if(typeof top.mainpane !== "undefined") {
        jQuery("#jumpout").show();
    }
    
    // jump out to new window
    jQuery(document).on("click","#jumpout", function(e) {
        e.preventDefault(); window.open(top.mainpane.location.href);
    });
    
    jQuery(document).on("click",".mp_refresh",function(e){

        e.preventDefault();
        // construct string
        var pages = ""; 
        jQuery(this).closest("div,form,body").find(".monster").not("[data-progress=3]").each(function(){
             
            
            var letter = jQuery(this).attr("data-monstername").substring(0,1).toLowerCase();
            console.log(letter);
            if(!/^[a-z]$/g.test(letter)) {letter = "-";}
            if(pages.indexOf(letter) == -1) {
                if(pages !== "") {pages = pages + ","}
                pages = pages + letter;
            }
        });
        
        mp_update_monsters(pages);
        
    });
    
    
}









jQuery(document).ready(function() {
    mp_do_binds();
    mp_init();
});

