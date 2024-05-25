<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['id_pengawasan']) && !empty($_POST['id_pengawasan'])) {
        $id_pengawasan = $_POST['id_pengawasan'];

        // Menggunakan prepared statement untuk keamanan
        $stmt = $koneksi->prepare("DELETE FROM pengawasan WHERE id_pengawasan = ?");
        $stmt->bind_param("s", $id_pengawasan);

        if ($stmt->execute()) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil menghapus data pengawasan";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal menghapus data pengawasan: " . $stmt->error;
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
