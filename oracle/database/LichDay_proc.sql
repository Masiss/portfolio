CREATE OR REPLACE PROCEDURE themlichday (
    p_magiaovien giaovien.magiaovien%TYPE,
    p_makhoahoc  khoahoc.makhoahoc%TYPE,
    p_thoigian   lichday.thoigian%TYPE
) AS
    v_count INT := 0;
    v_sobuoi int;
BEGIN
    insert into lichday(magiaovien,makhoahoc,thoigian)
    values (p_magiaovien,p_makhoahoc,p_thoigian);
    dbms_output.put_line('Thêm lịch dạy thành công');
END;
/

create or replace trigger trg_insert_lichday
before insert
on lichday for each row
declare
    v_count int;
    v_sobuoi int;
begin
     SELECT
        COUNT(*)
    INTO v_count
    FROM
        lichday
    WHERE
            magiaovien = :new.magiaovien
        AND thoigian = :new.thoigian;
    if v_count>0 then
        raise_application_error(-20010,'Giáo viên đã có lịch dạy ở thời gian này');
    end if; 
    
    
    select count(*) into v_count
    from lichday
    where makhoahoc=:new.makhoahoc;
    
    select sobuoi into v_sobuoi from khoahoc where makhoahoc=:new.makhoahoc;
    
    if v_count>= v_sobuoi then
        raise_application_error(-20010,'Lịch học của khoá học này đã đủ, không thể xếp thêm');
    end if;
    
    if updating then
        dbms_output.put_line('Cập nhật lịch dạy thành công');
    elsif inserting then
        dbms_output.put_line('Thêm lịch dạy thành công');
    end if;
end;
/

create or replace procedure sualichday(
    p_magiaovien giaovien.magiaovien%type,
    p_makhoahoc khoahoc.makhoahoc%type,
    p_thoigiancu lichday.thoigian%type,
    p_thoigianmoi lichday.thoigian%type)
as
    v_lichday lichday%rowtype;
begin
    select * into v_lichday
    from lichday
    where magiaovien=p_magiaovien
    and makhoahoc=p_makhoahoc
    and thoigian=p_thoigiancu;
    
    if p_thoigiancu>sysdate then
        raise_application_error(-20010,'Lịch dạy đã qua, không thể sửa');
    end if;
    
    update lichday
    set thoigian=p_thoigianmoi
    where magiaovien=p_magiaovien
    and makhoahoc=p_makhoahoc
    and thoigian=p_thoigiancu;
    
    dbms_output.put_line('Cập nhật hành công');
end;
/

CREATE OR REPLACE PROCEDURE xemlichday (
    p_magiaovien giaovien.magiaovien%TYPE default null
) AS

    CURSOR lichday_cursor IS
    SELECT
        lichday.*,
        khoahoc.tenkhoahoc,
        giaovien.tengiaovien
    FROM
             lichday
        JOIN khoahoc ON lichday.makhoahoc = khoahoc.makhoahoc
        JOIN giaovien ON giaovien.magiaovien = lichday.magiaovien
    WHERE
        lichday.magiaovien = nvl(p_magiaovien, lichday.magiaovien);

BEGIN
    FOR rec IN lichday_cursor LOOP
        dbms_output.put_line(rec.tengiaovien
                             || ' '
                             || rec.tenkhoahoc
                             || ' '
                             || to_char(rec.thoigian, 'dd-mm-yyyy HH24:MI:SS'));
    END LOOP;
END;
/
exec XemLichDay;
exec XemLichDay('GV001');
exec XemLichDay('dasdas');
/