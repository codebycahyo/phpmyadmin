-- =====================================================
-- PRAKTIKUM 2: IMPLEMENTASI RANCANGAN BASIS DATA
-- Database : db_penjualan
-- DBMS     : MySQL / MariaDB 10.4+ (CHECK constraint didukung)
-- =====================================================

DROP DATABASE IF EXISTS db_penjualan;
CREATE DATABASE db_penjualan CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE db_penjualan;

-- =====================================================
-- DATA DEFINITION LANGUAGE (DDL)
-- =====================================================

-- 1. Tabel Produk
CREATE TABLE Produk (
  KodeProduk CHAR(4)      NOT NULL,
  NamaProduk VARCHAR(100) NOT NULL,
  Harga      INT          NOT NULL,
  stok       INT          NOT NULL DEFAULT 0,
  CONSTRAINT pk_produk      PRIMARY KEY (KodeProduk),
  CONSTRAINT uq_namaproduk  UNIQUE (NamaProduk),
  CONSTRAINT ck_produk_harga CHECK (Harga >= 0),
  CONSTRAINT ck_produk_stok  CHECK (stok >= 0)
) ENGINE=InnoDB;

-- 2. Tabel Kasir
CREATE TABLE Kasir (
  KodeKasir CHAR(3)     NOT NULL,
  NamaKasir VARCHAR(50) NOT NULL,
  Pass      CHAR(6)     NOT NULL,
  CONSTRAINT pk_kasir PRIMARY KEY (KodeKasir),
  CONSTRAINT ck_kasir_pass CHECK (CHAR_LENGTH(Pass) = 6)
) ENGINE=InnoDB;

-- 3. Tabel Customer
CREATE TABLE Customer (
  KodeCus        CHAR(5)      NOT NULL,
  NamaCus        VARCHAR(50)  NOT NULL,
  TglLahir       DATE         NULL,
  JenKelCus      CHAR(1)      NULL,
  AlmtCus        VARCHAR(100) NOT NULL DEFAULT 'Yogyakarta',
  HPCus          VARCHAR(15)  NULL,
  PointTerkumpul INT          NOT NULL DEFAULT 0,
  CONSTRAINT pk_customer PRIMARY KEY (KodeCus),
  CONSTRAINT ck_customer_jenkel CHECK (JenKelCus IN ('L','P')),
  CONSTRAINT ck_customer_point  CHECK (PointTerkumpul >= 0)
) ENGINE=InnoDB;

-- 4. Tabel Nota
CREATE TABLE Nota (
  Nonota    CHAR(10) NOT NULL,
  KodeKasir CHAR(3)  NOT NULL,
  TglTran   DATE     NOT NULL,
  KodeCus   CHAR(5)  NOT NULL,
  CONSTRAINT pk_nota PRIMARY KEY (Nonota),
  CONSTRAINT ck_nota_nonota CHECK (CHAR_LENGTH(Nonota) = 10),
  CONSTRAINT fk_nota_kasir    FOREIGN KEY (KodeKasir) REFERENCES Kasir (KodeKasir),
  CONSTRAINT fk_nota_customer FOREIGN KEY (KodeCus)   REFERENCES Customer (KodeCus)
) ENGINE=InnoDB;

-- 5. Tabel ItemNota
CREATE TABLE ItemNota (
  Nonota     CHAR(10) NOT NULL,
  KodeProduk CHAR(4)  NOT NULL,
  banyak     INT      NOT NULL DEFAULT 1,
  hargajual  INT      NOT NULL,
  CONSTRAINT pk_itemnota PRIMARY KEY (Nonota, KodeProduk),
  CONSTRAINT ck_item_banyak    CHECK (banyak >= 1),
  CONSTRAINT ck_item_hargajual CHECK (hargajual >= 0),
  CONSTRAINT fk_item_nota   FOREIGN KEY (Nonota)     REFERENCES Nota (Nonota),
  CONSTRAINT fk_item_produk FOREIGN KEY (KodeProduk) REFERENCES Produk (KodeProduk)
) ENGINE=InnoDB;

-- =====================================================
-- DATA MANIPULATION LANGUAGE (DML) - INSERT
-- =====================================================

-- 6. Data Produk
INSERT INTO Produk (KodeProduk, NamaProduk, Harga, stok) VALUES
('P001', 'Indomie goreng special', 2100, 100),
('P002', 'Wafer Tango',            4300,  50),
('P003', 'SariRoti Coklat Keju',   7500,  30);

-- 7. Data Kasir
INSERT INTO Kasir (KodeKasir, NamaKasir, Pass) VALUES
('001', 'Unyil',  'unyil1'),
('002', 'Melani', 'melani');

-- 8. Data Customer
INSERT INTO Customer (KodeCus, NamaCus, TglLahir, JenKelCus, AlmtCus, HPCus, PointTerkumpul) VALUES
('M0000', 'UMUM',  NULL,         NULL, DEFAULT,         NULL,        0),
('M0001', 'indah', '1990-12-12', 'P',  'jl.wijaya 255', '08162992',  25),
('M0002', 'budi',  '1987-05-20', 'L',  'jl.mawar 19',   '081239927', 10);

-- 9. Data Nota
INSERT INTO Nota (Nonota, KodeKasir, TglTran, KodeCus) VALUES
('2208030001', '001', '2022-08-03', 'M0001'),
('2208030002', '001', '2022-08-03', 'M0002'),
('2208040001', '002', '2022-08-04', 'M0000'),
('2208050001', '002', '2022-08-05', 'M0001');

-- 10. Data ItemNota
INSERT INTO ItemNota (Nonota, KodeProduk, banyak, hargajual) VALUES
('2208030001', 'P001', 5, 2100),
('2208030001', 'P002', 1, 4300),
('2208030002', 'P003', 2, 7500),
('2208040001', 'P001', 3, 2100),
('2208040001', 'P002', 3, 4300),
('2208040001', 'P003', 1, 7500),
('2208050001', 'P002', 2, 4300);

-- =====================================================
-- SELECT SEDERHANA
-- =====================================================

-- 11. Menampilkan data masing-masing tabel
--     (Customer dan Produk diurutkan berdasarkan nama)
SELECT * FROM Customer ORDER BY NamaCus;
SELECT * FROM Produk   ORDER BY NamaProduk;
SELECT * FROM Kasir;
SELECT * FROM Nota;
SELECT * FROM ItemNota;

-- 12. Transaksi antara tanggal 1 - 3 Agustus 2022
SELECT * FROM Nota
WHERE TglTran BETWEEN '2022-08-01' AND '2022-08-03';

-- 13. Daftar belanja customer Budi
SELECT n.Nonota, n.TglTran, p.NamaProduk, i.banyak, i.hargajual,
       i.banyak * i.hargajual AS subtotal
FROM Customer c
JOIN Nota n     ON n.KodeCus = c.KodeCus
JOIN ItemNota i ON i.Nonota = n.Nonota
JOIN Produk p   ON p.KodeProduk = i.KodeProduk
WHERE c.NamaCus = 'budi';

-- 14. Data barang, harga, stok, nilai persediaan
SELECT NamaProduk AS Barang, Harga, stok,
       Harga * stok AS NilaiPersediaan
FROM Produk;

-- 15. Data nonota, tanggal, total nota
SELECT n.Nonota, n.TglTran,
       SUM(i.banyak * i.hargajual) AS TotalNota
FROM Nota n
JOIN ItemNota i ON i.Nonota = n.Nonota
GROUP BY n.Nonota, n.TglTran
ORDER BY n.Nonota;
