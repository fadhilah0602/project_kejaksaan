<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['id_jms']) && !empty($_POST['id_jms'])) {
        $id_jms = $_POST['id_jms'];

        // Menggunakan prepared statement untuk keamanan
        $stmt = $koneksi->prepare("DELETE FROM jms WHERE id_jms = ?");
        $stmt->bind_param("s", $id_jms);

        if ($stmt->execute()) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil menghapus data jms";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal menghapus data jms: " . $stmt->error;
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
