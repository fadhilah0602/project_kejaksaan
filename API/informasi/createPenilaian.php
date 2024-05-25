<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Pastikan bahwa semua parameter yang diperlukan tersedia
    if (isset($_POST['id_user']) && isset($_POST['rating'])) {
        $id_user = $_POST['id_user'];
        $rating = $_POST['rating'];

        $sql = "INSERT INTO penilaian (id_user, rating) VALUES ('$id_user', '$rating')";
        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil menambahkan penilain";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal menambahkan penilaian: " . $koneksi->error;
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
