--thêm chức vụ
insert into ChucVu(TenChucVu) values ('Giám đốc');
insert into ChucVu(TenChucVu) values ('Trưởng phòng kế toán');
insert into ChucVu(TenChucVu) values ('Thu ngân');
insert into ChucVu(TenChucVu) values ('Kế toán');
insert into ChucVu(TenChucVu) values ('Trưởng phòng IT');
insert into ChucVu(TenChucVu) values ('Trưởng phòng marketing');
insert into ChucVu(TenChucVu) values ('Nhân viên IT');
insert into ChucVu(TenChucVu) values ('Nhân viên marketing');
--thêm loại khoá học
insert into LoaiKhoaHoc(TenLoai) values('Speaking');
insert into LoaiKhoaHoc(TenLoai) values('5.0-6.0');
insert into LoaiKhoaHoc(TenLoai) values('4.0');
insert into LoaiKhoaHoc(TenLoai) values('6.0-6.5');
insert into LoaiKhoaHoc(TenLoai) values('6.0-7.0');

--thêm khoá học
insert into KhoaHoc(MaKhoaHoc,HocPhi,NgayBatDau,TenKhoaHoc,SoLuong,SoBuoi,Loai)
values ('KH001',5000000,to_date('01/01/2024','dd/mm/yyyy'),'IELTS Foundation',30,30,1);

insert into KhoaHoc(MaKhoaHoc,HocPhi,NgayBatDau,TenKhoaHoc,SoLuong,SoBuoi,Loai)
values ('KH002',9000000,to_date('02/01/2024','dd/mm/yyyy'),'IELTS Intensive',30,50,2);

insert into KhoaHoc(MaKhoaHoc,HocPhi,NgayBatDau,TenKhoaHoc,SoLuong,SoBuoi,Loai)
values ('KH003',20000000,to_date('03/01/2024','dd/mm/yyyy'),'IELTS Fighter',20,50,3);

insert into KhoaHoc(MaKhoaHoc,HocPhi,NgayBatDau,TenKhoaHoc,SoLuong,SoBuoi,Loai)
values ('KH004',3000000,to_date('04/01/2024','dd/mm/yyyy'),'IELTS Basic',50,30,2);

insert into KhoaHoc(MaKhoaHoc,HocPhi,NgayBatDau,TenKhoaHoc,SoLuong,SoBuoi,Loai)
values ('KH005',4000000,to_date('05/01/2024','dd/mm/yyyy'),'IELTS Pre Foundation',40,30,1);

insert into KhoaHoc(MaKhoaHoc,HocPhi,NgayBatDau,TenKhoaHoc,SoLuong,SoBuoi,Loai)
values ('KH006',5000000,to_date('06/01/2024','dd/mm/yyyy'),'Mất gốc',20,20,2);


-- thêm giáo viên
insert into GiaoVien(MaGiaoVien,TenGiaoVien,SoDienThoai,GioiTinh,DiaChi,NgaySinh,luong)
values ('GV001','Nguyễn Hữu Bình','0987562173','Nam','15/22/1 Nguyễn Hữu Thọ, phường Tân Kiểng, quận 7, TP Hồ Chí Minh',to_date('03/11/2000','dd/mm/yyyy'),15000000);

insert into GiaoVien(MaGiaoVien,TenGiaoVien,SoDienThoai,GioiTinh,DiaChi,NgaySinh,luong)
values ('GV002','Nguyễn Ngọc Kiều Nhi','0984325921','Nữ','44/15 đường Nguyễn Thị Minh Khai, phường 3, quận 1, TP Hồ Chí Minh',to_date('16/01/2000','dd/mm/yyyy'),10000000);

insert into GiaoVien(MaGiaoVien,TenGiaoVien,SoDienThoai,GioiTinh,DiaChi,NgaySinh,luong)
values ('GV003','Lê Thị Bảo Châu','0845263712','Nữ','232 Nguyễn Thị Thập, phường Tân Phú, quận 7, TP Hồ Chí Minh',to_date('13/09/2000','dd/mm/yyyy'),20000000);

insert into GiaoVien(MaGiaoVien,TenGiaoVien,SoDienThoai,GioiTinh,DiaChi,NgaySinh,luong)
values ('GV004','Trần Gia Huy','0836427329','Nam','32 đường Nguyễn Văn Cừ, phường 8, quận 5, TP Hồ Chí Minh',to_date('08/12/2000','dd/mm/yyyy'),12000000);


--thêm nhân viên
insert into NhanVien(MaNhanVien, TenNhanVien, SoDienThoai, GioiTinh, DiaChi, NgaySinh, ChucVu,luong)
values ('NV001','Trần Trung Hiếu','0972837254','Nam','121 Nguyễn Kiệm, phường 10, quận Gò Vấp, TP Hồ Chí Minh',to_date('1999-12-21','yyyy/mm/dd'),3,7000000);

insert into NhanVien(MaNhanVien, TenNhanVien, SoDienThoai, GioiTinh, DiaChi, NgaySinh, ChucVu,luong)
values ('NV002','Đặng Hoàng','0857642731','Nam','10 Phan Kế Bính, phường Đa Kao, quận 1, TP Hồ Chí Minh',to_date('1995-05-21','yyyy/mm/dd') ,1,5000000);

insert into NhanVien(MaNhanVien, TenNhanVien, SoDienThoai, GioiTinh, DiaChi, NgaySinh, ChucVu,luong)
values ('NV003','Vũ Phương Linh','0372637218','Nữ','321 Lê Đức Thọ, phường 10, quận Gò Vấp, TP Hồ Chí Minh',to_date('1999-03-02','yyyy/mm/dd'),5,10000000);


--thêm học viên
insert into HocVien(MaHocVien, TenHocVien, NgaySinh, SoDienThoai, Email, DiaChi, GioiTinh)
values ('HV001','Nguyễn Tường Vy',to_date('2008/04/03','yyyy/mm/dd'),'0678932841','nguyentuongvy03@gmail.com','10/3 Thích Quảng Đức, phường 3, quận Phú Nhuận, TP Hồ Chí Minh','Nữ');

insert into HocVien(MaHocVien, TenHocVien, NgaySinh, SoDienThoai, Email, DiaChi, GioiTinh)
values ('HV002','Trần Mạnh Cường',to_date('2006/08/21','yyyy/mm/dd'),'0678522351','cuongtm1008@gmail.com','103/11/3 Cách mạng tháng 8, phường 11, quận Tân Bình, TP Hồ Chí Minh','Nam');


--thêm danh sách đăng ký
insert into DanhSachDangKy (MaHocVien, MaKhoaHoc,Ngay)
values ('HV001','KH001',to_date('2023/11/13','yyyy/mm/dd'));

insert into DanhSachDangKy (MaHocVien, MaKhoaHoc,Ngay)
values ('HV002','KH005',to_date('2023/12/30','yyyy/mm/dd'));

insert into DanhSachDangKy (MaHocVien, MaKhoaHoc,Ngay)
values ('HV001','KH003',to_date('2024/01/13','yyyy/mm/dd'));

insert into DanhSachDangKy (MaHocVien, MaKhoaHoc, Ngay)
values ('HV002','KH002',to_date('2024/02/13','yyyy/mm/dd'));


--thêm hoá đơn
insert into HoaDon(MaHoaDon, SoTien, MaHocVien, MaNhanVien,ngay)
values ('HDT3001',3000000,'HV001','NV001',to_date('21/03/2021','dd/mm/yyyy'));

insert into HoaDon(MaHoaDon, SoTien, MaHocVien, MaNhanVien,ngay)
values ('HDT3002',9000000,'HV002','NV002',to_date('21/03/2021','dd/mm/yyyy'));

insert into HoaDon(MaHoaDon, SoTien, MaHocVien, MaNhanVien,ngay)
values ('HDT3003',10000000,'HV001','NV003',to_date('21/03/2021','dd/mm/yyyy'));


--thêm chi tiết hoá đơn
insert into ChiTietHoaDon(MaKhoaHoc, MaHoaDon)
values ('KH001','HDT3001');

insert into ChiTietHoaDon(MaKhoaHoc, MaHoaDon)
values ('KH002','HDT3002');

insert into ChiTietHoaDon(MaKhoaHoc, MaHoaDon)
values ('KH003','HDT3003');


--thêm sách
insert into Sach(TenSach, GiaSach, SoLuong, MaKhoaHoc)
values ('Tài liệu IELTS Foundation',1200000,5,'KH001');

insert into Sach(TenSach, GiaSach, SoLuong, MaKhoaHoc)
values ('Tài liệu tiếng Anh mất gốc','800000',10,'KH006');


--thêm hoá đơn sách
insert into HoaDonSach(MaHoaDon,MaSach,SoLuong)
values ('HDT3001',1,2);

insert into HoaDonSach(MaHoaDon,MaSach,SoLuong)
values ('HDT3002',2,3);

insert into HoaDonSach(MaHoaDon,MaSach,SoLuong)
values ('HDT3003',1,2);


--thêm lịch dạy
insert into LichDay(MaGiaoVien, MaKhoaHoc, ThoiGian)
values ('GV001','KH001',to_timestamp('2024-03-02 15:00:00','yyyy/mm/dd HH24:MI:SS'));

insert into LichDay(MaGiaoVien, MaKhoaHoc, ThoiGian)
values ('GV002','KH002',to_timestamp('2024-03-02 17:00:00','yyyy/mm/dd HH24:MI:SS'));

insert into LichDay(MaGiaoVien, MaKhoaHoc, ThoiGian)
values ('GV003','KH003',to_timestamp('2024-03-03 19:00:00','yyyy/mm/dd HH24:MI:SS'));

--thêm bài thi
insert into BaiThi(TenBaiThi, ThoiGian, MaKhoaHoc)
values ('Kiểm tra chất lượng đầu vào',to_timestamp('2024-02-13 09:00:00','yyyy/mm/dd HH24:MI:SS'),'KH001');

insert into BaiThi(TenBaiThi, ThoiGian, MaKhoaHoc)
values ('Kiểm tra chất lượng đầu vào',to_timestamp('2024-02-13 09:00:00','yyyy/mm/dd HH24:MI:SS'),'KH002');

insert into BaiThi(TenBaiThi, ThoiGian, MaKhoaHoc)
values ('Kiểm tra xét bằng', to_timestamp('2024-03-10 16:00:00','yyyy/mm/dd HH24:MI:SS'),'KH002');



--thêm điểm
insert into Diem(MaHocVien, MaBaiThi, Diem)
values ('HV001',1,5);

insert into Diem(MaHocVien, MaBaiThi, Diem)
values ('HV002',2,7);

