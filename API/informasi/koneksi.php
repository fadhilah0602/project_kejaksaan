<?php

$koneksi = mysqli_connect("localhost", "root", "", "informasi");

if($koneksi){

	// echo "Database berhasil Connect";
	
} else {
	echo "gagal Connect";
}

?>