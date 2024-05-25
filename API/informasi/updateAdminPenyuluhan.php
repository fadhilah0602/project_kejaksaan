<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Pastikan bahwa semua parameter yang diperlukan tersedia
    if (isset($_POST['id_penyuluhan']) && isset($_POST['status'])) {
        $id_penyuluhan = $_POST['id_penyuluhan'];
        $status = $_POST['status'];

        $sql = "UPDATE penyuluhan SET status='$status' WHERE id_penyuluhan='$id_penyuluhan'";
        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil mengedit status penyuluhan hukum";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal mengedit status penyuluhan hukum: " . $koneksi->error;
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
