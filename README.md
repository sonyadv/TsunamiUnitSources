# 資料庫速算系統
> 透過初始波高的係數矩陣，進行資料庫疊加的海嘯速算

## create_coef.m
1. set the diameter and initial elevation of the single unit source
    > **need to be same as database**
2. get initial surface
3. calculat the coefficient matrix
4. print the matrix as `(event)memo.csv`

## superposition.m
1. parameter setting
    * event/case name
    * grid size (a.k.a. layer number)
    * run time, same as `comcot.ctl` setting
2. initialize
    * load bathmetry files
    * initial martix setting
    * load `(event)memo.csv`
3. linear superposition
    * times the unit sourse propagation with coefficient
    * add up each unit sources' result
    * record arrival time and Maximum wave height
4. Get Result and save '.csv'

## plot_all.m
1. parameter setting and initialize
     > same as `superposition.m`
2. load `.csv` and plot
