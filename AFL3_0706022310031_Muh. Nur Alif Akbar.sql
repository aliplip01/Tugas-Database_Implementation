use afl_dbi;
-- A
-- 1.) TRUE
-- 2.) TRUE
-- 3.) FALSE
-- 4.) FALSE
-- 5.) FALSE

-- B
-- 6.) 
-- INSERT:
-- NEW digunakan untuk mengakses data baru yang akan dimasukkan ke tabel.
-- OLD tidak tersedia karena data lama belum ada.
-- UPDATE:
-- OLD digunakan untuk mengakses data sebelum perubahan dilakukan.
-- NEW digunakan untuk mengakses data baru setelah perubahan dilakukan.
-- DELETE:
-- OLD digunakan untuk mengakses data yang akan dihapus.
-- NEW tidak tersedia karena data baru tidak ada.

-- 7.)
-- IN = act as input value to procedure/functions
-- OUT = act as output value to procedure
-- INOUT = act as input also output value to procedure 

-- C
-- 8.) 
DELIMITER $$
CREATE PROCEDURE TrackLateReturns()
BEGIN
	SELECT 
		BorrowID, BorrowDate, ReturnDate, 
		if(datediff(ReturnDate, BorrowDate) > 14, 
        datediff(ReturnDate, BorrowDate)-14, 0) as DaysLate
	from BORROWS;
END $$
DELIMITER ;

SELECT 
	BorrowID, BorrowDate, ReturnDate, 
    if(datediff(ReturnDate, BorrowDate) > 14, datediff(ReturnDate, BorrowDate)-14, 0) as DaysLate
from BORROWS;

-- 9.)
DELIMITER $$
CREATE FUNCTION CalculateFine(BD DATE, RD DATE)
RETURNS DECIMAL (10,2) READS SQL DATA
BEGIN 
	DECLARE HASIL DECIMAL(10,2);
    SET HASIL = IF(DATEDIFF(RD,BD) > 14, (DATEDIFF(RD,BD) - 14) * 0.50, 0.00);
    RETURN HASIL;
END $$
DELIMITER ;

-- 10.)
DELIMITER $$
CREATE FUNCTION IsBookAvailable(ID VARCHAR(4))
RETURNS VARCHAR(3) READS SQL DATA
BEGIN
	DECLARE HASIL VARCHAR(3);
    SELECT IF(STOCK > 0, 'YES', 'NO') INTO HASIL
    FROM BOOKS
    WHERE BookID = ID;
    RETURN HASIL;
END $$
DELIMITER ;

-- 11.)
DELIMITER $$
CREATE TRIGGER AutoGenerateBookID
BEFORE INSERT ON BOOKS FOR EACH ROW
BEGIN 
	DECLARE MAX_ID INT;
    SELECT CAST(MAX(SUBSTRING(BookID, 2)) AS UNSIGNED) INTO MAX_ID
    FROM BOOKS;
    SET NEW.BookID = CONCAT('B', LPAD(MAX_ID + 1, 3, '0'));
END $$
DELIMITER ;

-- 12.)
SELECT*FROM BOOKS;
SELECT*FROM BORROWDETAILS;
DELIMITER $$
CREATE TRIGGER UpdateStockAfterBorrow
AFTER INSERT ON BORROWDETAILS FOR EACH ROW
BEGIN
	UPDATE BOOKS
    SET Stock = Stock - NEW.Quantity
    WHERE BookID = NEW.BookID;
END $$
DELIMITER ;





