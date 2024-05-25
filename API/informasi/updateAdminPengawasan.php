<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Pastikan bahwa semua parameter yang diperlukan tersedia
    if (isset($_POST['id_pengawasan']) && isset($_POST['status'])) {
        $id_pengawasan = $_POST['id_pengawasan'];
        $status = $_POST['status'];

        $sql = "UPDATE pengawasan SET status='$status' WHERE id_pengawasan='$id_pengawasan'";
        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil mengedit status pengawasan aliran";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal mengedit status pengawasan aliran: " . $koneksi->error;
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
