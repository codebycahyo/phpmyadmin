-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 16, 2026 at 11:05 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_penjualan`
--

-- --------------------------------------------------------

--
-- Table structure for table `Customer`
--

CREATE TABLE `Customer` (
  `KodeCus` char(5) NOT NULL,
  `NamaCus` varchar(50) NOT NULL,
  `TglLahir` date DEFAULT NULL,
  `JenKelCus` char(1) DEFAULT NULL,
  `AlmtCus` varchar(100) NOT NULL DEFAULT 'Yogyakarta',
  `HPCus` varchar(15) DEFAULT NULL,
  `PointTerkumpul` int(11) NOT NULL DEFAULT 0
) ;

--
-- Dumping data for table `Customer`
--

INSERT INTO `Customer` (`KodeCus`, `NamaCus`, `TglLahir`, `JenKelCus`, `AlmtCus`, `HPCus`, `PointTerkumpul`) VALUES
('M0000', 'UMUM', NULL, NULL, 'Yogyakarta', NULL, 0),
('M0001', 'indah', '1990-12-12', 'P', 'jl.wijaya 255', '08162992', 25),
('M0002', 'budi', '1987-05-20', 'L', 'jl.mawar 19', '081239927', 10);

-- --------------------------------------------------------

--
-- Table structure for table `ItemNota`
--

CREATE TABLE `ItemNota` (
  `Nonota` char(10) NOT NULL,
  `KodeProduk` char(4) NOT NULL,
  `banyak` int(11) NOT NULL DEFAULT 1,
  `hargajual` int(11) NOT NULL
) ;

--
-- Dumping data for table `ItemNota`
--

INSERT INTO `ItemNota` (`Nonota`, `KodeProduk`, `banyak`, `hargajual`) VALUES
('2208030001', 'P001', 5, 2100),
('2208030001', 'P002', 1, 4300),
('2208030002', 'P003', 2, 7500),
('2208040001', 'P001', 3, 2100),
('2208040001', 'P002', 3, 4300),
('2208040001', 'P003', 1, 7500),
('2208050001', 'P002', 2, 4300);

-- --------------------------------------------------------

--
-- Table structure for table `Kasir`
--

CREATE TABLE `Kasir` (
  `KodeKasir` char(3) NOT NULL,
  `NamaKasir` varchar(50) NOT NULL,
  `Pass` char(6) NOT NULL
) ;

--
-- Dumping data for table `Kasir`
--

INSERT INTO `Kasir` (`KodeKasir`, `NamaKasir`, `Pass`) VALUES
('001', 'Unyil', 'unyil1'),
('002', 'Melani', 'melani');

-- --------------------------------------------------------

--
-- Table structure for table `Nota`
--

CREATE TABLE `Nota` (
  `Nonota` char(10) NOT NULL,
  `KodeKasir` char(3) NOT NULL,
  `TglTran` date NOT NULL,
  `KodeCus` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Nota`
--

INSERT INTO `Nota` (`Nonota`, `KodeKasir`, `TglTran`, `KodeCus`) VALUES
('2208030001', '001', '2022-08-03', 'M0001'),
('2208030002', '001', '2022-08-03', 'M0002'),
('2208040001', '002', '2022-08-04', 'M0000'),
('2208050001', '002', '2022-08-05', 'M0001');

-- --------------------------------------------------------

--
-- Table structure for table `Produk`
--

CREATE TABLE `Produk` (
  `KodeProduk` char(4) NOT NULL,
  `NamaProduk` varchar(50) NOT NULL,
  `Harga` int(11) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 0
) ;

--
-- Dumping data for table `Produk`
--

INSERT INTO `Produk` (`KodeProduk`, `NamaProduk`, `Harga`, `stok`) VALUES
('P001', 'Indomie goreng special', 2100, 100),
('P002', 'Wafer Tango', 4300, 50),
('P003', 'SariRoti Coklat Keju', 7500, 30);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Customer`
--
ALTER TABLE `Customer`
  ADD PRIMARY KEY (`KodeCus`);

--
-- Indexes for table `ItemNota`
--
ALTER TABLE `ItemNota`
  ADD PRIMARY KEY (`Nonota`,`KodeProduk`),
  ADD KEY `fk_item_produk` (`KodeProduk`);

--
-- Indexes for table `Kasir`
--
ALTER TABLE `Kasir`
  ADD PRIMARY KEY (`KodeKasir`);

--
-- Indexes for table `Nota`
--
ALTER TABLE `Nota`
  ADD PRIMARY KEY (`Nonota`),
  ADD KEY `fk_nota_kasir` (`KodeKasir`),
  ADD KEY `fk_nota_customer` (`KodeCus`);

--
-- Indexes for table `Produk`
--
ALTER TABLE `Produk`
  ADD PRIMARY KEY (`KodeProduk`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ItemNota`
--
ALTER TABLE `ItemNota`
  ADD CONSTRAINT `fk_item_nota` FOREIGN KEY (`Nonota`) REFERENCES `Nota` (`Nonota`),
  ADD CONSTRAINT `fk_item_produk` FOREIGN KEY (`KodeProduk`) REFERENCES `Produk` (`KodeProduk`);

--
-- Constraints for table `Nota`
--
ALTER TABLE `Nota`
  ADD CONSTRAINT `fk_nota_customer` FOREIGN KEY (`KodeCus`) REFERENCES `Customer` (`KodeCus`),
  ADD CONSTRAINT `fk_nota_kasir` FOREIGN KEY (`KodeKasir`) REFERENCES `Kasir` (`KodeKasir`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
