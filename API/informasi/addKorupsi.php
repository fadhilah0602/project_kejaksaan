<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

$response = array('isSuccess' => false, 'message' => 'Unknown error occurred');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['id_user']) && isset($_POST['laporan']) && isset($_POST['ktp']) && isset($_POST['nama_pelapor']) && isset($_POST['no_hp']) && isset($_POST['uraian'])) {
        $id_user = $_POST['id_user'];
        $laporan = $_POST['laporan'];
        $ktp = $_POST['ktp'];
        $nama_pelapor = $_POST['nama_pelapor'];
        $no_hp = $_POST['no_hp'];
        $uraian = $_POST['uraian'];
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
            $sql = "SELECT laporan_pdf FROM korupsi WHERE id_korupsi = '$id_korupsi'";
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
            $sql = "SELECT ktp_pdf FROM korupsi WHERE id_korupsi = '$id_korupsi'";
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

        $sql = "INSERT INTO korupsi (id_user, laporan_pdf, ktp_pdf, laporan, ktp, nama_pelapor, no_hp, status, uraian) 
        VALUES ('$id_user', '$laporan_pdf', '$ktp_pdf', '$laporan', '$ktp', '$nama_pelapor', '$no_hp', '$status', '$uraian')";

        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil manambah data pidana korupsi";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal menambah data pidana korupsi: " . $koneksi->error;
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

// header("Access-Control-Allow-Origin: *");

// include 'koneksi.php';

// $response = array();

// define('UPLOAD_DIR_KTP', __DIR__ . '/upload/ktp/');
// define('UPLOAD_DIR_LAPORAN', __DIR__ . '/upload/laporan/');
// define('MAX_FILE_SIZE', 2 * 1024 * 1024); // 2 MB

// if ($_SERVER['REQUEST_METHOD'] === 'POST') {
//     $id_user = $_POST['id_user'];
//     $nama_pelapor = $_POST['nama_pelapor'];
//     $no_hp = $_POST['no_hp'];
//     $ktp = $_POST['ktp'];
//     $laporan = $_POST['laporan'];

//     // File upload handling
//     $ktp_pdf = $_FILES['ktp_pdf'];
//     $laporan_pdf = $_FILES['laporan_pdf'];
    
//     // Check file sizes
//     if ($ktp_pdf['size'] > MAX_FILE_SIZE || $laporan_pdf['size'] > MAX_FILE_SIZE) {
//         $response = [
//             'status' => 'error',
//             'message' => 'File size should not exceed 2 MB'
//         ];
//         echo json_encode($response);
//         exit();
//     }
    
//     // Ensure directories exist
//     if (!file_exists(UPLOAD_DIR_KTP) && !is_dir(UPLOAD_DIR_KTP)) {
//         mkdir(UPLOAD_DIR_KTP, 0777, true);
//     }
//     if (!file_exists(UPLOAD_DIR_LAPORAN) && !is_dir(UPLOAD_DIR_LAPORAN)) {
//         mkdir(UPLOAD_DIR_LAPORAN, 0777, true);
//     }
    
//     // Generate unique file names
//     $ktp_pdf_name = UPLOAD_DIR_KTP . uniqid() . '_' . basename($ktp_pdf['name']);
//     $laporan_pdf_name = UPLOAD_DIR_LAPORAN . uniqid() . '_' . basename($laporan_pdf['name']);
    
//     // Move uploaded files to target directories
//     if (move_uploaded_file($ktp_pdf['tmp_name'], $ktp_pdf_name) && move_uploaded_file($laporan_pdf['tmp_name'], $laporan_pdf_name)) {
//         $status = "Pending";
        
//         // Insert into database
//         $sql = "INSERT INTO pengaduan (id_user, nama_pelapor, no_hp, ktp, ktp_pdf, laporan, laporan_pdf, status) 
//                 VALUES ('$id_user', '$nama_pelapor', '$no_hp', '$ktp', '$ktp_pdf_name', '$laporan', '$laporan_pdf_name', '$status')";
        
//         if ($koneksi->query($sql) === TRUE) {
//             $response = [
//                 'status' => 'success',
//                 'message' => 'Pengaduan created successfully'
//             ];
//         } else {
//             $response = [
//                 'status' => 'error',
//                 'message' => 'Error: ' . $sql . '<br>' . $koneksi->error
//             ];
//         }
//     } else {
//         $response = [
//             'status' => 'error',
//             'message' => 'File upload failed'
//         ];
//     }
// }
// echo json_encode($response);
?>
