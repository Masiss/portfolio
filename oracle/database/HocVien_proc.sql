CREATE OR REPLACE PROCEDURE ThemHocVien (
    p_MaHocVien IN HocVien.MaHocVien%TYPE,
    p_TenHocVien IN HocVien.TenHocVien%TYPE,
    p_NgaySinh IN HocVien.NgaySinh%TYPE,
    p_SoDienThoai IN HocVien.SoDienThoai%TYPE,
    p_Email IN HocVien.Email%TYPE,
    p_DiaChi IN HocVien.DiaChi%TYPE,
    p_GioiTinh IN HocVien.GioiTinh%TYPE
) AS
BEGIN
    IF p_NgaySinh >= SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: Ngày sinh không hợp lệ.');
        RETURN;
    END IF;

    INSERT INTO HocVien (MaHocVien, TenHocVien, NgaySinh, SoDienThoai, Email, DiaChi, GioiTinh)
    VALUES (p_MaHocVien, p_TenHocVien, p_NgaySinh, p_SoDienThoai, p_Email, p_DiaChi, p_GioiTinh);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Học viên đã được thêm vào thành công.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: Mã học viên đã tồn tại.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END ThemHocVien;
/

CREATE OR REPLACE PROCEDURE CapNhatThongTinHocVien (
    p_MaHocVien IN HocVien.MaHocVien%TYPE,
    p_TenHocVien IN HocVien.TenHocVien%TYPE DEFAULT NULL,
    p_NgaySinh IN HocVien.NgaySinh%TYPE DEFAULT NULL,
    p_SoDienThoai IN HocVien.SoDienThoai%TYPE DEFAULT NULL,
    p_Email IN HocVien.Email%TYPE DEFAULT NULL,
    p_DiaChi IN HocVien.DiaChi%TYPE DEFAULT NULL,
    p_GioiTinh IN HocVien.GioiTinh%TYPE DEFAULT NULL
) AS
BEGIN
    IF p_NgaySinh >= SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: Ngày sinh không hợp lệ.');
        RETURN;
    END IF;

    UPDATE HocVien
    SET 
        TenHocVien = NVL(p_TenHocVien, TenHocVien),
        NgaySinh = NVL(p_NgaySinh, NgaySinh),
        SoDienThoai = NVL(p_SoDienThoai, SoDienThoai),
        Email = NVL(p_Email, Email),
        DiaChi = NVL(p_DiaChi, DiaChi),
        GioiTinh = NVL(p_GioiTinh, GioiTinh)
    WHERE MaHocVien = p_MaHocVien;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy học viên với Mã Học Viên đã nhập.');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Thông tin học viên đã được cập nhật thành công.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END CapNhatThongTinHocVien;
/


CREATE OR REPLACE PROCEDURE LayThongTinHocVien (
    p_MaHocVien IN HocVien.MaHocVien%TYPE DEFAULT NULL
) AS
BEGIN
    FOR rec IN (SELECT *
                FROM HocVien
                WHERE MaHocVien = NVL(p_MaHocVien, MaHocVien))
    LOOP
        DBMS_OUTPUT.PUT_LINE('Thông tin học viên:');
        DBMS_OUTPUT.PUT_LINE('Mã Học Viên: ' || NVL(rec.MaHocVien, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Tên Học Viên: ' || NVL(rec.TenHocVien, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Ngày Sinh: ' || NVL(TO_CHAR(rec.NgaySinh, 'DD-MON-YYYY'), 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Số Điện Thoại: ' || NVL(rec.SoDienThoai, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Email: ' || NVL(rec.Email, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Địa Chỉ: ' || NVL(rec.DiaChi, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Giới Tính: ' || NVL(rec.GioiTinh, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy học viên với Mã Học Viên đã nhập.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END LayThongTinHocVien;
/
exec Laythongtinhocvien('HV001');
exec Laythongtinhocvien;