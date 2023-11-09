<?php
require_once "./../../../../../config/config.php";
$mysqli = new mysqli($HOST, $USER, $PASS, $DB, null, $SOCKET);

if ($mysqli->connect_error) {
    die('Connect Error (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
}

// Execute the SQL query and order the results by "Time" in ascending order
$query = "SELECT *
FROM Scheduler
WHERE Scheduler.Status='1' AND
 	JSON_CONTAINS(Frequency,  DAYOFWEEK(CURDATE())-1, '$') AND
	Time BETWEEN   CURRENT_TIME()  AND  ADDTIME(CURRENT_TIME(), '01:00:00')
ORDER BY Time ASC
LIMIT 1;
";
$result = $mysqli->query($query);

if ($result) {
    // Fetch the first result (the one with the shortest time)
    $row = $result->fetch_assoc();

    // Close the result set
    $result->close();

    // Close the database connection
    $mysqli->close();

    // Encode the data as JSON and send the JSON response
    header('Content-Type: application/json');
    echo json_encode($row);
} else {
    // Handle the query error
    echo 'Query error: ' . $mysqli->error;
}
?>
