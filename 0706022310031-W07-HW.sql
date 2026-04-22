SELECT*FROM dokter;
select*from spesialis;

###### NOMER 1 ######
drop procedure dokter;

DELIMITER $$
CREATE PROCEDURE dokter(IN JENIS VARCHAR(10))
BEGIN
    SELECT d.nama_dokter
    FROM dokter d
    LEFT JOIN spesialis s ON s.id_spes = d.id_spes
    WHERE s.nama_spesialis = JENIS;
END$$
DELIMITER ;

###### NOMER 2 ######
DROP PROCEDURE TOTAL_P;

DELIMITER $$
CREATE PROCEDURE TOTAL_P(IN ID VARCHAR(20))
BEGIN

DECLARE TOTAL_PENJUALAN INT DEFAULT 0;

SELECT SUM(jumlah * harga) INTO TOTAL_PENJUALAN
FROM d_jual
WHERE id_jual = ID;

SELECT CONCAT('Total penjualan untuk id_jual nomor ', ID, ' sebesar Rp. ', FORMAT(total_penjualan, 0, 'id_ID'), ',-') AS hasil;

END$$
DELIMITER ;

###### NOMER 3 ######
SELECT*FROM d_jual;
SELECT*FROM obat;

DROP PROCEDURE TOTAL_LABA;
DELIMITER $$
CREATE PROCEDURE TOTAL_LABA(IN ID VARCHAR(15))
BEGIN

    DECLARE total_penjualan INT DEFAULT 0;
    DECLARE total_modal INT DEFAULT 0;
    DECLARE total_keuntungan INT DEFAULT 0;

    -- Hitung total penjualan
    SELECT SUM(d.jumlah * d.harga) INTO total_penjualan
    FROM d_jual d
    WHERE d.id_jual = ID;

    -- Hitung total modal 
    SELECT SUM(d.jumlah * s.harga_beli) INTO total_modal
	FROM d_jual d
	JOIN obat s ON d.id_obat = s.id_obat
	WHERE d.id_jual = ID;

    -- Hitung keuntungan
    SET total_keuntungan = total_penjualan - total_modal;

    -- Tampilkan hasil
    SELECT CONCAT('Laporan Laba/Rugi untuk id_jual nomor ', ID) AS laporan,
           CONCAT('Total penjualan = Rp. ', FORMAT(total_penjualan, 0, 'id_ID'), ',-') AS total_penjualan,
           CONCAT('Modal = Rp. ', FORMAT(total_modal, 0, 'id_ID'), ',-') AS modal,
           CONCAT('Keuntungan = Rp. ', FORMAT(total_keuntungan, 0, 'id_ID'), ',-') AS keuntungan;
END$$
DELIMITER ;

###### NOMER 4 ######
select*from suply_obat;
drop procedure ubah_harga;

DELIMITER $$

CREATE PROCEDURE ubah_harga()
BEGIN
    UPDATE obat o
    JOIN (
        SELECT id_obat, harga_beli
        FROM suply_obat
    ) AS so ON o.id_obat = so.id_obat
    SET o.harga_beli = so.harga_beli
    WHERE so.harga_beli IS NOT NULL;
END$$

DELIMITER ;







