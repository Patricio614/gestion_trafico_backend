<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: http://localhost:5173');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include 'db.php';

$response = ['success' => false, 'message' => ''];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Obtener datos del POST
    $emergencia_id = intval($_POST['emergencia_id'] ?? 0);
    $conductor_id = intval($_POST['conductor_id'] ?? 0);
    $ambulancia_id = intval($_POST['ambulancia_id'] ?? 0);
    
    error_log("📥 Aceptar emergencia - E: $emergencia_id, C: $conductor_id, A: $ambulancia_id");

    if ($emergencia_id > 0 && $conductor_id > 0 && $ambulancia_id > 0) {
        
        // INICIAR TRANSACCIÓN
        $conn->begin_transaction();
        
        try {
            // 1. ACTUALIZAR EMERGENCIA
            $stmt = $conn->prepare("
                UPDATE emergencias 
                SET conductor_asignado = ?, 
                    ambulancia_asignada = ?,
                    estado = 'asignada',
                    fecha_asignacion = CURRENT_TIMESTAMP 
                WHERE id = ? AND estado = 'pendiente'
            ");
            
            if (!$stmt->execute([$conductor_id, $ambulancia_id, $emergencia_id])) {
                throw new Exception('Error al actualizar emergencia: ' . $conn->error);
            }
            
            if ($stmt->affected_rows === 0) {
                throw new Exception('La emergencia ya está asignada o no existe');
            }

            // 2. ACTUALIZAR AMBULANCIA A OCUPADA
            $stmtAmbulancia = $conn->prepare("
                UPDATE ambulancias 
                SET estado = 'ocupada',
                    fecha_actualizacion = CURRENT_TIMESTAMP
                WHERE id = ?
            ");
            
            if (!$stmtAmbulancia->execute([$ambulancia_id])) {
                throw new Exception('Error al actualizar ambulancia: ' . $conn->error);
            }

            // 3. ACTUALIZAR CONDUCTOR A OCUPADO
            $stmtConductor = $conn->prepare("
                UPDATE usuarios 
                SET estado_operativo = 'Ocupado' 
                WHERE id = ?
            ");
            
            if (!$stmtConductor->execute([$conductor_id])) {
                throw new Exception('Error al actualizar conductor: ' . $conn->error);
            }

            // 4. CREAR NOTIFICACIÓN
            $stmtNotif = $conn->prepare("
                INSERT INTO notificaciones (usuario_id, emergencia_id, mensaje, tipo) 
                VALUES (?, ?, ?, 'emergencia_asignada')
            ");
            $stmtNotif->execute([
                $conductor_id, 
                $emergencia_id, 
                'Has aceptado una nueva emergencia'
            ]);

            // 5. REGISTRAR EN HISTORIAL
            $stmtHistorial = $conn->prepare("
                INSERT INTO historial_emergencias (emergencia_id, usuario_id, accion, detalles)
                VALUES (?, ?, 'asignada', 'Conductor aceptó la emergencia')
            ");
            $stmtHistorial->execute([$emergencia_id, $conductor_id]);
            
            // CONFIRMAR TRANSACCIÓN
            $conn->commit();
            
            $response['success'] = true;
            $response['message'] = 'Emergencia aceptada correctamente';
            error_log("✅ Emergencia $emergencia_id aceptada - Conductor: $conductor_id, Ambulancia: $ambulancia_id");
            
        } catch (Exception $e) {
            // REVERTIR en caso de error
            $conn->rollback();
            $response['message'] = $e->getMessage();
            error_log("❌ Error en aceptarEmergencia: " . $e->getMessage());
        }
    } else {
        $response['message'] = 'Datos incompletos o inválidos';
        error_log("❌ Datos inválidos - E: $emergencia_id, C: $conductor_id, A: $ambulancia_id");
    }
} else {
    $response['message'] = 'Método no permitido';
}

echo json_encode($response);
?>