<?php 

header("Access-Control-Allow-Origin: header");
header("Access-Control-Allow-Origin: *");

include 'koneksi.php';

	// $response = array();
	$sql = "SELECT * FROM posko";
	$result = $koneksi->query($sql);

	if($result->num_rows > 0) {
		$response['isSuccess'] = true;
		$response['message'] = "Berhasil Menampilkan Data Posko Pemilu";
		$response['data'] = array();
		while ($row = $result->fetch_assoc()) {
			$response['data'][] = $row;
		}
	} else {
		$response['isSuccess'] = false;
		$response['message'] = "Gagal menampilkan Data Posko Pemilu";
		$response['data'] = null;
	}
	echo json_encode($response);
?> 
