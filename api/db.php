<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

$host = "localhost";
$user = "root";
$pass = "";
$db   = "gestion_transito";  // Cambié el nombre para que coincida con tu BD

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    // Devuelve error en formato JSON para el frontend
    die(json_encode([
        'success' => false, 
        'message' => 'Error de conexión a la base de datos: ' . $conn->connect_error
    ]));
}

// Configurar charset
$conn->set_charset("utf8");
?>