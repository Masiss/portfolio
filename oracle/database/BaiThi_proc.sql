create or replace procedure ThemBaiThi(
    p_TenBaiThi baithi.tenbaithi%type,
    p_ThoiGian  baithi.thoigian%type,
    p_MaKhoaHoc baithi.makhoahoc%type)
as
begin
    insert into BaiThi(tenbaithi,thoigian,makhoahoc)
    values(p_TenBaiThi,p_ThoiGian,p_MaKhoaHoc);
    
    dbms_output.put_line('Thêm bài thi thành công');

end;
/
create or replace trigger trg_insert_baithi
before insert or update
on baithi for each row
declare
    v_count int;
begin
    select count(*)
    into v_count
    from baithi
    where tenbaithi=:new.tenbaithi
    and thoigian=:new.thoigian
    and makhoahoc=:new.makhoahoc;
    if v_count>0 then
        raise_application_error(-20010,'Bài thi trùng');
    else
        dbms_output.put_line('Thêm bài thi thành công');
    end if;
end;
/
create or replace procedure SuaBaiThi(
    p_MaBaiThi baithi.mabaithi%type,
    p_TenBaiThi baithi.tenbaithi%type default null,
    p_ThoiGian  baithi.thoigian%type default null,
    p_MaKhoaHoc baithi.makhoahoc%type default null)
as
begin
    if p_tenbaithi is null and p_thoigian is null and p_makhoahoc is null then
        raise_application_error(-20010,'Cập nhật thất bại');
    end if;
    
    update baithi
    set tenbaithi=nvl(p_tenbaithi,tenbaithi),
    thoigian=nvl(p_thoigian,thoigian),
    makhoahoc=nvl(p_makhoahoc,makhoahoc)
    where mabaithi=p_mabaithi;
    
    dbms_output.put_line('Cập nhật bài thi thành công');

end;
/

create or replace procedure XoaBaiThi(
    p_MaBaiThi baithi.mabaithi%type)
as
begin
    delete baithi where mabaithi=p_mabaithi;
    
    dbms_output.put_line('Xoá bài thi thành công');

end;
/
create or replace trigger trg_delete_baithi
before delete
on baithi for each row
declare
    v_countDiem int;
begin
    select count(*) into v_countDiem
    from Diem
    where mabaithi=:old.mabaithi;
    
    if v_countDiem>0 then
        raise_application_error(-20010,'Xoá bài thi thất bại');
    else
        dbms_output.put_line('Xoá bài thi thành công');
    end if;
end;
/
create or replace procedure LayThongTinBaiThi(
    p_mabaithi baithi.mabaithi%type default null
)
as
    cursor cursor_baithi is
    select baithi.*,khoahoc.tenkhoahoc
    from baithi
    join khoahoc on baithi.makhoahoc=khoahoc.makhoahoc
    where mabaithi=nvl(p_mabaithi,mabaithi);
begin
    for rec in cursor_baithi
    loop
        dbms_output.put_line('Thông tin bài thi: ');        
        dbms_output.put_line('Mã bài thi: '||rec.mabaithi);
        dbms_output.put_line('Tên bài thi: '||rec.tenbaithi);
        dbms_output.put_line('Thời gian thi: '||to_date(rec.thoigian,'dd/mm/yyyy'));
        dbms_output.put_line('Mã khoá học: '|| rec.makhoahoc);
        dbms_output.put_line('Tên khoá học: '|| rec.tenkhoahoc);
        dbms_output.put_line('--------------------------------');        

    end loop;
end;
/