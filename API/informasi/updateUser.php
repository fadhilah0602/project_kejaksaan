<?php

header("Access-Control-Allow-Origin: *");
include 'koneksi.php';

if($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array();
    
    // Memeriksa keberadaan data POST yang diperlukan
    if(isset($_POST['id_user']) && isset($_POST['nama']) && isset($_POST['email']) && isset($_POST['no_telp']) && isset($_POST['ktp']) && isset($_POST['alamat'])) {
        $id_user = $_POST['id_user'];
        $nama = $_POST['nama'];
        $email = $_POST['email']; 
        $no_telp = $_POST['no_telp'];
        $ktp = $_POST['ktp'];
        $alamat = $_POST['alamat'];

        $sql = "UPDATE users SET nama = '$nama', email = '$email', no_telp = '$no_telp', ktp = '$ktp', alamat = '$alamat' WHERE id_user = $id_user";
        $isSuccess = $koneksi->query($sql);

        if ($isSuccess) {
            $cek = "SELECT * FROM users WHERE id_user = $id_user";
            $result = mysqli_fetch_array(mysqli_query($koneksi, $cek));
            $response['is_success'] = true;
            $response['value'] = 1;
            $response['message'] = "User Berhasil di Edit";
            $response['nama'] = $result['nama'];
            $response['email'] = $result['email']; 
            $response['no_telp'] = $result['no_telp']; 
            $response['ktp'] = $result['ktp']; 
            $response['alamat'] = $result['alamat']; 
            $response['id_user'] = $result['id_user'];
        } else {
            $response['is_success'] = false;
            $response['value'] = 0;
            $response['message'] = "Gagal Edit User: " . $koneksi->error; // Menampilkan pesan kesalahan
        }
    } else {
        // Jika salah satu data POST tidak lengkap
        $response['is_success'] = false;
        $response['value'] = 0;
        $response['message'] = "Data yang diperlukan tidak lengkap";
    }

    echo json_encode($response);
}

?>
