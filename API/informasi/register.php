<?php

header("Access-Control-Allow-Origin: header");
header("Access-Control-Allow-Origin: *");
include 'koneksi.php';

if($_SERVER['REQUEST_METHOD'] == "POST") {

    $response = array();
    $nama = $_POST['nama'];
    $email = $_POST['email'];
    $no_telp = $_POST['no_telp'];
    $ktp = $_POST['ktp'];
    $password = password_hash($_POST['password'], PASSWORD_BCRYPT); 
    $alamat = $_POST['alamat'];
    $role = 'Customers'; // Set role to 'Customers'

    $cek = "SELECT * FROM users WHERE nama = '$nama' OR email = '$email'"; 
    $result = mysqli_query($koneksi, $cek);

    if(mysqli_num_rows($result) > 0){ 
        $response['value'] = 2;
        $response['message'] = "Nama atau email telah digunakan";
        echo json_encode($response);
    } else {
        $insert = "INSERT INTO users (nama, email, no_telp, ktp, password, alamat, role) 
                   VALUES ('$nama', '$email', '$no_telp', '$ktp', '$password', '$alamat', '$role')";
        
        if(mysqli_query($koneksi, $insert)){
            $response['value'] = 1;
            $response['nama'] = $nama;
            $response['email'] = $email;
            $response['no_telp'] = $no_telp;
            $response['ktp'] = $ktp;
            $response['password'] = $password;
            $response['alamat'] = $alamat;
            $response['role'] = $role;
            $response['message'] = "Registrasi Berhasil";
            echo json_encode($response);
        } else {
            $response['value'] = 0;
            $response['message'] = "Gagal Registrasi";
            echo json_encode($response);
        }
    }
}

?>
