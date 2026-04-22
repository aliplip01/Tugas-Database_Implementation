## Muh. Nur Alif Akbar / 0706022310031

##### SOAL NO 1 ######

drop function fDisplayName;
delimiter $$
create function fDisplayName(Spesialisasi varchar(10))
returns varchar(1000) reads sql data
begin
	declare nama varchar(1000);

    select group_concat(d.nama_dokter, ', ') into nama
    from dokter d
    join spesialis s on s.id_spes = d.id_spes
    where s.nama_spesialis = Spesialisasi;
    
    return nama;
end$$    
delimiter ;

##### SOAL NO 2 ######

drop function fTotalPenjualan;
delimiter $$
create function fTotalPenjualan(input varchar(15))
returns varchar(1000) reads sql data
begin
	declare TotalPenjualan varchar(200);
    
	select sum(jumlah * harga) into TotalPenjualan
	from d_jual
	where id_jual = input;
	Set TotalPenjualan = Concat('Total penjualan untuk id_jual nomor ', input, ' sebesar Rp. ', TotalPenjualan, ',-');
    return TotalPenjualan;
end$$
delimiter ;

select db_apotik.fTotalPenjualan('TJ2507202100005');

##### SOAL NO 3 ######

delimiter $$
create function fSellTerbanyak()
returns varchar(200) reads sql data
begin
	declare tgl date;
    declare terbanyak varchar(10);

	select tgl_trans into tgl
    from h_jual
    group by tgl_trans
    order by 1 desc
    limit 1;
	
	select count(tgl_trans) into terbanyak
    from h_jual
    group by tgl_trans
    order by 1 desc
    limit 1;
    return concat(tgl, ' terdapat ', terbanyak, ' transaksi.');
end$$
delimiter ;

select db_apotik.fSellTerbanyak();

##### SOAL NO 4 ######

drop function fGenerateId;
delimiter $$
create function fGenerateId()
returns varchar(15) reads sql data
begin
	declare tgl varchar(10);
    declare tanggal int;
    declare bulan int;
    
	select concat(
		substring(id_beli, 3, 2), '-',
		substring(id_beli, 5, 2), '-', 
		substring(id_beli, 7, 4)) into tgl
    from h_beli
    order by 1
    limit 1;
    
    set tanggal = (substring(tgl, 1, 2)) + 1;
    set bulan = substring(tgl, 4, 2);
    
    if tanggal = 31 then
		set tanggal = 01;
        set bulan = bulan + 1;
    end if;
    
	return concat('TB', lpad(tanggal, 2, 0), lpad(bulan, 2, 0), substring(tgl, 7, 4), '00001');
end$$
delimiter ;

select db_apotik.fGenerateId();

##### SOAL NO 5 ######

drop function fCekStock;

delimiter $$
create function fCekStock(id_input varchar(10), jmlh_minta int)
returns varchar(15) reads sql data
begin
	declare jmlh_stock int;
    
    select stock_obat into jmlh_stock
    from obat
    where id_obat = id_input;
    
    if jmlh_stock < jmlh_minta
    then return 'TIDAK_CUKUP';
    elseif jmlh_stock >= jmlh_minta
    then return 'CUKUP';
    end if;
end$$
delimiter ;

select db_apotik.fCekStock('B0013', 100);
