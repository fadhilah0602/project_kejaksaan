<?php


header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

$response = array('isSuccess' => false, 'message' => 'Unknown error occurred');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['id_penyuluhan']) && isset($_POST['id_user']) && isset($_POST['permasalahan']) && isset($_POST['ktp']) && isset($_POST['nama']) && isset($_POST['no_hp'])) {
        $id_penyuluhan = $_POST['id_penyuluhan'];
        $id_user = $_POST['id_user'];
        $permasalahan = $_POST['permasalahan'];
        $ktp = $_POST['ktp'];
        $nama = $_POST['nama'];
        $no_hp = $_POST['no_hp'];
        $status = isset($_POST['status']) ? $_POST['status'] : '';

        $permasalahan_pdfPath = isset($_FILES['permasalahan_pdf']['name']) ? $_FILES['permasalahan_pdf']['name'] : '';
        // Handle file upload
        if (!empty($_FILES['permasalahan_pdf']['name'])) {
            $fileError = $_FILES['permasalahan_pdf']['error'];
            if ($fileError === UPLOAD_ERR_OK) {
                $targetDir = "uploads/";
                $targetFilePath = $targetDir . basename($_FILES["permasalahan_pdf"]["name"]);
                $fileType = strtolower(pathinfo($targetFilePath, PATHINFO_EXTENSION));
                // Allow certain file formats
                $allowed = array('pdf', 'png', 'jpg', 'jpeg');
                if (in_array($fileType, $allowed)) {
                    // Upload file to server
                    if (move_uploaded_file($_FILES["permasalahan_pdf"]["tmp_name"], $targetFilePath)) {
                        $permasalahan_pdf = $targetFilePath; // Update laporan_pengaduan_pdf path to use in SQL
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
            $sql = "SELECT permasalahan_pdf FROM penyuluhan WHERE id_penyuluhan = '$id_penyuluhan'";
            $result = $koneksi->query($sql);
            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                $permasalahan_pdf = $row['permasalahan_pdf'];
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
            $sql = "SELECT ktp_pdf FROM penyuluhan WHERE id_penyuluhan = '$id_penyuluhan'";
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

        $sql = "UPDATE penyuluhan SET id_user='$id_user', permasalahan_pdf='$permasalahan_pdf', ktp_pdf='$ktp_pdf', permasalahan='$permasalahan', ktp='$ktp', nama='$nama', no_hp='$no_hp', status='$status' WHERE id_penyuluhan='$id_penyuluhan'";
        if ($koneksi->query($sql) === TRUE) {
            $response['isSuccess'] = true;
            $response['message'] = "Berhasil mengedit data penyuluhan hukum";
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Gagal mengedit data penyuluhan hukum: " . $koneksi->error;
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
