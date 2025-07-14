create or replace procedure BanSach( p_MaSach in sach.masach%type, p_SoLuong in sach.soluong%type)
as
begin
    if p_SoLuong <=0 then
        raise_application_error(-20010,'Số lượng sách bán bị sai');
    end if;
    update sach set soluong=soluong-p_SoLuong
    where masach=p_MaSach;
    if sql%rowcount >0 then
        dbms_output.put_line('Bán sách thành công');
    end if;
end;
/

create or replace procedure HoanSach(p_MaSach in sach.masach%type, p_SoLuong in sach.soluong%type)
as
begin
    if p_SoLuong <=0 then
        raise_application_error(-20010,'Số lượng sách hoàn lại sai');
    end if;
    update sach set soluong = soluong + p_SoLuong
    where masach=p_MaSach;
    if sql%rowcount >0 then
        dbms_output.put_line('Hoàn '||p_SoLuong|| ' sách ' || p_MaSach|| ' thành công');
    end if;
end;
/
CREATE OR REPLACE PROCEDURE ThemSach (
    p_TenSach IN Sach.TenSach%TYPE,
    p_GiaSach IN Sach.GiaSach%TYPE,
    p_SoLuong IN Sach.SoLuong%TYPE,
    p_MaKhoaHoc IN Sach.MaKhoaHoc%TYPE
) AS
BEGIN
    INSERT INTO Sach (TenSach, GiaSach, SoLuong, MaKhoaHoc)
    VALUES (p_TenSach, p_GiaSach, p_SoLuong, p_MaKhoaHoc);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Sách đã được thêm thành công.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END ThemSach;
/

CREATE OR REPLACE PROCEDURE CapNhatSach (
    p_MaSach IN Sach.MaSach%TYPE,
    p_TenSach IN Sach.TenSach%TYPE default null,
    p_GiaSach IN Sach.GiaSach%TYPE default null,
    p_SoLuong IN Sach.SoLuong%TYPE default null,
    p_MaKhoaHoc IN Sach.MaKhoaHoc%TYPE default null
) AS
BEGIN
    UPDATE Sach
    SET 
        TenSach =nvl( p_TenSach,tensach),
        GiaSach =nvl( p_GiaSach,giasach),
        SoLuong = nvl(p_SoLuong,soluong),
        MaKhoaHoc = nvl(p_MaKhoaHoc,makhoahoc)
    WHERE MaSach = p_MaSach;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy sách với Mã Sách đã nhập.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Thông tin sách đã được cập nhật thành công.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END CapNhatSach;
/

CREATE OR REPLACE PROCEDURE XoaSach (
    p_MaSach IN Sach.MaSach%TYPE
) AS
BEGIN
    DELETE FROM Sach WHERE MaSach = p_MaSach;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy sách với Mã Sách đã nhập.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Sách đã được xóa thành công.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END XoaSach;
/
CREATE OR REPLACE PROCEDURE LayThongTinSach (
    p_MaSach IN Sach.MaSach%TYPE DEFAULT NULL
) AS
    CURSOR c_Sach IS
        SELECT MaSach, TenSach, GiaSach, sach.SoLuong, TenKhoaHoc
        FROM Sach
        join khoahoc on khoahoc.makhoahoc=sach.makhoahoc
        WHERE MaSach = NVL(p_MaSach, MaSach) OR p_MaSach IS NULL;
BEGIN
    FOR rec IN c_Sach LOOP
        DBMS_OUTPUT.PUT_LINE('Thông tin sách:');
        DBMS_OUTPUT.PUT_LINE('Mã Sách: ' || rec.MaSach);
        DBMS_OUTPUT.PUT_LINE('Tên Sách: ' || rec.TenSach);
        DBMS_OUTPUT.PUT_LINE('Giá Sách: ' || rec.GiaSach);
        DBMS_OUTPUT.PUT_LINE('Số Lượng: ' || rec.SoLuong);
        DBMS_OUTPUT.PUT_LINE('Mã Khóa Học: ' || rec.TenKhoaHoc);
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;

    IF c_Sach%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy sách với Mã Sách đã nhập.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END LayThongTinSach;
/