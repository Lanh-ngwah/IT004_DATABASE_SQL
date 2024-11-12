----------------------------------------------------------------------------------------------
-----------------------------------LAB 04-----------------------------------------------------
-- 76. Liệt kê top 3 chuyên gia có nhiều kỹ năng nhất và số lượng kỹ năng của họ.
SELECT TOP 3  CG.MaChuyenGia,CG.HoTen , COUNT(MaKyNang) AS 'SL KY NANG'
FROM ChuyenGia_KyNang CGKN, ChuyenGia CG
WHERE CGKN.MaChuyenGia= CG.MaChuyenGia
GROUP BY CG.MaChuyenGia, CG.HoTen
ORDER BY COUNT(MaKyNang) DESC

-- 77. Tìm các cặp chuyên gia có cùng chuyên ngành và số năm kinh nghiệm chênh lệch không quá 2 năm.
SELECT A.HoTen AS 'ChuyenGia1', B.HoTen AS 'ChuyenGia2'
FROM ChuyenGia A JOIN ChuyenGia B 
ON A.ChuyenNganh = B.ChuyenNganh AND A.MaChuyenGia < B.MaChuyenGia
WHERE ABS(A.NamKinhNghiem - B.NamKinhNghiem) <= 2;


-- 78. Hiển thị tên công ty, số lượng dự án và tổng số năm kinh nghiệm của các chuyên gia tham gia dự án của công ty đó.
SELECT CT.TenCongTy, COUNT(DISTINCT DA.MaDuAn) AS 'So Luong Du An',SUM(CG.NamKinhNghiem) AS 'Tong Nam Kinh Nghiem'
FROM CongTy CT
LEFT JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
LEFT JOIN ChuyenGia_DuAn CG_DA ON DA.MaDuAn = CG_DA.MaDuAn
LEFT JOIN ChuyenGia CG ON CG_DA.MaChuyenGia = CG.MaChuyenGia
GROUP BY CT.MaCongTy, CT.TenCongTy

-- 79. Tìm các chuyên gia có ít nhất một kỹ năng cấp độ 5 nhưng không có kỹ năng nào dưới cấp độ 3.
SELECT DISTINCT CG.HoTen
FROM ChuyenGia CG JOIN ChuyenGia_KyNang CG_KN 
ON CG.MaChuyenGia = CG_KN.MaChuyenGia
WHERE CG.MaChuyenGia IN (
              SELECT MaChuyenGia
              FROM ChuyenGia_KyNang
              WHERE CapDo = 5)
AND CG.MaChuyenGia NOT IN (
              SELECT MaChuyenGia
              FROM ChuyenGia_KyNang
              WHERE CapDo < 3)


-- 80. Liệt kê các chuyên gia và số lượng dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào.
SELECT CG.HoTen, COUNT(CG_DA.MaDuAn) AS 'So luong du an'
FROM ChuyenGia CG JOIN ChuyenGia_DuAn CG_DA
ON CG.MaChuyenGia = CG_DA.MaChuyenGia
GROUP BY CG.HoTen, CG.MaChuyenGia

-- 81*. Tìm chuyên gia có kỹ năng ở cấp độ cao nhất trong mỗi loại kỹ năng.
SELECT CG.HoTen, KN.LoaiKyNang, CG_KN.CapDo
FROM ChuyenGia CG LEFT JOIN ChuyenGia_KyNang CG_KN
ON CG.MaChuyenGia= CG_KN.MaChuyenGia
JOIN KyNang KN
ON KN.MaKyNang = CG_KN.MaKyNang
GROUP BY KN.LoaiKyNang
ORDER BY MAX(CG_KN.CapDo) DESC

WITH ChuyenNganhCount AS (
    SELECT ChuyenNganh, COUNT(*) AS SoLuong
    FROM ChuyenGia
    GROUP BY ChuyenNganh
),
TotalCount AS (
    SELECT COUNT(*) AS TongSo
    FROM ChuyenGia
)
SELECT 
    ChuyenNganhCount.ChuyenNganh,
    ChuyenNganhCount.SoLuong,
    CAST(ChuyenNganhCount.SoLuong AS FLOAT) / TotalCount.TongSo * 100 AS PhanTram
FROM ChuyenNganhCount, TotalCount;

-- 83. Tìm các cặp kỹ năng thường xuất hiện cùng nhau nhất trong hồ sơ của các chuyên gia.
WITH B1 AS (
    SELECT CG_KN1.MaKyNang AS KN1, CG_KN2.MaKyNang AS KN2, COUNT(*) AS KQ
    FROM ChuyenGia_KyNang CG_KN1 JOIN ChuyenGia_KyNang CG_KN2
	ON CG_KN1.MaChuyenGia = CG_KN2.MaChuyenGia AND CG_KN1.MaKyNang < CG_KN2.MaKyNang
    GROUP BY CG_KN1.MaKyNang, CG_KN2.MaKyNang
)
SELECT TOP 5 K1.TenKyNang AS KN1,  K2.TenKyNang AS KN2, B1.KQ
FROM B1
JOIN KyNang K1 ON B1.KN1 = K1.MaKyNang
JOIN KyNang K2 ON B1.KN2 = K2.MaKyNang
ORDER BY B1.KQ DESC

-- 84. Tính số ngày trung bình giữa ngày bắt đầu và ngày kết thúc của các dự án cho mỗi công ty.
SELECT CT.TenCongTy, AVG(DATEDIFF(day, DA.NgayBatDau, DA.NgayKetThuc)) AS 'Trung Binh So Ngay'
FROM CongTy CT
JOIN DuAn DA ON CT.MaCongTy = DA.MaCongTy
GROUP BY CT.MaCongTy, CT.TenCongTy;

-- 85. Tìm chuyên gia có sự kết hợp độc đáo nhất của các kỹ năng (kỹ năng mà chỉ họ có).
WITH UniqueSkills AS (
    SELECT CG.MaChuyenGia, CG.HoTen, COUNT(*) AS SoLuongKyNangDocDao
    FROM ChuyenGia CG
    JOIN ChuyenGia_KyNang CG_KN  
	ON CG.MaChuyenGia = CG_KN.MaChuyenGia
    WHERE CG_KN.MaKyNang NOT IN (
        SELECT DISTINCT MaKyNang
        FROM ChuyenGia_KyNang
        WHERE MaChuyenGia != CG.MaChuyenGia
    )
    GROUP BY CG.MaChuyenGia, CG.HoTen
)
SELECT TOP 1 HoTen, SoLuongKyNangDocDao
FROM UniqueSkills
ORDER BY SoLuongKyNangDocDao DESC;

-- 86. Tạo một bảng xếp hạng các chuyên gia dựa trên số lượng dự án và tổng cấp độ kỹ năng.
WITH ProjectCount AS (
    SELECT MaChuyenGia, COUNT(*) AS SoLuongDuAn
    FROM ChuyenGia_DuAn
    GROUP BY MaChuyenGia
),
SkillLevelSum AS (
    SELECT MaChuyenGia, SUM(CapDo) AS TongCapDoKyNang
    FROM ChuyenGia_KyNang
    GROUP BY MaChuyenGia
)
SELECT 
    ChuyenGia.HoTen,
    COALESCE(ProjectCount.SoLuongDuAn, 0) AS SoLuongDuAn,
    COALESCE(SkillLevelSum.TongCapDoKyNang, 0) AS TongCapDoKyNang,
    RANK() OVER (ORDER BY COALESCE(ProjectCount.SoLuongDuAn, 0) + COALESCE(SkillLevelSum.TongCapDoKyNang, 0) DESC) AS XepHang
FROM ChuyenGia
LEFT JOIN ProjectCount ON ChuyenGia.MaChuyenGia = ProjectCount.MaChuyenGia
LEFT JOIN SkillLevelSum ON ChuyenGia.MaChuyenGia = SkillLevelSum.MaChuyenGia;

-- 87. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
WITH DuAnChuyenNganh AS (
    SELECT 
        DuAn.MaDuAn,
        DuAn.TenDuAn,
        COUNT(DISTINCT ChuyenGia.ChuyenNganh) AS SoLuongChuyenNganh
    FROM DuAn
    JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
    JOIN ChuyenGia ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
    GROUP BY DuAn.MaDuAn, DuAn.TenDuAn
),
TotalChuyenNganh AS (
    SELECT COUNT(DISTINCT ChuyenNganh) AS TongSoChuyenNganh
    FROM ChuyenGia
)
SELECT DuAnChuyenNganh.TenDuAn
FROM DuAnChuyenNganh, TotalChuyenNganh
WHERE DuAnChuyenNganh.SoLuongChuyenNganh = TotalChuyenNganh.TongSoChuyenNganh;

-- 88. Tính tỷ lệ thành công của mỗi công ty dựa trên số dự án hoàn thành so với tổng số dự án.
WITH DuAnStatus AS (
    SELECT 
        CongTy.MaCongTy,
        CongTy.TenCongTy,
        SUM(CASE WHEN DuAn.TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) AS SoDuAnHoanThanh,
        COUNT(*) AS TongSoDuAn
    FROM CongTy
    LEFT JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
    GROUP BY CongTy.MaCongTy, CongTy.TenCongTy
)
SELECT 
    TenCongTy,
    SoDuAnHoanThanh,
    TongSoDuAn,
    CASE 
        WHEN TongSoDuAn > 0 THEN CAST(SoDuAnHoanThanh AS FLOAT) / TongSoDuAn * 100 
        ELSE 0 
    END AS TyLeThanhCong
FROM DuAnStatus;

-- 89. Tìm các chuyên gia có kỹ năng "bù trừ" nhau (một người giỏi kỹ năng A nhưng yếu kỹ năng B, người kia ngược lại).