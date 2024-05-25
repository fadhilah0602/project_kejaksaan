<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Pastikan bahwa semua parameter yang diperlukan tersedia
    if (isset($_POST['id_jms']) && isset($_POST['nama_pemohon']) && isset($_POST['sekolah'])) {
        $id_jms = $_POST['id_jms'];
        $nama_pemohon = $_POST['nama_pemohon'];
        $sekolah = $_POST['sekolah'];

        $sql = "UPDATE jms SET nama_pemohon='$nama_pemohon', sekolah='$sekolah' WHERE id_jms='$id_jms'";
        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil mengedit data pegawai";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal mengedit data pegawai: " . $koneksi->error;
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
