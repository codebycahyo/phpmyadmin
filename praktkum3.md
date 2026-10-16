Soal 1–9 di modul sudah ada contoh dan jawabannya, jadi saya kerjakan **soal 10, 11, dan 12**.

Modul tidak memuat struktur tabel lengkap, jadi saya berasumsi seperti ini, dari query contoh di modul:
- `kasir(kodekasir, namakasir, pass)`
- `customer(kodecus, namacus, jenkelcus, hpcus)`
- `produk(kodeproduk, namaproduk, harga, stok)`
- `nota(nonota, tgltran, kodekasir, kodecus)`
- `itemnota(nonota, kodeproduk, banyak, hargajual)`

Kalau nama kolom di database Anda berbeda (misalnya kolom kasir di `nota`), sesuaikan saja.

## Soal 10: View kodekasir-namakasir dan jumlah transaksi

```sql
CREATE VIEW JumlahTransaksiKasir
AS
SELECT CONCAT(k.kodekasir, '-', k.namakasir) AS kasir,
       COUNT(n.nonota) AS 'jumlah transaksi'
FROM kasir k
LEFT JOIN nota n ON k.kodekasir = n.kodekasir
GROUP BY k.kodekasir, k.namakasir;

SELECT * FROM JumlahTransaksiKasir;
```

`LEFT JOIN` dipakai supaya kasir yang belum mencatat transaksi tetap muncul dengan jumlah 0.

## Soal 11: View detail nota

```sql
CREATE VIEW DetailNota
AS
SELECT n.nonota,
       n.tgltran AS tanggal,
       k.namakasir AS kasir,
       c.namacus AS pelanggan,
       CONCAT(p.kodeproduk, '-', p.namaproduk) AS 'kode-nama barang',
       i.banyak,
       i.hargajual,
       i.banyak * i.hargajual AS subtotal
FROM nota n
INNER JOIN itemnota i ON n.nonota = i.nonota
INNER JOIN produk p   ON i.kodeproduk = p.kodeproduk
INNER JOIN kasir k    ON n.kodekasir = k.kodekasir
INNER JOIN customer c ON n.kodecus = c.kodecus;

SELECT * FROM DetailNota;
```

## Soal 12: Nonota dan nama pelanggan dari 2 transaksi dengan total terbanyak

Query ini memakai view `TampilTotalNota` dari contoh nomor 4:

```sql
SELECT t.nonota, c.namacus AS pelanggan
FROM TampilTotalNota t
INNER JOIN nota n     ON t.nonota = n.nonota
INNER JOIN customer c ON n.kodecus = c.kodecus
ORDER BY t.`total nota` DESC
LIMIT 2;
```

Alternatif tanpa view, dengan subquery:

```sql
SELECT x.nonota, c.namacus AS pelanggan
FROM (SELECT nonota, SUM(banyak * hargajual) AS total
      FROM itemnota
      GROUP BY nonota
      ORDER BY total DESC
      LIMIT 2) x
INNER JOIN nota n     ON x.nonota = n.nonota
INNER JOIN customer c ON n.kodecus = c.kodecus;
```

Kalau ada total yang sama di urutan ke-2, `LIMIT 2` hanya mengambil dua baris. Kalau dosen minta semua yang seri ikut tampil, perlu pendekatan lain.

Kalau Anda kirim skema tabel atau script database-nya, saya bisa cocokkan nama kolomnya.
