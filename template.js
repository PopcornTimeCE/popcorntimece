//The following annoys the user with some stupid cookie warning.
function getCookie(cname) {
    var name = cname + '=';
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
    }
    return '';
}

function setCookie(cname, cvalue, date) {
  if (getCookie('agreed') != 'Yes') return;
    document.cookie = cname + '=' + cvalue + '; ' + expires + 'expires=' + date.toUTCString() + ';';
}

if (getCookie('agreed') == '') {
  var r = confirm('In easy words: EU law enforces me to show this alert: This site uses cookies. Click "OK" to continue, "Cancel" to stop. Disable cookies if you do not like them.\n\n\n\
In complicated words: This site stores information on your terminal equipment in order to provide the given service. Other websites embedded in this website might store information as well.\n\
Click "OK" to allow information to be stored. Click "Cancel" to stop *this* website from storing information. \
A cookie to save your choice will be stored either way, as this is information which is strictly necessary in order to provide service which is explicitly requested to store by you.');
  console.log(r)
  if (r == true) {
    var d = new Date();
    d.setTime(d.getTime() + 31536000000);
    document.cookie = 'agreed=Yes; expires=' + d.toUTCString() + ';';
  } else {
    var d = new Date();
    d.setTime(d.getTime() + 31536000000);
    document.cookie = 'agreed=No; expires=' + d.toUTCString() + ';';
  }
}

//The following loads the website layout.
var title = document.getElementById('title').innerHTML;
var content = document.getElementById('content').innerHTML;
var template = '\
<!DOCTYPE html> \
<html> \
<head> \
	<meta http-equiv="content-type" content="text/html" charset="utf-8"/> \
	<meta charset="UTF-8"> \
	<link rel="shortcut icon" href="/Files/H6nry-Icon.png"> \
	<meta name="robots" content="index,follow"> \
	<meta http-equiv="cache-control" content="Public|Private"> \
	<title>'+title+'</title> \
	<link rel="stylesheet" href="/styles.css"></style> \
</head> \
<body class="tp-dync2"> \
\
<header class="tp-dync" align="center" style="background-color:#77ffff; font-family: serif; width:100%;"> \
	<h1>H6nry\'s page</h1> \
	"A different kind of magic." \
</header> \
 \
\
 \
<nav class="tp-dync"><br> \
	<a href="/index.html">Home</a><br><br> \
	<a href="/projects.html">Projects</a><br><br> \
	<a href="/repo/">Cydia repo</a><br><br> \
	<a href="/tutorial-cydia-repo.html">Tutorial: How to host your own Cydia repo</a><br><br> \
	<a href="/c-autoreleasepool.html">C-Autoreleasepool project</a><br><br> \
	<a href="/surutcra.html">Surutcra - A Twitter client</a><br><br> \
	<a href="/ncforward.html">NCForward - Forward your notifications</a><br><br> \
    <a href="/common-theos-problems.html">A collection of common THEOS problems</a><br><br> \
	<a href="http://github.com/H6nry/" target="_blank">Github</a><br><br> \
</nav> \
<aside class="tp-dync"> \
	<h4>News</h4> \
	--- This webpage uses HTML5 now. ---<br> \
	--- Noticed how the website colors change during the day? ---<br> \
	--- Repo page now shows the Packages on the repo (HTML5). ---<br> \
\
	<h4>Clicks</h4><iframe src="/counter.html" seamless="seamless" frameborder="0" style="width:125px; height:56px;"></iframe> \
</aside> \
\
<section class="tp-dync2"><br> \
	' + content + ' \
</section> \
 \
';
document.documentElement.innerHTML = template;

//The following part warms up the background of the page.
function makeWarm() {
  var date = new Date();
  var time = date.getHours() + date.getMinutes()/60 + date.getSeconds()/60/60;

  var warmth = 1.77777*Math.pow((time-12), 2); //The darker light is, the higher this value raises.
  var iwarm = 256-parseInt(warmth);

  elements = document.getElementsByClassName('tp-dync2');
  for (var c = 0; c < elements.length; ++c) {
    elements[c].style.backgroundColor = "rgb(".concat("255,", parseInt(256-(256-120)*Math.exp(-0.02*iwarm)), ",", parseInt(256-(256-0)*Math.exp(-0.02*iwarm)), ")"); //Get your favorite color picker and set the first constant after "265-" to the green color and the second to the blue color. Every color from yellow over red to magenta is allowed.
  }
}

makeWarm(); //Fire directly.
window.setInterval(makeWarm, 30000); //Fire every 30 sec.


//The following makes some winter feeling. I wonder that this code even works...
var flakes = [];

function startWinter() {
	document.head.innerHTML = document.head.innerHTML + '<style>@keyframes rotate {0% {transform:rotate(360deg);} 100% {transform:rotate(0deg);}}</style>'; //Paste some snowflake animation code into the head.

	for (var i = 0; i < 10; i++) { //Create some random snowflakes
		var snf = document.createElement('img');
		snf.setAttribute('src', '/Files/snowflake.svg');
		snf.style.position = 'fixed';
		snf.style.top = '-30px';
		snf.style.left = Math.floor(window.innerWidth * Math.random()) + 'px';
		snf.style.width = '30px';
		snf.style.height = '30px';
		snf.style.pointerEvents = 'none';
		var sec = Math.floor((20-5) * Math.random() + 5) + 's';
		snf.style.transition = 'top ' + sec + ' linear';
		snf.addEventListener("transitionend", updateFlake); //Everytime the transition is finished (the flake has reached page bottom), this will fire.
		snf.style.animation = 'rotate ' + Math.floor((20-5) * Math.random() + 5) + 's linear 0s infinite ' + (Math.random() > 0.5 ? 'reverse' : ''); //More rotation hack.
		document.body.appendChild(snf);

		flakes[i] = snf;
	};
}

function updateFlake() { //This gets fired with every snowflake which reaches the bottom.
	if (event.propertyName == 'top') {
		this.style.display = 'none'; //Hack, this will stop transitions to animate
		this.style.top = '-30px';
		this.style.left = Math.floor(window.innerWidth * Math.random()) + 'px';
		var sec = Math.floor((20-5) * Math.random() + 5) + 's';
		this.style.transition = 'top ' + sec + ' linear';

		var o = this;
		window.setTimeout(function () { //More hack, this will definitely break.
			o.style.display = 'block';
			window.setTimeout(function () {
				o.style.top = window.innerHeight + 'px';
			}, 500);
		}, 500);
	}
}

function startAnimation() { //Here, we start our bad stuff.
	var date = new Date();
	var m = date.getMonth();
	if (m == 11 || m == 0) {
		startWinter();

		this.remove();
		window.setTimeout(function () {
			for (var i = 0; i < 10; i++) {
				flakes[i].style.top = window.innerHeight +'px';
			};
		}, 100);
	}
}

//Bad, hacky check to see if this browser supports what we do here .~.
var tte = document.createElement('img');
tte.setAttribute('src', '/Files/snowflake.svg');
tte.style.transition = 'transform 0.1s linear';
tte.style.width = '0px';
tte.style.height = '0px';
tte.addEventListener("transitionend", startAnimation);
document.body.appendChild(tte);

window.setTimeout(function () {
	tte.style.transform = 'rotate(90deg)';
}, 100);
