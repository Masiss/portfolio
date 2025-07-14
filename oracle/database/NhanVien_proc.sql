CREATE OR REPLACE PROCEDURE themnhanvien (
    p_manhanvien  IN nhanvien.manhanvien%TYPE,
    p_tennhanvien IN nhanvien.tennhanvien%TYPE,
    p_sodienthoai IN nhanvien.sodienthoai%TYPE,
    p_gioitinh    IN nhanvien.gioitinh%TYPE,
    p_diachi      IN nhanvien.diachi%TYPE,
    p_ngaysinh    IN nhanvien.ngaysinh%TYPE,
    p_chucvu      IN nhanvien.chucvu%TYPE,
    p_luong nhanvien.luong%type
) AS
BEGIN
    INSERT INTO nhanvien (
        manhanvien,
        tennhanvien,
        sodienthoai,
        gioitinh,
        diachi,
        ngaysinh,
        chucvu,
        luong
    ) VALUES (
        p_manhanvien,
        p_tennhanvien,
        p_sodienthoai,
        p_gioitinh,
        p_diachi,
        p_ngaysinh,
        p_chucvu,
        p_luong
    );

    dbms_output.put_line('Nhân viên đã được thêm vào thành công.');
END;
/

CREATE OR REPLACE PROCEDURE capnhatthongtinnhanvien (
    p_manhanvien  IN nhanvien.manhanvien%TYPE,
    p_tennhanvien IN nhanvien.tennhanvien%TYPE DEFAULT NULL,
    p_sodienthoai IN nhanvien.sodienthoai%TYPE DEFAULT NULL,
    p_gioitinh    IN nhanvien.gioitinh%TYPE DEFAULT NULL,
    p_diachi      IN nhanvien.diachi%TYPE DEFAULT NULL,
    p_ngaysinh    IN nhanvien.ngaysinh%TYPE DEFAULT NULL,
    p_chucvu      IN nhanvien.chucvu%TYPE DEFAULT NULL,
    p_luong nhanvien.luong%type default null
) AS
BEGIN
    UPDATE nhanvien
    SET
        tennhanvien = nvl(p_tennhanvien, tennhanvien),
        sodienthoai = nvl(p_sodienthoai, sodienthoai),
        gioitinh = nvl(p_gioitinh, gioitinh),
        diachi = nvl(p_diachi, diachi),
        ngaysinh = nvl(p_ngaysinh, ngaysinh),
        chucvu = nvl(p_chucvu, chucvu),
        luong = nvl(p_luong,luong)
    WHERE
        manhanvien = p_manhanvien;

END;
/

CREATE OR REPLACE PROCEDURE xoanhanvien (
    p_manhanvien IN nhanvien.manhanvien%TYPE
) AS
BEGIN
    DELETE FROM nhanvien
    WHERE
        manhanvien = p_manhanvien;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Không tìm thấy nhân viên với Mã Nhân Viên đã nhập.');
    ELSE
        COMMIT;
        dbms_output.put_line('Nhân viên đã được xóa thành công.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Lỗi: ' || sqlerrm);
END;
/
CREATE OR REPLACE PROCEDURE laythongtinnhanvien (
    p_manhanvien IN nhanvien.manhanvien%TYPE DEFAULT NULL
) AS

    CURSOR nhanviencursor IS
    SELECT
        nhanvien.*,chucvu.tenchucvu
    FROM
             nhanvien
        JOIN chucvu ON nhanvien.chucvu = chucvu.machucvu
    WHERE
        manhanvien = nvl(p_manhanvien, manhanvien);

BEGIN
    FOR rec IN nhanviencursor LOOP
        dbms_output.put_line('Thông tin nhân viên:');
        dbms_output.put_line('Mã Nhân Viên: '
                             || nvl(rec.manhanvien, 'NULL'));
        dbms_output.put_line('Tên Nhân Viên: '
                             || nvl(rec.tennhanvien, 'NULL'));
        dbms_output.put_line('Số Điện Thoại: '
                             || nvl(rec.sodienthoai, 'NULL'));
        dbms_output.put_line('Giới Tính: '
                             || nvl(rec.gioitinh, 'NULL'));
        dbms_output.put_line('Địa Chỉ: '
                             || nvl(rec.diachi, 'NULL'));
        dbms_output.put_line('Ngày Sinh: '
                             || nvl(to_char(rec.ngaysinh, 'YYYY-MM-DD'), 'NULL'));

        dbms_output.put_line('Chức Vụ: '
                             || nvl(rec.tenchucvu, 'NULL'));
        dbms_output.put_line('Lương: '
                             || rec.luong);
                             
        dbms_output.put_line('------------------------');
    END LOOP;

    IF SQL%notfound THEN
        dbms_output.put_line('Không tìm thấy nhân viên với Mã Nhân Viên đã nhập.');
    END IF;
END;
/



create or replace procedure capnhatluongnhanvien(
    p_manhanvien nhanvien.manhanvien%type, 
    p_luong nhanvien.luong%type)
as

begin
    update nhanvien
    set luong=p_luong
    where manhanvien=p_manhanvien;
    if sql%rowcount >0 then
        dbms_output.put_line('Cập nhật lương nhân viên thành công');
        commit;
    end if;    
end;
/
create or replace trigger trg_update_salary_nhanvien
before update of luong
on nhanvien for each row
begin
    if (:new.luong/:old.luong) > 1.3 or (:new.luong/:old.luong)<0.7 then
        raise_application_error(-20010,'Lương cập nhật không tăng giảm quá 30%');
    end if;
    dbms_output.put_line('Cập nhật lương nhân viên thành công');
end;
/
CREATE OR REPLACE PROCEDURE thaydoichucvunhanvien (
    p_manhanvien nhanvien.manhanvien%TYPE,
    p_chucvu     chucvu.tenchucvu%TYPE
) AS
    v_machucvu chucvu.machucvu%TYPE;
    v_count    INT;
BEGIN
    SELECT
        COUNT(*)
    INTO v_count
    FROM
        chucvu
    WHERE
        lower(tenchucvu) = lower(p_chucvu);

    IF v_count = 0 THEN
        raise_application_error(-20010, 'Chức vụ không tồn tại');
    END IF;
    SELECT
        machucvu
    INTO v_machucvu
    FROM
        chucvu
    WHERE
        lower(tenchucvu) = lower(p_chucvu);

    UPDATE nhanvien
    SET
        chucvu = v_machucvu
    WHERE
        manhanvien = p_manhanvien;

    IF SQL%rowcount > 0 THEN
        dbms_output.put_line('Cập nhật thành công');
    ELSE
        dbms_output.put_line('Không có nhân viên này');
    END IF;

END;
/
--test đúng
exec ThayDoiChucVuNhanVien('NV001','Thu ngân');
--test sai
exec ThayDoiChucVuNhanVien('NV001','giamdoc');