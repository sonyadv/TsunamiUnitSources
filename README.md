# Auto Generate Unit-Sources Database
> 自動生成指定範圍、指定大小的點源海嘯資料庫

## comcot_generate.m
1. 

## database_generate.m
1. 設定參數
  * 要生成單元海嘯的範圍
  * 單元海嘯大小（以網格點為單位，網格大小取決於地形圖精度）
  * 初始波高
2. 讀入初始資料
  * 地形資料
3. 生成初始波高圖
  * 根據設定之參數生成點元海嘯
  * 以 COMCOT 之格式（15 x n）輸出 `ini.cct` 檔案
5. 模擬
  * 使用 COMCOT 模擬海嘯傳遞的過程
  * 將結果整理至資料夾
