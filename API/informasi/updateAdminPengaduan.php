<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Pastikan bahwa semua parameter yang diperlukan tersedia
    if (isset($_POST['id_pengaduan']) && isset($_POST['status'])) {
        $id_pengaduan = $_POST['id_pengaduan'];
        $status = $_POST['status'];

        $sql = "UPDATE pengaduan SET status='$status' WHERE id_pengaduan='$id_pengaduan'";
        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil mengedit status pengaduan";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal mengedit status pengaduan: " . $koneksi->error;
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
