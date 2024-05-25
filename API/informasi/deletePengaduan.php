<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['id_pengaduan']) && !empty($_POST['id_pengaduan'])) {
        $id_pengaduan = $_POST['id_pengaduan'];

        // Menggunakan prepared statement untuk keamanan
        $stmt = $koneksi->prepare("DELETE FROM pengaduan WHERE id_pengaduan = ?");
        $stmt->bind_param("s", $id_pengaduan);

        if ($stmt->execute()) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil menghapus data pengaduan";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal menghapus data pengaduan: " . $stmt->error;
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
