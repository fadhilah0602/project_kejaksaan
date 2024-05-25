<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['id_korupsi']) && !empty($_POST['id_korupsi'])) {
        $id_korupsi = $_POST['id_korupsi'];

        // Menggunakan prepared statement untuk keamanan
        $stmt = $koneksi->prepare("DELETE FROM korupsi WHERE id_korupsi = ?");
        $stmt->bind_param("s", $id_korupsi);

        if ($stmt->execute()) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil menghapus data korupsi";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal menghapus data korupsi: " . $stmt->error;
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
