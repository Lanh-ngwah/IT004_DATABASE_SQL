-------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
------------------------------------------BUOI TH IN CLASS 04 -----------------------------------------------------------
-- Bai tap 01: 
--19. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua? 
SELECT COUNT (SOHD) AS 'SLHD'
FROM CTHD
WHERE SOHD IN (
            SELECT SOHD
			FROM CTHD
			WHERE SOHD NOT IN (
			       SELECT SOHD
				   FROM HOADON
				   WHERE MAKH IN (
				          SELECT MAKH
						  FROM KHACHHANG)))

--20. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006. 
SELECT COUNT (DISTINCT MASP) AS 'SL SP KHAC' 
FROM CTHD
WHERE MASP IN( 
      SELECT DISTINCT MASP
	  FROM HOADON
	  WHERE YEAR(NGHD) = 2006)
	  

--21. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu? 
SELECT MAX(TRIGIA) AS 'MAX' , MIN(TRIGIA) AS 'MIN'
FROM HOADON

--22. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu? 
SELECT AVG(TRIGIA) AS 'TRIGIA TB'
FROM HOADON
WHERE YEAR(NGHD)= 2006

--23. Tính doanh thu bán hàng trong năm 2006. 
SELECT SUM(TRIGIA) AS'DOANH THU '
FROM HOADON
WHERE YEAR(NGHD)=2006

--24. Tìm số hóa đơn có trị giá cao nhất trong năm 2006. 
SELECT SOHD 
FROM HOADON
WHERE TRIGIA IN (
      SELECT MAX(TRIGIA)
	  FROM HOADON
	  WHERE YEAR(NGHD)=2006)

--25. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006. 
SELECT HOTEN
FROM KHACHHANG
WHERE MAKH IN (
        SELECT MAKH
		FROM HOADON
		WHERE TRIGIA IN (
		        SELECT MAX(TRIGIA)
	            FROM HOADON
	            WHERE YEAR(NGHD)=2006))

--26. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG 
ORDER BY DOANHSO DESC

--27. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất. 
SELECT MASP, TENSP 
FROM SANPHAM
WHERE GIA IN(
	    SELECT DISTINCT TOP 3 GIA FROM SANPHAM
	    ORDER BY GIA DESC)

--28. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm). 
SELECT MASP, TENSP 
FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' AND GIA IN(
	    SELECT DISTINCT TOP 3 GIA 
		FROM SANPHAM
	    ORDER BY GIA DESC)

--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất). 
SELECT MASP, TENSP 
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA IN(
	    SELECT DISTINCT TOP 3 GIA 
		FROM SANPHAM
		WHERE NUOCSX = 'Trung Quoc'
	    ORDER BY GIA DESC)

--30. * In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
SELECT MAKH, HOTEN, DOANHSO 
FROM KHACHHANG 
WHERE DOANHSO IN (
           SELECT TOP 3 DOANHSO
		   FROM KHACHHANG 
		   ORDER BY DOANHSO DESC)
ORDER BY DOANHSO DESC
-- Bai tap 02: 
--19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất. 
SELECT MAKHOA, TENKHOA 
FROM KHOA
WHERE NGTLAP IN (
             SELECT TOP 1 NGTLAP
			 FROM KHOA
			 ORDER BY NGTLAP ASC)

--20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”. 
SELECT COUNT (MAGV) AS 'SL GIAO VIEN'
FROM GIAOVIEN
WHERE HOCHAM IN ('GS', 'PGS')

--21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa. 
SELECT COUNT (MAGV) AS 'SL GIAO VIEN' , MAKHOA
FROM GIAOVIEN
WHERE HOCVI IN ('CN', 'KS', 'ThS', 'TS', 'PTS')
GROUP BY MAKHOA

--22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt). 

--23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học. 
SELECT MAGV, HOTEN 
FROM GIAOVIEN
WHERE MAGV IN (
           SELECT MAGVCN
		   FROM LOP)
	  AND MAGV IN (
	       SELECT LOP.MAGVCN
		   FROM  LOP
		   WHERE LOP.MALOP IN (SELECT GIANGDAY.MALOP 
									FROM GIANGDAY 
									WHERE GIANGDAY.MALOP = LOP.MALOP
									GROUP BY MAGV, GIANGDAY.MALOP
									HAVING COUNT(MAGV) > 1))
--24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất. 
SELECT HO + TEN AS HOTEN
FROM HOCVIEN
WHERE MAHV IN(
       SELECT TRGLOP
	   FROM LOP
	   WHERE SISO IN (
	            SELECT TOP 1 SISO
				FROM LOP
				ORDER BY SISO DESC))
   
--25. * Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi). 
SELECT HO, TEN
FROM HOCVIEN
WHERE MAHV IN (
                SELECT TRGLOP
				FROM LOP
				WHERE TRGLOP IN (
				                SELECT MAHV
								FROM KETQUATHI
								WHERE KQUA = 'Khong Dat'
								GROUP BY MAHV
								HAVING COUNT(DISTINCT MAMH) > 3))
-- Bai tap 03:
--31. Tính tổng số sản phẩm do “Trung Quoc” sản xuất. 
SELECT COUNT(MASP) AS ' TONG SP'
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

--32. Tính tổng số sản phẩm của từng nước sản xuất. 
SELECT COUNT(MASP) AS ' TONG SP', NUOCSX
FROM SANPHAM
GROUP BY NUOCSX

--33. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm. 
SELECT MAX(GIA) AS 'MAX', MIN (GIA) AS 'MIN' , AVG(GIA) AS 'AVG', NUOCSX
FROM SANPHAM
GROUP BY NUOCSX

--34. Tính doanh thu bán hàng mỗi ngày. 
SELECT NGHD, SUM(TRIGIA) AS 'DOANH THU'
FROM HOADON
GROUP BY NGHD

--35. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006. 
SELECT SUM(SL) AS 'SO LUONG', MASP
FROM CTHD
WHERE MASP IN (
       SELECT MASP
	   FROM HOADON
	   WHERE YEAR(NGHD) = 2006 AND MONTH(NGHD)= 10)
GROUP BY MASP

--36. Tính doanh thu bán hàng của từng tháng trong năm 2006. 
SELECT SUM(TRIGIA) AS 'DOANH THU', MONTH(NGHD) AS 'THANG'
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)

--37. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau. 
SELECT SOHD 
FROM CTHD
GROUP BY SOHD 
HAVING COUNT(DISTINCT MASP) >= 4

--38. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau). 
SELECT SOHD 
FROM CTHD
WHERE MASP IN (
       SELECT MASP
	   FROM SANPHAM
	   WHERE NUOCSX = 'Viet Nam')
GROUP BY SOHD 
HAVING COUNT(DISTINCT MASP) = 3

--39. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT MAKH, HOTEN
FROM KHACHHANG
WHERE MAKH IN(
         SELECT TOP 1 MAKH
		 FROM HOADON
		 GROUP BY MAKH
		 ORDER BY COUNT(DISTINCT SOHD) DESC)
		 
--40. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ? 
SELECT TOP 1 MONTH(NGHD) AS 'THANG DOANH SO MAX'
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC

--41. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP IN (
        SELECT TOP 1 MASP
		FROM CTHD
		WHERE SOHD IN (
		          SELECT SOHD
				  FROM HOADON
				  WHERE YEAR(NGHD) = 2006)
		GROUP BY MASP
		ORDER BY SUM(SL) ASC)

--42. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP IN(
      SELECT MAX(GIA) , NUOCSX
	  FROM SANPHAM
	  GROUP BY NUOCSX)
GROUP BY NUOCSX
ORDER BY MAX(GIA) DESC

--43. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau. 
SELECT NUOCSX 
FROM SANPHAM 
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) > 3
--44. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
-- Bai tap 04:
--26. Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất. 
SELECT MAHV, HO + TEN AS HOTEN
FROM HOCVIEN
WHERE MAHV IN (SELECT MAHV 
				FROM KETQUATHI
				WHERE DIEM >= 9 AND DIEM <= 10 
				GROUP BY MAHV
				HAVING COUNT(*) = (SELECT TOP 1 COUNT(*)
									FROM KETQUATHI
									WHERE DIEM >= 9 
										AND DIEM <= 10 
									GROUP BY MAHV
									ORDER BY COUNT(*) DESC))
--27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất. 
SELECT MAHV, HO + TEN AS HOTEN, MALOP
FROM HOCVIEN
WHERE MAHV IN (
                SELECT MAHV 
				FROM KETQUATHI
				WHERE DIEM >= 9 AND DIEM <= 10 
				GROUP BY MAHV
				HAVING COUNT(*) = (SELECT TOP 1 COUNT(*)
									FROM KETQUATHI
									WHERE DIEM >= 9 AND DIEM <= 10 
									GROUP BY MAHV
									ORDER BY COUNT(*) DESC))
GROUP BY MALOP
--28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp. 
SELECT HOCKY, NAM, MAGV, COUNT(MAMH) SOMH, COUNT(MALOP) SOLOP 
FROM GIANGDAY
GROUP BY HOCKY, NAM, MAGV

--29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất. 
SELECT  GV.MAGV, GV.HOTEN, GD.HOCKY, GD.NAM,COUNT(*) AS 'SoLopGiangDay'
FROM GIAOVIEN GV, GIANGDAY GD
WHERE GV.MAGV = GD.MAGV
GROUP BY GV.MAGV, GV.HOTEN, GD.HOCKY, GD.NAM
HAVING  COUNT(*) > = (
        SELECT MAX(SoLopGiangDay)
        FROM (
            SELECT MAGV, COUNT(*) AS SoLopGiangDay
            FROM GIANGDAY
            WHERE HOCKY = GD.HOCKY AND NAM = GD.NAM
            GROUP BY MAGV
        ) AS MaxSoLop
    )
ORDER BY GD.HOCKY, GD.NAM
--30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất. 
--31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1). 
--32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng). 
--33. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi thứ 1). 
--34. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi sau cùng). 
--35. ** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).