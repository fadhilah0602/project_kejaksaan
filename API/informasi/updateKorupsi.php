<?php

header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

$response = array('isSuccess' => false, 'message' => 'Unknown error occurred');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['id_korupsi'], $_POST['nama_pelapor'], $_POST['no_hp'], $_POST['ktp'], $_POST['uraian'], $_POST['laporan']) && isset($_FILES['ktp_pdf'], $_FILES['laporan_pdf'])) {
        $id_korupsi = $_POST['id_korupsi'];
        $nama_pelapor = $_POST['nama_pelapor'];
        $no_hp = $_POST['no_hp'];
        $ktp = $_POST['ktp'];
        $uraian = $_POST['uraian'];
        $laporan = $_POST['laporan'];
        
        // Handle file upload for ktp_pdf
        $file1 = $_FILES['ktp_pdf'];
        $filename1 = $file1['name'];
        $filetmp1 = $file1['tmp_name'];
        $fileError1 = $file1['error'];
        $fileSize1 = $file1['size'];
        $fileExt1 = explode('.', $filename1);
        $fileActualExt1 = strtolower(end($fileExt1));
        
        // Handle file upload for laporan_pdf
        $file2 = $_FILES['laporan_pdf'];
        $filename2 = $file2['name'];
        $filetmp2 = $file2['tmp_name'];
        $fileError2 = $file2['error'];
        $fileSize2 = $file2['size'];
        $fileExt2 = explode('.', $filename2);
        $fileActualExt2 = strtolower(end($fileExt2));

        // Define allowed file extensions
        $allowed = array('pdf');

        // Pastikan kedua upload file adalah file PDF
        if (in_array($fileActualExt1, $allowed) && in_array($fileActualExt2, $allowed)) {
            // Pastikan tidak ada kesalahan dalam proses upload file
            if ($fileError1 === 0 && $fileError2 === 0) {
                // Periksa ukuran file
                if ($fileSize1 < 5000000 && $fileSize2 < 5000000) { // Batasi ukuran file menjadi 5MB
                    // Generate nama file unik
                    $fileNameNew1 = uniqid('', true).".".$fileActualExt1;
                    $fileDestination1 = 'uploads/'.$fileNameNew1;
                    move_uploaded_file($filetmp1, $fileDestination1);
                    $ktp_pdf = $fileDestination1;

                    $fileNameNew2 = uniqid('', true).".".$fileActualExt2;
                    $fileDestination2 = 'uploads/'.$fileNameNew2;
                    move_uploaded_file($filetmp2, $fileDestination2);
                    $laporan_pdf = $fileDestination2;

                    // Perbarui data di database
                    $sql = "UPDATE korupsi SET nama_pelapor=?, no_hp=?, ktp=?, ktp_pdf=?, uraian=?, laporan=?, laporan_pdf=? WHERE id_korupsi=?";
                    $stmt = $koneksi->prepare($sql);
                    if ($stmt === false) {
                        $response['isSuccess'] = false;
                        $response['message'] = "Gagal mempersiapkan statement: " . $koneksi->error;
                    } else {
                        $stmt->bind_param("sssssssi", $nama_pelapor, $no_hp, $ktp, $ktp_pdf, $uraian, $laporan, $laporan_pdf, $id_korupsi);
                        if ($stmt->execute()) {
                            $response['isSuccess'] = true;
                            $response['message'] = "Berhasil mengedit data korupsi";
                        } else {
                            $response['isSuccess'] = false;
                            $response['message'] = "Gagal mengedit data korupsi: " . $stmt->error;
                        }
                        $stmt->close();
                    }
                } else {
                    $response['isSuccess'] = false;
                    $response['message'] = "Ukuran file terlalu besar";
                }
            } else {
                $response['isSuccess'] = false;
                $response['message'] = "Terjadi kesalahan saat mengunggah file";
            }
        } else {
            $response['isSuccess'] = false;
            $response['message'] = "Anda tidak dapat mengunggah file dengan jenis ini";
        }
    } else {
        $response['isSuccess'] = false;
        $response['message'] = "Parameter tidak lengkap";
    }
} else {
    $response['isSuccess'] = false;
    $response['message'] = "Hanya metode POST yang diizinkan";
}

echo json_encode($response);
?>
