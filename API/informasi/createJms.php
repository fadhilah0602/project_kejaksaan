 <?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include 'koneksi.php';

$response = array();

// Periksa metode permintaan
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Periksa apakah parameter lengkap
    if (isset($_POST['id_user']) && isset($_POST['nama_pemohon']) && isset($_POST['sekolah'])) {
        $id_user = $_POST['id_user'];
        $nama_pemohon = $_POST['nama_pemohon'];
        $sekolah = $_POST['sekolah'];
        $status = 'Pending'; // Set status default

        // Gunakan prepared statements untuk menghindari SQL Injection
        $stmt = $koneksi->prepare("INSERT INTO jms (id_user, nama_pemohon, sekolah, status) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("isss", $id_user, $nama_pemohon, $sekolah, $status);

        if ($stmt->execute()) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil menambahkan JMS";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal menambahkan JMS: " . $stmt->error;
        }

        $stmt->close();
    } else {
        $response['isSuccess'] = false;
        $response['message'] = "Parameter tidak lengkap";
    }
} else {
    $response['isSuccess'] = false;
    $response['message'] = "Metode yang diperbolehkan hanya POST";
}

echo json_encode($response);

$koneksi->close();
?> 
