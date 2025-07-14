use master;
drop database if exists TTTADB;
create database TTTADB;
go
use TTTADB;
go
create table HocVien(
ID char(10) primary key,
Ten nvarchar(50) not null,
GioiTinh nchar(10) check(GioiTinh in (N'Nữ',N'Nam')) not null,
Email varchar(50) unique not null,
SoDienThoai varchar(50) not null,
NgaySinh date not null,
DiaChi nvarchar not null)

create table GiaoVien(
ID char(10) primary key,
Ten nvarchar(50) not null,
GioiTinh nchar(10) check(GioiTinh in (N'Nữ',N'Nam')) not null,
Email varchar(50) unique not null,
SoDienThoai char(10) not null,
NgaySinh date not null,
DiaChi nvarchar not null)

create table BangLuongGV(
ID int primary key,
IDGV char(10) not null,
SoBuoi int not null,
SoTien int not null,
TinhTrang nchar not null default (N'Chưa duyệt') check (TinhTrang in (N'Chưa duyệt',N'Đã duyệt')),
foreign key (IDGV) references GiaoVien(ID))

create table ChucVu(
ID int primary key,
Ten nvarchar(20) not null)

create table NhanVien(
ID int primary key,
Ten nvarchar(50) not null,
GioiTinh nchar(10) check(GioiTinh in (N'Nữ',N'Nam')) not null,
Email varchar(50) unique not null,
SoDienThoai char(10) not null,
NgaySinh date not null,
DiaChi nvarchar not null,
ChucVu int not null,
foreign key (ChucVu) references ChucVu(ID)
)

create table BangLuongNV(
ID int primary key,
IDNV int not null,
Luong int not null,
Thang date not null,
TinhTrang nchar not null default (N'Chưa duyệt') check (TinhTrang in (N'Chưa duyệt',N'Đã duyệt')),
foreign key (IDNV) references NhanVien(ID))


create table TrinhDo(
ID int primary key identity(1,1),
Ten nvarchar(50) not null)

create table KhoaHoc(
ID int primary key identity(1,1),
Ten nvarchar(50) not null,
SoLuong char(3) not null,
HocPhi int not null,
SoBuoi int not null,
ThoiGian datetime not null,
MucDo int not null,
TrangThai nvarchar(20) not null  default N'Chuẩn bị' check(TrangThai in(N'Chuẩn bị',N'Đang dạy',N'Đã kết thúc')),
foreign key (MucDo) references TrinhDo(ID))

create table DanhSachDangKy(
IDHV char(10) not null,
IDKH int not null,
Ngay date not null,
TrangThai nvarchar not null default N'Chưa thanh toán' check(TrangThai in(N'Chưa thanh toán',N'Đã thanh toán')),
foreign key (IDHV) references HocVien(ID),
foreign key (IDKH) references KhoaHoc(ID))

create table ThoiKhoaBieu(
ID int primary key identity(1,1),
IDGV char(10) not null,
IDKH int not null,
ThoiGian datetime not null,
foreign key(IDGV) references GiaoVien(ID),
foreign key(IDKH) references KhoaHoc(ID))

create table HoaDon(
ID char(10) primary key ,
IDHV char(10) not null,
IDNV int not null,
SoTien int not null,
foreign key (IDHV) references HocVien(ID),
foreign key (IDNV) references NhanVien(ID))

create table ChiTietHoaDon(
IDHD char(10) not null,
IDKH int not null,
foreign key (IDHD) references HoaDon(ID),
foreign key (IDKH) references KhoaHoc(ID))

create table BaiThi(
ID int primary key identity(1,1),
Ten nvarchar not null,
ThoiGian datetime not null,
KhoaHoc int not null,
foreign key(KhoaHoc) references KhoaHoc(ID))

create table Diem(
IDHV char(10) not null,
IDBT int not null,
SoDiem char(1),
foreign key(IDHV) references HocVien(ID),
foreign key(IDBT) references BaiThi(ID))
go

create function check_info (@email varchar(50),@sodienthoai char(10))
returns bit
as begin
declare @emailPattern as varchar='.+@.+\..+',
@sdtPattern as varchar='(84|0[3|5|7|8|9])+([0-9]{8})\b';
if @email not like @emailPattern and @sodienthoai not like @sdtPattern
begin
return 0
end
return 1
end
go

create trigger tr_GiaoVien on GiaoVien
for Insert,Update
as
begin 
declare @maGV char(10), @email varchar(50),@sodienthoai char(10);
select @maGV=ID,@email=email,@sodienthoai=sodienthoai 
from inserted
if @maGV not like '^GV[0-9]+' and dbo.check_info(@email,@sodienthoai)=0
begin
 rollback transaction
 print N'Thông tin của nhân viên chưa hợp lệ.'
 end
end
go

create trigger tr_NhanVien on NhanVien
for Insert,Update
as
begin 
declare @email varchar(50),@sodienthoai char(10),@chucvu int;
select @email=email,@sodienthoai=sodienthoai 
from inserted
if @chucvu in (select top 2 id from ChucVu) and
(select count(*) from NhanVien where ChucVu in (select top 2 id from ChucVu))>2
begin
rollback transaction
print N'Thông tin nhân viên lỗi'
end
if  dbo.check_info(@email,@sodienthoai)=0
and @chucvu not in (select id from ChucVu)
begin
 rollback transaction
 print N'Thông tin của nhân viên chưa hợp lệ.'
end
end
go

create trigger tr_HocVien on HocVien
for Insert, Update
as 
begin
 declare @mahv char(10),@ten nvarchar(50),@email varchar(50),@sodienthoai char(10);

select @mahv=ID,@email=Email,@sodienthoai=SoDienThoai from inserted;
if @mahv not like '^HV[0-9]+$' and dbo.check_info(@email,@sodienthoai)=0
 begin
 print N'Thông tin của học viên chưa hợp lệ.'
 rollback transaction
 end
end
go

create trigger tr_HoaDon on HoaDon
for Insert, Update
as
begin
declare @idhd char(10),@idhv char(10),@sotien int,@idnv int;
select @idhv=IDHV, @idhd=ID, @sotien=SoTien,@idnv=IDNV from inserted
if @sotien<>(select sum(KhoaHoc.HocPhi) from HoaDon
inner join ChiTietHoaDon on ChiTietHoaDon.IDHD=HoaDon.ID
inner join KhoaHoc on ChiTietHoaDon.IDKH=KhoaHoc.ID
where HoaDon.ID=@idhd and HoaDon.SoTien=@sotien) 
begin
 print N'Học phí không đủ.'
 rollback transaction
 end
 else if exists (select NhanVien.ChucVu 
 from NhanVien 
 inner join ChucVu on ChucVu.Ten=NhanVien.ChucVu
 where ChucVu.Ten=N'Thu ngân'
 and NhanVien.ID=@idnv)
 begin 
 print N'Nhân viên sai.'
 rollback transaction
 end
end
go

create trigger tr_ThoiKhoaBieu on ThoiKhoaBieu
for Insert, Update
as
begin
declare @idgv char(10),@thoigian date;
select @idgv=IDGV, @thoigian=ThoiGian from inserted
if (select count(IDGV) from ThoiKhoaBieu where IDGV=@idgv and ThoiGian=@thoigian)>1
begin
rollback transaction
print N'Lịch dạy của giáo viên bị trùng'
end
end
go


create proc sp_XemGiaoVien @id char(10)
as 
begin
if @id like 'HV[0-9]+$' and @id in (select ID from HocVien)
 select * from GiaoVien
 inner join ThoiKhoaBieu on GiaoVien.ID=ThoiKhoaBieu.IDGV
 inner join DanhSachDangKy on DanhSachDangKy.IDKH=ThoiKhoaBieu.IDKH
 where DanhSachDangKy.IDHV=@id
end
go

create proc sp_XemThoiKhoaBieu @id char(10)
as 
begin
if @id in (select ID from HocVien where ID like '^HV[0-9]+$')
begin
 select * from ThoiKhoaBieu 
 inner join DanhSachDangKy on DanhSachDangKy.IDKH=ThoiKhoaBieu.IDKH
 where DanhSachDangKy.IDHV=@id
 end
if @id in (select ID from GiaoVien where ID like '^GV[0-9]+$')
begin
 select * from ThoiKhoaBieu
 where IDGV=@id
 end
end
go

create proc sp_XemHocVien @id char(10)
as
begin
if @id like '^GV[0-9]+$'
and @id in (select ID from GiaoVien where ID like '^GV[0-9]+$')
begin
	select * from HocVien
	inner join DanhSachDangKy on DanhSachDangKy.IDHV=HocVien.ID
	inner join ThoiKhoaBieu on ThoiKhoaBieu.IDKH=DanhSachDangKy.IDKH
	where ThoiKhoaBieu.IDGV=@id;
end
end
go

create trigger tr_MoLop on DanhSachDangKy
for Insert,Update
as 
begin
 declare @idkh int, @SucChua int;
 select @idkh=IDKH from inserted;
 select @SucChua=SoLuong from KhoaHoc where ID=@idkh
 if (select count(*) from DanhSachDangKy where IDKH=@idkh)>(@SucChua/3)
 begin
	update KhoaHoc set 
	TrangThai=N'Đang dạy'
	where ID=@idkh
 end
 end
 go

 create proc sp_DangKy @idhv char(10), @idkh int,@ngay date = null
 as
 begin
 if (select count(*) 
 from DanhSachDangKy
 where IDHV=@idhv and IDKH=@idkh
 and TrangThai=N'Chưa thanh toán') >=1
 begin
 print N'Học viên chưa thanh toán khóa học.'
 end
 else if (select count(*)
 from DanhSachDangKy 
 where IDKH=@idkh 
 and TrangThai=N'Đã thanh toán')>=(select SoLuong from KhoaHoc where ID=@idkh)
 begin
 print N'Khóa học đã đủ.'
 end
 else 
 begin
  insert into DanhSachDangKy values(@idhv,@idkh, ISNULL(@ngay,getdate()),N'Chưa thanh toán');
 end
 end
 go
 
 create proc sp_XoaQuaHanThanhToan
 as
	 begin
	 delete from DanhSachDangKy where TrangThai=N'Chưa thanh toán'
	 and DATEDIFF(day,getdate(),Ngay)>3
	 end
 go

create proc sp_XemLuongTatCaGiaoVien @id char(10)
as
begin
 if @id in(select ten from ChucVu where ten in (N'Giám đốc',N'Phó giám đốc',N'Thu ngân'))
 begin
 select * from BangLuongGV
 end
 else print N'Bạn không có quyền xem lương.'
end
go

insert into HocVien values
('HV01',N'Nguyễn Hữu Bình',N'Nam','binhnh0311@gmail.com','0987835378','03/11/2003',N'Đường A phường B quận C thành phố D'),
('HV02',N'Nguyễn Ngọc Kiều Nhi',N'Nữ','nnkn1601@gmail.com','0128272845','16/01/2003',N'Đường E phường X quận E tỉnh Z'),
('HV03',N'Nguyễn Hữu Thắng',N'Nam','nht0501@gmai.com','0282957192','03/05/2003',N'Đường C phường O thị xã P tỉnh M'),
('HV04',N'Nguyễn Thanh Minh',N'Nam','ndkis842@hotmail.com','05827592712','22/03/2001',N'Ngõ I đường L phường A quận B thành phố A')
go


