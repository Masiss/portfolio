--admin
create user adminTTTA identified by adminttta account unlock;
grant all privileges to adminTTTA;
/

--trưởng phòng nhân sự
create user hrmanager identified by hrmanager account unlock;
/
grant insert,select, update, delete on giaovien to hrmanager;
grant insert,select, update, delete on chucvu to hrmanager;
grant insert,select, update, delete on nhanvien to hrmanager;

--nhân viên phòng nhân sự
create user hremployee identified by hr account unlock;
/
grant insert,select, update on giaovien to hremployee;
grant insert,select, update on chucvu to hremployee;
grant insert,select, update on nhanvien to hremployee;

--trưởng phòng tài chính
create user accmanager identified by accmanager account unlock;
/
grant insert,select, update, delete on hoadon to accmanager;
grant insert,select, update, delete on chitiethoadon to accmanager;
grant insert,select, update, delete on hoadonsach to accmanager;

--nhân viên phòng tài chính
create user accemployee identified by accemployee account unlock;
/
grant insert,select, update on chitiethoadon to accmanager;
grant insert,select, update on chitiethoadon to accmanager;
grant insert,select, update on hoadonsach to accmanager;

--giáo vụ
create user teamanager identified by teamanager account unlock;
/
grant insert,select, update, delete on khoahoc to hrmanager;
grant insert,select, update, delete on giaovien to hrmanager;
grant insert,select, update, delete on hocvien to hrmanager;
grant insert,select, update, delete on danhsachdangky to hrmanager;
grant insert,select, update, delete on baithi to hrmanager;
grant insert,select, update, delete on diem to hrmanager;
