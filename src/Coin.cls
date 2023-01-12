Class IntegratedML.Coin Extends %Library.Persistent
{

Property CoinDate As %String [ SqlColumnNumber = 2 ];

Property PriceOpen As %Double [ SqlColumnNumber = 3 ];

Property PriceHigh As %Double [ SqlColumnNumber = 4 ];

Property PriceLow As %Double [ SqlColumnNumber = 5 ];

Property PriceClose As %Double [ SqlColumnNumber = 6 ];

Property TradeVolume As %Double [ SqlColumnNumber = 7 ];

Property Prediction As %Double [ SqlColumnNumber = 8 ];

ClassMethod LoadData(path As %String = "/opt/irisapp/misc/CoinData.csv") As %Status
{
    set query = "LOAD DATA FROM FILE '" _ path _ "' INTO IntegratedML.Coin (CoinDate, PriceOpen, PriceHigh, PriceLow, PriceClose, TradeVolume)"
    set tStatement = ##class(%SQL.Statement).%New()
    set qSC = tStatement.%Prepare(query)
    if qSC '= 1 {
        write "%Prepare failed:" 
        do $System.Status.DisplayError(qSC) 
        quit
    }
    set tSC = tStatement.%Execute()
    do tSC.%Display()
    write !!,"Data loaded successfully."
    return tSC
}

ClassMethod Predict(pModel As %String = "model-1") As %Status
{
    do $System.SQL.Execute("SET ML CONFIGURATION %PMML")
    set default = ##class(%SYS.ML.Configuration).%GetDefault()
    write !,"The default IntegratedML service is: "_default
    write !,"Creating Model " _ pModel _"...",!
    set cSC = $System.SQL.Execute("CREATE MODEL """_ pModel _""" PREDICTING (Prediction) FROM IntegratedML.Coin")
    do cSC.%Display()
    write !,"Model "_ pModel _" created."
    write !,"Training "_ pModel _"...",!
  //  set tSC = $System.SQL.Execute("TRAIN MODEL """_ pModel _""" USING {""class_name"" : ""IntegratedML.pmml." _ pModel _ "}")
    do tSC.%Display()
}

Storage Default
{
<Data name="CoinDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CoinDate</Value>
</Value>
<Value name="3">
<Value>PriceOpen</Value>
</Value>
<Value name="4">
<Value>PriceHigh</Value>
</Value>
<Value name="5">
<Value>PriceLow</Value>
</Value>
<Value name="6">
<Value>PriceClose</Value>
</Value>
<Value name="7">
<Value>TradeVolume</Value>
</Value>
<Value name="8">
<Value>Prediction</Value>
</Value>
</Data>
<DataLocation>^IntegratedML.CoinD</DataLocation>
<DefaultData>CoinDefaultData</DefaultData>
<IdLocation>^IntegratedML.CoinD</IdLocation>
<IndexLocation>^IntegratedML.CoinI</IndexLocation>
<StreamLocation>^IntegratedML.CoinS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
