<?php
    $db;
    include('connection.php');
    
    $table = $_GET['table'];
    $params = $_GET['params'];
    $condition = $_GET['condition'];
    
    $paramsArr = explode('ǃǃ', $params);
    $set = [];
    foreach ($paramsArr as $key => $value) {
        $value = explode('ǃ', $value);
        $set[] = $value[0] . ' = '. $value[1];
    }
    
    $setParams = implode(", ", $set);
    
    $request = 'UPDATE ' . $table . ' SET ' . $setParams . ' WHERE ' . $condition;
    
    try {
        $stmt = $db->query($request);
        echo json_encode(["status" => "success"]);
    } catch (PDOException $e) {
        echo json_encode(["error" => "Database error: " . $e->getMessage()]);
    }
?>
