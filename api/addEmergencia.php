<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin: http://localhost:5173');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include "db.php";

$response = ['success' => false, 'message' => ''];

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Campos actualizados según nueva estructura
    $tipo = $_POST['tipo'] ?? '';
    $titulo = $_POST['titulo'] ?? ''; // NUEVO campo requerido
    $ubicacion = $_POST['ubicacion'] ?? ''; // Cambio de nombre: direccion → ubicacion
    $descripcion = $_POST['descripcion'] ?? '';
    $lat = $_POST['latitud'] ?? ''; // Cambio de nombre: ubicacion_lat → latitud
    $lng = $_POST['longitud'] ?? ''; // Cambio de nombre: ubicacion_lng → longitud
    $prioridad = $_POST['prioridad'] ?? 'media'; // NUEVO campo
    $creado_por = $_POST['creado_por'] ?? 1; // NUEVO campo (ID del admin que crea)

    // Validar campos requeridos
    if ($tipo && $titulo && $ubicacion && $lat && $lng) {
        // CONSULTA ACTUALIZADA con nueva estructura
        $stmt = $conn->prepare("
            INSERT INTO emergencias 
            (titulo, tipo, prioridad, estado, ubicacion, descripcion, latitud, longitud, creado_por) 
            VALUES (?, ?, ?, 'pendiente', ?, ?, ?, ?, ?)
        ");
        
        $stmt->bind_param("sssssddi", $titulo, $tipo, $prioridad, $ubicacion, $descripcion, $lat, $lng, $creado_por);

        if ($stmt->execute()) {
            $emergencia_id = $conn->insert_id;
            
            // NUEVO: Crear notificación para conductores disponibles
            $stmtNotif = $conn->prepare("
                INSERT INTO notificaciones (usuario_id, emergencia_id, mensaje, tipo)
                SELECT id, ?, CONCAT('Nueva emergencia: ', ?), 'emergencia_nueva'
                FROM usuarios 
                WHERE tipo IN ('conductor_especial', 'conductor_comun') 
                AND estado = 'activo'
            ");
            $stmtNotif->bind_param("is", $emergencia_id, $titulo);
            $stmtNotif->execute();
            
            // NUEVO: Registrar en historial
            $stmtHistorial = $conn->prepare("
                INSERT INTO historial_emergencias (emergencia_id, usuario_id, accion, detalles)
                VALUES (?, ?, 'creada', 'Emergencia creada por administrador')
            ");
            $stmtHistorial->bind_param("ii", $emergencia_id, $creado_por);
            $stmtHistorial->execute();
            
            $response['success'] = true;
            $response['message'] = 'Emergencia registrada correctamente';
            $response['emergencia_id'] = $emergencia_id;
        } else {
            $response['message'] = 'Error al registrar emergencia: ' . $conn->error;
        }
        $stmt->close();
    } else {
        $response['message'] = 'Faltan datos requeridos';
    }
} else {
    $response['message'] = 'Método no permitido';
}

echo json_encode($response);
?>