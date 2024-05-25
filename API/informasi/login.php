<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

function kirimResponse($sukses, $status, $pesan, $data = null) {
    $response = [
        'sukses' => $sukses,
        'status' => $status,
        'pesan' => $pesan
    ];

    if ($data !== null) {
        $response['data'] = $data;
    }

    header('Content-Type: application/json');
    echo json_encode($response);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['login'])) {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $result = loginUser($koneksi, $email, $password);
    echo $result;
}

function loginUser($koneksi, $email, $password) {
    $query = "SELECT * FROM users WHERE email='$email'";
    $result = mysqli_query($koneksi, $query);

    if (mysqli_num_rows($result) == 1) {
        $row = mysqli_fetch_assoc($result);
        if (password_verify($password, $row['password'])) {
            // Pengguna berhasil login, dapatkan id_user
            $id_user = $row['id_user'];
            
            // Masukkan id_user ke dalam session atau token untuk digunakan nanti
            // Contoh: $_SESSION['id_user'] = $id_user;
            
            // Response berhasil login
            $response = [
                'sukses' => true,
                'status' => 200,
                'pesan' => 'Login berhasil',
                'data' => $row
            ];
        } else {
            $response = [
                'sukses' => false,
                'status' => 401,
                'pesan' => 'Login gagal, username atau password salah',
                'data'=> null
            ];
        }
    } else {
        $response = [
            'sukses' => false,
            'status' => 401,
            'pesan' => 'Login gagal, username atau password salah',
            'data'=> null
        ];
    }

    return json_encode($response);
}
?>
