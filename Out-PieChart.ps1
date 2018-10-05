Function Out-PieChart {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [psobject] $inputObject,

        [Parameter()]
        [string] $PieChartTitle,

        [Parameter()]
        [int] $ChartWidth = 800,

        [Parameter()]
        [int] $ChartHeight = 400,

        [Parameter()]
        [string[]] $NameProperty,

        [Parameter()]
        [string] $ValueProperty,

        [Parameter()]
        [switch] $Pie3D,

        [Parameter()]
        [switch] $DisplayToScreen,

        [Parameter()]
        [ValidateScript( {Test-Path -Path $_})]
        [string] $saveImage = 'c:\tmp\testpie.png'
    )
    begin {
        Add-Type -AssemblyName System.Windows.Forms.DataVisualization

        # Frame
        $Chart = [System.Windows.Forms.DataVisualization.Charting.Chart]@{
            Width       = $ChartWidth
            Height      = $ChartHeight
            BackColor   = 'White'
            BorderColor = 'Black'
        }

        # Body
        $null = $Chart.Titles.Add($PieChartTitle)
        $Chart.Titles[0].Font = "segoeuilight,20pt"
        $Chart.Titles[0].Alignment = "TopCenter"

        # Create Chart Area
        $ChartArea = [System.Windows.Forms.DataVisualization.Charting.ChartArea]
        $ChartArea.Area3DStyle.Enable3D = $Pie3D.ToBool()
        $ChartArea.Area3DStyle.Inclination = 50
        $Chart.ChartAreas.Add($ChartArea)

        # Define Chart Area
        $null = $Chart.Series.Add("Data")
        $Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie

        # Chart style
        $Chart.Series["Data"]["PieLabelStyle"] = "Outside"
        $Chart.Series["Data"]["PieLineColor"] = "Black"
        $Chart.Series["Data"]["PieDrawingStyle"] = "Concave"


        $chart.Series["Data"].IsValueShownAsLabel = $true
        $chart.series["Data"].Label = "#PERCENT\n#VALX"

        # Set ArrayList
        $XColumn = [System.Collections.ArrayList]::new()
        $yColumn = [System.Collections.ArrayList]::new()
    }
    process {
        if (-not $valueProperty) {
            $numericProperties = foreach ($property in $inputObject.PSObject.Properties) {
                if ([Double]::TryParse($property.Value, [Ref]$null)) {
                    $property.Name
                }
            }
            if (@($numericProperties).Count -eq 1) {
                $valueProperty = $numericProperties
            }
            else {
                throw 'Unable to automatically determine properties to graph'
            }
        }

        if (-not $LabelProperty) {
            if ($inputObject.PSObject.Properties.Count -eq 2) {
                $LabelProperty = $inputObject.Properties.Name -ne $valueProperty
            }
            elseif ($inputObject.PSObject.Properties.Item('Name')) {
                $LabelProperty = 'Name'
            }
            else {
                throw 'Cannot convert Data'
            }
        }

        # Bind chart columns
        $null = $yColumn.Add($InputObject.$valueProperty)
        $null = $xColumn.Add($inputObject.$LabelProperty)
    }
    end {
        # Add data to chart
        $Chart.Series["Data"].Points.DataBindXY($xColumn, $yColumn)

        # Save file
        if ($psboundparameters.ContainsKey('SaveImage')) {
            if (-not (Test-Path (Split-Path $SaveImage -Parent))) {
                $SaveImage = $pscmdlet.GetUnresolvedProviderPathFromPSPath($SaveImage)
                $Chart.SaveImage($saveImage, "png")
            }
            else {
                throw "Invalid path"
            }
        }

        # Display Chart to screen
        if ($DisplayToScreen.ToBool()) {
            $Form = [Windows.Forms.Form]@{
                Width           = 800
                Height          = 450
                AutoSize        = $true
                FormBorderStyle = "FixedDialog"
                MaximizeBox     = $false
                MinimizeBox     = $false
                KeyPreview      = $true

            }
            $Form.controls.add($Chart)
            $Chart.Anchor = 'Bottom, Right, Top, Left'

            $Form.Add_KeyDown({
                if ($_.KeyCode -eq "Escape") { $Form.Close() }
            })
            $Form.Add_Shown( {$Form.Activate()})
            $Form.ShowDialog() | Out-Null
        }
    }
}
