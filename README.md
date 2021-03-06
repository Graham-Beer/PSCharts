# PSCharts

## What is Out-PieChart?
Out-PieChart is a function to take data from the pipeline and create a pie chart. The function makes use of the .net assembly 'System.Windows.Forms.DataVisualization'. 

## Examples
### 3D pie chart
```powershell
Get-Process | 
    select -First 5 name, pm | 
    Out-PieChart -PieChartTitle "Top 5 Windows processes running" -DisplayToScreen -Pie3D
```

### standard pie chart
```powershell
Get-Process | 
     select -First 5 name, pm | 
     Out-PieChart -PieChartTitle "Top 5 Windows processes running" -DisplayToScreen
```

### Display pie chart to screen
use switch `-DisplayToScreen`

```powershell
Get-Process | 
     select -First 5 name, pm | 
     Out-PieChart -PieChartTitle "Top 5 Windows processes running" -DisplayToScreen
```

### Save pie chart
```powershell
Get-Process | 
    select -First 5 name, pm | 
    Out-PieChart -PieChartTitle "Top 5 Windows processes running" -saveImage 'C:\tmp\Win_Process.png'
```

## Pie Chart examples

### Standard Pie Chart
![](images/Win_Process.png)

### 3D Pie Chart
![](images/Win_Process-3D.png)
