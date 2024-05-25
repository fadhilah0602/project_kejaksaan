<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Pastikan bahwa semua parameter yang diperlukan tersedia
    if (isset($_POST['id_jms']) && isset($_POST['status'])) {
        $id_jms = $_POST['id_jms'];
        $status = $_POST['status'];

        $sql = "UPDATE jms SET status='$status' WHERE id_jms='$id_jms'";
        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil mengedit status jms";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal mengedit status jms: " . $koneksi->error;
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
