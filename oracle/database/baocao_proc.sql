create or replace procedure ThongKeLuongHocVienMoi(p_ngaybatdau varchar,p_ngayketthuc varchar)
as
    v_count int;
begin
    select count(*) into v_count from danhsachdangky
    where to_date(ngay,'dd/mm/yyyy') between to_date(p_ngaybatdau,'dd/mm/yyyy') and to_date(p_ngayketthuc,'dd/mm/yyyy');
    
    dbms_output.put_line('Từ ngày '||p_ngaybatdau|| 'đến ngày '|| p_ngayketthuc||' có '||v_count||' học viên đăng ký mới'); 

end;
/
exec ThongKeLuongHocVienMoi('01/01/2024','23/03/2024');

create or replace procedure ThongKeDoanhThuTheoThang(p_ngaybatdau varchar,p_ngayketthuc varchar)
as
    v_total int;
begin
    select sum(sotien) into v_total
    from hoadon
    where to_date(ngay,'dd/mm/yyyy') between to_date(p_ngaybatdau,'dd/mm/yyyy') and to_date(p_ngayketthuc,'dd/mm/yyyy');
    
    dbms_output.put_line('Doanh thu từ ngày '|| p_ngaybatdau|| ' tới ngày '||p_ngayketthuc||' là : '||v_total); 
end;
/

exec ThongKeDoanhThuTheoThang('01/01/2024','24/03/2024');
