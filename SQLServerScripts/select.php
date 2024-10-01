<?php
    header('Content-Type: application/json; charset=utf-8');
    
    $db;
    include('connection.php');
    
    $table = $_GET['table'];
    $params = $_GET['params'];
    $condition = isset($_GET['condition']) ? $_GET['condition'] : '';
    
    $request = 'SELECT ' . $params . ' FROM ' . $table;
    
    if ($condition != '') {
        $request .= ' WHERE ' . $condition;
    }
    
    try {
        $stmt = $db->query($request);
        echo json_encode(['status' => 'success', 'result' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
?>
