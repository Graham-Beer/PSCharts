# PSCharts

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
