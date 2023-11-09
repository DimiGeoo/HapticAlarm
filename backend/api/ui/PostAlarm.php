<?php
require_once "./../../../../../config/config.php";
$mysqli = new mysqli($HOST, $USER, $PASS, $DB, null, $SOCKET);

if ($mysqli->connect_error) {
    die('Connect Error (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the JSON data from the request
    $json = file_get_contents('php://input');
    $data = json_decode($json);

    if ($data === null) {
        // Return a JSON error response with status code 400 (Bad Request)
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Invalid JSON data']);
        exit;
    }

    // Extract the fields from the JSON data
    $newTime = $data->Time; // New time
    $newStatus = $data->Status; // New status
    $newFrequency = $data->Frequency; // New frequency
    $newType = $data->Type; // New type

    // Prepare and execute the SQL query to insert the new record
    $query = "INSERT INTO Scheduler (Time, Status, Frequency, Type) VALUES (?, ?, ?, ?)";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param('ssss', $newTime, $newStatus, $newFrequency, $newType);
    $result = $stmt->execute();

    if ($result) {
        // Record inserted successfully
        echo json_encode(['success' => true, 'message' => 'Record inserted successfully']);
    } else {
        // Return a JSON error response with status code 400 (Bad Request)
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Query error: ' . $mysqli->error]);
    }

    // Close the prepared statement
    $stmt->close();
} else {
    // Invalid request method
    // Return a JSON error response with status code 400 (Bad Request)
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
}

// Close the database connection
$mysqli->close();
