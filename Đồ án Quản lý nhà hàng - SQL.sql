

-- Nhóm sử dụng một số kiến thức chưa học so với chương trình học hiện tại
-- 1. Proceduce , view: tiện, dễ dàng trong quá trình xử lý truy vấn một cách linh hoạt
-- 2. Các lệnh điều kiện, rẽ nhánh (if-else, case-when)
-- 3. Lệnh khai báo CREATE OR ALTER (có thể chỉnh sửa trực tiếp PROC hoặc VIEW mà không cần DROP)
-- :v Cô nên chạy từng phần 1 theo thứ tự, vì chỗ view nhóm không biết sao chạy 1 cục thì nó chạy được mà phải chạy từng cái 1
-- Một số truy vấn nhóm chưa xử lý tối ưu được, ví dụ ở tìm bàn và nhân viên, nhóm chưa tìm ra cách để input vào là (Trống/Đầy) đối với Bàn
-- và (NAM/NỮ) đối với Nhân viên để nó quy về dạng bit (0/1) là kiểu dữ liệu tương ứng trên bảng,...


-- Bảng NHÓM DỊCH VỤ
CREATE TABLE NhomDV
(
  MaNDV CHAR(10),
  TenNDV NCHAR(20) UNIQUE NOT NULL,
  CONSTRAINT PK_NDV PRIMARY KEY (MaNDV)
);
-------------------------

-- Bảng DỊCH VỤ
CREATE TABLE DichVu
(
  MaDV CHAR(5), 
  TenDV NCHAR(50) NOT NULL,
  Size TINYINT DEFAULT 1 NOT NULL,
  GiaDV INT NOT NULL,
  MaNDV CHAR(10) NOT NULL,
  CONSTRAINT PK_DV PRIMARY KEY (MaDV),
  CONSTRAINT FK_DV_NDV FOREIGN KEY (MaNDV) REFERENCES NhomDV(MaNDV),
  CONSTRAINT C_GiaDV CHECK (GiaDV >= 0),
  CONSTRAINT C_Size CHECK (Size > 0),
  CONSTRAINT U_DV UNIQUE (TenDV,Size),
  CONSTRAINT C_MaDV CHECK (MaDV like 'DV%')
);
-- Size lớn hơn 0 và mặc định khi nhập thông tin là 1, Giá các dịch vụ nhỏ nhất là 0VNĐ, Các dịch vụ phải có mã bắt đầu bằng DV
-------------------------

-- Bảng KHU VỰC
CREATE TABLE KhuVuc
(
  MaKV CHAR(3),
  TenKV NCHAR(10) UNIQUE NOT NULL,
  CONSTRAINT PK_KV PRIMARY KEY (MaKV)
);
-------------------------

-- Bảng BÀN
CREATE TABLE Ban
(
  MaBan CHAR(5),
  TenBan NCHAR(10) UNIQUE NOT NULL,
  SoGhe TINYINT NOT NULL,
  TrangThaiBan BIT NOT NULL DEFAULT 0,
  MaKV CHAR(3) NOT NULL,
  CONSTRAINT PK_B PRIMARY KEY (MaBan),
  CONSTRAINT FK_B FOREIGN KEY (MaKV) REFERENCES KhuVuc(MaKV),
  CONSTRAINT C_SoGhe CHECK (SoGhe > 0 AND SoGhe <= 15)
);
ALTER TABLE Ban
ADD CONSTRAINT C_MaBan CHECK (MaBan like 'B%');
ALTER TABLE Ban
ADD CONSTRAINT C_TenBan CHECK (TenBan like N'BÀN %');

-- Số ghế của một bàn được giới hạn từ 1 đến 15, Mã bàn phải bắt đầu bằng B và tên bàn thì phải bắt đầu bằng BÀN
-------------------------


-- Bảng KHÁCH HÀNG
CREATE TABLE KhachHang
(
  MaKH CHAR(8),
  TenKH NCHAR(30),
  SdtKH CHAR(13),
  DiaChiKH NCHAR(30),
  CONSTRAINT PK_KH PRIMARY KEY (MaKH)
);
ALTER TABLE KhachHang
ADD CONSTRAINT C_MaKH CHECK (MaKH like 'KH%');
--Mã khách hàng phải bắt đầu bằng KH
-------------------------


-- Bảng CA LÀM
CREATE TABLE CaLam
(
  MaCaLam CHAR(2),
  TenCaLam NCHAR(10) UNIQUE NOT NULL,
  TienCong INT NOT NULL,
  CONSTRAINT PK_CL PRIMARY KEY (MaCaLam),
  CONSTRAINT C_TienCong CHECK (TienCong >= 200000 AND TienCong <= 500000)
);
-- Tiền công một ca làm giới hạn từ 200000 đến 500000
-------------------------


-- Bảng CHỨC VỤ
CREATE TABLE ChucVu
(
  MaCV CHAR(5),
  TenCV NCHAR(30) UNIQUE NOT NULL,
  HeSoLuong FLOAT(2) NOT NULL,
  CONSTRAINT PK_CV PRIMARY KEY (MaCV),
  CONSTRAINT C_HeSoLuong CHECK (HeSoLuong >= 1 and HeSoLuong <= 3)
);
-- Hệ số lương giới hạn trong khoảng [1;3]
-------------------------


-- Bảng NHÂN VIÊN
CREATE TABLE NhanVien
(
  MaNV CHAR(4),
  TenNV NCHAR(50) NOT NULL,
  GioiTinh BIT NOT NULL,
  SdtNV CHAR(13) NOT NULL,
  DiaChiNV NCHAR(30) NOT NULL,
  NgaySinh DATE NOT NULL,
  NgayBatDauLam DATE NOT NULL,
  MaCV CHAR(5) NOT NULL,
  CONSTRAINT PK_NV PRIMARY KEY (MaNV),
  CONSTRAINT FK_NV_CV FOREIGN KEY (MaCV) REFERENCES ChucVu(MaCV),
  CONSTRAINT C_Tuoi CHECK ((DATEDIFF(DAY,NgaySinh,NgayBatDauLam)) >=6570 )
);
ALTER TABLE NhanVien
ADD CONSTRAINT C_MaNV CHECK (MaNV like 'NV%');
-- Nhân viên phải trên 18 tuổi ( nhóm tính theo ngày cho chắc ăn ạ :v ), Mã nhân viên phải bắt đầu bằng NV 
-------------------------

-- Bảng CHI TIẾT CA LÀM
CREATE TABLE ChiTietCaLam
(
  MaNV CHAR(4) NOT NULL,
  MaCaLam CHAR(2) NOT NULL,
  NgayLam DATE NOT NULL,
  ChamCong BIT NOT NULL DEFAULT 0,
  CONSTRAINT PK_CTCL PRIMARY KEY (NgayLam, MaNV, MaCaLam),
  CONSTRAINT FK_CTCL_NV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
  CONSTRAINT FK_CTCL_CL FOREIGN KEY (MaCaLam) REFERENCES CaLam(MaCaLam),
);
-------------------------

-- Bảng HÓA ĐƠN
CREATE TABLE HoaDon
(
  MaHD CHAR(8) ,
  ThoiGianLap DATE DEFAULT GETDATE() NOT NULL,
  MaNV CHAR(4) NOT NULL,
  MaBan CHAR(5) NOT NULL,
  MaKH CHAR(8) NOT NULL,
  CONSTRAINT PK_HD PRIMARY KEY (MaHD),
  CONSTRAINT FK_HD_NV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
  CONSTRAINT FK_HD_B FOREIGN KEY (MaBan) REFERENCES Ban(MaBan),
  CONSTRAINT FK_HD_KH FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);
ALTER TABLE HoaDon
ADD CONSTRAINT C_MaHD CHECK (MaHD like 'HD%');
-- Mã hóa đơn phải bắt đầu bằng HD
-------------------------

-- Bảng CHI TIẾT HÓA ĐƠN
CREATE TABLE ChiTietHD
(
  MaHD CHAR(8) NOT NULL,
  MaDV CHAR(5) NOT NULL,
  SoLuong TINYINT NOT NULL,
  PRIMARY KEY (MaHD, MaDV),
  FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
  FOREIGN KEY (MaDV) REFERENCES DichVu(MaDV),
  CONSTRAINT C_SoLuong CHECK (SoLuong > 0)
);
--Các bản ghi nhập vào phải có số lượng của dịch vụ lớn hơn 0

--------------------


-- Nhập dữ liệu nhóm dịch vụ
INSERT INTO NhomDV (MaNDV,TenNDV) VALUES 
('COM',N'CƠM'),
('BUN','BÚN'),('PHO',N'PHỞ'),('DCHAY',N'ĐỒ CHAY'),('DNUONG',N'ĐỒ NƯỚNG'),
('NNGOT',N'NƯỚC NGỌT'),('BIA','BIA'),('NKHOANG',N'NƯỚC KHOÁNG'),
('TMIENG',N'TRÁNG MIỆNG'),('TUTHIEN',N'TỪ THIỆN'),('LAU',N'LẨU'),('CANH','CANH');


-- Nhập dữ liệu các dịch vụ
INSERT INTO DichVu VALUES
('DV01',N'CƠM SƯỜN BÒ',DEFAULT,69000,'COM'),('DV02',N'CƠM HẤP LÁ SEN',DEFAULT ,62000,'COM'),
('DV03',N'CƠM GÀ TAM KỲ',DEFAULT ,55000,'COM'),('DV04',N'CƠM RANG THẬP CẨM',DEFAULT ,45000,'COM'),
('DV05',N'CƠM THỊT KHO NƯỚC DỪA',DEFAULT,56000,'COM'),('DV06',N'CƠM THỊT TRƯNG MẮM RUỐC',DEFAULT,60000,'COM'),
('DV07',N'BÚN BÒ',DEFAULT ,60000,'BUN'),('DV08',N'BÚN CÁ NGỪ',DEFAULT,60000,'BUN'),('DV09',N'BÚN THỊT NƯỚNG',DEFAULT,56000,'BUN'),
('DV10',N'PHỞ BÒ',DEFAULT,62000,'PHO'),('DV11',N'PHỞ CUNG ĐÌNH',DEFAULT,75000,'PHO'),('DV12',N'PHỞ CUỐN',DEFAULT,60000,'PHO'),
('DV13',N'PHỞ TRỘN',DEFAULT,50000,'PHO'),('DV14',N'PHỞ CHIÊN',DEFAULT,60000,'PHO'),('DV15',N'KHỔ QUA XÀO ĐẬU',DEFAULT,40000,'DCHAY'),
('DV16',N'GỎI XOÀI CHAY',DEFAULT,40000,'DCHAY'),('DV17',N'CHẢ BẮP CHAY',DEFAULT,40000,'DCHAY'),('DV18',N'ĐẬU COVE XÀO VỪNG',DEFAULT,40000,'DCHAY'),
('DV19',N'CANH CHUA CHAY',DEFAULT,40000,'DCHAY'),('DV20',N'LẨU CHÁO BÒ',DEFAULT,100000,'LAU'),('DV21',N'LẨU CHÁO BÒ',3,290000,'LAU'),
('DV22',N'LẨU CHÁO BÒ',5,470000,'LAU'),('DV23',N'LẨU BÒ NHÚNG DẤM',3,450000,'LAU'),('DV24',N'LẨU BÒ NHÚNG DẤM',5,720000,'LAU'),
('DV25',N'LẨU ẾCH',3,270000,'LAU'),('DV26',N'LẨU ẾCH',5,435000,'LAU'),('DV27',N'LẨU GÀ RƯỢU NẾP',3,270000,'LAU'),
('DV28',N'LẨU GÀ RƯỢU NẾP',5,435000,'LAU'),('DV29',N'LẨU CÁ NGỪ',5,690000,'LAU'),('DV30',N'LẨU NƯỚNG',3,270000,'LAU'),
('DV31',N'LẨU NƯỚNG',5,435000,'LAU'),('DV32',N'GÀ NƯỚNG HUN KHÓI',3,200000,'DNUONG'),('DV33',N'BA CHỈ BÒ MỸ',DEFAULT,100000,'DNUONG'),
('DV34',N'VAI HEO NƯỚNG',DEFAULT,100000,'DNUONG'),('DV35',N'TÔM NƯỚNG MUỐI ỚT',DEFAULT,100000,'DNUONG'),
('DV36',N'LƯƠN NƯỚNG NGHỆ',DEFAULT,100000,'DNUONG'),('DV37',N'VỊT NƯỚNG BẮC GIANG',3,200000,'DNUONG'),
('DV38',N'SET NƯỚNG TỔNG HỢP',10,1999000,'DNUONG'),('DV39',N'BIA 321',DEFAULT,20000,'BIA'),('DV40',N'BIA TPHCM',DEFAULT,20000,'BIA'),
('DV41',N'BIA THỦ ĐÔ',DEFAULT,20000,'BIA'),('DV42',N'BIA TYGER',DEFAULT,20000,'BIA'),('DV43',N'BIA HEIKEN',DEFAULT,25000,'BIA'),
('DV44',N'BIA HASAGI',DEFAULT,30000,'BIA'),('DV45',N'KOKA COLA',DEFAULT,20000,'NNGOT'),('DV46',N'BEPXI',DEFAULT,20000,'NNGOT'),
('DV47',N'FENTA ORANGE',DEFAULT,20000,'NNGOT'),('DV48',N'SUBCRI',DEFAULT,20000,'NNGOT'),('DV49',N'READ PULL',DEFAULT,20000,'NNGOT'),
('DV50',N'LEVIA',DEFAULT,15000,'NKHOANG'),('DV51',N'DENSE',DEFAULT,15000,'NKHOANG'),('DV52',N'AQUEFILA',DEFAULT,15000,'NKHOANG'),
('DV53',N'CHÈ SEN LONG NHÃN',DEFAULT,25000,'TMIENG'),('DV54',N'CHÈ CHUỐI',DEFAULT,25000,'TMIENG'),
('DV55',N'CHÈ KHOAI TÍA',DEFAULT,25000,'TMIENG'),('DV56',N'CHÈ ĐẬU XANH',DEFAULT,25000,'TMIENG'),
('DV57',N'CHÈ BẮP',DEFAULT,25000,'TMIENG'),('DV58',N'CHÈ BƯỞI',DEFAULT,25000,'TMIENG'),
('DV59',N'CANH CUA MỒNG TƠI',DEFAULT,30000,'CANH'),('DV60',N'CANH CHUA THỊT BĂM',DEFAULT,30000,'CANH'),
('DV61',N'CANH CHUA CÁ LÓC',DEFAULT,30000,'CANH'),('DV62',N'CANH NGAO CHUA',DEFAULT,30000,'CANH'),
('DV63',N'CANH SƯỜN NẤU ME',DEFAULT,30000,'CANH'),('DV64',N'CANH GÀ LÁ GIANG',DEFAULT,30000,'CANH'),
('DV65',N'SET CƠM TỪ THIỆN',DEFAULT,0,'TUTHIEN')
;

-- Nhập dữ liệu khu vực
INSERT INTO KhuVuc VALUES
('TA1',N'TẦNG 1'),('TA2',N'TẦNG 2'),('TA3',N'TẦNG 3');

-- Nhập dữ liệu bàn
INSERT INTO Ban VALUES
('B01',N'BÀN 01',2,1,'TA1'),('B02',N'BÀN 02',2,1,'TA1'),('B03',N'BÀN 03',2,1,'TA1'),
('B04',N'BÀN 04',2,1,'TA1'),('B05',N'BÀN 05',2,DEFAULT,'TA1'),('B06',N'BÀN 06',2,1,'TA1'),('B07',N'BÀN 07',4,DEFAULT,'TA1'),
('B08',N'BÀN 08',4,1,'TA1'),('B09',N'BÀN 09',4,1,'TA1'),('B10',N'BÀN 10',4,DEFAULT,'TA1'),('B11',N'BÀN 11',4,1,'TA1'),
('B12',N'BÀN 12',4,1,'TA1'),('B13',N'BÀN 13',4,DEFAULT,'TA1'),('B14',N'BÀN 14',4,1,'TA1'),('B15',N'BÀN 15',4,DEFAULT,'TA1'),
('B16',N'BÀN 16',4,DEFAULT,'TA1'),('B17',N'BÀN 17',4,1,'TA1'),('B18',N'BÀN 18',4,1,'TA1'),('B19',N'BÀN 19',4,DEFAULT,'TA1'),
('B20',N'BÀN 20',4,DEFAULT,'TA1'),('B21',N'BÀN 21',6,DEFAULT,'TA1'),('B22',N'BÀN 22',6,DEFAULT,'TA1'),('B23',N'BÀN 23',6,DEFAULT,'TA1'),
('B24',N'BÀN 24',6,1,'TA1'),('B25',N'BÀN 25',6,DEFAULT,'TA1'),('B26',N'BÀN 26',6,DEFAULT,'TA2'),('B27',N'BÀN 27',6,1,'TA2'),
('B28',N'BÀN 28',6,DEFAULT,'TA2'),('B29',N'BÀN 29',8,1,'TA2'),('B30',N'BÀN 30',8,1,'TA2'),('B31',N'BÀN 31',8,DEFAULT,'TA2'),
('B32',N'BÀN 32',8,DEFAULT,'TA2'),('B33',N'BÀN 33',8,DEFAULT,'TA2'),('B34',N'BÀN 34',8,1,'TA2'),('B35',N'BÀN 35',8,1,'TA2'),
('B36',N'BÀN 36',8,1,'TA2'),('B37',N'BÀN 37',8,1,'TA2'),('B38',N'BÀN 38',8,DEFAULT,'TA2'),('B39',N'BÀN 39',8,DEFAULT,'TA2'),
('B40',N'BÀN 40',8,1,'TA2'),('B41',N'BÀN 41',10,1,'TA3'),('B42',N'BÀN 42',10,1,'TA3'),('B43',N'BÀN 43',10,1,'TA3'),
('B44',N'BÀN 44',10,1,'TA3'),('B45',N'BÀN 45',10,1,'TA3'),('B46',N'BÀN 46',15,1,'TA3'),('B47',N'BÀN 47',15,1,'TA3'),
('B48',N'BÀN 48',15,1,'TA3'),('B49',N'BÀN 49',15,1,'TA3'),('B50',N'BÀN 50',15,1,'TA3')
;

-- Nhập dữ liệu chức vụ
INSERT INTO ChucVu VALUES 
('TN',N'THU NGÂN',1.8),('BB',N'NHÂN VIÊN BỒI BÀN',1.8),('CM',N'NHÂN VIÊN CHẠY MÓN',1.8),
('BV',N'BẢO VỆ',1.7),('PQL',N'PHÓ QUẢN LÝ',2.3),('QL',N'QUẢN LÝ',3.0);


-- Nhập dữ liệu ca làm
INSERT INTO CaLam VALUES 
('SA',N'SÁNG',280000),('TR',N'TRƯA',275000),('CH',N'CHIỀU',250000),('TO',N'TỐI',290000);

-- Nhập dữ liệu khách hàng
INSERT INTO KhachHang VALUES 
('KH01',NULL,NULL,NULL),('KH02',N'NGUYỄN VĂN AN','0987654321',N'BA ĐÌNH'),
('KH03',N'TRẦN VĂN BÌNH',NULL,NULL),('KH04',NULL,NULL,NULL),('KH05',N'NGUYỄN THỊ LAN',NULL,N'THANH XUÂN'),
('KH06',NULL,'09812323646',NULL),('KH07',N'HHENIE',NULL,NULL),('KH08',NULL,NULL,NULL),
('KH09',NULL,NULL,NULL),('KH10',N'HAI BÀ TRƯNG',NULL,NULL),('KH11',N'THẠCH SANH',NULL,NULL),
('KH12',N'YASUO GÁNH TEAM',NULL,N'CẦU GIẤY'),('KH13',N'NGUYỄN NHẬT MINH',NULL,N'CẦU GIẤY'),
('KH14',N'TRỊNH TIẾN DŨNG',NULL,N'THANH XUÂN'),('KH15',N'LÊ THÀNH DUY',NULL,N'HAI BÀ TRƯNG'),
('KH16',N'PHẠM QUỐC BẢO',NULL,N'BA ĐÌNH'),('KH17',N'LƯƠN ĐỨC ANH',NULL,N'HAI BÀ TRƯNG'),
('KH18',N'SƠN',NULL,NULL),('KH19',N'VĂN HƯNG','0985423756',NULL),('KH20',NULL,NULL,NULL),
('KH21',N'TÙNG',NULL,NULL),('KH22',NULL,'0939494123',NULL),('KH23',NULL,NULL,NULL),('KH24',N'SƠN',NULL,N'THANH XUÂN'),
('KH25','LONG',NULL,N'BA ĐÌNH'),('KH26',NULL,NULL,NULL),('KH27',N'TRẦN VĂN BÌNH',NULL,N'HOÀN KIẾM'),('KH28',NULL,NULL,N'CẦU GIẤY'),
('KH29',NULL,NULL,N'THANH TRÌ'),('KH30',NULL,NULL,NULL),('KH31',NULL,NULL,N'THẠCH THẤT'),('KH32',N'TÙNG',NULL,NULL),
('KH33','LINH',NULL,N'THƯỜNG TÍN'),('KH34','VU QUY',NULL,N'THƯỜNG TÍN'),('KH35',NULL,NULL,N'THANH TRÌ'),('KH36',N'MINH',NULL,N'THẠCH THẤT');


-- Nhập dữ liệu nhân viên
INSERT INTO NhanVien VALUES 
('NV01',N'NGUYỄN THỊ NHẬT MINH',0,'0987654321',N'MINH KHAI','2002-06-09','2020-10-01','PQL'),
('NV02',N'TRỊNH TIẾN DŨNG',1,'0981895084',N'THANH XUÂN','2002-04-05','2021-02-19','PQL'),('NV00',N'QUẢN VĂN LÝ',1,'0999999999',N'HOÀN KIẾM','1992-03-14','2019-11-20','QL')
,('NV03',N'PHẠM QUỐC BẢO',1,'0944806666',N'BA ĐÌNH','1999-09-11','2020-11-12','PQL'),
('NV04',N'NGUYỄN NHẬT ANH',0,'09835678435',N'THANH XUÂN','1995-05-01','2019-10-10','TN'), 
('NV05',N'LÊ THÀNH DƯƠNG',1,'09935678435',N'THANH XUÂN','1998-07-01','2019-10-10','TN'), 
('NV06',N'LÊ THỊ DUNG',0,'09735678435', N'THANH XUÂN','1997-01-08','2020-10-10','TN'), 
('NV07',N'TRẦN THỊ ĐĂNG',0,'09787678435',N'THANH XUÂN','1997-04-09','2021-10-10','TN'), 
('NV08',N'NGUYỄN DUY HƯNG',1,'09835667435',N'THANH XUÂN','2000-01-24','2019-10-10','BB'), 
('NV09',N'NGUYỄN VĂN THẮNG',1,'09836765435',N'THANH XUÂN','1995-11-25','2019-10-10','BB'), 
('NV10',N'HỒ THỊ QUÝ LEE',0,'09835456435',N'THANH XUÂN','1995-12-26','2019-10-10','BB'), 
('NV11',N'ĐEN THỊ VÂU',0,'09835678437',N'THANH XUÂN','1996-04-21','2019-10-10','BB'),
('NV12',N'NGUYỄN THỊ THANH TÙNG',0,'09835678438',N'THANH XUÂN','1992-05-11','2019-10-10','BB'), 
('NV13',N'LƯƠNG MAI ANH',0,'09835678439',N'THANH XUÂN','1993-09-01','2019-10-10','BB'), 
('NV14',N'ÂU DƯƠNG QUÁ',1,'09835678564',N'THANH XUÂN','1994-06-30','2020-10-10','BB'),
('NV15',N'TÔN THỊ SÁCH',0,'09835678547',N'HAI BÀ TRƯNG','1994-07-25','2020-10-10','BB'), 
('NV16',N'GIA CÁT LƯỢNG',1,'09835678454',N'HAI BÀ TRƯNG','1993-02-26','2020-10-10','BB'),
('NV17',N'QUAN VŨ',1,'09835678787',N'HAI BÀ TRƯNG','1992-03-29','2020-10-10','BB'), 
('NV18',N'PARK HANG SALE',1,'09835675465',N'HAI BÀ TRƯNG','1999-01-21','2020-10-10','BB'), 
('NV19',N'LEE MEAN HÔ',1,'09835674566',N'HAI BÀ TRƯNG','1998-03-22','2020-10-10','BB'),
('NV20',N'TỐNG THỊ GIANG',0,'09835677754',N'HAI BÀ TRƯNG','2001-04-21','2021-10-10','BB'), 
('NV21',N'NGUYỄN PHƯƠNG HẰNG',1,'09835673453',N'HAI BÀ TRƯNG','2000-05-15','2021-10-10','BB'), 
('NV22',N'TÔN THỊ KHÔNG',0,'09835647464',N'THANH XUÂN','2000-08-16','2019-10-10','CM'),
('NV23',N'DƯƠNG QUÁ',1,'09835674564',N'CẦU GIẤY','1999-10-17','2019-10-10','CM'),
('NV24',N'VŨ THỊ OANH',0,'09835345345',N'CẦU GIẤY','1999-11-18','2019-10-10','CM'), 
('NV25',N'KHƯƠNG DUY',1,'09835435433',N'CẦU GIẤY','1993-12-19','2019-10-10','CM'),
('NV26',N'TÔN THỊ QUYỀN',0,'09835632434',N'CẦU GIẤY','1995-12-20','2019-10-10','CM'),
('NV27',N'CHU DU',1,'09835678675',N'CẦU GIẤY','1999-11-21','2019-10-10','CM'), 
('NV28',N'LÊ THỊ KIM LIÊN',0,'09835687658',N'CẦU GIẤY','1994-01-22','2019-10-10','CM'),
('NV29',N'ĐOÀN THỊ ĐÀO',0,'09833453455',N'CẦU GIẤY','1995-02-23','2020-10-10','CM'), 
('NV30',N'HỨA THỊ QUYÊN',0,'09835675673',N'BA ĐÌNH','1992-03-24','2020-10-10','CM'),
('NV31',N'LÊ VĂN NUYỆN',1,'09835643534',N'BA ĐÌNH','1995-04-25','2020-10-10','CM'),
('NV32',N'SÀNG A HẢI',1,'09835678686',N'BA ĐÌNH','2000-05-26','2020-10-10','CM'),
('NV33',N'VÕ TÒNG',1,'09843543554',N'BA ĐÌNH','1985-06-27','2019-10-10','BV'), 
('NV34',N'TRIỆU TỬ LONG',1,'09835667634',N'BA ĐÌNH','1970-08-28','2020-10-10','BV'),
('NV35',N'LỮ BỐ',1,'09835664564',N'BA ĐÌNH','1970-12-29','2020-10-10','BV') ;

-- Nhập dữ liệu làm việc/ chấm công của nhân viên
INSERT INTO ChiTietCaLam VALUES 
('NV03','TO','2021-08-12',1),('NV05','TO','2021-08-12',1),('NV14','TO','2021-08-12',1),('NV18','TO','2021-08-12',1),
('NV19','TO','2021-08-12',1),('NV23','TO','2021-08-12',1),('NV26','TO','2021-08-12',0),('NV25','TO','2021-08-12',0),
('NV34','TO','2021-08-12',0),('NV04','CH','2021-08-17',1),('NV15','CH','2021-08-17',1),('NV17','CH','2021-08-17',1),
('NV16','CH','2021-08-17',1),('NV25','CH','2021-08-17',1),('NV26','CH','2021-08-17',0),
('NV27','CH','2021-08-17',1),('NV32','CH','2021-08-17',1),
('NV01','TO','2021-08-20',0),('NV05','TO','2021-08-20',0),('NV10','TO','2021-08-20',1),('NV11','TO','2021-08-20',1),
('NV12','TO','2021-08-20',1),('NV29','TO','2021-08-20',1),('NV30','TO','2021-08-20',0),('NV31','TO','2021-08-20',1),
('NV35','TO','2021-08-20',0),('NV02','CH','2021-08-24',1),('NV11','CH','2021-08-24',1),
('NV12','CH','2021-08-24',1),('NV13','CH','2021-08-24',0),('NV22','CH','2021-08-24',0),('NV23','CH','2021-08-24',1),
('NV24','CH','2021-08-24',1),('NV34','CH','2021-08-24',1),('NV03','SA','2021-08-27',1),('NV05','SA','2021-08-27',1),
('NV10','SA','2021-08-27',0),('NV11','SA','2021-08-27',1),('NV12','SA','2021-08-27',1),('NV27','SA','2021-08-27',0),
('NV28','SA','2021-08-27',1),('NV29','SA','2021-08-27',0),('NV34','SA','2021-08-27',1),('NV01','TR','2021-08-30',1),
('NV06','TR','2021-08-30',1),('NV16','TR','2021-08-30',1),
('NV17','TR','2021-08-30',1),('NV18','TR','2021-08-30',1),('NV23','TR','2021-08-30',1),
('NV24','TR','2021-08-30',0),('NV25','TR','2021-08-30',1),('NV34','TR','2021-08-30',1),
('NV01','CH','2021-09-03',0),
('NV10','CH','2021-09-03',1),('NV14','CH','2021-09-03',1),('NV26','CH','2021-09-03',1),
('NV27','CH','2021-09-03',1),('NV34','CH','2021-09-03',0),
('NV02','SA','2021-09-07',1),('NV04','CH','2021-09-07',1), ('NV09','SA','2021-09-07',1),
('NV11','SA','2021-09-07',1),('NV12','SA','2021-09-07',1),
('NV30','SA','2021-09-07',1),('NV29','SA','2021-09-07',0),('NV28','SA','2021-09-07',1),('NV34','SA','2021-09-07',1),
('NV03','TR','2021-09-12',0),('NV05','TR','2021-09-12',1),('NV14','TR','2021-09-12',1),('NV18','TR','2021-09-12',1),
('NV19','TR','2021-09-12',1),('NV23','TR','2021-09-12',1),('NV26','TR','2021-09-12',0),('NV25','TR','2021-09-12',1),
('NV34','SA','2021-09-12',1),('NV04','SA','2021-09-17',1),('NV15','SA','2021-09-17',1),('NV17','SA','2021-09-17',1),
('NV16','SA','2021-09-17',1),('NV25','SA','2021-09-17',1),('NV26','SA','2021-09-17',1),
('NV27','SA','2021-09-17',1),('NV32','SA','2021-09-17',1),
('NV01','CH','2021-09-20',0),('NV05','CH','2021-09-20',1),('NV10','TO','2021-09-20',1),('NV11','TO','2021-09-20',1),
('NV12','TO','2021-09-20',1),('NV29','TO','2021-09-20',1),('NV30','TO','2021-09-20',1),('NV31','TO','2021-09-20',1),
('NV35','TO','2021-09-20',1),('NV02','TO','2021-09-24',1),('NV11','TO','2021-09-24',1),
('NV12','TO','2021-09-24',1),('NV13','TO','2021-09-24',0),('NV22','TO','2021-09-24',1),('NV23','TO','2021-09-24',1),
('NV24','TO','2021-09-24',1),('NV34','TO','2021-09-24',1),('NV03','TR','2021-09-27',0),('NV05','TR','2021-09-27',1),
('NV10','TR','2021-09-27',0),('NV11','TR','2021-09-27',1),('NV12','TR','2021-09-27',1),('NV27','TR','2021-09-27',1),
('NV28','TR','2021-09-27',1),('NV29','TR','2021-09-27',1),('NV34','TR','2021-09-27',1),('NV01','TR','2021-09-30',1),
('NV06','TR','2021-09-30',1),('NV16','TR','2021-09-30',1),
('NV17','TR','2021-09-30',1),('NV18','TR','2021-09-30',1),('NV23','TR','2021-09-30',1),
('NV24','TR','2021-09-30',1),('NV25','TR','2021-09-30',0),('NV34','TR','2021-09-30',1),('NV02','CH','2021-10-02',1),
('NV06','CH','2021-10-02',1),('NV15','CH','2021-10-02',1),('NV16','CH','2021-10-02',1),
('NV17','CH','2021-10-02',0),('NV25','CH','2021-10-02',1),('NV26','CH','2021-10-02',1),('NV27','CH','2021-10-02',1),
('NV34','CH','2021-10-02',1),('NV02','TR','2021-10-05',1),('NV04','TR','2021-10-05',1),('NV12','TR','2021-10-05',1),
('NV13','TR','2021-10-05',1),('NV14','TR','2021-10-05',1),('NV25','TR','2021-10-05',1),('NV22','TR','2021-10-05',1),
('NV23','TR','2021-10-05',1),('NV34','TR','2021-10-05',1),('NV04','TO','2021-10-10',1),('NV07','TO','2021-10-10',1),
('NV19','TO','2021-10-10',1),('NV20','TO','2021-10-10',1),('NV21','TO','2021-10-10',1),('NV30','TO','2021-10-10',1),
('NV31','TO','2021-10-10',1),('NV32','TO','2021-10-10',1),('NV35','TO','2021-10-10',1),('NV01','SA','2021-10-15',1),
('NV07','SA','2021-10-15',1),('NV19','SA','2021-10-15',0),('NV20','SA','2021-10-15',1),('NV21','SA','2021-10-15',1),
('NV31','SA','2021-10-15',1),('NV32','SA','2021-10-15',1),('NV28','SA','2021-10-15',1),('NV35','SA','2021-10-15',1),
('NV01','TO','2021-09-01',1),('NV01','TR','2021-09-02',1),
('NV01','TR','2021-09-06',DEFAULT),('NV01','TR','2021-09-07',1),('NV01','CH','2021-09-15',DEFAULT),
('NV01','TO','2021-09-20',1),('NV01','SA','2021-09-25',DEFAULT),('NV01','SA','2021-09-30',1),
('NV01','SA','2021-10-01',1),('NV01','TO','2021-10-05',1),('NV01','SA','2021-10-09',1),
('NV00','TR','2021-09-01',DEFAULT),('NV00','SA','2021-09-04',DEFAULT),('NV00','TO','2021-09-09',1),
('NV00','CH','2021-09-15',1),('NV00','SA','2021-09-25',1),('NV00','TO','2021-09-30',DEFAULT),
('NV04','SA','2021-09-01',DEFAULT),('NV04','TR','2021-09-02',1),('NV04','SA','2021-09-03',1),
('NV04','SA','2021-09-05',1),('NV04','SA','2021-09-06',DEFAULT),('NV04','SA','2021-09-07',1),
('NV05','TO','2021-09-20',1),('NV05','SA','2021-09-21',1),('NV05','SA','2021-09-22',DEFAULT),
('NV05','TR','2021-09-23',1),('NV05','CH','2021-09-24',1),('NV05','CH','2021-09-25',1),
('NV05','SA','2021-09-26',1),('NV05','SA','2021-09-27',1),('NV05','TO','2021-09-28',1),
('NV05','TO','2021-10-10',1),('NV05','TO','2021-10-05',1),('NV04','TO','2021-10-08',1),('NV04','TO','2021-10-06',1),
('NV08','SA','2021-09-01',1),('NV08','TR','2021-09-02',1),('NV08','SA','2021-09-03',1),
('NV08','SA','2021-09-05',1),('NV08','SA','2021-09-06',DEFAULT),('NV08','SA','2021-09-07',1),
('NV09','SA','2021-09-20',1),('NV09','SA','2021-09-21',1),('NV09','SA','2021-09-22',1),
('NV09','TR','2021-09-23',DEFAULT),('NV09','CH','2021-09-24',1),('NV09','CH','2021-09-25',1),
('NV09','SA','2021-09-26',1),('NV09','SA','2021-09-27',1),('NV09','TO','2021-09-28',1),
('NV08','TO','2021-10-10',1),('NV08','TO','2021-10-05',1),('NV09','TO','2021-10-08',1),('NV09','TO','2021-10-06',1),
('NV22','SA','2021-09-01',1),('NV22','TR','2021-09-02',1),('NV22','SA','2021-09-03',1),
('NV22','SA','2021-09-05',DEFAULT),('NV22','SA','2021-09-06',1),('NV22','SA','2021-09-07',1),
('NV23','SA','2021-09-20',1),('NV23','SA','2021-09-21',1),('NV23','SA','2021-09-22',1),
('NV23','TR','2021-09-23',1),('NV23','CH','2021-09-24',DEFAULT),('NV23','CH','2021-09-25',1),
('NV23','SA','2021-09-26',1),('NV23','SA','2021-09-27',1),('NV23','TO','2021-09-28',1),
('NV22','TO','2021-10-10',1),('NV22','TO','2021-10-05',1),('NV22','TO','2021-10-08',1),('NV22','TO','2021-10-06',1),
('NV33','SA','2021-09-01',DEFAULT),('NV33','TR','2021-09-02',1),('NV33','SA','2021-09-03',1),
('NV33','SA','2021-09-05',1),('NV33','SA','2021-09-06',DEFAULT),('NV33','SA','2021-09-07',1),
('NV33','TO','2021-10-10',1),('NV33','TO','2021-10-05',1),('NV33','TO','2021-10-08',1),('NV33','TO','2021-10-06',1)
;


-- Nhập dữ liệu hóa đơn
INSERT INTO HoaDon VALUES 
('HD01','2021-08-12','NV05','B01','KH01'), --1 dv37x2 - 400000
('HD02','2021-08-12','NV05','B46','KH02'), --2 dv38x2+dv43x50 - 5248000
('HD03','2021-08-17','NV04','B45','KH03'), --3 dv38x1+dv44x20 - 2599000
('HD04','2021-08-27','NV05','B02','KH04'), --4 dv07x2+dv45x2 - 160000
('HD05','2021-08-27','NV05','B23','KH05'), --5 dv06x1+dv07x1+dv12x2+dv49x4 - 320000
('HD06','2021-08-30','NV06','B03','KH06'), --6 dv14x2 - 120000
('HD07','2021-08-30','NV06','B34','KH07'), --7 dv33x1+dv34x1+dv35x1+dv36x1+dv37x1+dv42x10 - 800000
('HD08','2021-09-02','NV04','B04','KH08'), --8 dv33x1+dv34x1+dv35x1+dv36x1+dv40x10 - 600000
('HD09','2021-09-02','NV04','B04','KH09'), --9 dv1x1 + dv39x1 - 89k
('HD10','2021-09-03','NV04','B35','KH10'), --10 dv38x1 + dv41x5 - 2999k
('HD11','2021-09-05','NV04','B23','KH11'), --11 dv36x1 + dv35x1 +dv34x1 + dv47x5 +dv48x5- 500k
('HD12','2021-09-07','NV04','B45','KH12'), --12 dv31x2 + dv42x10 - 1070k
('HD13','2021-09-12','NV05','B48','KH13'), --13 dv26x5 + dv42x100 - 4175000
('HD14','2021-09-17','NV04','B41','KH14'), --14 dv11x1 - 75k
('HD15','2021-09-21','NV05','B12','KH15'), --15 dv14x1 - 60k
('HD16','2021-09-23','NV05','B17','KH16'), --16 dv01x1 + dv03x1 +dv04x1 + dv05x1 + dv06x1 + dv46x5- 385k
('HD17','2021-09-25','NV05','B36','KH17'), --17 dv 02x3 + dv52x3- 231k
('HD18','2021-09-26','NV05','B12','KH18'), --18 dv 01x1- 69k
('HD19','2021-09-27','NV05','B34','KH19'), --19 dv01x4 +dv52x4 -336k
('HD20','2021-09-27','NV05','B32','KH20'), --20 dv01x10 +dv42x10 - 890k
('HD21','2021-09-28','NV05','B43','KH21'), --21 dv44x5 - 150k
('HD22','2021-09-28','NV05','B23','KH22'), --22 dv65x10 - 0
('HD23','2021-09-28','NV05','B21','KH23'), --23 dv08x6 + dv44x5 - 450k
('HD24','2021-09-30','NV05','B47','KH24'), --24 dv44x50 + dv38x3 + dv43x50 - 8747000
('HD25','2021-09-30','NV05','B14','KH25'), --25 dv10x3 + dv13x3 + dv14x2 + dv39x2 +dv44x2 + dv45x3 +dv47x1 - 636k
('HD26','2021-09-30','NV05','B05','KH26'), --26 dv31x1 + dv48x3 + dv45x2- 535k
('HD27','2021-09-30','NV05','B34','KH27'), --27 dv 65x3 - 0
('HD28','2021-10-02','NV06','B38','KH28'), --28 dv29x1 + dv33x3 +dv41x5- 1090k
('HD29','2021-10-02','NV06','B16','KH29'), --29 dv38x1 + dv43x10 + 53x10 - 2990k
('HD30','2021-10-05','NV05','B19','KH30'), --30 dv37x3 - 600k
('HD31','2021-10-06','NV04','B10','KH31'), --31 dv25x1 +dv23x1 + dv30x1 + dv33x3+ dv46x9 - 1470k
('HD32','2021-10-08','NV04','B49','KH32'), --32 dv29x4 + dv39x60 - 3960000
('HD33','2021-10-10','NV05','B07','KH33'), --33 dv01x3 +dv50x2 - 237k
('HD34','2021-10-10','NV04','B09','KH34'), --34 dv03x5+ dv52x5- 350k
('HD35','2021-10-10','NV07','B10','KH35'), --35 dv07x5- 300k
('HD36','2021-10-15','NV07','B11','KH36')  --36 dv09x2+dv08x3 + dv49x2 +dv46x2 + dv43x1 +dv53x5- 522k
;


-- Nhập dữ liệu chi tiết hóa đơn
INSERT INTO ChiTietHD VALUES
('HD01','DV37',2),
('HD02','DV38',2),
('HD02','DV43',50),
('HD03','DV38',1),
('HD03','DV44',20),
('HD04','DV45',2),
('HD04','DV07',2),
('HD05','DV07',1),
('HD05','DV06',1),
('HD05','DV12',2),
('HD05','DV49',4),
('HD06','DV14',2),
('HD07','DV33',1),
('HD07','DV34',1),
('HD07','DV35',1),
('HD07','DV36',1),
('HD07','DV37',1),
('HD07','DV42',10),
('HD08','DV33',1),
('HD08','DV34',1),
('HD08','DV35',1),
('HD08','DV36',1),
('HD08','DV40',10),
('HD09','DV01',1),
('HD09','DV39',1),
('HD10','DV38',1),
('HD10','DV41',5),
('HD11','DV36',1),
('HD11','DV35',1),
('HD11','DV34',1),
('HD11','DV47',5),
('HD11','DV48',5),
('HD12','DV31',2),
('HD12','DV42',10),
('HD13','DV26',5),
('HD13','DV42',100),
('HD14','DV11',1),
('HD15','DV14',1),
('HD16','DV01',1),
('HD16','DV03',1),
('HD16','DV04',1),
('HD16','DV05',1),
('HD16','DV06',1),
('HD16','DV46',5),
('HD17','DV02',3),
('HD17','DV52',3),
('HD18','DV01',1),
('HD19','DV01',4),
('HD19','DV52',4),
('HD20','DV01',10),
('HD20','DV42',10),
('HD21','DV44',5),
('HD22','DV65',10),
('HD23','DV08',6),
('HD23','DV44',5),
('HD24','DV44',50),
('HD24','DV38',3),
('HD24','DV43',50),
('HD25','DV10',3),
('HD25','DV13',3),
('HD25','DV14',2),
('HD25','DV39',2),
('HD25','DV44',2),
('HD25','DV45',3),
('HD25','DV47',1),
('HD26','DV31',1),
('HD26','DV48',3),
('HD26','DV45',2),
('HD27','DV65',5),
('HD28','DV29',1),
('HD28','DV33',3),
('HD28','DV41',5),
('HD29','DV38',1),
('HD29','DV43',10),
('HD29','DV53',10),
('HD30','DV37',3),
('HD31','DV25',5),
('HD31','DV23',5),
('HD31','DV30',1),
('HD31','DV33',3),
('HD31','DV46',9),
('HD32','DV29',4),
('HD32','DV39',60),
('HD33','DV01',3),
('HD33','DV50',2),
('HD34','DV03',5),
('HD34','DV52',5),
('HD35','DV07',5),
('HD36','DV09',2),
('HD36','DV08',3),
('HD36','DV49',2),
('HD36','DV46',2),
('HD36','DV43',1),
('HD36','DV53',5);


-- Proceduce hiển thị toàn bộ thông tin về NHÂN VIÊN
CREATE OR ALTER PROC ThongTin_NV
AS 
SELECT MaNV,TenNV,
		(case when GioiTinh=1 then 'NAM' else N'NỮ' end) AS GioiTinh,
		SdtNV,
		DiaChiNV,
		NgaySinh,
		NgayBatDauLam,
		MaCV
FROM NhanVien;

EXEC ThongTin_NV

-- Proceduce hiển thị toàn bộ thông tin về CHI TIẾT CA LÀM
CREATE OR ALTER PROC ThongTin_CTCL
AS SELECT 
		MaNV,
		MaCaLam,
		NgayLam,
		(case when ChamCong=1 then N'ĐI LÀM' else N'NGHỈ' end ) AS ChamCong
FROM ChiTietCaLam;

EXEC ThongTin_CTCL

-- Proceduce hiển thị toàn bộ thông tin về HÓA ĐƠN
CREATE OR ALTER PROC ThongTin_HD
AS SELECT * FROM HD;

EXEC ThongTin_HD

-- Proceduce hiển thị toàn bộ thông tin về DỊCH VỤ
CREATE OR ALTER PROC ThongTin_DV
AS SELECT * FROM DichVu;

EXEC ThongTin_DV

-- Proceduce hiển thị toàn bộ thông tin về KHÁCH HÀNG
CREATE OR ALTER PROC ThongTin_KH 
AS 
SELECT 
MaKH,
(case when TenKH is null then '' else TenKH end) as TenKH,
(case when SdtKH is null then '' else SdtKH end) as SdtKH,
(case when DiaChiKH is null then '' else DiaChiKH end) as DiaChiKH
FROM KhachHang;

EXEC ThongTin_KH

-- Proceduce hiển thị toàn bộ thông tin về KHU VỰC
CREATE OR ALTER PROC ThongTin_KV
AS SELECT KhuVuc.MaKV,TenKV,COUNT(Ban.MaKV) AS SoBan FROM KhuVuc INNER JOIN Ban ON KhuVuc.MaKV=Ban.MaKV GROUP BY KhuVuc.MaKV,TenKV;

EXEC ThongTin_KV

-- Proceduce hiển thị toàn bộ thông tin bảng BÀN
CREATE OR ALTER PROC ThongTin_Ban
AS SELECT 
MaBan,
TenBan,
SoGhe,
(case when TrangThaiBan=1 then N'CÓ KHÁCH' else N'TRỐNG' end) AS TrangThaiBan,
MaKV
FROM Ban;

EXEC ThongTin_Ban

-- Proceduce hiển thị toàn bộ thông tin về CHI TIẾT HÓA ĐƠN
CREATE OR ALTER PROC ThongTin_CTHD
AS SELECT * FROM CTHD;

EXEC ThongTin_CTHD

-- Proceduce hiển thị toàn bộ thông tin về NHÓM DỊCH VỤ
CREATE OR ALTER PROC ThongTin_NDV
AS 
BEGIN
SELECT NhomDV.MaNDV,TenNDV,COUNT(DichVu.MaNDV) AS SoLuongDV FROM NhomDV INNER JOIN DichVu ON NhomDV.MaNDV=DichVu.MaNDV GROUP BY NhomDV.MaNDV,TenNDV;
END;

EXEC ThongTin_NDV

-- Proceduce hiển thị toàn bộ thông tin về CHỨC VỤ
CREATE OR ALTER PROC ThongTin_CV
AS 
SELECT * FROM ChucVu;

EXEC ThongTin_CV

-- Proceduce hiển thị toàn bộ thông tin về CA LÀM
CREATE OR ALTER PROC ThongTin_CL
AS SELECT * FROM CaLam;

EXEC ThongTin_CL

-- View tiền chi tiết hóa đơn
CREATE OR ALTER VIEW CTHD
AS 
(SELECT MaHD,ChiTietHD.MaDV,SoLuong,GiaDV,GiaDV*SoLuong AS ThanhTien FROM DichVu INNER JOIN ChiTietHD on DichVu.MaDV=ChiTietHD.MaDV);

-- View tiền hóa đơn
CREATE OR ALTER VIEW HD 
AS 
(SELECT HoaDon.MaHD,ThoiGianLap,MaNV,MaBan,MaKH,SUM(ThanhTien) AS TongTienHD FROM CTHD INNER JOIN HoaDon ON CTHD.MaHD=HoaDon.MaHD GROUP BY HoaDon.MaHD,ThoiGianLap,MaNV,MaBan,MaKH);

-- View lượt sử dụng dịch vụ đồ uống theo từng tháng
CREATE OR ALTER VIEW LUOTSD_DVDU
AS
SELECT DichVu.MaDV,TenDV,MaNDV,SUM(SoLuong) AS LuotSD,SUM(SoLuong)*GiaDV AS ThanhTien,MONTH(ThoiGianLap) as Thang FROM (HoaDon inner join ChiTietHD on HoaDon.MaHD=ChiTietHD.MaHD) 
INNER JOIN DichVu on ChiTietHD.MaDV=DichVu.MaDV WHERE DichVu.MaNDV IN ('BIA','NNGOT','NKHOANG') GROUP BY DichVu.MaDV,TenDV,MaNDV,GiaDV,MONTH(ThoiGianLap)


-- View lượt sử dụng dịch vụ đồ ăn theo từng tháng
CREATE OR ALTER VIEW LUOTSD_DVDA
AS
SELECT DichVu.MaDV,TenDV,MaNDV,SUM(SoLuong) AS LuotSD,SUM(SoLuong)*GiaDV as ThanhTien,MONTH(ThoiGianLap) as Thang FROM (HoaDon inner join ChiTietHD on HoaDon.MaHD=ChiTietHD.MaHD) 
INNER JOIN DichVu on ChiTietHD.MaDV=DichVu.MaDV WHERE DichVu.MaNDV NOT IN ('BIA','NNGOT','NKHOANG') GROUP BY DichVu.MaDV,TenDV,MaNDV,GiaDV,MONTH(ThoiGianLap)

-- View lượt sử dụng nhóm dịch vụ đồ uống theo từng tháng
CREATE OR ALTER VIEW LUOTSD_NDVDU
AS
SELECT NhomDV.MaNDV,TenNDV,SUM(LuotSD) AS LuotSD,SUM(ThanhTien) as ThanhTien,Thang 
FROM LUOTSD_DVDU inner join NhomDV ON NhomDV.ManDV=LUOTSD_DVDU.MaNDV WHERE NhomDV.MaNDV IN ('BIA','NNGOT','NKHOANG') GROUP BY NhomDV.MaNDV,TenNDV,Thang

-- View lượt sử dụng nhóm dịch vụ đồ ăn theo từng tháng
CREATE OR ALTER VIEW LUOTSD_NDVDA
AS
SELECT NhomDV.MaNDV,TenNDV,SUM(LuotSD) AS LuotSD,SUM(ThanhTien) as ThanhTien,Thang 
FROM LUOTSD_DVDA inner join NhomDV ON NhomDV.ManDV=LUOTSD_DVDA.MaNDV WHERE NhomDV.MaNDV not IN ('BIA','NNGOT','NKHOANG') GROUP BY NhomDV.MaNDV,TenNDV,Thang


-- View lương nhân viên
CREATE OR ALTER VIEW TINHLUONG_NV
AS
SELECT ChiTietCaLam.MaNV,MONTH(NgayLam) as Thang,TienCong*HeSoLuong AS Luong
FROM (ChucVu INNER JOIN NhanVien ON ChucVu.MaCV = NhanVien.MaCV) INNER JOIN (CaLam INNER JOIN ChiTietCaLam ON CaLam.MaCaLam = ChiTietCaLam.MaCaLam) ON NhanVien.MaNV = ChiTietCaLam.MaNV
WHERE ChiTietCaLam.ChamCong=1


-- Kiểm tra tình trạng bàn đầy/trống của từng khu vực (KV đầy sẽ không hiển thị)

CREATE OR ALTER PROC TrangThaiKV 
AS 
BEGIN
SELECT Ban.MaKV,TenKV,Count(KhuVuc.MaKV) AS SoBanTrong 
FROM Ban inner JOIN KhuVuc on Ban.MaKV=KhuVuc.MaKV WHERE TrangThaiBan=0 GROUP BY Ban.MaKV,TenKV
END;

EXEC TrangThaiKV -- chạy cái truy vấn vừa viết ở bên trên ạ

-- Thêm khu vực
CREATE OR ALTER PROC Them_KV
@MaKV char(3),
@TenKV nchar(10)
as
begin
insert into KhuVuc values (@MaKV, @TenKV)
select MaKV, TenKV from KhuVuc where MaKV= @MaKV 
end;

exec Them_KV @MaKV='TA4',@TenKV=N'TẦNG 4' --Thêm 1 khu vực là TẦNG 4 với Mã khu vực là TA4

--Xóa Khu vực
CREATE OR ALTER PROC Xoa_KV
@MaKV char(3)
as
begin
delete from KhuVuc where MaKV=@MaKV
end;

EXEC Xoa_KV @MaKV='TA4' --Xóa khu vực có mã là TA4

-- Tìm bàn trống ( nếu có input thì sẽ tìm bàn trống theo input <số ghế hoặc khu vực>, không có thì sẽ tìm tất cả bàn trống )
CREATE OR ALTER PROC Tim_BTrong
@MaKV varCHAR(3) = null,
@SoGhe tinyint =null
AS
BEGIN
IF (@MaKV is null and @SoGhe is null) SELECT MaBan,TenBan, SoGhe,
		(case when TrangThaiBan=1 then N'CÓ KHÁCH' else N'TRỐNG' end) AS TrangThaiBan, MaKV
FROM Ban WHERE TrangThaiBan=0;
ELSE
SELECT MaBan,TenBan, SoGhe,
		(case when TrangThaiBan=1 then N'CÓ KHÁCH' else N'TRỐNG' end) AS TrangThaiBan,
		MaKV
FROM Ban WHERE (((MaKV like '%' +@MaKV+'%') or SoGhe=@SoGhe) and TrangThaiBan=0)
END;

EXEC Tim_BTrong --Tìm tất cả bàn trống
EXEC Tim_BTrong @SoGhe=4 --Tìm bàn trống có số ghế là 4
EXEC Tim_BTrong @MaKV='2' --Tìm bàn trống ở khu vực có mã khu vực có số 2
EXEC Tim_BTrong @MaKV='TA1' --Tìm bàn trống ở khu vực có mã là TA1


-- Tìm bàn
CREATE OR ALTER PROC Tim_Ban
@MaBan VARCHAR(3) = null,
@TenBan nvarchar (10) = null,
@Soghe tinyint = null,
@TrangThaiBan bit =null,
@MaKV varchar(3) = null
AS
BEGIN
SELECT MaBan,TenBan, SoGhe,
		(case when TrangThaiBan=1 then N'CÓ KHÁCH' else N'TRỐNG' end) AS TrangThaiBan,
		MaKV
FROM Ban WHERE (MaBan like '%' +@MaBan+ '%') or (TenBan like '%' +@TenBan+'%') or Soghe=@Soghe or TrangThaiBan=@TrangThaiBan or (MaKV like '%' + @MaKV +'%') 
END;

EXEC Tim_Ban @MaKV='3' --Tìm bàn ở khu vực có mã khu vực có số 3
EXEC Tim_Ban @TrangThaiBan=1 --Tìm bàn có khách
EXEC Tim_Ban @TenBan='45' --Tìm bàn số 45

-- Lượt sử dụng của từng loại bàn theo số ghế ( nếu có input sẽ hiển thị lượt sd theo tháng nhập vào, không có thì sẽ hiển lượt tổng sd từ trước đến giờ )

CREATE OR ALTER PROC LuotSD_Ban_Ghe
@Thang tinyint =null
AS
BEGIN
IF @Thang is null SELECT SoGhe AS BanCoSoGhe,COUNT(SoGhe) LuotSD FROM HoaDon INNER JOIN Ban ON HoaDon.MaBan=Ban.MaBan GROUP BY SoGhe;
ELSE
	SELECT SoGhe AS BanCoSoGhe,COUNT(SoGhe) LuotSD FROM HoaDon INNER JOIN Ban ON HoaDon.MaBan=Ban.MaBan WHERE MONTH(ThoiGianLap)=@Thang GROUP BY SoGhe
END;

EXEC LuotSD_Ban_Ghe -- tỉnh tổng lượt sử dụng của từng loại bàn theo số ghế từ trước đến giờ
EXEC LuotSD_Ban_Ghe @Thang=10 -- tỉnh tổng lượt sử dụng của từng loại bàn theo số ghế trong tháng 10

-- Thay đổi thông tin của bàn và hiển thị bàn được thay đổi
CREATE OR ALTER PROC CapNhat_Ban
@MaBan CHAR(5),
@MaKV CHAR(3) = NULL, 
@SoGhe TINYINT = NULL, 
@TrangThaiBan BIT = NULL
AS
BEGIN
	-- thông tin bàn trước khi cập nhật
	SELECT MaBan,TenBan, SoGhe,
	(case when TrangThaiBan=1 then N'CÓ KHÁCH' else N'TRỐNG' end) AS TrangThaiBan,
	MaKV FROM Ban WHERE MaBan=@MaBan
	-- cập nhật
	UPDATE Ban
	SET
	MaKV= case when @MaKV is null then MaKV else @MaKV end,
	SoGhe=case when @SoGhe is null then SoGhe else @SoGhe end,
	TrangThaiBan=case when @TrangThaiBan is null then TrangThaiBan else @TrangThaiBan end
	WHERE MaBan=@MaBan
	--thông tin bàn sau khi cập nhật
	SELECT MaBan,TenBan, SoGhe,
	(case when TrangThaiBan=1 then N'CÓ KHÁCH' else N'TRỐNG' end) AS TrangThaiBan,
	MaKV FROM Ban WHERE MaBan=@MaBan
END;

EXEC CapNhat_Ban @MaBan='B01',@MaKV='TA2' --thay đổi Mã khu vực của bàn có mã B01 thành TA2
EXEC CapNhat_Ban @MaBan='B01',@TrangThaiBan=1 --thay đổi trạng thái của bàn có mã B01 thành 1
EXEC CapNhat_Ban @MaBan='B01',@SoGhe=4 --thay đổi số ghế của bàn có mã B01 thành 4

-- Thêm bàn và hiển thị thông tin bàn mới

CREATE OR ALTER PROC Them_Ban
@MaBan char(5),
@TenBan nchar(10),
@SoGhe tinyint,
@MaKV char(3)
AS
BEGIN
	INSERT INTO Ban VALUES (@MaBan,@TenBan,@SoGhe,DEFAULT,@MaKV)
	SELECT MaBan,
	TenBan,
	SoGhe,
	(case when TrangThaiBan=1 then N'CÓ KHÁCH' else N'TRỐNG' end) AS TrangThaiBan,
	MaKV 
	FROM Ban WHERE MaBan=@MaBan 
END;

EXEC Them_Ban @MaBan='B51',@TenBan=N'BÀN 51',@SoGhe=8,@MaKV='TA3' --thêm bàn với các thông tin tương ứng

-- Xóa thông tin bàn
CREATE OR ALTER PROC Xoa_Ban
@MaBan char(5)
AS
BEGIN
	DELETE 
	FROM Ban WHERE MaBan=@MaBan 
END;

EXEC Xoa_Ban @MaBan='B51' --xóa bàn có mã bàn là B51

-- Tìm khách theo thông tin khách
CREATE OR ALTER PROC Tim_KH
@MaKH varchar(8) = null,
@TenKH nvarchar(30) = null,
@DiaChiKH nvarchar(30) = null,
@SdtKH varchar(15) = null,
@Thang int = null
AS
BEGIN
SELECT KhachHang.MaKH,
(case when TenKH is null then '' else TenKH end) as TenKH,
(case when SdtKH is null then '' else SdtKH end) as SdtKH,
(case when DiaChiKH is null then '' else DiaChiKH end) as DiaChiKH
FROM KhachHang inner join  HoaDon on KhachHang.MaKH=HoaDon.MaKH WHERE (KhachHang.MaKH like '%' +@MaKH +'%') or (TenKH like N'%' + @TenKH + N'%') or (DiaChiKH like N'%' + @DiaChiKH +N'%') or (SdtKH like '%' + @SdtKH +'%') or month(ThoiGianLap)=@Thang
END

EXEC Tim_KH @TenKH=N'NGUYỄN NHẬT MINH' --tìm khách hàng trong tên có NGUYỄN NHẬT MINH
EXEC Tim_KH @SdtKH='09' --tìm khách hàng trong SDT có cặp số 09
EXEC Tim_KH @MaKH='KH3' --tìm khách hàng có mã đầu KH3 ( đầu KH3 vì ràng buộc mã khách phải bắt đầu bằng KH )

-- Thêm khách hàng
CREATE OR ALTER PROC Them_KH
@MaKH char(8),
@SdtKH char(13) = NULL,
@TenKH nchar(30) = NULL,
@DiaChiKH Nchar(30) = NULL
AS
BEGIN
	INSERT INTO KhachHang VALUES (@MaKH,@TenKH,@SdtKH,@DiaChiKH)
	SELECT MaKH,
	(case when TenKH is null then '' else TenKH end) as TenKH,
	(case when SdtKH is null then '' else SdtKH end) as SdtKH,
	(case when DiaChiKH is null then '' else DiaChiKH end) as DiaChiKH FROM KhachHang WHERE MaKH=@MaKH
END;

EXEC Them_KH @MaKH='KH39' -- thêm khách có mã KH39

-- Xóa thông tin khách
CREATE OR ALTER PROC Xoa_KH
@MaKH char(5)
AS
BEGIN
	DELETE 
	FROM KhachHang WHERE MaKH=@MaKH
END;

EXEC Xoa_KH @MaKH='KH39' --xóa khách có mã KH39

-- Thay đổi thông tin khách hàng và hiển thị khách hàng được thay đổi
CREATE OR ALTER PROC CapNhat_KH
@MaKH char(8),
@TenKH nchar(30) = NULL, 
@SdtKH char(15) = NULL, 
@DiaChiKH nchar(30) = NULL
AS
BEGIN
	-- thông tin khách trước khi cập nhật
	SELECT MaKH,
	(case when TenKH is null then '' else TenKH end) as TenKH,
	(case when SdtKH is null then '' else SdtKH end) as SdtKH,
	(case when DiaChiKH is null then '' else DiaChiKH end) as DiaChiKH
	FROM KhachHang WHERE MaKH=@MaKH
	-- cập nhật
	UPDATE KhachHang
	SET
	TenKH= case when @TenKH is null then TenKH else @TenKH end,
	SdtKH=case when @SdtKH is null then SdtKH else @SdtKH end,
	DiaChiKH=case when @DiaChiKH is null then DiaChiKH else @DiaChiKH end
	WHERE MaKH=@MaKH
	-- thông tin khách sau khi cập nhật
	SELECT MaKH,
	(case when TenKH is null then '' else TenKH end) as TenKH,
	(case when SdtKH is null then '' else SdtKH end) as SdtKH,
	(case when DiaChiKH is null then '' else DiaChiKH end) as DiaChiKH
	FROM KhachHang WHERE MaKH=@MaKH
END;

EXEC CapNhat_KH @MaKH='KH01',@TenKH=N'DŨNG ĐẸP TRAI SIÊU CẤP VIPRO',@SdtKH ='09872732721' -- cập nhật lại tên và sdt của khách hàng có mã KH01

-- Tìm nhân viên theo thông tin từ bảng nhân viên
CREATE OR ALTER PROC Tim_NV
@MaNV varCHAR(4) = null,
@TenNV NvarCHAR(50) = NULL,
@GioiTinh bit = NULL,
@SdtNV varCHAR(13) = NULL,
@DiaChiNV NvarCHAR(30) = NULL,
@NgaySinh DATE = NULL,
@NamSinh int=null,
@NamVaoLam int= null,
@NgayBatDauLam DATE = NULL,
@MaCV varCHAR(5) = NULL
AS
BEGIN

SELECT MaNV,TenNV,
		(case when GioiTinh=1 then 'NAM' else N'NỮ' end) AS GioiTinh,
		SdtNV,
		DiaChiNV,
		NgaySinh,
		NgayBatDauLam,
		MaCV
FROM NhanVien WHERE (MaNV like '%' + @MaNV +'%') or (TenNV like '%' + @TenNV + '%') or (DiaChiNV like '%' + @DiaChiNV +'%') or (SdtNV like '%' + @SdtNV +'%') or GioiTinh=@GioiTinh or NgaySinh=@NgaySinh
				     or NgayBatDauLam=@NgayBatDauLam or (MaCV like '%'+@MaCV+'%') or year(NgayBatDauLam)=@NamVaoLam or year(NgaySinh)=@NamSinh
END;

EXEC Tim_NV @TenNV=N'NGUYỄN' --tìm các nhân viên trong tên có chữ NGUYỄN
EXEC Tim_NV @MaCV='PQL' --tìm các nhân viên là phó quản lý
EXEC Tim_NV @NamVaoLam=2021 --tìm các nhân năm vào làm là 2021

--Thêm nhân viên
CREATE OR ALTER PROC Them_NV
@MaNV CHAR(4),
@TenNV NCHAR(50),
@GioiTinh BIT ,
@SdtNV CHAR(13) ,
@DiaChiNV NCHAR(30) ,
@NgaySinh DATE ,
@NgayBatDauLam DATE ,
@MaCV CHAR(5)
AS
BEGIN
	INSERT INTO NhanVien VALUES (@MaNV,@TenNV,@GioiTinh,@SdtNV,@DiaChiNV,@NgaySinh,@NgayBatDauLam,@MaCV)
	SELECT * FROM NhanVien WHERE MaNV=@MaNV
END;

EXEC Them_NV @MaNV='NV66',@TenNV=N'JACK CASE ATM',@GioiTinh=1,@SdtNV='09248283342',@DiaChiNV=N'THANH XUÂN',@NgaySinh='1997-05-03',@NgayBatDauLam='2020-05-04',@MaCV='BV'
-- thêm nhân viên với các thông tin tương ứng


--Xóa nhân viên
CREATE OR ALTER PROC Xoa_NV
@MaNV CHAR(4)
AS
BEGIN
	DELETE FROM NhanVien WHERE MaNV=@MaNV
END;

EXEC Xoa_NV @MaNV='NV66' --xóa nhân viên có mã là NV66

-- Thay đổi thông tin của nhân viên
CREATE OR ALTER PROC CapNhat_NV
@MaNV CHAR(4),
@TenNV NCHAR(50) = NULL,
@GioiTinh BIT = NULL,
@SdtNV CHAR(13) = NULL,
@DiaChiNV NCHAR(30) = NULL,
@NgaySinh DATE = NULL,
@NgayBatDauLam DATE = NULL,
@MaCV CHAR(5) = NULL
AS
BEGIN
	-- hiển thị thông tin nv trước khi thay đổi
	SELECT MaNV,TenNV,
		(case when GioiTinh=1 then 'NAM' else N'NỮ' end) AS GioiTinh,
		SdtNV,
		DiaChiNV,
		NgaySinh,
		NgayBatDauLam,
		MaCV
	FROM NhanVien WHERE MaNV=@MaNV
	-- thay đổi thông tin nhân viên
	UPDATE NhanVien
	SET 
		TenNV = case when @TenNV is null then TenNV else @TenNV end,
		GioiTinh = case when @GioiTinh is null then GioiTinh else @GioiTinh end,
		SdtNV = case when @SdtNV is null then SdtNV else @SdtNV end,
		DiaChiNV = case when @DiaChiNV is null then DiaChiNV else @DiaChiNV end,
		NgaySinh = case when @NgaySinh is null then NgaySinh else @NgaySinh end,
		NgayBatDauLam = case when @NgayBatDauLam is null then NgayBatDauLam else @NgayBatDauLam end,
		MaCV = case when @MaCV is null then MaCV else @MaCV end
	WHERE MaNV=@MaNV
	-- hiển thị thông tin sau khi thay đổi
	SELECT MaNV,TenNV,
		(case when GioiTinh=1 then 'NAM' else N'NỮ' end) AS GioiTinh,
		SdtNV,
		DiaChiNV,
		NgaySinh,
		NgayBatDauLam,
		MaCV
	FROM NhanVien WHERE MaNV=@MaNV
END;

EXEC CapNhat_NV @MaNV='NV01',@TenNV=N'NGUYỄN NHẬT MINH' -- cập nhật lại tên cho nhân viên có mã là NV01

-- Thay đổi thông tin ca làm và hiển thị ca làm được thay đổi
CREATE OR ALTER PROC CapNhat_CL
@MaCaLam char(2),
@TienCong int = NULL
AS
BEGIN
	-- thông tin tiền công trước khi cập nhật
	SELECT * FROM CaLam WHERE MaCaLam=@MaCaLam
	-- cập nhật
	UPDATE CaLam
	SET
	TienCong = case when @TienCong is null then TienCong else @TienCong end
	WHERE MaCaLam=@MaCaLam
	-- thông tin tiền công sau khi cập nhật
	SELECT * FROM CaLam WHERE MaCaLam=@MaCaLam
END;

EXEC CapNhat_CL @MaCaLam='SA',@TienCong='432124' --cập nhật lại tiền công cho ca làm có mã SA

-- Thêm ca làm
CREATE OR ALTER PROC Them_CL
@MaCaLam char(2),
@TenCalam nchar(10),
@TienCong int
AS
BEGIN
	INSERT INTO CaLam VALUES (@MaCaLam,@TenCalam,@TienCong)
	SELECT * FROM CaLam WHERE MaCaLam=@MaCaLam
END;

EXEC Them_CL @MaCaLam='DE',@TenCaLam=N'ĐÊM',@TienCong=345678 --thêm ca làm với thông tin tương ứng

--Xóa ca làm 
CREATE OR ALTER PROC Xoa_CL
@MaCaLam char(2)
AS
BEGIN
	DELETE FROM CaLam WHERE MaCaLam=@MaCaLam
END;

EXEC Xoa_CL @MaCaLam='DE' --xóa ca làm có mã DE

-- Thêm chức vụ
CREATE OR ALTER PROC Them_CV
@MaCV char(5),
@TenCV nchar(10),
@HeSoLuong float(2)
AS
BEGIN
	INSERT INTO ChucVu VALUES (@MaCV,@TenCV,@HeSoLuong)
	SELECT * FROM ChucVu WHERE MaCV=@MaCV
END;

EXEC Them_CV @MaCV='BK',@TenCV=N'BẢO KÊ',@HeSoLuong=2.0 --thêm chức vụ với thông tin tương ứng

--Xóa chức vụ
CREATE OR ALTER PROC Xoa_CV
@MaCV char(5)
AS
BEGIN
	DELETE FROM ChucVu WHERE MaCV=@MaCV
END;

EXEC Xoa_CV @MaCV='BK' --xóa chức vụ có mã BK

-- Thay đổi thông tin tên chức vụ và hiển thị chức vụ được thay đổi
CREATE OR ALTER PROC CapNhat_CV
@MaCV char(5),
@TenCV nchar(30) = null,
@HeSoLuong float(2) = null
AS
BEGIN
	-- thông tin tiền công trước khi cập nhật
	SELECT * FROM ChucVu WHERE MaCV=@MaCV
	-- cập nhật
	UPDATE ChucVu
	SET
	TenCV = case when @TenCV is null then TenCV else @TenCV end,
	HeSoLuong = case when @HeSoLuong is null then HeSoLuong else @HeSoLuong end
	WHERE MaCV=@MaCV
	-- thông tin tiền công sau khi cập nhật
	SELECT * FROM ChucVu WHERE MaCV=@MaCV
END;

EXEC CapNhat_CV @MaCV='BB',@HeSoLuong=2.0 --cập nhật lại hệ số lương cho chức vụ có mã BB

-- Kiểm tra tình trạng đi làm của các nhân viên
-- (nếu nhập tháng thì in ra lịch làm việc trong tháng đó của tất cả nhân viên, không nhập gì in ra toàn bộ lịch làm việc trên csdl )
CREATE OR ALTER PROC NV_CTCL
@Thang tinyint = null
AS
BEGIN
IF @Thang is null SELECT MaNV, MaCaLam, NgayLam,
		(case when ChamCong=1 then N'ĐI LÀM' else N'NGHỈ' end ) AS ChamCong FROM ChiTietCaLam
ELSE
SELECT MaNV, MaCaLam, NgayLam,
		(case when ChamCong=1 then N'ĐI LÀM' else N'NGHỈ' end ) AS ChamCong
FROM ChiTietCaLam WHERE  MONTH(NgayLam)=@Thang
END;

EXEC NV_CTCL 
EXEC NV_CTCL @Thang=9

-- Kiểm tra tình trạng đi làm của một nhân viên cụ thể 
-- ( nếu chỉ nhập vào mã nhân viên thì in ra toàn bộ lịch làm việc của nhân viên đó, nếu nhập cả mã nhân viên và tháng thì in ra lịch làm việc trong tháng của nhân viên đó )
CREATE OR ALTER PROC NVCT_CTCL
@MaNV CHAR(4),
@Thang tinyint = null
AS
BEGIN
IF @Thang is null SELECT MaNV, MaCaLam, NgayLam,
		(case when ChamCong=1 then N'ĐI LÀM' else N'NGHỈ' end ) AS ChamCong
FROM ChiTietCaLam WHERE MaNV=@MaNV
ELSE
SELECT MaNV, MaCaLam, NgayLam,
		(case when ChamCong=1 then N'ĐI LÀM' else N'NGHỈ' end ) AS ChamCong
FROM ChiTietCaLam WHERE MaNV=@MaNV and MONTH(NgayLam)=@Thang 
END;

EXEC NVCT_CTCL @MaNV='NV01'
EXEC NVCT_CTCL @MaNV='NV01', @Thang=9

-- Tính lương nhân viên
-- (nếu nhập tháng thì in ra lương trong tháng đó của tất cả nhân viên có lương, không nhập gì in ra toàn bộ lương các tháng trên csdl )
CREATE OR ALTER PROC Luong_NV
@Thang tinyint =null
AS
BEGIN
	IF @Thang is null
		SELECT MaNV,Thang,Sum(Luong) as Luong FROM TINHLUONG_NV GROUP BY MaNV,Thang;
	ELSE
	SELECT MaNV,Thang,Sum(Luong) as Luong FROM TINHLUONG_NV WHERE Thang=@Thang GROUP BY MaNV,Thang
END;

EXEC Luong_NV
EXEC Luong_NV @Thang=9

-- Tìm hóa đơn theo nhân viên lập,mã hóa đơn, tháng lập, thời gian lập cụ thể, khách hàng thanh toán 
CREATE OR ALTER PROC Tim_HD
@MaHD CHAR(8) = NULL,
@MaNV char(4) = null,
@ThoiGianLap date = null,
@Thang tinyint = null,
@MaBan char(5) = null,
@MaKH char(8) = null
AS
BEGIN
SELECT *
FROM HD WHERE MaNV=@MaNV or MaHD=@MaHD or MONTH(ThoiGianLap)=@Thang or MaBan=@MaBan or ThoiGianLap=@ThoiGianLap or MaKH=@MaKH
END;

EXEC Tim_HD @MaNV='NV04' --tìm hóa đơn có nhân viên lập mã là NV04
EXEC Tim_HD @Thang=9 --tìm các hóa đơn dc lập trong tháng 9

-- Tìm hóa đơn theo khoảng giá trị hóa đơn
-- (nếu chỉ nhập giá trên, in ra các hóa đơn có giá trị < giatren, chỉ nhập giá dưới thì in ra các hóa đơn có giá trị > giaduoi,
-- nhập cả 2 thì in ra hóa đơn có giá trị nằm trong khoảng (giaduoi;giatren) )
CREATE OR ALTER PROC Tim_HD1
@giaduoi int =null,
@giatren int =null
AS
BEGIN
if @giaduoi is null SELECT * FROM HD WHERE TongTienHD < @giatren
ELSE IF @giatren is null SELECT * FROM HD WHERE TongTienHD > @giaduoi
else if (@giaduoi is not null and @giatren is not null)
SELECT * FROM HD WHERE (TongTienHD < @giatren and TongTienHD > @giaduoi)
END;

exec Tim_HD1 @giatren=1000000
exec Tim_HD1 @giaduoi=1000000
exec Tim_HD1 @giatren=1000000,@giaduoi=600000

-- Tìm hóa đơn theo khoảng thời gian lập
-- (nếu chỉ nhập thời gian trên, in ra các hóa đơn có giá trịthời gian lập <thoigiantren, chỉ nhập thời gian dưới thì in ra các hóa đơn có thời gian lập > thoigianduoi,
-- nhập cả 2 thì in ra hóa đơn có thời gian lập nằm trong khoảng (thoigianduoi;thoigiantren) )
CREATE OR ALTER PROC Tim_HD2
@thoigianduoi date =null,
@thoigiantren date =null
AS
BEGIN
if @thoigianduoi is null SELECT * FROM HD WHERE ThoiGianLap < @thoigiantren
ELSE IF @thoigiantren is null SELECT * FROM HD WHERE ThoiGianLap > @thoigianduoi
else if (@thoigianduoi is not null and @thoigiantren is not null)
SELECT * FROM HD WHERE (ThoiGianLap < @thoigiantren and ThoiGianLap > @thoigianduoi)
END;

exec Tim_HD2 @thoigiantren='9-1-2021'
exec Tim_HD2 @thoigianduoi='10-1-2021'
exec Tim_HD2 @thoigiantren='10-30-2021',@thoigianduoi='9-1-2021'

-- Tính số lượng hóa đơn
-- ( nếu không nhập tháng, in ra số lượng hóa đơn của tất cả các tháng, nhập tháng thì tháng nào in ra tháng đó )
CREATE OR ALTER PROC Tinh_SLHD
@Thang tinyint = null
AS
BEGIN
IF @Thang is null SELECT month(ThoiGianLap) as Thang, count(MaHD) as SL_HD from HoaDon group by month(ThoiGianLap)
ELSE
SELECT month(ThoiGianLap) as Thang, count(MaHD) as SL_HD from HoaDon where month(ThoiGianLap)=@Thang group by month(ThoiGianLap)
END;

EXEC Tinh_SLHD
EXEC Tinh_SLHD @Thang=9

-- Tính doanh thu
-- ( nếu nhập tháng thì in ra doanh thu tháng đó, không nhập thì in ra doanh thu tất cả các tháng )
CREATE OR ALTER PROC Tinh_DoanhThu
@Thang tinyint = null
AS
BEGIN
IF @Thang is null SELECT month(ThoiGianLap) as Thang, sum(TongTienHD) AS DoanhThu from HD group by month(ThoiGianLap)
ELSE
SELECT month(ThoiGianLap) as Thang, sum(TongTienHD) AS DoanhThu from HD where month(ThoiGianLap)=@Thang group by month(ThoiGianLap)
END;

EXEC Tinh_DoanhThu
EXEC Tinh_DoanhThu @Thang=10


-- Tính giá trị hóa đơn trung bình theo tháng
-- ( nếu nhập tháng thì in ra giá trị hóa đơn trung bình tháng đó, không nhập thì in ra giá trị hóa đơn trung bình tất cả các tháng )
CREATE OR ALTER PROC Tinh_GTTB_HD
@Thang tinyint = null
AS
BEGIN
IF @Thang is null SELECT month(ThoiGianLap) as Thang, avg(TongTienHD) as GTTB_HD from HD group by month(ThoiGianLap)
ELSE
SELECT month(ThoiGianLap) as Thang, avg(TongTienHD) as GTTB_HD from HD where month(ThoiGianLap)=@Thang group by month(ThoiGianLap)
END;

EXEC Tinh_GTTB_HD
EXEC Tinh_GTTB_HD @Thang=9

-- Thay đổi thông tin <số lượng dịch vụ> trong chi tiết hóa đơn và hiển thị ra bản ghi được thay đổi

CREATE OR ALTER PROC CapNhat_CTHD
@MaDV char(5),
@MaHD nchar(8),
@SoLuong tinyint
AS
BEGIN
	-- thông tin cthd trước khi cập nhật
	SELECT * FROM ChiTietHD WHERE MaDV=@MaDV AND MaHD=@MaHD
	-- cập nhật
	UPDATE ChiTietHD
	SET
	SoLuong=@SoLuong
	WHERE MaDV=@MaDV AND MaHD=@MaHD
	-- thông tin cthd sau khi cập nhật
	SELECT * FROM ChiTietHD WHERE MaDV=@MaDV AND MaHD=@MaHD
END;

EXEC CapNhat_CTHD @MaDV='DV37', @MaHD='HD01', @SoLuong=2 --cập nhật chi tiết hóa đơn về số lượng mặt hàng của hóa đơn HD01 ứng với dịch vụ có mã DV37

-- Cập nhật thông tin về hóa đơn và hiển thị hóa đơn được thay đổi
CREATE OR ALTER PROC CapNhat_HD
@MaHD char(8),
@MaBan char(5) = NULL,
@MaKH char(8) = null,
@MaNV char(4) = null,
@ThoiGianLap date = null
AS
BEGIN
	-- thông tin hd trước khi cập nhật
	SELECT * FROM HoaDon WHERE MaHD=@MaHD
	-- cập nhật
	UPDATE HoaDon
	SET
	MaBan= case when @MaBan is null then MaBan else @MaBan end,
	MaKH=case when @MaKH is null then MaKH else @MaKH end,
	MaNV=case when @MaNV is null then MaNV else @MaNV end,
	ThoiGianLap=case when @ThoiGianLap is null then ThoiGianLap else @ThoiGianLap end
	WHERE MaHD=@MaHD
	-- thông tin hd sau khi cập nhật
	SELECT * FROM HoaDon WHERE MaHD=@MaHD
END;

EXEC CapNhat_HD @MaHD='HD01', @MaNV='NV05', @MaBan='B01' --cập nhật lại nhân viên lập hóa đơn và bàn thanh toán với hóa đơn có mã HD01

-- Tạo hóa đơn
CREATE OR ALTER PROC Tao_HD
@MaHD char(8),
@MaBan char(5),
@MaKH char(8),
@MaNV char(4)
AS
BEGIN
	INSERT INTO HoaDon VALUES (@MaHD,Getdate(),@MaNV,@MaBan,@MaKH)
	SELECT * FROM HoaDon WHERE MaHD=@MaHD
END;

EXEC Tao_HD @MaHD='HD38',@MaNV='NV04',@MaBan='B45',@MaKH='KH38' --tạo 1 hóa đơn với thông tin tương ứng
EXEC Tao_HD @MaHD='HD39',@MaNV='NV05',@MaBan='B49',@MaKH='KH38' --tạo 1 hóa đơn với thông tin tương ứng

-- Thêm CTHD 

CREATE OR ALTER PROC Them_CTHD
@MaHD char(8),
@MaDV nchar(5),
@SoLuong tinyint
AS
BEGIN
	INSERT INTO ChiTietHD VALUES (@MaHD,@MaDV,@SoLuong)
	SELECT * FROM CTHD WHERE MaHD=@MaHD and MaDV=@MaDV
END;

EXEC Them_CTHD @MaHD='HD38',@MaDV='DV03',@SoLuong=5 --thêm chi tiết hóa đơn với thông tin tương ứng
EXEC Them_CTHD @MaHD='HD38',@MaDV='DV45',@SoLuong=5

-- Xóa hóa đơn
CREATE OR ALTER PROC Xoa_HD
@MaHD char(8)
AS
BEGIN
	DELETE FROM HoaDon WHERE MaHD=@MaHD
END;

EXEC Xoa_HD @MaHD='HD39' --xóa hóa đơn có mã HD39

-- Xóa CTHD ( xóa 1 bản ghi của 1 hóa đơn )

CREATE OR ALTER PROC Xoa_CTHD1
@MaHD char(8),
@MaDV char(5)
AS
BEGIN
	DELETE FROM ChiTietHD WHERE MaHD=@MaHD and MaDV=@MaDV
END;

exec Xoa_CTHD1 @MaHD='HD38',@MaDV='DV03' 

exec Xoa_CTHD1 @MaHD='HD38',@MaDV='DV45'

-- Xóa CTHD ( xóa tất cả bản ghi của 1 hóa đơn)

CREATE OR ALTER PROC Xoa_CTHDn
@MaHD char(8)
AS
BEGIN
	DELETE FROM ChiTietHD WHERE MaHD=@MaHD
END;

exec Xoa_CTHDn @MaHD='HD39' 

-- Tìm dịch vụ theo (mã dịch vụ, tên dịch vụ cụ thể, size, giá cụ thể, mã nhóm dịch vụ cụ thể )
CREATE OR ALTER PROC Tim_DV
@MaDV char(5) = null,
@TenDV nchar(50) = null,
@Size tinyint = null,
@GiaDV int = null,
@MaNDV char(10) = null
AS
BEGIN
SELECT *
FROM DichVu WHERE MaDV=@MaDV or TenDV=@TenDV or Size=@Size or GiaDV=@GiaDV or MaNDV=@MaNDV
END;

EXEC Tim_DV @MaDV='DV01',@Size=3 -- tìm dịch vụ có mã DV01 hoặc các DV có size là 3

-- Tìm dịch vụ theo khoảng giá
-- (nếu chỉ nhập giá trên, in ra các dịch vụ có giá trị <giatren, chỉ nhập giá dưới thì in ra các dịch vụ có giá trị > giaduoi,
-- nhập cả 2 thì in ra dịch vụ có giá trị nằm trong khoảng (giaduoi;giatren) )
CREATE OR ALTER PROC Tim_DV1
@giaduoi int =null,
@giatren int =null
AS
BEGIN
if @giaduoi is null SELECT * FROM DichVu WHERE GiaDV < @giatren
ELSE IF @giatren is null SELECT * FROM DichVu WHERE GiaDV > @giaduoi
else if (@giaduoi is not null and @giatren is not null)
SELECT * FROM DichVu WHERE (GiaDV < @giatren and GiaDV > @giaduoi)
END;

exec Tim_DV1 @giatren=1000000
exec Tim_DV1 @giaduoi=100000
exec Tim_DV1 @giatren=500000,@giaduoi=60000

-- Thêm DV và hiển thị

CREATE OR ALTER PROC Them_DV
@MaDV char(5) ,
@TenDV nchar(50) ,
@Size tinyint,
@GiaDV int,
@MaNDV char(10)
AS
BEGIN
	INSERT INTO DichVu VALUES (@MaDV,@TenDV,@Size,@GiaDV,@MaNDV)
	SELECT * FROM DichVu WHERE MaDV=@MaDV
END;

EXEC Them_DV @MaDV='DV66',@TenDV=N'SƯỜN BÒ DÁT VÀNG',@Size=3,@GiaDV=9999000,@MaNDV='DNUONG' --thêm dịch vụ với thông tin tương ứng

-- Xóa DV
CREATE OR ALTER PROC Xoa_DV
@MaDV char(5)
AS
BEGIN
	DELETE FROM DichVu WHERE MaDV=@MaDV
END;

EXEC Xoa_DV @MaDV='DV66' --xóa dịch vụ có mã DV66

-- Thay đổi thông tin về dịch vụ và hiển thị lại dịch vụ được thay đổi

CREATE OR ALTER PROC CapNhat_DV
@MaDV char(5),
@TenDV nchar(50) = NULL,
@Size tinyint = null,
@GiaDV int = null,
@MaNDV char(10) = null
AS
BEGIN
	-- thông tin dịch vụ trước khi cập nhật
	SELECT * FROM DichVu WHERE MaDV=@MaDV
	-- cập nhật
	UPDATE DichVu
	SET
	TenDV= case when @TenDV is null then TenDV else @TenDV end,
	Size=case when @Size is null then Size else @Size end,
	GiaDV=case when @GiaDV is null then GiaDV else @GiaDV end,
	MaNDV=case when @MaNDV is null then MaNDV else @MaNDV end
	WHERE MaDV=@MaDV
	-- thông tin dịch vụ sau khi cập nhật
	SELECT * FROM DichVu WHERE MaDV=@MaDV
END;

EXEC CapNhat_DV @MaDV='DV01',@GiaDV=69000 --cập nhật giá của dịch vụ

-- Thêm NDV và hiển thị

CREATE OR ALTER PROC Them_NDV
@MaNDV char(10),
@TenNDV nchar(20)
AS
BEGIN
	INSERT INTO NhomDV VALUES (@MaNDV,@TenNDV)
	SELECT * FROM NhomDV WHERE MaNDV=@MaNDV
END;

EXEC Them_NDV @MaNDV='MYTOM',@TenNDV=N'MỲ TÔM' --thêm nhóm dịch vụ với thông tin tương ứng


-- Cập nhật NDV và hiển thị bản ghi được sửa
CREATE OR ALTER PROC CapNhat_NDV
@MaNDV char(10),
@TenNDV nchar(20) = null
AS
BEGIN
	-- thông tin dịch vụ trước khi cập nhật
	SELECT * FROM NhomDV WHERE MaNDV=@MaNDV
	-- cập nhật
	UPDATE NhomDV
	SET
	TenNDV= case when @TenNDV is null then TenNDV else @TenNDV end	WHERE MaNDV=@MaNDV
	-- thông tin dịch vụ sau khi cập nhật
	SELECT * FROM NhomDV WHERE MaNDV=@MaNDV
END;

EXEC CapNhat_NDV @MaNDV='MYTOM',@TenNDV=N'MỲ TÔM VIPRO' --cập nhật lại tên nhóm dịch vụ có mã là MYTOM

-- Xóa NDV
CREATE OR ALTER PROC Xoa_NDV
@MaNDV char(10)
AS
BEGIN
	DELETE FROM NhomDV WHERE MaNDV=@MaNDV
END;

EXEC Xoa_NDV @MaNDV='MYTOM' --xóa nhóm dịch vụ có mã MYTOM

-- Tính và hiển thị lượt sử dụng của từng nhóm dịch vụ đồ uống
-- ( nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra toàn bộ các tháng )
CREATE OR ALTER PROC Tinh_LuotSD_NDVDU
@Thang tinyint =null
AS
BEGIN
if @Thang is null select MaNDV,TenNDV,LuotSD,ThanhTien,Thang from LUOTSD_NDVDU
else
	select MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDU where Thang=@Thang 
END;

exec Tinh_LuotSD_NDVDU
exec Tinh_LuotSD_NDVDU @Thang=9

--Đưa ra nhóm đồ uống có lượt sử dụng nhiều/ít nhất 
-- (@top=nhóm số dịch vụ muốn xem, @thang--nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Top_LuotSD_NDVDU
@top tinyint,
@Thang tinyint =null
AS
BEGIN
if @Thang is null 
	begin
		select top (@top) MaNDV,TenNDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_NDVDU group by MaNDV,TenNDV order by sum(LuotSD) DESC
		select top (@top) MaNDV,TenNDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_NDVDU group by MaNDV,TenNDV order by sum(LuotSD) ASC
	end;
else
	begin
		select top (@top) MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDU where Thang=@Thang order by LuotSD DESC
		select top (@top) MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDU where Thang=@Thang order by LuotSD ASC
	end;
END;

exec Top_LuotSD_NDVDU @top=1
exec Top_LuotSD_NDVDU @Thang=9,@top=1

--Đưa ra nhóm đồ uống có doanh thu nhiều/ít nhất 
-- ( @top=nhóm số dịch vụ muốn xem, @thang--nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Top_DoanhThu_NDVDU
@Thang tinyint =null,
@top tinyint 
AS
BEGIN
if @Thang is null 
	begin
		select top (@top) MaNDV,TenNDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_NDVDU group by MaNDV,TenNDV order by sum(ThanhTien) DESC
		select top (@top) MaNDV,TenNDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_NDVDU group by MaNDV,TenNDV order by sum(ThanhTien) ASC
	end;
else
	begin
		select top (@top) MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDU where Thang=@Thang order by ThanhTien DESC
		select top (@top) MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDU where Thang=@Thang order by ThanhTien ASC
	end;
END;

exec Top_DoanhThu_NDVDU @top=2
exec Top_DoanhThu_NDVDU @Thang=9,@top=2

-- Tính và hiển thị lượt sử dụng của từng nhóm dịch vụ đồ ăn
-- ( nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Tinh_LuotSD_NDVDA
@Thang tinyint = null
AS
BEGIN
if @Thang is null select MaNDV,TenNDV,LuotSD,ThanhTien,Thang from LUOTSD_NDVDA
else
		select MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDA where Thang=@Thang 
END;

exec Tinh_LuotSD_NDVDA
exec Tinh_LuotSD_NDVDA @Thang=9

--Đưa ra nhóm đồ ăn có lượt sử dụng nhiều/ít nhất 
-- ( @top=nhóm số dịch vụ muốn xem, @thang--nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Top_LuotSD_NDVDA
@top tinyint,
@Thang tinyint =null
AS
BEGIN
if @Thang is null 
	begin
		select top (@top) MaNDV,TenNDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_NDVDA group by MaNDV,TenNDV order by sum(LuotSD) DESC
		select top (@top) MaNDV,TenNDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_NDVDA group by MaNDV,TenNDV order by sum(LuotSD) ASC
	end;
else
	begin
		select top (@top) MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDA where Thang=@Thang order by LuotSD DESC
		select top (@top) MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDA where Thang=@Thang order by LuotSD ASC
	end;
END;

exec Top_LuotSD_NDVDA @top=1
exec Top_LuotSD_NDVDA @Thang=9, @top=2

--Đưa ra nhóm đồ ăn có doanh thu nhiều/ít nhất 
-- ( @top=nhóm số dịch vụ muốn xem, @thang--nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Top_DoanhThu_NDVDA
@top tinyint,
@Thang tinyint =null
AS
BEGIN
if @Thang is null 
	begin
		select top (@top) MaNDV,TenNDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_NDVDA group by MaNDV,TenNDV order by sum(ThanhTien) DESC
		select top (@top) MaNDV,TenNDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_NDVDA group by MaNDV,TenNDV order by sum(ThanhTien) ASC
	end;
else
	begin
		select top (@top) MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDA where Thang=@Thang order by ThanhTien DESC
		select top (@top) MaNDV,TenNDV,LuotSD,ThanhTien from LUOTSD_NDVDA where Thang=@Thang order by ThanhTien ASC
	end;
END;

exec Top_DoanhThu_NDVDA @top=2
exec Top_DoanhThu_NDVDA @Thang=10,@top=3

-- Tính và hiển thị lượt sử dụng của từng dịch vụ đồ uống
-- ( nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Tinh_LuotSD_DVDU
@Thang tinyint =null
AS
BEGIN
if @Thang is null select MaDV,TenDV,LuotSD,ThanhTien,Thang from LUOTSD_DVDU 
else
		select MaDV,TenDV,LuotSD,ThanhTien,Thang from LUOTSD_DVDU where Thang=@Thang
END;

exec Tinh_LuotSD_DVDU
exec Tinh_LuotSD_DVDU @Thang=9

--Đưa ra đồ uống có lượt sử dụng nhiều/ít nhất
-- ( @top= số dịch vụ muốn xem, @thang--nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Top_LuotSD_DVDU
@Thang tinyint =null,
@top tinyint 
AS
BEGIN
if @Thang is null 
	begin
		select top (@top) MaDV,TenDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_DVDU group by MaDV,TenDV order by sum(LuotSD) DESC
		select top (@top) MaDV,TenDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_DVDU group by MaDV,TenDV order by sum(LuotSD) ASC
	end;
else
	begin
		select top (@top) MaDV,TenDV,LuotSD,ThanhTien from LUOTSD_DVDU where Thang=@Thang order by LuotSD DESC
		select top (@top) MaDV,TenDV,LuotSD,ThanhTien from LUOTSD_DVDU where Thang=@Thang order by LuotSD ASC
	end;
END;

exec Top_LuotSD_DVDU @top=2
exec Top_LuotSD_DVDU @Thang=9, @top=5

--Đưa ra đồ uống có doanh thu nhiều/ít nhất
-- ( @top= số dịch vụ muốn xem, @thang--nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Top_DoanhThu_DVDU
@top tinyint,
@Thang tinyint =null
AS
BEGIN
if @Thang is null 
	begin
		select top (@top) MaDV,TenDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_DVDU group by MaDV,TenDV order by sum(ThanhTien) DESC
		select top (@top) MaDV,TenDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_DVDU group by MaDV,TenDV order by sum(ThanhTien) ASC
	end;
else
	begin
		select top (@top) MaDV,TenDV,LuotSD,ThanhTien from LUOTSD_DVDU where Thang=@Thang order by ThanhTien DESC
		select top (@top) MaDV,TenDV,LuotSD,ThanhTien from LUOTSD_DVDU where Thang=@Thang order by ThanhTien ASC
	end;
END;

exec Top_DoanhThu_DVDU @top=3
exec Top_DoanhThu_DVDU @Thang=9,@top=1

-- Tính và hiển thị lượt sử dụng của từng dịch vụ đồ ăn 
-- ( nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Tinh_LuotSD_DVDA
@Thang tinyint = null
AS
BEGIN
if @Thang is null select MaDV,TenDV,LuotSD,ThanhTien,Thang from LUOTSD_DVDA 
else
	select MaDV,TenDV,LuotSD,ThanhTien,Thang from LUOTSD_DVDA where Thang=@Thang
END;

exec Tinh_LuotSD_DVDA 
exec Tinh_LuotSD_DVDA @Thang=8

--Đưa ra đồ ăn có lượt sử dụng nhiều/ít nhất 
-- ( @top= số dịch vụ muốn xem, @thang--nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Top_LuotSD_DVDA
@top tinyint,
@Thang tinyint =null
AS
BEGIN
if @Thang is null 
	begin
		select top (@top) MaDV,TenDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_DVDA group by MaDV,TenDV order by sum(LuotSD) DESC
		select top (@top) MaDV,TenDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_DVDA group by MaDV,TenDV order by sum(LuotSD) ASC
	end;
else
	begin
		select top (@top) MaDV,TenDV,LuotSD,ThanhTien from LUOTSD_DVDA where Thang=@Thang order by LuotSD DESC
		select top (@top) MaDV,TenDV,LuotSD,ThanhTien from LUOTSD_DVDA where Thang=@Thang order by LuotSD ASC
	end;
END;

exec Top_LuotSD_DVDA @top=2
exec Top_LuotSD_DVDA @Thang=9,@top=1

--Đưa ra đồ ăn có doanh thu nhiều/ít nhất 
-- ( @top= số dịch vụ muốn xem, @thang--nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu tổng )
CREATE OR ALTER PROC Top_DoanhThu_DVDA
@top tinyint,
@Thang tinyint =null
AS
BEGIN
if @Thang is null 
	begin
		select top (@top) MaDV,TenDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_DVDA group by MaDV,TenDV order by sum(ThanhTien) DESC
		select top (@top) MaDV,TenDV,sum(LuotSD) as LuotSD,sum(ThanhTien) as ThanhTien from LUOTSD_DVDA group by MaDV,TenDV order by sum(ThanhTien) ASC
	end;
else
	begin
		select top (@top) MaDV,TenDV,LuotSD,ThanhTien from LUOTSD_DVDA where Thang=@Thang order by ThanhTien DESC
		select top (@top) MaDV,TenDV,LuotSD,ThanhTien from LUOTSD_DVDA where Thang=@Thang order by ThanhTien ASC
	end;
END;

exec Top_DoanhThu_DVDA @top=3
exec Top_DoanhThu_DVDA @Thang=9,@top=2

-- Hiển thị những dịch vụ đồ uống không được sử dụng 
-- ( nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu từ trước đến giờ )
CREATE OR ALTER PROC DVDU_KhongSD
@Thang tinyint =null
AS
BEGIN
if @Thang is null SELECT DichVu.MaDV,DichVu.TenDV,Size,GiaDV,DichVu.MaNDV FROM LUOTSD_DVDU
right join DichVu ON DichVu.MaDV=LUOTSD_DVDU.MaDV WHERE DichVu.MaNDV  IN ('BIA','NNGOT','NKHOANG') and LUOTSD_DVDU.MaDV is null
else
SELECT DichVu.MaDV,DichVu.TenDV,Size,GiaDV,DichVu.MaNDV FROM (select * from LUOTSD_DVDU where Thang=@Thang) AS A RIGHT JOIN DichVu on DichVu.MaDV=A.MaDV where  A.MaDV is null AND DichVu.MaNDV IN ('NKHOANG','NNGOT','BIA') 
END;

exec DVDU_KhongSD
exec DVDU_KhongSD @Thang=10

-- Hiển thị những dịch vụ đồ ăn không được sử dụng 
-- ( nếu nhập tháng thì in ra số liệu theo tháng đó, không nhập thì in ra số liệu trước đến giờ )
CREATE OR ALTER PROC DVDA_KhongSD
@Thang tinyint =null
AS
BEGIN
if @Thang is null 
SELECT DichVu.MaDV,DichVu.TenDV,Size,GiaDV,DichVu.MaNDV FROM LUOTSD_DVDA right join DichVu ON DichVu.MaDV=LUOTSD_DVDA.MaDV WHERE DichVu.MaNDV NOT IN ('BIA','NNGOT','NKHOANG') and LUOTSD_DVDA.MaDV is null
else
SELECT DichVu.MaDV,DichVu.TenDV,Size,GiaDV,DichVu.MaNDV FROM (select * from LUOTSD_DVDA where Thang=@Thang) AS A RIGHT JOIN DichVu on DichVu.MaDV=A.MaDV where  A.MaDV is null AND DichVu.MaNDV NOT IN ('NKHOANG','NNGOT','BIA') 
END;

exec DVDA_KhongSD
exec DVDA_KhongSD @Thang=8



