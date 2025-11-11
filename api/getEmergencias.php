<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: http://localhost:5173');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include "db.php";

$response = ['success' => false, 'emergencias' => []];

try {
    // CONSULTA ACTUALIZADA con nueva estructura y joins
    $sql = "
        SELECT 
            e.id,
            e.titulo,
            e.tipo,
            e.prioridad,
            e.estado,
            e.ubicacion,
            e.descripcion,
            e.latitud,
            e.longitud,
            e.fecha_creacion,
            e.fecha_asignacion,
            e.fecha_completada,
            e.notas,
            e.conductor_asignado,
            e.ambulancia_asignada,
            e.creado_por,
            -- Información del conductor asignado
            uc.nombre as conductor_nombre,
            uc.email as conductor_email,
            uc.tipo as conductor_tipo,
            -- Información de la ambulancia asignada
            a.patente as ambulancia_patente,
            a.modelo as ambulancia_modelo,
            a.tipo as ambulancia_tipo,
            -- Información del creador
            ua.nombre as creador_nombre
        FROM emergencias e
        LEFT JOIN usuarios uc ON e.conductor_asignado = uc.id
        LEFT JOIN ambulancias a ON e.ambulancia_asignada = a.id
        LEFT JOIN usuarios ua ON e.creado_por = ua.id
        WHERE e.estado IN ('pendiente', 'asignada', 'en_camino', 'en_lugar')
        ORDER BY 
            CASE e.prioridad
                WHEN 'critica' THEN 1
                WHEN 'alta' THEN 2
                WHEN 'media' THEN 3
                WHEN 'baja' THEN 4
            END,
            e.fecha_creacion DESC
    ";
    
    $result = $conn->query($sql);
    
    if ($result) {
        $emergencias = [];
        while ($row = $result->fetch_assoc()) {
            $emergencias[] = $row;
        }
        
        $response['success'] = true;
        $response['emergencias'] = $emergencias;
    } else {
        $response['message'] = 'Error en la consulta: ' . $conn->error;
    }
    
} catch (Exception $e) {
    $response['message'] = 'Error: ' . $e->getMessage();
}

echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
$conn->close();
?>