<?php
	header('Content-Type: application/json; charset=utf-8');
	
	$db;
	include('connection.php');
	
	$login = $_GET['login'];
	$password = $_GET['password'];
	
	$request = 'SELECT password FROM users WHERE login = \'' . $login . '\'';
	
	try {
		$stmt = $db->query($request);
		$res = $stmt->fetchAll(PDO::FETCH_ASSOC);
		if ($res[0]["password"] == $password) {
			echo json_encode(['status' => 'success']);
		} else {
			echo json_encode(['status' => 'error']);
		}
	} catch (PDOException $e) {
		echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
	}
?>