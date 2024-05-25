<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Pastikan bahwa semua parameter yang diperlukan tersedia
    if (isset($_POST['id_korupsi']) && isset($_POST['status'])) {
        $id_korupsi = $_POST['id_korupsi'];
        $status = $_POST['status'];

        $sql = "UPDATE korupsi SET status='$status' WHERE id_korupsi='$id_korupsi'";
        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil mengedit status tindak korupsi";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal mengedit status tindak korupsi: " . $koneksi->error;
        }
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
