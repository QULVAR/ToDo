<?php
	header('Content-Type: application/json; charset=utf-8');
	
	$db;
	include('connection.php');
	
	$login = $_GET['login'];
	$password = $_GET['password'];
	$timestamp = $_GET['unix'];
	
	$request = 'SELECT * FROM users WHERE login = \'' . $login . '\'';
	
	try {
		$stmt = $db->query($request);
		$res = $stmt->fetchAll(PDO::FETCH_ASSOC);
		if ($res == []) {
			
			$request = 'INSERT INTO users VALUES (default, \'' . $login . '\', \'' . $password . '\', \'' . $timestamp . '\')';
			
			try {
				$stmt = $db->query($request);
				$request = 'SELECT id FROM users WHERE login = \'' . $login . '\'';
				$stmt = $db->query($request);
				$res = $stmt->fetchAll(PDO::FETCH_ASSOC);
				$request = 'INSERT INTO settings (user, language) VALUES (' . $res[0]["id"] . ', 1)';
				$stmt = $db->query($request);
				echo json_encode(["status" => "success"]);
			} catch (PDOException $e) {
				echo json_encode(["status" => "error", "error" => "Database error: " . $e->getMessage()]);
			}
		}
		else {
			echo json_encode(["status" => "error", "error" => 'Данный логин уже занят']);
		}
	} catch (PDOException $e) {
		echo json_encode(["status" => "error", "error" => 'Database error: ' . $e->getMessage()]);
	}
?>