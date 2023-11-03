<?php
require_once "./../../../../../config/config.php";

$mysqli = new mysqli($HOST, $USER, $PASS, $DB, null, $SOCKET);

if ($mysqli->connect_error) {
    die('Connect Error (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
}

// Execute the SQL query
$query = "SELECT * FROM Scheduler";
$result = $mysqli->query($query);

if ($result) {
    // Fetch the results and store them in an array
    $data = array();
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    // Close the result set
    $result->close();

    // Close the database connection
    $mysqli->close();

    // Encode the data as JSON and send the JSON response
    header('Content-Type: application/json');
    echo json_encode($data);
} else {
    // Handle the query error
    echo 'Query error: ' . $mysqli->error;
}

?>

