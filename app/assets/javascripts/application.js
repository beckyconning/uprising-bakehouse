// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(window).load(load_map);

function load_map() {
	var map = new google.maps.Map(document.getElementById('map'), {
		zoom: 17,
		center: new google.maps.LatLng(53.45090, -2.2713),
		disableDefaultUI: true,
		mapTypeId: google.maps.MapTypeId.HYBRID
	});
	var marker = new google.maps.Marker({
		position: new google.maps.LatLng(53.45066, -2.271906),
		map: map,
		clickable: false,
		icon: 'http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-301f17/shapecolor-white/shadow-1/border-dark/symbolstyle-color/symbolshadowstyle-no/gradient-bottomtop/bread.png'
	});
}