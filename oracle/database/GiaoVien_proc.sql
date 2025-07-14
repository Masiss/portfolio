CREATE OR REPLACE PROCEDURE ThemGiaoVien (
    p_MaGiaoVien IN GiaoVien.MaGiaoVien%TYPE,
    p_TenGiaoVien IN GiaoVien.TenGiaoVien%TYPE,
    p_SoDienThoai IN GiaoVien.SoDienThoai%TYPE,
    p_GioiTinh IN GiaoVien.GioiTinh%TYPE,
    p_DiaChi IN GiaoVien.DiaChi%TYPE,
    p_NgaySinh IN GiaoVien.NgaySinh%TYPE,
    p_Luong giaovien.luong%type
) AS
BEGIN
    INSERT INTO GiaoVien (MaGiaoVien, TenGiaoVien, SoDienThoai, GioiTinh, DiaChi, NgaySinh,luong)
    VALUES (p_MaGiaoVien, p_TenGiaoVien, p_SoDienThoai, p_GioiTinh, p_DiaChi, p_NgaySinh,p_luong);
    DBMS_OUTPUT.PUT_LINE('Giáo viên đã được thêm thành công.');
END;
/
create or replace procedure capnhatluonggiaovien(
    p_magiaovien giaovien.magiaovien%type, 
    p_luong giaovien.luong%type)
as

begin
    update giaovien
    set luong=p_luong
    where magiaovien=p_magiaovien;
    if sql%rowcount >0 then
        dbms_output.put_line('Cập nhật lương giáo viên thành công');
        commit;
    end if;    
end;
/
create or replace trigger trg_update_salary_giaovien
before update of luong
on nhanvien for each row
begin
    if (:new.luong/:old.luong) > 1.3 or (:new.luong/:old.luong)<0.7 then
        raise_application_error(-20010,'Lương cập nhật không tăng giảm quá 30%');
    end if;
    dbms_output.put_line('Cập nhật lương nhân viên thành công');
end;
/
CREATE OR REPLACE PROCEDURE LayThongTinGiaoVien (
    p_MaGiaoVien IN GiaoVien.MaGiaoVien%TYPE DEFAULT NULL
) AS
    CURSOR GiaoVienCursor IS
        SELECT *
        FROM GiaoVien
        WHERE MaGiaoVien = NVL(p_MaGiaoVien, MaGiaoVien) OR p_MaGiaoVien IS NULL;

    rec GiaoVienCursor%ROWTYPE;
BEGIN
    for rec in GiaoVienCursor
    LOOP
        DBMS_OUTPUT.PUT_LINE('Thông tin giáo viên:');
        DBMS_OUTPUT.PUT_LINE('Mã Giáo Viên: ' || NVL(rec.MaGiaoVien, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Tên Giáo Viên: ' || NVL(rec.TenGiaoVien, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Số Điện Thoại: ' || NVL(rec.SoDienThoai, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Giới Tính: ' || NVL(rec.GioiTinh, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Địa Chỉ: ' || NVL(rec.DiaChi, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Ngày Sinh: ' || NVL(TO_CHAR(rec.NgaySinh, 'DD-MON-YYYY'), 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Lương: ' || rec.luong);
        
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END ;
/
exec LayThongTinGiaoVien;

CREATE OR REPLACE PROCEDURE CapNhatThongTinGiaoVien (
    p_MaGiaoVien IN GiaoVien.MaGiaoVien%TYPE,
    p_TenGiaoVien IN GiaoVien.TenGiaoVien%TYPE DEFAULT NULL,
    p_SoDienThoai IN GiaoVien.SoDienThoai%TYPE DEFAULT NULL,
    p_GioiTinh IN GiaoVien.GioiTinh%TYPE DEFAULT NULL,
    p_DiaChi IN GiaoVien.DiaChi%TYPE DEFAULT NULL,
    p_NgaySinh IN GiaoVien.NgaySinh%TYPE DEFAULT NULL,
    p_Luong giaovien.luong%type default null
) AS
BEGIN
    UPDATE GiaoVien
    SET 
        TenGiaoVien = NVL(p_TenGiaoVien, TenGiaoVien),
        SoDienThoai = NVL(p_SoDienThoai, SoDienThoai),
        GioiTinh = NVL(p_GioiTinh, GioiTinh),
        DiaChi = NVL(p_DiaChi, DiaChi),
        NgaySinh = NVL(p_NgaySinh, NgaySinh),
        luong =nvl(p_luong,luong)
    WHERE MaGiaoVien = p_MaGiaoVien;
    if sql%rowcount>0 then 
        dbms_output.put_line('Cập nhật thành công giáo viên '||p_MaGiaoVien);
    else
        dbms_output.put_line('Không tìm thấy nhân viên có mã '|| p_MaGiaoVien);
    end if;

END;
/

CREATE OR REPLACE PROCEDURE XoaGiaoVien (
    p_MaGiaoVien IN GiaoVien.MaGiaoVien%TYPE
) AS
BEGIN
    DELETE FROM GiaoVien
    WHERE MaGiaoVien = p_MaGiaoVien;
    if sql%rowcount >0 then
        DBMS_OUTPUT.PUT_LINE('Giáo viên ' || p_MaGiaoVien || ' đã được xóa thành công.');
    else
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy giáo viên có mã '||p_MaGiaoVien);
    end if;
END;
/

