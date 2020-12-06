# convertkraken2cointracer
The script converts export files from kraken exchange into the cointracer format. Cointracer is a free software used to create tax reports for cryptocurrency trading. The convertion includes major coin pairs, see chapter supported pairs (bitcoin, ethereum, litecoin, link, uni, dash, xrp, dai, usdt, dot and more).
Yet it does not convert margin positions.

# Version
The script was tested on Win10 Powershell 5.1.

# Instructions
1. Open your powershell ISE
2. Open convertkraken2cointracer.ps1
3. Edit lines, that specify the infile and outfile
4. Run the script
5. Use the new outputfile as import in cointracer

# How to export your trades from kraken
1. Log into your kraken account
2. Go to Trading History
3. Export  your historic trades with all columns
4. Download the export file with historic trades to your computer

# Example kraken export 
"txid","ordertxid","pair","time","type","ordertype","price","cost","fee","vol","margin","misc","ledgers"
"45RRZM-MJNVR-6EP8","D7RETL-10IXJ-ZZYRYF","XXBTZEUR","2017-04-02 07:31:31.8234","buy","limit",7813.40000,625.07200,1.06262,0.02000000,312.53600,"","QPWERT-LOPF4N-KHC4EM,UZUT11-POZSCI-3R52G"

# Example converted file after script (import for cointracer)
Reference;DateTime;Info;SourcePlatform;SourceCurrency;SourceAmount;TargetPlatform;TargetCurrency;TargetAmount;FeeCurrency;FeeAmount
45RRZM-MJNVR-6EP8;02.04.2017 07:31:31;XXBTZEUR buy;kraken;EUR;77.42;kraken;BTC;0.01000000;EUR;0.20129

# Supported Coin Pairs
"XXBTZEUR" $coin="BTC" 
"XETHZEUR" $coin="ETH" 
"XLTCZEUR" $coin="LTC" 

"BCHEUR"   $coin="BCH" 
"UNIEUR"   $coin="UNI" 
"DASHEUR"  $coin="DASH"
"LINKEUR"  $coin="LINK"

"XXRPZEUR" $coin="XRP" 
"XXLMZEUR" $coin="XLM" 
"WAVESEUR" $coin="WAVES"
"DAIEUR"   $coin="DAI" 

"TRXEUR"   $coin="TRX" 
"OMGEUR"   $coin="OMG" 
"NANOEUR"  $coin="NANO"
"ANTEUR"   $coin="ANT" 

"EOSEUR"   $coin="EOS" 
"YFIEUR"   $coin="YFI" 
"XXMRZEUR" $coin="XMR" 
"XZECZEUR" $coin="ZEC" 

"ADAEUR"   $coin="ADA" 
"DOTEUR"   $coin="DOT" 
"XTZEUR"   $coin="XTZ" 

"FILEUR"   $coin="FIL" 
"CRVEUR"   $coin="CRV" 
"COMPEUR"  $coin="COMP"
"BALEUR"   $coin="BAL" 

"USDTEUR"  $coin="USDT"
"USDCEUR"  $coin="USDC"


# Link to cointracer software
https://www.cointracer.de/


