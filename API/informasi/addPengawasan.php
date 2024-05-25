<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

$response = array('isSuccess' => false, 'message' => 'Unknown error occurred');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['id_user']) && isset($_POST['laporan']) && isset($_POST['ktp']) && isset($_POST['nama_pelapor']) && isset($_POST['no_hp'])) {
        $id_user = $_POST['id_user'];
        $laporan = $_POST['laporan'];
        $ktp = $_POST['ktp'];
        $nama_pelapor = $_POST['nama_pelapor'];
        $no_hp = $_POST['no_hp'];
        $status = "Pending";

        $laporan_pdfPath = isset($_FILES['laporan_pdf']['name']) ? $_FILES['laporan_pdf']['name'] : '';
        // Handle file upload
        if (!empty($_FILES['laporan_pdf']['name'])) {
            $fileError = $_FILES['laporan_pdf']['error'];
            if ($fileError === UPLOAD_ERR_OK) {
                $targetDir = "uploads/";
                $targetFilePath = $targetDir . basename($_FILES["laporan_pdf"]["name"]);
                $fileType = strtolower(pathinfo($targetFilePath, PATHINFO_EXTENSION));
                // Allow certain file formats
                $allowed = array('pdf', 'png', 'jpg', 'jpeg');
                if (in_array($fileType, $allowed)) {
                    // Upload file to server
                    if (move_uploaded_file($_FILES["laporan_pdf"]["tmp_name"], $targetFilePath)) {
                        $laporan_pdf = $targetFilePath; // Update laporan_pengaduan_pdf path to use in SQL
                    } else {
                        $response['message'] = "Sorry, there was an error uploading your file.";
                        echo json_encode($response);
                        exit;
                    }
                } else {
                    $response['message'] = "Sorry, only PDF, JPG, JPEG, & PNG files are allowed.";
                    echo json_encode($response);
                    exit;
                }
            } else {
                $response['message'] = "Error uploading file: " . $fileError;
                echo json_encode($response);
                exit;
            }
        } else {
            // Use existing laporan_pengaduan_pdf path if new laporan_pengaduan_pdf is not uploaded
            $sql = "SELECT laporan_pdf FROM pengawasan WHERE id_pengawasan = '$id_pengawasan'";
            $result = $koneksi->query($sql);
            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                $laporan_pdf = $row['laporan_pdf'];
            } else {
                $response['message'] = "No record found to update.";
                echo json_encode($response);
                exit;
            }
        }
        
        // Handle file upload for ktp_pdf
        $ktp_pdfPath = isset($_FILES['ktp_pdf']['name']) ? $_FILES['ktp_pdf']['name'] : '';
        if (!empty($_FILES['ktp_pdf']['name'])) {
            $fileError = $_FILES['ktp_pdf']['error'];
            if ($fileError === UPLOAD_ERR_OK) {
                $targetDir = "uploads/";
                $targetFilePath = $targetDir . basename($_FILES["ktp_pdf"]["name"]);
                $fileType = strtolower(pathinfo($targetFilePath, PATHINFO_EXTENSION));
                // Allow certain file formats
                $allowed = array('pdf', 'png', 'jpg', 'jpeg');
                if (in_array($fileType, $allowed)) {
                    // Upload file to server
                    if (move_uploaded_file($_FILES["ktp_pdf"]["tmp_name"], $targetFilePath)) {
                        $ktp_pdf = $targetFilePath; // Update ktp_pdf path to use in SQL
                    } else {
                        $response['message'] = "Sorry, there was an error uploading your file.";
                        echo json_encode($response);
                        exit;
                    }
                } else {
                    $response['message'] = "Sorry, only PDF, JPG, JPEG, & PNG files are allowed.";
                    echo json_encode($response);
                    exit;
                }
            } else {
                $response['message'] = "Error uploading file: " . $fileError;
                echo json_encode($response);
                exit;
            }
        } else {
            // Use existing ktp_pdf path if new ktp_pdf is not uploaded
            $sql = "SELECT ktp_pdf FROM pengawasan WHERE id_pengawasan = '$id_pengawasan'";
            $result = $koneksi->query($sql);
            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                $ktp_pdf = $row['ktp_pdf'];
            } else {
                $response['message'] = "No record found to update.";
                echo json_encode($response);
                exit;
            }
        }

        $sql = "INSERT INTO pengawasan (id_user, laporan_pdf, ktp_pdf, laporan, ktp, nama_pelapor, no_hp, status) 
        VALUES ('$id_user', '$laporan_pdf', '$ktp_pdf', '$laporan', '$ktp', '$nama_pelapor', '$no_hp', '$status')";

        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil manambah data pengawasan aliran";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal menambah data pengawasan aliran: " . $koneksi->error;
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
