<?php
    $db;
    include('connection.php');
    
    $table = $_GET['table'];
    $params = $_GET['params'];
    
    $parameters = str_replace('ǃǃ', ', ', $params);
    
    $request = 'INSERT INTO ' . $table . ' VALUES (default,' . $parameters . ')';
    
    try {
        $stmt = $db->query($request);
        echo json_encode(["status" => "success"]);
    } catch (PDOException $e) {
        echo json_encode(["error" => "Database error: " . $e->getMessage()]);
    }
?>
