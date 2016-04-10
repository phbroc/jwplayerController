window.addEventListener('complexAction', eventHandlerComplexAction, false);
window.addEventListener('setupAction', eventHandlerSetup, false);

function eventHandlerSetup(e) {
  //alert('detail: ' + e.detail.imageFileIn + ' ' + e.detail.videoFile + ' ' + e.detail.imageFileOut);
  //repéré un problème avec CustomEvent dans Dart qui est sérialisé, il faut ensuite le désérialiser (dart 1.15)
  var s = e.detail.toString();
  var d = JSON.parse(s);
  //console.log(d.imageFileIn + " " + d.videoFile + " " + d.imageFileOut);

  JwplayerControl.init(d.imageFileIn, d.videoFile, d.imageFileOut);
  JwplayerControl.setup();
}

function eventHandlerComplexAction(e) {
  //alert('detail: ' + e.detail.imageFileIn + ' ' + e.detail.videoFile + ' ' + e.detail.imageFileOut);
	//repéré un problème avec CustomEvent dans Dart qui est sérialisé, il faut ensuite le désérialiser (dart 1.15)
  var s = e.detail.toString();
  var d = JSON.parse(s);

  JwplayerControl.init(d.imageFileIn, d.videoFile, d.imageFileOut);
  if (d.autostart == "false")
  {
  		var mode = JwplayerControl.getMode();
  		if (mode == "flash")
  		{
  			JwplayerControl.load();
  		} else {
  			JwplayerControl.unset();
  			JwplayerControl.setup();
  		}
  }
  else {

  		JwplayerControl.loadandplay();
  }
  var theEle = document.getElementById('interactions');
  theEle.className = 'hide';
}

/* ---------------------- */



/* -------------------------- */

var JwplayerControl = function () {

	var imageFileIn = "";
	var videoFile = "";
	var imageFileOut = "";
	var autostart = "";
	var mode = "";
	var mediaFolder = "";


	
	function complete() {
		//alert("complete");
		autostart = "false";
		jwplayer("thePlayer").load([{
					image: imageFileOut,
					sources: [{ 
						file: videoFile
					}]
		}]);
		window.dispatchEvent(new CustomEvent("videoComplete", {"detail":{"ended":true}}));
	}
	
	function playlistLoaded() {
		//alert("playlist: " + autostart);
		//if (autostart == "false") jwplayer("thePlayer").stop();
		//var state = jwplayer("thePlayer").getState();
		//alert("playlistLoaded state: " + state);
		//if (autostart != "true") jwplayer("thePlayer").pause(true);
		//if (autostart == "false") jwplayer("thePlayer").pause(true);
	}

	return {
	
		init: function(i, v, o) {
			mediaFolder = "medias/";
			imageFileIn = mediaFolder+i;
			videoFile = mediaFolder+v;
			imageFileOut = mediaFolder+o;
		},
	
		setup: function() {
			var playerInstance = jwplayer("thePlayer");
			playerInstance.setup({
				playlist: [{
					image: imageFileIn,
					sources: [{ 
						file: videoFile
					}]
				}],
				height: "100%",
				primary: "html5",
				width: "100%",
				analytics: {
            		enabled: false
        		},
				events:{
           			onComplete: function() {
                		complete();
                	},
                	onPlaylist: function() {
                		playlistLoaded();
                	}
            	},
            	skin: "skins/sixalt.xml",
				logo: {
					hide: false,
					file: "images/mylogo.png"
				}
			});
		},
		
		unset: function() {
			var playerInstance = jwplayer("thePlayer");
			playerInstance.remove();
		},
		
		load: function() {
			autostart = "false";
			var playerInstance = jwplayer("thePlayer");
			playerInstance.load([{
					image: imageFileIn,
					sources: [{ 
						file: videoFile
					}]
			}]);
			//jwplayer("thePlayer").play();
		},
		
		loadandplay: function() {
			autostart = "true";
			var playerInstance = jwplayer("thePlayer");
			playerInstance.load([{
					image: imageFileIn,
					sources: [{ 
						file: videoFile
					}]
			}]);
			playerInstance.play();
		},
		
		play: function() {
			var playerInstance = jwplayer("thePlayer");
			playerInstance.play();
		},
		
		getMode: function() {
			var playerInstance = jwplayer("thePlayer");
			mode = playerInstance.getRenderingMode();
			return mode;
		}
	};

}();