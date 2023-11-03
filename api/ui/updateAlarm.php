<?php
require_once "./../../../../../config/config.php";
$mysqli = new mysqli($HOST, $USER, $PASS, $DB, null, $SOCKET);

if ($mysqli->connect_error) {
    die('Connect Error (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the JSON payload from the request body
    $jsonPayload = file_get_contents("php://input");

    // Decode the JSON data
    $data = json_decode($jsonPayload, true);

    // Check if 'id' is valid
    if (!isset($data['id']) || !is_numeric($data['id']) || $data['id'] <= 0) {
        http_response_code(400); // Bad Request
        echo json_encode(['success' => false, 'message' => 'Invalid ID']);
        exit;
    }

    // Extract data from the JSON request body
    $id = $data['id'];
    $newStatus = $data['Status'];
    $newTime = $data['Time'];
    $newFrequency = $data['Frequency'];
    $newType = $data['Type'];

    // Prepare and execute the SQL query to update the record
    $query = "UPDATE Scheduler SET Status = ?, Time = ?, Frequency = ?, Type = ? WHERE uid = ?";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param('ssssi', $newStatus, $newTime, $newFrequency, $newType, $id);
    $result = $stmt->execute();

    if ($result) {
        // Record updated successfully
        echo json_encode(['success' => true, 'message' => 'Record updated successfully']);
    } else {
        http_response_code(400); // Bad Request
        echo json_encode(['success' => false, 'message' => 'Query error: ' . $mysqli->error]);
    }

    $stmt->close();
} else {
    // Invalid request method
    http_response_code(400); // Bad Request
    echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
}

$mysqli->close();
?>
