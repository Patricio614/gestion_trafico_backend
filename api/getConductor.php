<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: http://localhost:5173');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db.php';

$response = ['success' => false, 'message' => ''];

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $conductor_id = $_GET['id'] ?? '';
    
    if (!empty($conductor_id)) {
        $stmt = $conn->prepare("SELECT id, nombre, estado_operativo as estado, ambulancia_asignada FROM usuarios WHERE id = ?"); 
        $stmt->execute([$conductor_id]);
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            $conductor = $result->fetch_assoc();    
            $response['success'] = true;
            $response['conductor'] = $conductor;
        } else {
            $response['message'] = 'Conduct or no encontrado';
        }
    } else {
        $response['message'] = 'ID de conductor requerido';
    }
} else {
    $response['message'] = 'Método no permitido';
}

echo json_encode($response);
?>