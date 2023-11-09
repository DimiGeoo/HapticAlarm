<?php
require_once "./../../../../../config/config.php";

$mysqli = new mysqli($HOST, $USER, $PASS, $DB, null, $SOCKET);

if ($mysqli->connect_error) {
    die('Connect Error (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    // Get the ID to delete from the URL parameters
    $id = $_GET['id'];

    if (!is_numeric($id) || $id <= 0) {
        // Return a JSON error response with status code 400 (Bad Request)
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Invalid ID']);
        exit;
    }

    // Prepare and execute the SQL query to delete the record with the given ID
    $query = "DELETE FROM Scheduler WHERE uid = ?";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param('i', $id);
    $result = $stmt->execute();

    if ($result) {
        // Record deleted successfully
        echo json_encode(['success' => true, 'message' => 'Record deleted successfully']);
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
