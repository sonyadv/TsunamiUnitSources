# Auto Generate Unit-Sources Database
> 自動生成指定範圍、指定大小的點源海嘯資料庫

## comcot_generate.m
1. 打開 `sample.ctl`
2. 輸入震源機制解，並透過 scaling law 取得參數
3. 將參數填入，並生成 `comcot.ctl`
4. 使用 COMCOT 進行運算，得數值解

## database_generate.m
1. 設定參數
   * 要生成單元海嘯的範圍
   * 單元海嘯大小（以網格點為單位，網格大小取決於地形圖精度）
   * 初始波高
2. 初始化
   * 讀入地形資料
3. 生成初始波高圖
   * 根據設定之參數生成點元海嘯
   * 以 COMCOT 之格式（15 x n）輸出 `ini.cct` 檔案
4. 模擬
   * 使用 COMCOT 模擬海嘯傳遞的過程
   * 將結果整理至資料夾
