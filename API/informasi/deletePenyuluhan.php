<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['id_penyuluhan']) && !empty($_POST['id_penyuluhan'])) {
        $id_penyuluhan = $_POST['id_penyuluhan'];

        // Menggunakan prepared statement untuk keamanan
        $stmt = $koneksi->prepare("DELETE FROM penyuluhan WHERE id_penyuluhan = ?");
        $stmt->bind_param("s", $id_penyuluhan);

        if ($stmt->execute()) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil menghapus data penyuluhan";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal menghapus data penyuluhan: " . $stmt->error;
        }

        $stmt->close();
    } else {
        $response['isSuccess'] = false;
        $response['message'] = "Parameter tidak lengkap";
    }
} else {
    $response['isSuccess'] = false;
    $response['message'] = "Metode yang diperbolehkan hanya POST";
}

echo json_encode($response);
?>
