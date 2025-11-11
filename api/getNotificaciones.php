<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: http://localhost:5173');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include "db.php";

$response = ['success' => false, 'notificaciones' => []];

$usuario_id = $_GET['usuario_id'] ?? '';

if ($usuario_id) {
    try {
        // CONSULTA ACTUALIZADA con nueva estructura
        $stmt = $conn->prepare("
            SELECT 
                n.id,
                n.mensaje,
                n.tipo as tipo_notificacion,
                n.leida,
                n.estado as estado_notificacion,
                n.fecha_creacion,
                n.emergencia_id,
                -- Información de la emergencia relacionada
                e.titulo as emergencia_titulo,
                e.tipo as emergencia_tipo,
                e.prioridad as emergencia_prioridad,
                e.estado as emergencia_estado,
                e.ubicacion as emergencia_ubicacion,
                e.latitud as emergencia_latitud,
                e.longitud as emergencia_longitud,
                e.fecha_creacion as emergencia_fecha_creacion,
                -- Información del conductor asignado (si existe)
                uc.nombre as conductor_asignado_nombre
            FROM notificaciones n
            LEFT JOIN emergencias e ON n.emergencia_id = e.id
            LEFT JOIN usuarios uc ON e.conductor_asignado = uc.id
            WHERE n.usuario_id = ?
            ORDER BY n.fecha_creacion DESC
            LIMIT 50
        ");
        
        $stmt->bind_param("i", $usuario_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $notificaciones = [];
        while ($row = $result->fetch_assoc()) {
            $notificaciones[] = $row;
        }

        $response['success'] = true;
        $response['notificaciones'] = $notificaciones;
        
    } catch (Exception $e) {
        $response['message'] = 'Error en la consulta: ' . $e->getMessage();
    }
    
    $stmt->close();
} else {
    $response['message'] = 'Falta el parámetro usuario_id';
}

echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
$conn->close();
?>