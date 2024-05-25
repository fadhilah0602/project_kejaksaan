<?php

header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');

include 'koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    if (isset($_GET['id_user'])) {
        $id_user = $_GET['id_user'];

        // Query SQL untuk mengambil data JMS berdasarkan id_user
        $sql = "SELECT * FROM jms WHERE id_user = ?";
        
        // Persiapkan statement SQL
        $stmt = $koneksi->prepare($sql);

        // Bind parameter id_user ke statement SQL
        $stmt->bind_param("s", $id_user);

        // Eksekusi statement SQL
        $stmt->execute();

        // Dapatkan hasil dari eksekusi statement
        $result = $stmt->get_result();

        // Cek apakah ada baris data yang sesuai
        if($result->num_rows > 0) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil menampilkan data JMS";
            $response['data'] = array();

            // Ambil setiap baris hasil dan simpan dalam array data
            while ($row = $result->fetch_assoc()) {
                $response['data'][] = $row;
            }
        } else {
            // Jika tidak ada data yang sesuai
            $response['isSuccess'] = false;
            $response['message'] = "Tidak ada data JMS untuk pengguna ini";
            $response['data'] = [];
        }

        // Tutup statement
        $stmt->close();
    } else {
        // Jika id_user tidak diberikan
        $response['isSuccess'] = false;
        $response['message'] = "Parameter id_user tidak diberikan";
        $response['data'] = [];
    }
}

// Keluarkan respons dalam format JSON
echo json_encode($response);
?>
