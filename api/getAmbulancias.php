<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: http://localhost:5173');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include "db.php";

$response = ['success' => false, 'ambulancias' => []];

try {
    $sql = "
        SELECT 
            a.id,
            a.conductor_id,
            a.patente,
            a.modelo,
            a.tipo,
            a.ubicacion_actual,
            a.estado,
            a.latitud,
            a.longitud,
            a.fecha_actualizacion,
            u.nombre as conductor_nombre,
            u.tipo as conductor_tipo,
            -- Campo compatible con React
            CASE 
                WHEN a.estado = 'disponible' THEN 1 
                ELSE 0 
            END as disponible
        FROM ambulancias a
        LEFT JOIN usuarios u ON a.conductor_id = u.id
        ORDER BY a.estado, a.patente
    ";
    
    $result = $conn->query($sql);
    
    if ($result) {
        $ambulancias = [];
        while ($row = $result->fetch_assoc()) {
            $ambulancias[] = $row;
        }
        
        $response['success'] = true;
        $response['ambulancias'] = $ambulancias;
    } else {
        $response['message'] = 'Error en la consulta: ' . $conn->error;
    }
    
} catch (Exception $e) {
    $response['message'] = 'Error: ' . $e->getMessage();
}

echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
$conn->close();
?>