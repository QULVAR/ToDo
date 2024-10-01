<?php
    $db;
    include('connection.php');
    
    $table = $_GET['table'];
    $condition = $_GET['condition'];
    
    $request = 'DELETE FROM ' . $table . ' WHERE ' . $condition;
    
    try {
        $stmt = $db->query($request);
        echo json_encode(["status" => "success"]);
    } catch (PDOException $e) {
        echo json_encode(["error" => "Database error: " . $e->getMessage()]);
    }
?>
