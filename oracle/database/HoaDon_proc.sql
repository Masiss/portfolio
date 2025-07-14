CREATE OR REPLACE PROCEDURE ThemHoaDon (
    p_MaHoaDon IN HoaDon.MaHoaDon%TYPE,
    p_SoTien IN HoaDon.SoTien%TYPE,
    p_MaHocVien IN HoaDon.MaHocVien%TYPE,
    p_ngay in Hoadon.ngay%type,
    p_MaNhanVien IN HoaDon.MaNhanVien%TYPE,
    p_ChiTietSach IN HoaDonSachList DEFAULT NULL,
    p_ChiTietKhoaHoc IN ChiTietHoaDonList DEFAULT NULL
) AS
    v_TongSoTienChiTietSach INT := 0;
    v_TongSoTienChiTietKhoaHoc INT := 0;
    v_TongSoTienHoaDon INT;
    v_temp int;
BEGIN
    set transaction isolation level serializable;
    
    FOR rec IN (SELECT * FROM TABLE(p_ChiTietSach)) LOOP
        -- Lấy mã sách từ list
        SELECT GiaSach into v_temp  FROM Sach WHERE MaSach = rec.MaSach;
        v_TongSoTienChiTietSach := v_TongSoTienChiTietSach + rec.SoLuong * v_temp;
    END LOOP;

    -- Tính tổng số tiền từ khoá học
    FOR rec IN (SELECT * FROM TABLE(p_ChiTietKhoaHoc)) LOOP
        -- Lấy mã khoá học từ list
        SELECT HocPhi into v_temp FROM KhoaHoc WHERE MaKhoaHoc = rec.MaKhoaHoc;
        v_TongSoTienChiTietKhoaHoc := v_TongSoTienChiTietKhoaHoc + v_temp;
    END LOOP;
    dbms_output.put_line(v_TongSoTienChiTietSach);
    dbms_output.put_line(v_TongSoTienChiTietKhoaHoc);
    dbms_output.put_line(p_SoTien);
    -- Tính tổng số tiền của hóa đơn
    v_TongSoTienHoaDon := v_TongSoTienChiTietSach + v_TongSoTienChiTietKhoaHoc;

    -- Kiểm tra xem tổng số tiền của hóa đơn có bằng số tiền nhập vào không
    IF p_SoTien != v_TongSoTienHoaDon THEN
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Số tiền của hóa đơn không khớp với tổng số tiền của các mục chi tiết.');
    END IF;

    -- Thêm thông tin vào bảng HoaDon
    INSERT INTO HoaDon (MaHoaDon, SoTien, MaHocVien, MaNhanVien,Ngay)
    VALUES (p_MaHoaDon, p_SoTien, p_MaHocVien, p_MaNhanVien,p_Ngay);

    -- Thêm chi tiết hóa đơn sách vào bảng HoaDonSach nếu có
     IF p_ChiTietSach IS NOT NULL THEN
        FOR i IN 1..p_ChiTietSach.COUNT LOOP
            INSERT INTO HoaDonSach (MaHoaDon, MaSach, SoLuong)
            VALUES (p_MaHoaDon, p_ChiTietSach(i).MaSach, p_ChiTietSach(i).SoLuong);
            bansach(p_ChiTietSach(i).MaSach,p_chitietsach(i).soluong);
        END LOOP;
    END IF;

    -- Thêm chi tiết hóa đơn khoá học vào bảng ChiTietHoaDon nếu có
    IF p_ChiTietKhoaHoc IS NOT NULL THEN
        FOR i IN 1..p_ChiTietKhoaHoc.COUNT LOOP
            INSERT INTO ChiTietHoaDon (MaKhoaHoc, MaHoaDon)
            VALUES (p_ChiTietKhoaHoc(i).MaKhoaHoc, p_MaHoaDon);
        END LOOP;
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Hóa đơn đã được thêm thành công và số tiền đã được kiểm tra.');
EXCEPTION
    WHEN OTHERS THEN
        -- Rollback transaction nếu có lỗi
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Lỗi: ' || SQLERRM);
END ThemHoaDon;
/

-- lệnh test
DECLARE
    -- Khai báo các biến đầu vào
    v_MaHoaDon HoaDon.MaHoaDon%TYPE := 'HD001';
    v_SoTien HoaDon.SoTien%TYPE := 7400000;
    v_MaHocVien HoaDon.MaHocVien%TYPE := 'HV001';
    v_MaNhanVien HoaDon.MaNhanVien%TYPE := 'NV001';
    v_Ngay Hoadon.ngay%type := to_date('20/03/2024','dd/mm/yyyy');
    -- Khai báo danh sách chi tiết sách và chi tiết khoá học
    v_ChiTietSach HoaDonSachList := HoaDonSachList();
    v_ChiTietKhoaHoc ChiTietHoaDonList := ChiTietHoaDonList();

BEGIN
    -- Thêm một chi tiết sách vào danh sách chi tiết sách
    v_ChiTietSach.EXTEND;
    v_ChiTietSach(1) := HoaDonSachType(1, 2); -- Giả sử mã sách là 1 và số lượng là 2
    -- Thêm một chi tiết khoá học vào danh sách chi tiết khoá học
    v_ChiTietKhoaHoc.EXTEND;
    v_ChiTietKhoaHoc(1) := ChiTietHoaDonType('KH001'); -- Giả sử mã khoá học là 'KH001'

    -- Gọi procedure ThemHoaDon với các tham số đã được khai báo
    ThemHoaDon(v_MaHoaDon, v_SoTien, v_MaHocVien, v_Ngay, v_MaNhanVien, v_ChiTietSach, v_ChiTietKhoaHoc);
    
    -- In ra thông báo sau khi thực thi procedure thành công
    DBMS_OUTPUT.PUT_LINE('Procedure đã được thực thi thành công.');
EXCEPTION
    WHEN OTHERS THEN
        -- Xử lý nếu có lỗi xảy ra
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE CapNhatHoaDon (
    p_MaHoaDon IN HoaDon.MaHoaDon%TYPE,
    p_SoTien IN HoaDon.SoTien%TYPE,
    p_MaHocVien IN HoaDon.MaHocVien%TYPE,
    p_MaNhanVien IN HoaDon.MaNhanVien%TYPE,
    p_ChiTietSach IN HoaDonSachList DEFAULT NULL,
    p_ChiTietKhoaHoc IN ChiTietHoaDonList DEFAULT NULL
) AS
    v_TongSoTienChiTietSach INT := 0;
    v_TongSoTienChiTietKhoaHoc INT := 0;
    v_TongSoTienHoaDon INT;
    v_temp int;
BEGIN
    set transaction isolation level serializable;
    -- Tính tổng số tiền từ sách
    FOR rec IN (SELECT * FROM TABLE(p_ChiTietSach)) LOOP
        -- Lấy mã sách từ list
        SELECT GiaSach into v_temp FROM Sach WHERE MaSach = rec.MaSach;
        v_TongSoTienChiTietSach := v_TongSoTienChiTietSach + rec.SoLuong * v_temp;
    END LOOP;

    -- Tính tổng số tiền từ khoá học
    FOR rec IN (SELECT * FROM TABLE(p_ChiTietKhoaHoc)) LOOP
        -- Lấy mã khoá học từ list
        SELECT HocPhi into v_temp FROM KhoaHoc WHERE MaKhoaHoc = rec.MaKhoaHoc;
        v_TongSoTienChiTietKhoaHoc := v_TongSoTienChiTietKhoaHoc + v_temp;
    END LOOP;

    -- Tính tổng số tiền của hóa đơn
    v_TongSoTienHoaDon := v_TongSoTienChiTietSach + v_TongSoTienChiTietKhoaHoc;

    -- Kiểm tra xem tổng số tiền của hóa đơn có bằng số tiền nhập vào không
    IF p_SoTien != v_TongSoTienHoaDon THEN
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Số tiền của hóa đơn không khớp với tổng số tiền của các mục chi tiết.');
    END IF;

    -- Cập nhật thông tin vào bảng HoaDon
    UPDATE HoaDon
    SET SoTien = p_SoTien,
        MaHocVien = p_MaHocVien,
        MaNhanVien = p_MaNhanVien
    WHERE MaHoaDon = p_MaHoaDon;
    
    for sach_rec in (select * from hoadonsach where mahoadon=p_MaHoaDon)
    loop
        HoanSach(sach_rec.masach,sach_rec.soluong);
    end loop;
    
    
    -- Xóa các chi tiết cũ của hóa đơn
    DELETE FROM HoaDonSach WHERE MaHoaDon = p_MaHoaDon;
    DELETE FROM ChiTietHoaDon WHERE MaHoaDon = p_MaHoaDon;

    -- Thêm chi tiết hóa đơn sách vào bảng HoaDonSach nếu có
    IF p_ChiTietSach IS NOT NULL THEN
        FOR i IN 1..p_ChiTietSach.count LOOP
            INSERT INTO HoaDonSach (MaHoaDon, MaSach, SoLuong)
            VALUES (p_MaHoaDon, p_ChiTietSach(i).MaSach, p_ChiTietSach(i).SoLuong);
            bansach(p_ChiTietSach(i).MaSach, p_ChiTietSach(i).SoLuong);
        END LOOP;
    END IF;

    -- Thêm chi tiết hóa đơn khoá học vào bảng ChiTietHoaDon nếu có
    IF p_ChiTietKhoaHoc IS NOT NULL THEN
        FOR i IN 1..p_ChiTietKhoaHoc.count LOOP
            INSERT INTO ChiTietHoaDon (MaKhoaHoc, MaHoaDon)
            VALUES (p_ChiTietKhoaHoc(i).MaKhoaHoc, p_MaHoaDon);
        END LOOP;
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Hóa đơn đã được cập nhật thành công và số tiền đã được kiểm tra.');
EXCEPTION
    WHEN OTHERS THEN
        -- Rollback transaction nếu có lỗi
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Lỗi: ' || SQLERRM);
END CapNhatHoaDon;
/
--test
DECLARE
    -- Khai báo các biến đầu vào
    v_MaHoaDon HoaDon.MaHoaDon%TYPE := 'HD001';
    v_SoTien HoaDon.SoTien%TYPE := 10600000;
    v_MaHocVien HoaDon.MaHocVien%TYPE := 'HV002';
    v_MaNhanVien HoaDon.MaNhanVien%TYPE := 'NV002';

    -- Khai báo danh sách chi tiết sách và chi tiết khoá học
    v_ChiTietSach HoaDonSachList := HoaDonSachList();
    v_ChiTietKhoaHoc ChiTietHoaDonList := ChiTietHoaDonList();

BEGIN
    -- Thêm một chi tiết sách vào danh sách chi tiết sách
    v_ChiTietSach.EXTEND;
    v_ChiTietSach(1) := HoaDonSachType(2, 2); -- Giả sử mã sách là 102 và số lượng là 3
    -- Thêm một chi tiết khoá học vào danh sách chi tiết khoá học
    v_ChiTietKhoaHoc.EXTEND;
    v_ChiTietKhoaHoc(1) := ChiTietHoaDonType('KH002'); -- Giả sử mã khoá học là 'KH002'

    -- Gọi procedure CapNhatHoaDon với các tham số đã được khai báo
    CapNhatHoaDon(v_MaHoaDon, v_SoTien, v_MaHocVien, v_MaNhanVien, v_ChiTietSach, v_ChiTietKhoaHoc);
    
    -- In ra thông báo sau khi thực thi procedure thành công
    DBMS_OUTPUT.PUT_LINE('Procedure đã được thực thi thành công.');
EXCEPTION
    WHEN OTHERS THEN
        -- Xử lý nếu có lỗi xảy ra
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END;
/