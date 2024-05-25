-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 25, 2024 at 04:50 PM
-- Server version: 5.7.24
-- PHP Version: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `informasi`
--

-- --------------------------------------------------------

--
-- Table structure for table `jms`
--

CREATE TABLE `jms` (
  `id_jms` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `sekolah` varchar(100) NOT NULL,
  `nama_pemohon` varchar(100) NOT NULL,
  `status` enum('Pending','Approved','Rejected') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jms`
--

INSERT INTO `jms` (`id_jms`, `id_user`, `sekolah`, `nama_pemohon`, `status`) VALUES
(1, 2, 'SMP Cahaya', 'jms', 'Pending'),
(3, 2, 'SMP Bakti Asih', 'jms', 'Approved'),
(4, 2, 'SMP Bakti Mulya', 'jms', 'Rejected'),
(5, 10, 'SMP 10 Bogor Edit', 'joko1', 'Approved'),
(8, 10, 'SMP 10 Bogor3', 'joko3', 'Approved'),
(11, 8, 'skolah susi1', 'susi1', 'Pending'),
(13, 2, 'skolah lagi', 'jms lagi', 'Pending'),
(14, 8, 'skolah smp', 'susi 2', 'Approved'),
(17, 10, 'smp 5 edit', 'joko edit', 'Approved'),
(18, 10, 'SMA N 1 Bogor edit', 'joko jms edit', 'Approved');

-- --------------------------------------------------------

--
-- Table structure for table `korupsi`
--

CREATE TABLE `korupsi` (
  `id_korupsi` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `nama_pelapor` varchar(50) NOT NULL,
  `no_hp` varchar(50) NOT NULL,
  `ktp` text NOT NULL,
  `ktp_pdf` varchar(100) NOT NULL,
  `uraian` text NOT NULL,
  `laporan` text NOT NULL,
  `laporan_pdf` varchar(100) NOT NULL,
  `status` enum('Pending','Approved','Rejected') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `korupsi`
--

INSERT INTO `korupsi` (`id_korupsi`, `id_user`, `nama_pelapor`, `no_hp`, `ktp`, `ktp_pdf`, `uraian`, `laporan`, `laporan_pdf`, `status`) VALUES
(4, 10, 'korupsi1', '1234566', '134354', 'uploads/11. Naskah Soal UAS.pdf', 'uraiaaan', 'laporaaaan', 'uploads/11. Naskah Soal UAS.pdf', 'Pending'),
(6, 10, 'joko edit', '1231', '12344', 'uploads/UTS Alih Kredit.pdf', 'pidana korupsi edit', 'laporan pidana edit', 'uploads/UTS Alih Kredit.pdf', 'Approved'),
(7, 10, 'coba1', '1236', '12344', 'uploads/UTS Alih Kredit.pdf', 'coba uraian', 'laporan coba', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Pending'),
(8, 10, 'test edit', '123', '12', 'uploads/UTS Alih Kredit.pdf', 'uraian add', 'laporan add', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Approved'),
(10, 10, 'pidana korupsi edit ', '1231', '12341', 'uploads/UTS Alih Kredit.pdf', 'uraian tindak pidana korupsi', 'laporan add', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Approved');

-- --------------------------------------------------------

--
-- Table structure for table `pengaduan`
--

CREATE TABLE `pengaduan` (
  `id_pengaduan` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `nama_pelapor` varchar(50) NOT NULL,
  `no_hp` varchar(50) NOT NULL,
  `ktp` text NOT NULL,
  `ktp_pdf` text NOT NULL,
  `laporan` text NOT NULL,
  `laporan_pdf` text NOT NULL,
  `status` enum('Pending','Approved','Rejected') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pengaduan`
--

INSERT INTO `pengaduan` (`id_pengaduan`, `id_user`, `nama_pelapor`, `no_hp`, `ktp`, `ktp_pdf`, `laporan`, `laporan_pdf`, `status`) VALUES
(13, 10, 'coba edit lagi\n', '1234', '123', 'uploads/11. Naskah Soal UAS.pdf', 'lapor pak', 'uploads/UTS_Fadhilah Febriani_2311089014.pdf', 'Approved'),
(14, 10, 'coba edit13', '123413', '12313', 'uploads/UTS Alih Kredit.pdf', 'lapor pak13', 'uploads/UTS Alih Kredit.pdf', 'Rejected'),
(16, 10, 'joko ngadu123', '123123', '1234123', 'uploads/UTS Alih Kredit.pdf', 'laporan joko123', 'uploads/Ringkasan Fadhilah Febriani.pdf', 'Approved'),
(17, 10, 'test edit', '1234', '12345', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'laporan test edit', 'uploads/UTS Alih Kredit.pdf', 'Approved'),
(18, 8, 'susi edit', '123', '1234', 'uploads/KEBEBASAN LINEAR BASIS DAN DIMENSI-X.pdf', 'laporan susi edit', 'uploads/UTS Alih Kredit.pdf', 'Approved'),
(19, 10, 'coba1', '1231', '12341', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'laporan coba 1', 'uploads/UTS Alih Kredit.pdf', 'Pending'),
(21, 10, 'coba edit', '12341', '121', 'uploads/KEBEBASAN LINEAR BASIS DAN DIMENSI-X.pdf', 'laporan efit', 'uploads/UTS Alih Kredit.pdf', 'Pending'),
(22, 10, 'joko test edit', '123 edit', '12 edit', 'uploads/KEBEBASAN LINEAR BASIS DAN DIMENSI-X.pdf', 'laporan joko edit', 'uploads/UTS Alih Kredit.pdf', 'Approved');

-- --------------------------------------------------------

--
-- Table structure for table `pengawasan`
--

CREATE TABLE `pengawasan` (
  `id_pengawasan` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `nama_pelapor` varchar(100) NOT NULL,
  `no_hp` varchar(50) NOT NULL,
  `ktp` text NOT NULL,
  `ktp_pdf` varchar(100) NOT NULL,
  `laporan` text NOT NULL,
  `laporan_pdf` varchar(100) NOT NULL,
  `status` enum('Pending','Approved','Rejected') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pengawasan`
--

INSERT INTO `pengawasan` (`id_pengawasan`, `id_user`, `nama_pelapor`, `no_hp`, `ktp`, `ktp_pdf`, `laporan`, `laporan_pdf`, `status`) VALUES
(3, 10, 'joko edit1', '1231', '12341', 'uploads/UTS Alih Kredit.pdf', 'pengawasan add1', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Approved'),
(4, 10, 'joko edit', '1231', '12341', 'uploads/UTS Alih Kredit.pdf', 'lapran edit', 'uploads/UTS Alih Kredit.pdf', 'Approved'),
(5, 10, 'jokoq', '123', '12', 'uploads/UTS Alih Kredit.pdf', 'laporan joko', 'uploads/KEBEBASAN LINEAR BASIS DAN DIMENSI-X.pdf', 'Pending'),
(7, 10, 'test edit', '1231', '122', 'uploads/UTS Alih Kredit.pdf', 'laporan test', 'uploads/Ringkasan Fadhilah Febriani.pdf', 'Approved'),
(8, 10, 'coba edit', '1231', '125', 'uploads/UTS Alih Kredit.pdf', 'lapran add', 'uploads/Ringkasan Fadhilah Febriani.pdf', 'Rejected'),
(9, 10, 'joko penyuluhan edit', '1231', '121', 'uploads/UTS Alih Kredit.pdf', 'laporan pengawasan', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Approved');

-- --------------------------------------------------------

--
-- Table structure for table `penilaian`
--

CREATE TABLE `penilaian` (
  `id_penilaian` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `rating` enum('Memuaskan','Baik','Cukup') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `penilaian`
--

INSERT INTO `penilaian` (`id_penilaian`, `id_user`, `rating`) VALUES
(1, 2, 'Memuaskan'),
(2, 2, 'Memuaskan'),
(3, 8, 'Baik'),
(4, 2, 'Memuaskan'),
(5, 10, 'Memuaskan'),
(6, 10, 'Memuaskan'),
(7, 10, 'Baik'),
(8, 10, 'Memuaskan'),
(9, 10, 'Baik'),
(10, 10, 'Baik'),
(11, 10, 'Cukup'),
(12, 10, 'Memuaskan'),
(13, 10, 'Baik'),
(14, 10, 'Memuaskan'),
(15, 10, 'Cukup'),
(16, 10, 'Cukup'),
(17, 10, 'Memuaskan'),
(18, 10, 'Memuaskan'),
(19, 10, 'Memuaskan'),
(20, 10, 'Baik'),
(21, 10, 'Baik'),
(22, 10, 'Cukup'),
(23, 8, 'Baik'),
(24, 10, 'Cukup'),
(25, 10, 'Memuaskan'),
(26, 10, 'Cukup'),
(27, 10, 'Cukup'),
(28, 10, 'Baik'),
(29, 10, 'Memuaskan'),
(30, 10, 'Memuaskan'),
(31, 10, 'Baik'),
(32, 10, 'Cukup'),
(33, 10, 'Cukup'),
(34, 10, 'Memuaskan'),
(35, 10, 'Memuaskan'),
(36, 10, 'Baik'),
(37, 10, 'Memuaskan'),
(38, 10, 'Baik'),
(39, 10, 'Cukup'),
(40, 10, 'Memuaskan'),
(41, 10, 'Baik'),
(42, 10, 'Baik'),
(43, 10, 'Cukup'),
(44, 10, 'Memuaskan'),
(45, 10, 'Memuaskan');

-- --------------------------------------------------------

--
-- Table structure for table `penyuluhan`
--

CREATE TABLE `penyuluhan` (
  `id_penyuluhan` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `no_hp` varchar(50) NOT NULL,
  `ktp` text NOT NULL,
  `ktp_pdf` varchar(100) NOT NULL,
  `permasalahan` text NOT NULL,
  `permasalahan_pdf` varchar(100) NOT NULL,
  `status` enum('Pending','Approved','Rejected') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `penyuluhan`
--

INSERT INTO `penyuluhan` (`id_penyuluhan`, `id_user`, `nama`, `no_hp`, `ktp`, `ktp_pdf`, `permasalahan`, `permasalahan_pdf`, `status`) VALUES
(5, 10, 'joko12', '1234', '123', 'uploads/UTS Alih Kredit.pdf', 'masalah add', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Rejected'),
(6, 10, 'joko edit', '1231', '12341', 'uploads/UTS Alih Kredit.pdf', 'masalah edit', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Approved'),
(7, 10, 'coba1', '126', '1241', 'uploads/UTS Alih Kredit.pdf', 'masalah coba', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Pending'),
(9, 10, 'coba edit', '123', '12', 'uploads/UTS Alih Kredit.pdf', 'coba permasalahan', 'uploads/KEBEBASAN LINEAR BASIS DAN DIMENSI-X.pdf', 'Approved'),
(10, 10, 'joko penyuluhan edit ', '1235', '123', 'uploads/UTS Alih Kredit.pdf', 'permasalahan joko', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Approved');

-- --------------------------------------------------------

--
-- Table structure for table `posko`
--

CREATE TABLE `posko` (
  `id_posko` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `nama_pelapor` varchar(100) NOT NULL,
  `no_hp` varchar(50) NOT NULL,
  `ktp` text NOT NULL,
  `ktp_pdf` varchar(100) NOT NULL,
  `laporan` text NOT NULL,
  `laporan_pdf` varchar(100) NOT NULL,
  `status` enum('Pending','Approved','Rejected') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `posko`
--

INSERT INTO `posko` (`id_posko`, `id_user`, `nama_pelapor`, `no_hp`, `ktp`, `ktp_pdf`, `laporan`, `laporan_pdf`, `status`) VALUES
(4, 10, 'joko1', '123', '1234', 'uploads/UTS Alih Kredit.pdf', 'laporan add', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Approved'),
(5, 10, 'joko edit', '1231', '121', 'uploads/UTS Alih Kredit.pdf', 'lapran edit', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Approved'),
(6, 10, 'coba1', '123', '1234', 'uploads/UTS Alih Kredit.pdf', 'laporan coba', 'uploads/Ringkasan Fadhilah Febriani.pdf', 'Rejected'),
(7, 10, 'test', '123', '12', 'uploads/UTS Alih Kredit.pdf', 'laporan test', 'uploads/KEBEBASAN LINEAR BASIS DAN DIMENSI-X.pdf', 'Approved'),
(9, 10, 'joko pilkada edit', '12343', '1238', 'uploads/UTS Alih Kredit.pdf', 'laporan posko pilkada edit', 'uploads/Ringkasan Fadhilah Febriani (1).pdf', 'Approved');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `no_telp` varchar(50) NOT NULL,
  `ktp` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `alamat` text NOT NULL,
  `role` enum('Admin','Customers') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_user`, `nama`, `email`, `no_telp`, `ktp`, `password`, `alamat`, `role`) VALUES
(1, 'tindak korupsi edit', 'korupsi@gmail.com', '1234', '4321', '$2y$10$LxwWBiu/3Jb9PdT026VaIeFKOCMFmbcpm12M5c/jJYX8xTFsU0ce6', 'padang', 'Customers'),
(2, 'jms', 'jms@gmail.com', '11', '22', '$2y$10$pivxTgCWXauZqs.izPW41ezYnKKpf.LM9IPX.7E7R9w5T5K/ndch6', 'jakarta', 'Customers'),
(3, 'posko', 'posko@gmail.com', '111', '222', '$2y$10$yWDRBWCs9.Pb7RfrX6VBzOfWFOzRTsJX4eBFMPDSAjPZR1e9X.Fuy', 'bandung', 'Customers'),
(4, 'penyuluhan', 'penyuluhan@gmail.com', '123', '1234', '$2y$10$JO2BFsP6jqt4rJOe38RYQ.1fPBQZTcxAMh2T4dEhSK5OtiHfAq2lu', 'tangerang', 'Customers'),
(5, 'pengaduan', 'pengaduan@gmail.com', '1234', '12345', '$2y$10$iLObtkaY5GLOZa56d21ux.R0m3vnDCgL4c/fgZYsonm/Juhycz7cy', 'Jambi', 'Customers'),
(6, 'pengawasan', 'pengawasan@gmail.com', '1234', '12345', '$2y$10$Dlz04daeZHfmUMAfThvVQ.rH3DZKl63rn.VOwCZq5kMmAZallzAoO', 'Bogor', 'Customers'),
(7, 'penilaian', 'penilaian@gmail.com', '1234', '12345', '$2y$10$f5deb7qCIcpxplBjR4nOJOd7OzV.mbr474ZxhcXiOR/pmuhRs/P2y', 'Sukabumi', 'Customers'),
(8, 'susi', 'susi@gmail.com', '1234', '12345', '$2y$10$N3Jk8M7SQfW6DwEeNPRiS.P5F1TDRIM3RGg9N3sbJmLM4cuepCXHm', 'Sukabumi', 'Customers'),
(9, 'budi hartono', 'budi@gmail.com', '12345678', '1234512345', '$2y$10$CEGti5ZCbLRPIpNO8MZX5O0OpExhpVujBqfpvHabhAIk7Q122tDhS', 'padang', 'Customers'),
(10, 'joko1', 'joko1@gmail.com', '1234567', '123451234567', '$2y$10$K5xoahRuOm6uoivhdT6UaeN4ctbBB7gpgU8Q8GyAQ/CnAJJDN4Kwm', 'Jakarta Selatan 1', 'Customers'),
(12, 'Admin', 'admin1@gmail.com', '12345', '123456', '$2y$10$/fG4u8SEHa0CC2mGQEEn1OlmxE5Z./OeyNRLP/90j.MYlf87Ri70G', 'Jakarta Selatan1', 'Admin'),
(13, 'Customers1', 'customers1@gmail.com', '1234', '12345', '$2y$10$45RWkt5eSZFD6.M99SiP4uxAQVAjDQP4rh84Dnc0g.2TY1UVGXN2G', 'Jakarta Selatan', 'Customers');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jms`
--
ALTER TABLE `jms`
  ADD PRIMARY KEY (`id_jms`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `korupsi`
--
ALTER TABLE `korupsi`
  ADD PRIMARY KEY (`id_korupsi`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `pengaduan`
--
ALTER TABLE `pengaduan`
  ADD PRIMARY KEY (`id_pengaduan`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `pengawasan`
--
ALTER TABLE `pengawasan`
  ADD PRIMARY KEY (`id_pengawasan`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `penilaian`
--
ALTER TABLE `penilaian`
  ADD PRIMARY KEY (`id_penilaian`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `penyuluhan`
--
ALTER TABLE `penyuluhan`
  ADD PRIMARY KEY (`id_penyuluhan`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `posko`
--
ALTER TABLE `posko`
  ADD PRIMARY KEY (`id_posko`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jms`
--
ALTER TABLE `jms`
  MODIFY `id_jms` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `korupsi`
--
ALTER TABLE `korupsi`
  MODIFY `id_korupsi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pengaduan`
--
ALTER TABLE `pengaduan`
  MODIFY `id_pengaduan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `pengawasan`
--
ALTER TABLE `pengawasan`
  MODIFY `id_pengawasan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `penilaian`
--
ALTER TABLE `penilaian`
  MODIFY `id_penilaian` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `penyuluhan`
--
ALTER TABLE `penyuluhan`
  MODIFY `id_penyuluhan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `posko`
--
ALTER TABLE `posko`
  MODIFY `id_posko` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `jms`
--
ALTER TABLE `jms`
  ADD CONSTRAINT `jms_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`),
  ADD CONSTRAINT `jms_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `korupsi`
--
ALTER TABLE `korupsi`
  ADD CONSTRAINT `korupsi_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`),
  ADD CONSTRAINT `korupsi_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `pengaduan`
--
ALTER TABLE `pengaduan`
  ADD CONSTRAINT `pengaduan_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `pengawasan`
--
ALTER TABLE `pengawasan`
  ADD CONSTRAINT `pengawasan_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `penilaian`
--
ALTER TABLE `penilaian`
  ADD CONSTRAINT `penilaian_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`),
  ADD CONSTRAINT `penilaian_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `penyuluhan`
--
ALTER TABLE `penyuluhan`
  ADD CONSTRAINT `penyuluhan_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Constraints for table `posko`
--
ALTER TABLE `posko`
  ADD CONSTRAINT `posko_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
