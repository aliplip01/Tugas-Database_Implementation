use db_apotik;

-- Muh. Nur Alif Akbar / 0706022310031

-- No 1
drop trigger if exists TSpesialisDokter;
delimiter $$
create trigger TSpesialisDokter
before insert
on dokter for each row
begin
	declare nextID int;
    declare nextKode varchar(5);
    select convert(Right(MAX(id_dokter),2), unsigned) +1 from dokter
    into nextID;
    set nextKode = concat('D',LPAD(nextID, 2, '0'));

	IF NEW.id_spes = 'S000' THEN
		set NEW.nama_dokter := CONCAT('dr. ', NEW.nama_dokter, ', Sp.S.');
	ELSEIF NEW.id_spes = 'S001' THEN
		set NEW.nama_dokter := CONCAT('dr. ', NEW.nama_dokter, ', Sp.THT.');
	ELSEIF NEW.id_spes = 'S002' THEN
		set NEW.nama_dokter := CONCAT('dr. ', NEW.nama_dokter, ', Sp.PD.');
	ELSEIF NEW.id_spes = 'S003' THEN
		set NEW.nama_dokter := CONCAT('dr. ', NEW.nama_dokter, ', Sp.A.');
	END IF;
	SET NEW.id_dokter = nextKode;
    
end $$
delimiter ;
insert into dokter (nama_dokter,jenis_dokter,id_spes) values('Joko',1,'S003');

-- No 2
drop trigger if exists TSupplyObat;

delimiter $$
create trigger TSupplyObat
after insert
on d_beli for each row
begin
    DECLARE current_stock INT;

    SELECT stock_obat
    INTO current_stock
    FROM obat
    WHERE id_obat = NEW.id_obat;

    UPDATE obat
    SET stock_obat = current_stock + NEW.jumlah, harga_beli = NEW.harga_beli 
    WHERE id_obat = NEW.id_obat;

    INSERT INTO suply_obat (id_supplier, id_obat, harga_beli, status_del)
    VALUES ((SELECT id_supplier FROM h_beli WHERE id_beli = NEW.id_beli),NEW.id_obat, NEW.harga_beli,'F');
end $$
delimiter ;

insert into h_beli values('TB1411202200001', '2022-11-14', 'S04', 1, 'F');
insert into d_beli values('TB1411202200001', 'B0013', 5, 18000, 'F'),('TB1411202200001', 'B0012', 100, 1000, 'F');

-- No 3
DROP TRIGGER IF EXISTS TUpdateJual;
delimiter $$
CREATE TRIGGER TUpdateJual
BEFORE INSERT
ON d_jual
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    DECLARE current_price INT;

    SELECT stock_obat, harga_jual
    INTO current_stock, current_price
    FROM obat
    WHERE id_obat = NEW.id_obat;

    UPDATE obat
    SET stock_obat = current_stock - NEW.jumlah
    WHERE id_obat = NEW.id_obat;
	SET NEW.harga = current_price;
END $$
delimiter ;
insert into h_jual values('TJ1411202200001', '2022-11-14', 'Indra', 'Surabaya',null, 'F');
insert into d_jual values('TJ1411202200001', 'B0013', 15, null, 'F'),
('TJ1411202200001', 'B0012', 72, null, 'F');
