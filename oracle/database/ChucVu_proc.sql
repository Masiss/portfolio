CREATE OR REPLACE PROCEDURE ThemChucVu (
    p_TenChucVu IN ChucVu.TenChucVu%TYPE
) AS
    v_count int :=0;
BEGIN
    INSERT INTO ChucVu (TenChucVu)
    VALUES (p_TenChucVu);
    DBMS_OUTPUT.PUT_LINE('ChucVu được thêm thành công.');
END;
/
create or replace trigger trg_insert_chucvu
before insert or update
on chucvu for each row
declare
    v_count int;
begin
    select count(*) into v_count
    from chucvu
    where lower(tenchucvu)=lower(:new.tenchucvu);
    if v_count>0 then
        raise_application_error(-20010,'Chức vụ đã tồn tại');
    elsif inserting then
        DBMS_OUTPUT.PUT_LINE('ChucVu được thêm thành công.');
    elsif updating then
        DBMS_OUTPUT.PUT_LINE('ChucVu được cập nhật thành công.');
    end if;
end;
/
CREATE OR REPLACE PROCEDURE CapNhatChucVu (
    p_MaChucVu IN ChucVu.MaChucVu%TYPE,
    p_TenChucVu IN ChucVu.TenChucVu%TYPE
) AS
    v_count int :=0;
BEGIN
    UPDATE ChucVu
    SET TenChucVu = p_TenChucVu
    WHERE MaChucVu =  p_MaChucVu;
END;
/


CREATE OR REPLACE PROCEDURE XoaChucVu (
    p_MaChucVu IN ChucVu.MaChucVu%TYPE
) AS
BEGIN
    DELETE FROM ChucVu WHERE MaChucVu = p_MaChucVu;
END;
/
create or replace trigger trg_delete_chucvu
before delete
on chucvu for each row
declare
    v_count int;
begin
    select count(*) into v_count
    from nhanvien
    where nhanvien.chucvu=:old.machucvu;
    
    if v_count>0 then
        raise_application_error(-20010,'Hiện đang có nhân viên giữ chức vụ này nên không thể xoá chức vụ');
    else
        DBMS_OUTPUT.PUT_LINE('ChucVu được xóa thành công.');
    end if;
end;
/

CREATE OR REPLACE PROCEDURE LayThongTinChucVu (
    p_MaChucVu IN ChucVu.MaChucVu%TYPE default null
) AS
    cursor cursor_chucvu is
    select * from chucvu
    where machucvu=nvl(p_MaChucVu,MaChucVu);
BEGIN
    -- Kiểm tra điều kiện và báo lỗi nếu cần
    FOR rec IN cursor_chucvu LOOP
        DBMS_OUTPUT.PUT_LINE('Mã ChucVu: ' || rec.MaChucVu || ', Tên ChucVu: ' || rec.TenChucVu);
    END LOOP;
END;
/

exec LayThongTinChucVu(1);
exec LayThongTinChucVu;