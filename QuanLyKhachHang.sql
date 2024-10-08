--1 . TAO CAC QUAN HE VAF KHAI BAO KHOA

CREATE DATABASE QLBH
GO

USE QLBH
GO

SET DATEFORMAT DMY

-- Bang khach hang
CREATE TABLE KHACHHANG
(
MAKH char(4) ,
HOTEN varchar(40),
DCHI varchar(50),
SODT  varchar(20),
NGSINH smalldatetime,
NGDK smalldatetime,
DOANHSO  money,
CONSTRAINT PK_KH PRIMARY KEY (MAKH),
);

-- Bang nhan vien
CREATE TABLE NHANVIEN
(
MANV char(4) ,
HOTEN varchar(40) ,
SODT varchar(20),
NGVL smalldatetime,
CONSTRAINT PK_NV PRIMARY KEY(MANV),
);

-- Bang san pham
CREATE TABLE SANPHAM
(
MASP char(4),
TENSP varchar(40),
DVT varchar(20),
NUOCSX varchar(40),
GIA money,
CONSTRAINT PK_SP PRIMARY KEY (MASP),
);

-- Bang hoa don
CREATE TABLE HOADON
(
SOHD int ,
NGHD smalldatetime,
MAKH char(4) REFERENCES KHACHHANG,
MANV char(4) REFERENCES NHANVIEN,
TRIGIA money,
CONSTRAINT PK_HD PRIMARY KEY (SOHD),
--CONSTRAINT FK_HD_KH FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH),
);

-- Bang CTHD
CREATE TABLE CTHD
(
	SOHD INT  REFERENCES HOADON,
	MASP CHAR(4)  REFERENCES SANPHAM,
	SL INT,
	CONSTRAINT PK_CTHD PRIMARY KEY (SOHD, MASP),
);

--2 THEM VAO THUOC TINH GHICHU CHO QH SANPHAM
ALTER TABLE SANPHAM ADD GHICHU varchar(20)

-- 3 THEM THUOC TINH LOAIKH CHO QH KHACHHANG
ALTER TABLE KHACHHANG ADD LOAIKH tinyint

-- 4 SUA KIEU DU LIEU THUOC TINH GHICHU TRONG QH SANPHAM
ALTER TABLE SANPHAM ALTER COLUMN GHICHU varchar(100)

--5 XOA THUOC TINH GHICHU TRONG QH SANPHAM
ALTER TABLE SANPHAM DROP COLUMN GHICHU

--6
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH VARCHAR(12)
ALTER TABLE KHACHHANG ADD CONSTRAINT CHK_LOAIKH CHECK (LOAIKH IN ('Vang lai', 'Thuong xuyen', 'Vip'))
--7
ALTER TABLE SANPHAM ADD CONSTRAINT CHK_DVT CHECK (DVT IN ('cay', 'hop', 'cai', 'quyen', 'chuc'))

--8
ALTER TABLE SANPHAM ADD CONSTRAINT CHECK_GIA CHECK (GIA >=500)

--9
ALTER TABLE HOADON ADD CONSTRAINT CHECK_TRIGIA CHECK (TRIGIA >=1)

--10
ALTER TABLE KHACHHANG ADD CONSTRAINT CHECK_NGDK CHECK (NGDK >NGSINH)

