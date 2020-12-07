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



###########################################################################
#Parse coin names
$coin="NONE"                #name of 1st coin
$targetcoin="NONE"          #name of 2nd coin  
$pairmid_char_cnt=[int](0)  #position in string where frist coin name ends
$tc=""                      #to check (part of the string given in exports)  

#parse 1st coin name
$tc=$_.pair.substring(0, 5)
$pairmid_char_cnt=[int](5)
if ( $tc -match "SUSHI" )  { $coin="SUSHI" }
if ( $tc -match "STRAX"  ) { $coin="STRAX" }

if ($coin -eq "NONE") {
$tc=$_.pair.substring(0, 4)
$pairmid_char_cnt=[int](4)

if ( $tc -match "XXBT"  ) { $coin="BTC" }
if ( $tc -match "XETH"  ) { $coin="ETH" }
if ( $tc -match "XLTC"  ) { $coin="LTC" }
if ( $tc -match "XXMR"  ) { $coin="XMR" }
if ( $tc -match "XLMZ"  ) { $coin="LMZ" }
if ( $tc -match "XXRP"  ) { $coin="XRP" }
if ( $tc -match "ZEUR"  ) { $coin="EUR" }
if ( $tc -match "ZUSD"  ) { $coin="USD" }
if ( $tc -match "XZEC"  ) { $coin="ZEC" }

if ( $tc -match "ATOM"  ) { $coin="ATOM" }
if ( $tc -match "IOTA"  ) { $coin="IOTA" }
if ( $tc -match "USDT"  ) { $coin="USDT" }
if ( $tc -match "USDC"  ) { $coin="USDC" }
if ( $tc -match "WAVE"  ) { $coin="WAVE" }
if ( $tc -match "LINK"  ) { $coin="LINK" }
if ( $tc -match "LOOM"  ) { $coin="LOOM" }
if ( $tc -match "AAVE"  ) { $coin="AAVE" }
if ( $tc -match "AION"  ) { $coin="AION" }
if ( $tc -match "ALGO"  ) { $coin="ALGO" }
if ( $tc -match "SCRT"  ) { $coin="SCRT" }
if ( $tc -match "RUNE"  ) { $coin="RUNE" }
if ( $tc -match "COMP"  ) { $coin="COMP" }
if ( $tc -match "DASH"  ) { $coin="DASH" }
}                                  

if ($coin -eq "NONE") {
$tc=$_.pair.substring(0, 3)
$pairmid_char_cnt=[int](3)
if ( $tc -match "EUR"  ) { $coin=$tc }
if ( $tc -match "USD"  ) { $coin=$tc }
if ( $tc -match "BTC"  ) { $coin=$tc }
if ( $tc -match "BCH"  ) { $coin=$tc }
if ( $tc -match "ETH"  ) { $coin=$tc }
if ( $tc -match "BNB"  ) { $coin=$tc }
if ( $tc -match "LTC"  ) { $coin=$tc }
if ( $tc -match "XRP"  ) { $coin=$tc }
if ( $tc -match "ETC"  ) { $coin=$tc }
if ( $tc -match "XMR"  ) { $coin=$tc }
if ( $tc -match "XLM"  ) { $coin=$tc }
if ( $tc -match "ZEC"  ) { $coin=$tc }
if ( $tc -match "EOS"  ) { $coin=$tc }
if ( $tc -match "ADA"  ) { $coin=$tc }
if ( $tc -match "YFI"  ) { $coin=$tc }
if ( $tc -match "UNI"  ) { $coin=$tc }
if ( $tc -match "MKR"  ) { $coin=$tc }
if ( $tc -match "DOT"  ) { $coin=$tc }
if ( $tc -match "DAI"  ) { $coin=$tc }
if ( $tc -match "TRX"  ) { $coin=$tc }
if ( $tc -match "VET"  ) { $coin=$tc }
if ( $tc -match "XEM"  ) { $coin=$tc }
if ( $tc -match "XTZ"  ) { $coin=$tc }
if ( $tc -match "ZEC"  ) { $coin=$tc }
if ( $tc -match "ZRX"  ) { $coin=$tc }
if ( $tc -match "OMG"  ) { $coin=$tc }
if ( $tc -match "SOL"  ) { $coin=$tc }
if ( $tc -match "SNX"  ) { $coin=$tc }
if ( $tc -match "CRV"  ) { $coin=$tc }
if ( $tc -match "FIL"  ) { $coin=$tc }
if ( $tc -match "BAL"  ) { $coin=$tc }
if ( $tc -match "UNI"  ) { $coin=$tc }
}

#parse 2nd coin name
$len=[int]($_.pair.length)

$tc=$_.pair.substring($pairmid_char_cnt, ($_.pair.length-$pairmid_char_cnt))
if ( $tc -match "SUSHI" )  { $targetcoin="SUSHI" }
if ( $tc -match "STRAX"  ) { $targetcoin="STRAX" }

if ($targetcoin -eq "NONE") {
$tc=$_.pair.substring($pairmid_char_cnt, ($_.pair.length-$pairmid_char_cnt))
if ( $tc -match "XXBT"  ) { $targetcoin="BTC" }
if ( $tc -match "XETH"  ) { $targetcoin="ETH" }
if ( $tc -match "XLTC"  ) { $targetcoin="LTC" }
if ( $tc -match "XXMR"  ) { $targetcoin="XMR" }
if ( $tc -match "XLMZ"  ) { $targetcoin="LMZ" }
if ( $tc -match "XXRP"  ) { $targetcoin="XRP" }
if ( $tc -match "ZEUR"  ) { $targetcoin="EUR" }
if ( $tc -match "ZUSD"  ) { $targetcoin="USD" }
if ( $tc -match "XZEC"  ) { $targetcoin="ZEC" }

if ( $tc -match "ATOM"  ) { $targetcoin="ATOM" }
if ( $tc -match "IOTA"  ) { $targetcoin="IOTA" }
if ( $tc -match "USDT"  ) { $targetcoin="USDT" }
if ( $tc -match "USDC"  ) { $targetcoin="USDC" }
if ( $tc -match "WAVE"  ) { $targetcoin="WAVE" }
if ( $tc -match "LINK"  ) { $targetcoin="LINK" }
if ( $tc -match "LOOM"  ) { $targetcoin="LOOM" }
if ( $tc -match "AAVE"  ) { $targetcoin="AAVE" }
if ( $tc -match "AION"  ) { $targetcoin="AION" }
if ( $tc -match "ALGO"  ) { $targetcoin="ALGO" }
if ( $tc -match "SCRT"  ) { $targetcoin="SCRT" }
if ( $tc -match "RUNE"  ) { $targetcoin="RUNE" }
if ( $tc -match "COMP"  ) { $targetcoin="COMP" }
if ( $tc -match "DASH"  ) { $targetcoin="DASH" }
}                                  

if ($targetcoin -eq "NONE") {
$tc=$_.pair.substring($pairmid_char_cnt, ($_.pair.length-$pairmid_char_cnt))
if ( $tc -match "EUR"  ) { $targetcoin=$tc }
if ( $tc -match "USD"  ) { $targetcoin=$tc }
if ( $tc -match "BTC"  ) { $targetcoin=$tc }
if ( $tc -match "BCH"  ) { $targetcoin=$tc }
if ( $tc -match "ETH"  ) { $targetcoin=$tc }
if ( $tc -match "BNB"  ) { $targetcoin=$tc }
if ( $tc -match "LTC"  ) { $targetcoin=$tc }
if ( $tc -match "XRP"  ) { $targetcoin=$tc }
if ( $tc -match "ETC"  ) { $targetcoin=$tc }
if ( $tc -match "XMR"  ) { $targetcoin=$tc }
if ( $tc -match "XLM"  ) { $targetcoin=$tc }
if ( $tc -match "ZEC"  ) { $targetcoin=$tc }
if ( $tc -match "EOS"  ) { $targetcoin=$tc }
if ( $tc -match "ADA"  ) { $targetcoin=$tc }
if ( $tc -match "YFI"  ) { $targetcoin=$tc }
if ( $tc -match "UNI"  ) { $targetcoin=$tc }
if ( $tc -match "MKR"  ) { $targetcoin=$tc }
if ( $tc -match "DOT"  ) { $targetcoin=$tc }
if ( $tc -match "DAI"  ) { $targetcoin=$tc }
if ( $tc -match "TRX"  ) { $targetcoin=$tc }
if ( $tc -match "VET"  ) { $targetcoin=$tc }
if ( $tc -match "XEM"  ) { $targetcoin=$tc }
if ( $tc -match "XTZ"  ) { $targetcoin=$tc }
if ( $tc -match "ZEC"  ) { $targetcoin=$tc }
if ( $tc -match "ZRX"  ) { $targetcoin=$tc }
if ( $tc -match "OMG"  ) { $targetcoin=$tc }
if ( $tc -match "SOL"  ) { $targetcoin=$tc }
if ( $tc -match "SNX"  ) { $targetcoin=$tc }
if ( $tc -match "CRV"  ) { $targetcoin=$tc }
if ( $tc -match "FIL"  ) { $targetcoin=$tc }
if ( $tc -match "BAL"  ) { $targetcoin=$tc }
if ( $tc -match "UNI"  ) { $targetcoin=$tc }
}


#Other unknown Pairs, or Pairs against other currencies
if ( $coin -ne "NONE") {

#NON Margin Trades
 if ( $_.margin -eq "0" ) {
     $line=$_.txid +" " +$_.td.ToString() + " " + $_.pair  + " " + $_.type + " " + $_.vol + " " +$_.price + "€ " +$_.cost + "€ " + $_.fee + " " + $_.margin + " " + $_.misc +$nl
     #output for cointracer
     if ($_.type -eq "buy") {
       $line=$_.txid +";" +$_.td.ToString() + ";" + $_.pair  + " " + $_.type + ";" + "kraken" + ";" +$targetcoin+ ";" +$_.cost + ";" + "kraken" + ";" +$coin+ ";"+ $_.vol + ";" +$targetcoin+ ";" + $_.fee +$nl
       }
     if ($_.type -eq "sell") {
       $line=$_.txid +";" +$_.td.ToString() + ";" + $_.pair  + " " + $_.type + ";" + "kraken" + ";" + $coin + ";" +$_.vol + ";" + "kraken" + ";" +$targetcoin+ ";"+ $_.cost + ";" +$targetcoin+ ";" + $_.fee +$nl
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
