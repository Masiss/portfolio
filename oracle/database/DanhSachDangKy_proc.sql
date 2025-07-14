create or replace trigger trg_insert_danhsachdangky
before insert or update of mahocvien,makhoahoc, ngay
on danhsachdangky for each row
declare
    v_count int;
    v_total int;
begin
    if :new.ngay > sysdate then
        raise_application_error(-20010,'Ngày đăng ký không được lớn hơn ngày hiện tại');
    end if;
    
    select count(*) into v_count
    from danhsachdangky
    where makhoahoc=:new.makhoahoc;
    
    select soluong into v_total
    from khoahoc
    where makhoahoc=:new.makhoahoc;
    
    if v_total>=v_count then
        raise_application_error(-20010,'Khoá học đã đủ học viên, không thể đăng ký thêm.');
    end if;
    
    select count(*) into v_count
    from danhsachdangky
    where mahocvien=:new.mahocvien
    and makhoahoc=:new.makhoahoc
    and trangthai='Chưa thanh toán';
    
    if v_count>0 then
        raise_application_error(-20010,'Học viên đã đăng ký và chưa thanh toán khoá học này');
    end if;
    
    select count(*) into v_count
    from danhsachdangky
    where mahocvien=:new.mahocvien
    and trangthai='Chưa thanh toán';
    
    if v_count>5 then
        raise_application_error(-20010,'Học viên đã đăng ký nhiều hơn 5 khoá học mà chưa thanh toán, hãy xoá đăng ký và thử lại');
    end if;
    dbms_output.put_line('Đăng ký thành công');
    commit;
end;
/
CREATE OR REPLACE PROCEDURE CapNhatTrangThai (
    p_MaHocVien IN DanhSachDangKy.MaHocVien%TYPE,
    p_MaKhoaHoc IN DanhSachDangKy.MaKhoaHoc%TYPE,
    p_TrangThai IN DanhSachDangKy.TrangThai%TYPE
) AS
BEGIN
    UPDATE DanhSachDangKy
    SET TrangThai = p_TrangThai
    WHERE MaHocVien = p_MaHocVien AND MaKhoaHoc = p_MaKhoaHoc;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy đăng ký của học viên với Mã Học Viên và Mã Khóa Học đã nhập.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Trạng thái đăng ký đã được cập nhật thành công.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END CapNhatTrangThai;
/

CREATE OR REPLACE PROCEDURE XoaDangKy (
    p_MaHocVien IN DanhSachDangKy.MaHocVien%TYPE,
    p_MaKhoaHoc IN DanhSachDangKy.MaKhoaHoc%TYPE,
    p_NgayDangKy IN danhsachdangky.ngay%type
) AS
BEGIN
    
    DELETE FROM DanhSachDangKy
    WHERE MaHocVien = p_MaHocVien
    AND MaKhoaHoc = p_MaKhoaHoc
    and ngay=p_ngaydangky
    and trangthai='Chưa thanh toán';

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy đăng ký của học viên với Mã Học Viên và Mã Khóa Học đã nhập hoặc học viên đã đóng học phí và không thể xoá đăng ký.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Đăng ký của học viên đã được xóa thành công.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END XoaDangKy;
/

CREATE OR REPLACE PROCEDURE LayThongTinDangKy (
    p_MaHocVien IN DanhSachDangKy.MaHocVien%TYPE DEFAULT NULL,
    p_MaKhoaHoc IN DanhSachDangKy.MaKhoaHoc%TYPE DEFAULT NULL
) AS
BEGIN
    FOR rec IN (SELECT danhsachdangky.MaHocVien,TenHocVien, danhsachdangky.MaKhoaHoc,tenkhoahoc, Ngay,danhsachdangky.TrangThai
                FROM DanhSachDangKy
                join hocvien on hocvien.mahocvien=danhsachdangky.mahocvien
                join khoahoc on khoahoc.makhoahoc=danhsachdangky.makhoahoc
                WHERE (danhsachdangky.MaHocVien = NVL(p_MaHocVien, danhsachdangky.MaHocVien) OR p_MaHocVien IS NULL)
                AND (danhsachdangky.MaKhoaHoc = NVL(p_MaKhoaHoc, danhsachdangky.MaKhoaHoc) OR p_MaKhoaHoc IS NULL))
    LOOP
        DBMS_OUTPUT.PUT_LINE('Thông tin đăng ký:');
        DBMS_OUTPUT.PUT_LINE('Mã Học Viên: ' || rec.MaHocVien);
        DBMS_OUTPUT.PUT_LINE('Tên Học Viên: ' || rec.TenHocVien);
        DBMS_OUTPUT.PUT_LINE('Mã Khóa Học: ' || rec.MaKhoaHoc);
        DBMS_OUTPUT.PUT_LINE('Tên Khoá học: ' || rec.tenkhoahoc);
        DBMS_OUTPUT.PUT_LINE('Ngày: ' || TO_CHAR(rec.Ngay, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Trạng Thái: ' || rec.TrangThai);
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy thông tin đăng ký.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END LayThongTinDangKy;
/

exec laythongtindangky(null,'KH001')
exec laythongtindangky('hv002')
