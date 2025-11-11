<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: http://localhost:5173');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db.php';

$response = ['success' => false, 'message' => ''];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $conductor_id = $_POST['conductor_id'] ?? '';
    $nuevo_estado = $_POST['estado'] ?? '';
    
    if (!empty($conductor_id) && !empty($nuevo_estado)) {
        $stmt = $conn->prepare("UPDATE usuarios SET estado_operativo = ? WHERE id = ?");
        
        if ($stmt->execute([$nuevo_estado, $conductor_id])) {
            $response['success'] = true;
            $response['message'] = 'Estado actualizado correctamente';
            error_log("Conductor $conductor_id actualizado a estado: $nuevo_estado");
        } else {
            $response['message'] = 'Error al actualizar estado: ' . $conn->error;
        }
    } else {
        $response['message'] = 'Datos incompletos';
    }
} else {
    $response['message'] = 'Método no permitido';
}

echo json_encode($response);
?>