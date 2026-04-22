-- Tugas DBI Week 06 - Procedural Language
-- Compound Statement, Variables, Flow Control
-- Muh. Nur Alif Akbar / 031

/* No. 1
Buatlah program untuk mencari faktorial dari suatu bilangan.
Contoh: 5, maka akan muncul: 120
(karena 5! = 5 x 4 x 3 x 2 x 1 = 120)
*/

-- Jawab No.1 disini.
DROP PROCEDURE No1;
delimiter $$
CREATE PROCEDURE No1(IN num INT)
BEGIN
	DECLARE faktorial INT DEFAULT 1;
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= num DO
		SET faktorial = faktorial * i;
		SET i = i + 1;
    END WHILE;
    SELECT faktorial as hasil;
    
END $$
delimiter ;

/* No. 2
Buatlah program untuk melakukan konversi nilai menjadi grade. Berikut rumusannya:
90-100		A
85-89.99	A-
80-84.99	B+
75-79.99	B
70-74.99	B-
60-69.99	C+
55-59.99	C
45-54.99	D
 0-44.99	E
 
Contoh: 87, maka akan muncul: "Grade Anda A-"
*/

-- Jawab No.2 disini.
DROP PROCEDURE No2;
delimiter $$
CREATE PROCEDURE No2(IN nilai DECIMAL(5,2), OUT grade VARCHAR(15))
BEGIN

	IF nilai >= 90 AND nilai <= 100 THEN
		SET grade = 'Grade Anda A';
	ELSEIF nilai >= 85 AND nilai < 90 THEN
		SET grade = 'Grade Anda A-';
	ELSEIF nilai >= 80 AND nilai < 85 THEN
		SET grade = 'Grade Anda B+';
	ELSEIF nilai >= 75 AND nilai < 80 THEN
		SET grade = 'Grade Anda B';
	ELSEIF nilai >= 70 AND nilai < 75 THEN
		SET grade = 'Grade Anda B-';
	ELSEIF nilai >= 60 AND nilai < 70 THEN
		SET grade = 'Grade Anda C+';
	ELSEIF nilai >= 55 AND nilai < 60 THEN
		SET grade = 'Grade Anda C';
	ELSEIF nilai >= 45 AND nilai < 55 THEN
		SET grade = 'Grade Anda D';
	ELSEIF nilai >= 0 AND nilai < 45 THEN
		SET grade = 'Grade Anda E';
	END IF;

END $$
delimiter ;

/* 
copy sql berikut sebelum mengerjakan no.3 dan 4
*/
/*
create database 20231_w06_dbi;
use 20231_w06_dbi;

create table golongan
(
 kode_gol   varchar(4) primary key,
 g_pokok    int unsigned,
 g_tambah   int unsigned,
 tunj_istri int unsigned,
 tunj_anak  int unsigned
);

create table dosen
(
 nip        varchar(5) primary key,
 nama_dosen varchar(20),
 menikah    varchar(1),
 kode_gol   varchar(4) references golongan(kode_gol),
 tgl_lahir  date
);

create table keluarga
(
 nip        varchar(5) references dosen(nip),
 nama_kel   varchar(20),
 status     varchar(1)
);

INSERT INTO golongan VALUES ('GO01',1200000,25000,300000,150000);
INSERT INTO golongan VALUES ('GO02',1500000,35000,200000,200000);
INSERT INTO golongan VALUES ('GO03',800000 ,45000,150000,100000);
INSERT INTO golongan VALUES ('GO04',600000 ,25000,200000,120000);

INSERT INTO dosen VALUES ('20201','BERTRAND ARESTO'  ,'Y','GO01',str_to_date('17/09/1977','%d/%m/%Y'));
INSERT INTO dosen VALUES ('20202','SUGIARTO SAPUTRA' ,'T','GO02',str_to_date('31/01/1985','%d/%m/%Y'));
INSERT INTO dosen VALUES ('20203','ROLAND MEZZY'     ,'Y','GO02',str_to_date('28/02/1974','%d/%m/%Y'));
INSERT INTO dosen VALUES ('20304','CAROLUS WIDJAJA'  ,'Y','GO03',str_to_date('12/05/1982','%d/%m/%Y'));
INSERT INTO dosen VALUES ('20305','AGUS PUTRA'       ,'T','GO04',str_to_date('23/04/1985','%d/%m/%Y'));

INSERT INTO keluarga VALUES ('20201','MARIA ANTONIA'   ,'I');
INSERT INTO keluarga VALUES ('20201','MANDY LANTAROZ'  ,'A');
INSERT INTO keluarga VALUES ('20201','LUCKY ROSALIE'   ,'A');
INSERT INTO keluarga VALUES ('20203','MERRY ONGKO'     ,'I');
INSERT INTO keluarga VALUES ('20203','SILVIANA'        ,'A');
INSERT INTO keluarga VALUES ('20203','MARGARETHA'      ,'A');
INSERT INTO keluarga VALUES ('20304','ROSALES ANTAGUES','I');
*/
/* No. 3
Tampilkan NIP dan NAMA DOSEN yang gaji pokoknya lebih besar dari 1juta.
Hasil:
NIP		NAMA_DOSEN
------- -----------------------
20201	BERTRAND ARESTO
20202	SUGIARTO SAPUTRA
20203	ROLAND MEZZY
*/

-- Jawab No.3 disini.
DROP PROCEDURE No3;
delimiter $$
CREATE PROCEDURE No3()
BEGIN

	SELECT nip, nama_dosen 
    FROM dosen
    WHERE kode_gol = 'GO01' OR kode_gol = 'GO02'
    ORDER BY nip ASC;

END $$
delimiter ;

/* No. 4
Tampilkan data keluarga yang mengandung ‘ROS’.
Hasil:
nip 	nama_kel 			status
-------	------------------- ------
20201 	LUCKY ROSALIE 		Anak
20304 	ROSALES ANTAGUES 	Istri
*/

-- Jawab No.4 disini.
DROP PROCEDURE No4;
delimiter $$
CREATE PROCEDURE No4()
BEGIN

	SELECT nip,nama_kel,IF(`status` = 'I','Istri','Anak') AS `status`
    FROM keluarga
    WHERE nama_kel LIKE '%ros%'
    ORDER BY nip ASC;

END $$
delimiter ;
