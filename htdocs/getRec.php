<?php
/*
* ok, so this is clearly a very basic and simple script, real apps would use a framework such as
* symfony, laravel or similar for organization, security etc, include more validation, have clearer 
* separation of concerns (e.g. mvc) and an orm or similar (e.g. pdo) for abstraction. I also did not
* use php mysqli but used older php mysql to keep it simple for myself and the reviewer...but for this 
* exercise I hope it illustrates enough for the reviewer
* Also this file would typically not be in htdocs but in an apps folder inaccessible.
*
* This script functions as a simple rest api for retrieving data. Data is returned as a simple json array.
* The script responds with http codes as follows:
*  200 OK - one or more events are found
*  400    - bad data passed (see comments just below)
*  404    - no events found for params passed
*  500    - server error
* The script expects an email passed as Get Param 'email' and date as Get Param 'date' in form of yyyy-mm-dd. 
*  email is required
*  date is optional and if not passed is defaulted to '2011-11-14'
*/

// email is required, return 400 if not passed in
if (!isset($_GET["email"])) {
	echo "Email required";
	header($_SERVER["SERVER_PROTOCOL"] . ' 400 Bad Request');
	exit();
}
$rawEmailToCheckFor = htmlspecialchars($_GET["email"]);

// date is optional so default if not passed
if (isset($_GET["date"])) {
	$rawDateToCheckFor = htmlspecialchars($_GET["date"]);
} else {
	$rawDateToCheckFor = '2011-11-14';
}

// here we would certainly perform more validation of email and date, but for now only noting that for this exercise

// get a connnection for mysql at localhost 
// I am just using userid root on my local home computer. Obviously would not do so for a real app
//
$conn = mysql_connect("localhost", "root", "");
if (!$conn) {
	header($_SERVER["SERVER_PROTOCOL"] . ' 500 Internal Server Error');
	exit();
}
// select the database
if (!mysql_select_db("referrals")) {
	header($_SERVER["SERVER_PROTOCOL"] . ' 500 Internal Server Error');
	exit();
}

// escape special characters from validate input params
$emailToCheckFor = mysql_real_escape_string($rawEmailToCheckFor, $conn);
$dateToCheckFor = mysql_real_escape_string($rawDateToCheckFor, $conn);

// call getrecommendations stored procedure to run query to find recommended events
// 'supersize@subrational.com'
//
$result = mysql_query("call getrecommendations('$emailToCheckFor', '$dateToCheckFor');");
if (!$result) {
	header($_SERVER["SERVER_PROTOCOL"] . ' 500 Internal Server Error');
	exit();
}

// if no rows found then return return 404
if (mysql_num_rows($result) == 0) {
	echo "Zero events found";
	header($_SERVER["SERVER_PROTOCOL"] . ' 404 Not Found');
	exit();
}

// loop through rows returned and put into a simple array
$events = array();
while ($row = mysql_fetch_assoc($result)) {
    $events[] = $row["event_id"];
}

// free memory, note: conn will close on exit
mysql_free_result($result);

// set headers and content as json
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

// return data as simple json array
echo json_encode($events);

// status is 200 OK
header($_SERVER["SERVER_PROTOCOL"] . ' 200 OK');
exit();
