CREATE OR REPLACE PROCEDURE themkhoahoc (
    p_makhoahoc  IN khoahoc.makhoahoc%TYPE,
    p_hocphi     IN khoahoc.hocphi%TYPE,
    p_ngaybatdau IN khoahoc.ngaybatdau%TYPE,
    p_tenkhoahoc IN khoahoc.tenkhoahoc%TYPE,
    p_soluong    IN khoahoc.soluong%TYPE,
    p_sobuoi     IN khoahoc.sobuoi%TYPE,
    p_loai       IN loaikhoahoc.tenloai%TYPE
) AS
    v_count  INT := 0;
    v_maloai loaikhoahoc.maloai%TYPE;
BEGIN
    SELECT
        maloai
    INTO v_maloai
    FROM
        loaikhoahoc
    WHERE
        lower(tenloai) = lower(p_loai);

    INSERT INTO khoahoc (
        makhoahoc,
        hocphi,
        ngaybatdau,
        tenkhoahoc,
        soluong,
        sobuoi,
        loai
    ) VALUES (
        p_makhoahoc,
        p_hocphi,
        p_ngaybatdau,
        p_tenkhoahoc,
        p_soluong,
        p_sobuoi,
        v_maloai
    );

    COMMIT;
    dbms_output.put_line('Khóa học được thêm thành công.');
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20010, 'Không tìm thấy loại khoá học này');
END;
/

CREATE OR REPLACE TRIGGER trg_insert_khoahoc BEFORE
    INSERT OR UPDATE ON khoahoc
    FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    SELECT
        COUNT(*)
    INTO v_count
    FROM
        khoahoc
    WHERE
        lower(tenkhoahoc) = lower(:new.tenkhoahoc)
        OR makhoahoc = :new.makhoahoc;

    IF v_count > 0 THEN
        raise_application_error(-20001, 'Khoá học đã tồn tại');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE capnhatkhoahoc (
    p_makhoahoc  IN khoahoc.makhoahoc%TYPE,
    p_hocphi     IN khoahoc.hocphi%TYPE DEFAULT NULL,
    p_ngaybatdau IN khoahoc.ngaybatdau%TYPE DEFAULT NULL,
    p_tenkhoahoc IN khoahoc.tenkhoahoc%TYPE DEFAULT NULL,
    p_soluong    IN khoahoc.soluong%TYPE DEFAULT NULL,
    p_sobuoi     IN khoahoc.sobuoi%TYPE DEFAULT NULL,
    p_trangthai  IN khoahoc.trangthai%TYPE DEFAULT NULL,
    p_tenloai    IN loaikhoahoc.tenloai%TYPE
) AS
    v_loaikhoahoc loaikhoahoc.tenloai%TYPE;
BEGIN
    SELECT
        tenloai
    INTO v_loaikhoahoc
    FROM
        loaikhoahoc
    WHERE
        lower(tenloai) = lower(p_tenloai);

    UPDATE khoahoc
    SET
        hocphi = nvl(p_hocphi, hocphi),
        ngaybatdau = nvl(p_ngaybatdau, ngaybatdau),
        tenkhoahoc = nvl(p_tenkhoahoc, tenkhoahoc),
        soluong = nvl(p_soluong, soluong),
        sobuoi = nvl(p_sobuoi, sobuoi),
        trangthai = nvl(p_trangthai, trangthai),
        loai = nvl(v_loaikhoahoc, loai)
    WHERE
        makhoahoc = p_makhoahoc;

    COMMIT;
    dbms_output.put_line('Thông tin khóa học được cập nhật thành công.');
END;
/

CREATE OR REPLACE PROCEDURE xoakhoahoc (
    p_makhoahoc IN khoahoc.makhoahoc%TYPE
) AS
BEGIN
    DELETE FROM khoahoc
    WHERE
        makhoahoc = p_makhoahoc;

    COMMIT;
    dbms_output.put_line('Khóa học được xóa thành công.');
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20002, 'Không tìm thấy khóa học với Mã Khoa Học đã nhập.');
END;
/

CREATE OR REPLACE TRIGGER trg_delete_khoahoc BEFORE
    DELETE ON khoahoc
    FOR EACH ROW
DECLARE
    v_khoahoc_record khoahoc%rowtype;
    v_count          INT;
BEGIN
    SELECT
        *
    INTO v_khoahoc_record
    FROM
        khoahoc
    WHERE
        makhoahoc = :old.makhoahoc;

    SELECT
        COUNT(*)
    INTO v_count
    FROM
        danhsachdangky
    WHERE
            makhoahoc = :old.makhoahoc
        AND trangthai = 'Đã thanh toán';

    IF v_count > 0 THEN
        raise_application_error(-20010, 'Đã có người đăng ký và thanh toán khoá học này');
    ELSIF v_khoahoc_record.trangthai NOT IN ( 'Chuẩn bị', 'Đã kết thúc' ) THEN
        raise_application_error(-20003, 'Khoá học đang được giảng dạy.');
    END IF;

END;
/

CREATE OR REPLACE PROCEDURE laythongtinkhoahoc (
    p_makhoahoc IN khoahoc.makhoahoc%TYPE DEFAULT NULL
) AS

    CURSOR khoahoccursor IS
    SELECT
        makhoahoc,
        hocphi,
        ngaybatdau,
        tenkhoahoc,
        soluong,
        sobuoi,
        trangthai,
        tenloai
    FROM
             khoahoc
        JOIN loaikhoahoc ON khoahoc.loai = loaikhoahoc.maloai
    WHERE
        makhoahoc = nvl(p_makhoahoc, makhoahoc)
        OR p_makhoahoc IS NULL;

BEGIN
    FOR rec IN khoahoccursor LOOP
        dbms_output.put_line('Thông tin khóa học:');
        dbms_output.put_line('Mã Khoa Học: '
                             || nvl(rec.makhoahoc, 'NULL'));
        dbms_output.put_line('Học Phí: '
                             || nvl(to_char(rec.hocphi), 'NULL'));

        dbms_output.put_line('Ngày Bắt Đầu: '
                             || nvl(to_char(rec.ngaybatdau, 'DD-MON-YYYY'), 'NULL'));

        dbms_output.put_line('Tên Khóa Học: '
                             || nvl(rec.tenkhoahoc, 'NULL'));
        dbms_output.put_line('Số Lượng: '
                             || nvl(to_char(rec.soluong), 'NULL'));

        dbms_output.put_line('Số Buổi: '
                             || nvl(to_char(rec.sobuoi), 'NULL'));

        dbms_output.put_line('Trạng Thái: '
                             || nvl(rec.trangthai, 'NULL'));
        dbms_output.put_line('Loại khoá học: '
                             || nvl(rec.tenloai, 'NULL'));
        dbms_output.put_line('------------------------');
    END LOOP;
END;
/

exec LayThongTinKhoaHoc('KH001');
exec LayThongTinKhoaHoc;