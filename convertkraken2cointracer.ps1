#########################################################
## convertkraken2cointracer.ps1
## Converts Kraken Exports into Cointracer Import Format
## Only BTC-EUR  ETH-EUR   LTC-EUR   Trades  
## Only NON Margin Trades
##
## Usage:   1. Edit your input and output files in Line 15-20  
##          2. Run the script in windows powershell 
##
## Licence: Mozilla Public License 2.0
## Git:     https://github.com/perling1/convertkraken2cointracer


#########################################################                        
# Infile, Kraken export
[String]$infile="C:\temp\kraken_trades.csv"

# Outfile created for Cointracer
[String]$outfolder="C:\temp\"
[String]$outfilename="kraken_trades_cointracer.csv"
#########################################################

function readcsv() {
	param([String]$pfile = "", [System.Collections.ArrayList]$parray )

$rc1 = New-Object PSCustomObject
$counter=0
Import-Csv $pfile -Encoding UTF8 |  ForEach-Object {
    $counter++
	
    #Read DATE "yyyy-MM-dd HH:mm:ss" used by kraken exports, cut off milisec
    try { $timetry=$_.time.substring(0, 19)
          $parsedtime=[datetime]::ParseExact($timetry, "yyyy-MM-dd HH:mm:ss", $null) }
    catch {                      
        write ("Date not readable! "+ $_.time +" Row:" + $counter + " " + $pfile)
        $parsedtime =[datetime]::ParseExact("1900-01-01 00:00:00", "yyyy-MM-dd HH:mm:ss", $null) }
    
    #tiny decimal numbers need the decimal type instead of the double type
    try {
    if ( $_.fee -lt 0.01) { $sfee=[decimal]$_.fee;  }
    if ( $_.fee -ge 0.01) { $sfee=[double]$_.fee;   }
    if ( $_.cost -lt 0.01) { $sum=[decimal]$_.cost;  }
    if ( $_.cost -ge 0.01) { $sum=[double]$_.cost;  }
    } 
    catch {("fee or cost not double not decimal "+ $_.fee +" Row:" + $counter ) 
    }

   #Read CSV Fields into PSObject and add to arraylist
   foreach ($property in $_.PSObject.Properties) 
   {
    $rc1 = [PSCustomObject]@{
    td=[datetime]$parsedtime
    txid = $_.txid
    ordertxid = $_.ordertxid
    pair = $_.pair
    type = $_.type
    ordertype = $_.ordertype
    price = [double]$_.price
    cost=$sum              
    fee =$sfee
    vol = [decimal]$_.vol
    margin = [double]$_.margin
    misc = $_.misc
    ledgers = $_.ledgers
    }
   }
   $ArrayOperation = $parray.Add($rc1) }  
 }

#Output in console
Write-Host "Converting Kraken Export to Contracer Format"
Write-Host "Margin Positions will be ignored in process "
Write-Host "-------------------------------------------"
 
[System.Collections.ArrayList]$basis = New-Object System.Collections.ArrayList
readcsv $infile $basis

#Output Generator for Cointracer
$nl = [Environment]::NewLine
$outtext="Reference;DateTime;Info;SourcePlatform;SourceCurrency;SourceAmount;TargetPlatform;TargetCurrency;TargetAmount;FeeCurrency;FeeAmount"+$nl
$basis | ForEach-Object {

#only btc & ETH & LTC  
if ( $_.pair -match "XXBTZEUR") { $coin="BTC" }
if ( $_.pair -match "XETHZEUR") { $coin="ETH" }
if ( $_.pair -match "XLTCZEUR") { $coin="LTC" }

#only btc & ETH & LTC  
if ( $_.pair -match "XXBTZEUR" -Or $_.pair -match "XETHZEUR" -Or $_.pair -match "XLTCZEUR") {

#NON Margin Trades
 if ( $_.margin -eq "0" ) {
     $line=$_.txid +" " +$_.td.ToString() + " " + $_.pair  + " " + $_.type + " " + $_.vol + " " +$_.price + "€ " +$_.cost + "€ " + $_.fee + " " + $_.margin + " " + $_.misc +$nl
     #output for cointracer
     if ($_.type -eq "buy") {
       $line=$_.txid +";" +$_.td.ToString() + ";" + $_.pair  + " " + $_.type + ";" + "kraken" + ";" + "EUR" + ";" +$_.cost + ";" + "kraken" + ";" +$coin+ ";"+ $_.vol + ";" + "EUR" + ";" + $_.fee +$nl
       }
     if ($_.type -eq "sell") {
       $line=$_.txid +";" +$_.td.ToString() + ";" + $_.pair  + " " + $_.type + ";" + "kraken" + ";" + $coin + ";" +$_.vol + ";" + "kraken" + ";" +"EUR"+ ";"+ $_.cost + ";" + "EUR" + ";" + $_.fee +$nl
       }
   $outtext+=$line
 }
}
}

#Save outfile  - Remove old if existent
$FullPath = $outfolder+$outfilename
If (Test-Path $FullPath) { Remove-Item $FullPath }
New-Item -path $outfolder -name $outfilename -value $outtext | Out-Null

#Output in console
Write-Host "Infile= $infile"
Write-Host "Read="+(Get-Content $infile).Length+" Lines"
Write-Host "Outfile= $FullPath"
Write-Host "Wrote="+(Get-Content $FullPath).Length+" Lines"
