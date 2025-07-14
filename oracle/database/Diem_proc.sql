CREATE OR REPLACE PROCEDURE themdiem (
    p_mahocvien diem.mahocvien%TYPE,
    p_mabaithi  diem.mabaithi%TYPE,
    p_diem      diem.diem%TYPE
) AS
BEGIN
    INSERT INTO diem (
        mahocvien,
        mabaithi,
        diem
    ) VALUES (
        p_mahocvien,
        p_mabaithi,
        p_diem
    );

END;
/

CREATE OR REPLACE PROCEDURE capnhatdiem (
    p_madiem    diem.madiem%TYPE,
    p_mahocvien diem.mahocvien%TYPE,
    p_mabaithi  diem.mabaithi%TYPE,
    p_diem      diem.diem%TYPE
) AS
BEGIN
    UPDATE diem
    SET
        diem = nvl(p_diem, diem),
        mabaithi = nvl(p_mabaithi, mabaithi)
    WHERE
            madiem = p_madiem
        AND mahocvien = p_mahocvien;

END;
/

CREATE OR REPLACE PROCEDURE xemdiem (
    p_mahocvien diem.mahocvien%TYPE DEFAULT NULL,
    p_mabaithi  diem.mabaithi%TYPE DEFAULT NULL
) AS
BEGIN
    FOR rec IN (
        SELECT
            diem.*,
            baithi.tenbaithi,
            hocvien.tenhocvien
        FROM
                 diem
            JOIN baithi ON baithi.mabaithi = diem.mabaithi
            JOIN hocvien ON hocvien.mahocvien = diem.mahocvien
        WHERE
                diem.mahocvien = nvl(p_mahocvien, diem.mahocvien)
            AND diem.mabaithi = nvl(p_mabaithi, diem.mabaithi)
    ) LOOP
        dbms_output.put_line('Thông tin điểm học viên:');
        dbms_output.put_line('Mã điểm: ' || rec.madiem);
        dbms_output.put_line('Mã học viên:' || rec.mahocvien);
        dbms_output.put_line('Tên học viên: ' || rec.tenhocvien);
        dbms_output.put_line('Mã bài thi: ' || rec.mabaithi);
        dbms_output.put_line('Tên bài thi: ' || rec.tenbaithi);
        dbms_output.put_line('Số điểm: ' || rec.diem);
        dbms_output.put_line('--------------------------------------');
    END LOOP;
END;
/

CREATE OR REPLACE TRIGGER trg_insert_diem BEFORE
    INSERT OR UPDATE ON diem
    FOR EACH ROW
DECLARE
    v_count_diem   INT;
    v_count_dangky INT;
BEGIN
    SELECT
        COUNT(*)
    INTO v_count_diem
    FROM
        diem
    WHERE
            mahocvien = :new.mahocvien
        AND mabaithi = :new.mabaithi;

    SELECT
        COUNT(*)
    INTO v_count_dangky
    FROM
             baithi
        JOIN khoahoc ON baithi.makhoahoc = khoahoc.makhoahoc
        JOIN danhsachdangky ON danhsachdangky.makhoahoc = khoahoc.makhoahoc
    WHERE
            mabaithi = :new.mabaithi
        AND danhsachdangky.mahocvien = :new.mahocvien
        AND danhsachdangky.trangthai = 'Chưa thanh toán';

    IF v_count_diem > 0 THEN
        raise_application_error(-20010, 'Điểm bài thi của học viên đã tồn tại hoặc trùng');
    ELSIF v_count_dangky > 0 THEN
        raise_application_error(-20010, 'Học viên không đang học khoá học này, hoặc chưa thanh toán học phí');
    ELSIF inserting THEN
        dbms_output.put_line('Thêm điểm thành công');
    ELSIF updating THEN
        dbms_output.put_line('Cập nhật điểm thành công');
    END IF;

END;
/