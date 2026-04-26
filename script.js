API_URL = '';

if (localStorage['foolsEdition'] != 2026) {
	localStorage['userToken'] = '';
	localStorage['userName'] = '';
	localStorage['foolsEdition'] = 2026;
}

ACHIEVEMENTS = [
	// 100*10+ 40+40+40+40+40+50+50 +10+17+10
    [
        "Ultra secure vault",
        "Complete Hacking Challenge III (10 points)"
    ],
    [
        "Amazeing",
        "Finish the first puzzle room (40 points)"
    ],
    [
        "Mind the gap",
        "Finish the second puzzle room (40 points)"
    ],
    [
        "Item duplication",
        "Finish the third puzzle room (40 points)"
    ],
    [
        "Illusion of choice",
        "Finish the fourth puzzle room (40 points)"
    ],
    [
        "Phenomenal Phantom Thief",
        "Finish the fifth puzzle room (40 points)"
    ],
    [
        "When I climb",
        "Reach floor 100 (50 points)"
    ],
    [
        "Zzazzity Forest",
        "Reach floor 100 without using checkpoints, savestates, pausing, or saving (50 points)"
    ],
    [
        "A cut above the rest",
        "Complete Hacking Challenge I (10 points)"
    ],
    [
        "Certified hacker",
        "Complete Hacking Challenge II (17 points)"
    ]
];

function formatTimeDiff(diff){
    var time_split = [];
    time_split.push(diff % 60);
    diff = Math.floor(diff / 60);
    time_split.push(diff % 60);
    diff = Math.floor(diff / 60);
    time_split.push(diff % 24);
    diff = Math.floor(diff / 24);
    time_split.push(diff);
    time_split.reverse();
    var suffixes = ["days", "hours", "minutes", "seconds"];
    for (var i=0; i<suffixes.length; i++){
        suffixes[i] = time_split[i] + " " + suffixes[i];
    }
    return suffixes.join(", ");
}

function updateTimers(){
    var now = parseInt(+new Date() / 1000);
    var untilEventEnd = 1776592800 - now;
    if (untilEventEnd > 0){
        $('#countdown').html(formatTimeDiff(untilEventEnd) + " until the end of the event.");
    } else {
        $('#countdown').html("The event has ended. Thanks for participating!");
    }
}

function apiHit(data, fsucc, ffail) {
    $.get("leaderboard.json", {"d": JSON.stringify(data)}).done(fsucc).fail(ffail);
}

function entities(s){
    return $('<div>').text(s).html();
}

function getAchi(index, condition) {
	if (condition) return "<img src='achi/c" + index + ".png' class='achi-y' data-tooltip='" + index + "'>";
	else return "<img src='achi/c" + index + ".png' class='achi-n' data-tooltip='" + index + "'>";
}

function getAchiStr(ent) {
	var achievements = "";
	achievements += getAchi(1, ent['highestFloor'] > 10);
	achievements += getAchi(2, ent['highestFloor'] > 20);
	achievements += getAchi(3, ent['highestFloor'] > 30);
	achievements += getAchi(4, ent['highestFloor'] > 50);
	achievements += getAchi(5, ent['highestFloor'] > 70);
	achievements += getAchi(6, ent['highestFloor'] >= 100);
	achievements += getAchi(7, ent['achievementBits'] & 1);
	achievements += getAchi(8, ent['achievementBits'] & 2);
	achievements += getAchi(9, ent['achievementBits'] & 4);
	achievements += getAchi(0, ent['achievementBits'] & 8);
	return achievements;
}

function updateAchievementTooltips(){
    $('[data-tooltip]').each(function(a, e){
        var achievement = ACHIEVEMENTS[parseInt(e.getAttribute('data-tooltip'))];
        e.setAttribute('data-tooltip-content', "<div class='tc'><b>" + achievement[0] + "</b><br><span class='tt'>" + achievement[1] + "</span></div>");
        e.title = e.getAttribute('data-tooltip-content');
        $(e).tooltip({html: true});
        e.title = '';
    });
}

function getSmolLeaderboard() {
    apiHit({
        "r": "leaderboard"
    }, function(r) {
        if (r['error']) {
            alert(r['msg']);
            return;
        }
        if (r['data'].length == 0) {
            $("#leaderboard").html("<table><tr><td><i>You're so early, there's no one here yet!</i></td></tr></table>");
            return;
        }
        var tbl = [
            "<tr>",
            "<th style='width:60px'>#</th>",
            "<th>Username</th>",
            "<th>Score</th>",
            "<th>Highest floor</th>",
            "<th colspan='8' style='width:250px'>Achievements</th>",
            "</tr>"
        ];
        for (var i=0; i<r['data'].length; i++) {
            var ent = r['data'][i];
            tbl.push("<tr class='" + (ent['username'] == localStorage.userName ? 'me' : '') + "'><td>#" + (i+1) + "</td><td><b>" + entities(ent['username']) + "</b></td>");
            tbl.push("<td>" + parseInt(ent['score']) + "</td>");
            tbl.push("<td>" + parseInt(ent['highestFloor']) + "F</td>");
            tbl.push("<td style='line-height:18px'>" + getAchiStr(ent) + "</td>");
            tbl.push("</tr>");
        }
        $("#leaderboard").html("<table>" + tbl.join('') + "</table>");
		updateAchievementTooltips();
    }, function() {
        $("#leaderboard").html("Unable to connect to the server. <a href='index.html'>Retry?</a>");
    });
}

