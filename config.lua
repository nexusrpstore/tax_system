Config = {}

Config.Framework = 'esx' -- esx, qbcore, qbox

Config.CollectionTime = 7200 -- minutes real time based default (7200) 5 days..

Config.TrashFee = 150  ---simple trash fees 

Config.PropertyTax = {
    House = 0,    ---- set to 0 if you use property taxs else where... 
    Business = 1500   ----set to 0 if you use else where 
}

-------------------------------FEDERAL TAX RATE ---------------------------
--- Examples:
--Cash	Tax Rate	Tax Owed
--$10,000	0.25%	$25
--$50,000	0.50%	$250
--$100,000	0.75%	$750
--$500,000	1.00%	$5,000
--$1,000,000	1.00%	$10,000
--------------------------------------------------------------------------------
Config.FederalBrackets = {
    { max = 10000, rate = 0.25 },
    { max = 50000, rate = 0.25 },
    { max = 100000, rate = 0.25 },
    { max = 500000, rate = 0.25 },
    { max = 10000000, rate = 0.75 }
}

Config.SpendingTaxPercent = 5  --- how much precentages get taken out when spending money 