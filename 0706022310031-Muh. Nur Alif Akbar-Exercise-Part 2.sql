-- A Theory
-- 1. True
-- 2. True
-- 3. True
-- 4. False

-- A Essay
-- 5. Eror, karena tidak bisa jalan semenjak perintahnya after atau before insert table
-- 6. OLD = data lama sebelum di update, NEW = data baru setelah di update

-- B 
-- 7. 

delimiter $$
create trigger generateM
before insert on student for each row
begin
	declare gender varchar (15);
    if (new.Gender = 'Laki-laki') then
		set new.Gender = 'M';
	else 
		set new.Gender = 'F';
	end if;
end $$
delimiter ;

insert into student values ('997','Joko Tingkir','SBY','Perempuan');
select * from student order by 1 desc;

-- 8. 

delimiter $$
create function pGenerate_nim(input varchar(5))
returns varchar(9) reads sql data
begin
    declare new_nim varchar(9);
    declare last_nim varchar(9);
    declare last_num int;

    select max(NIM) into last_nim
    from student
    where NIM like concat(input, '%');

    if last_nim is not null then
        set last_num = cast(substring(last_nim, length(input) + 1) as unsigned);
        set new_nim = concat(input, lpad(last_num + 1, 4, '0'));
    else
        set new_nim = concat(input, '0001');
    end if;
    return new_nim;
end $$
delimiter ;

delimiter $$
create trigger generate_nim
before insert on student for each row
begin
    set new.NIM = pGenerate_nim(substring(new.NIM, 1, 5));
end $$
delimiter ;

-- 9 

delimiter $$
create trigger no9
before insert on subject_mark for each row
begin
	declare have_lab varchar(1);
    
    select HaveLab into have_lab
    from subject
    where Code = new.Code;
    
    if have_lab = 'N' then
		set new.PassLab = '-';
    elseif have_lab = 'Y' then
		if new.MidOrLab > 60 then
			set new.PassLab = 'Y';
		else
			set new.PassLab = 'N';
            set new.FinalExam = 0;
            set new.FinalScore = 0;
		end if;
	end if;
end $$
delimiter ;

-- 10 

delimiter $$
create trigger no10
before update on subject_mark for each row
begin 
	set new.FinalScore = (0.3 * new.MidOrLab) + (0.7 * new.FinalExam);
end $$
delimiter ;


