--- DO NOT TOUCH THIS unless you know what you're doing
print('^3[Government Tax]^7 Starting Resource...')

CreateThread(function()

    print('^3[Government Tax]^7 Loading Configuration...')

    Wait(500)

    print('^3[Government Tax]^7 Connecting Framework...')

    if Config.Framework == 'esx' then
        print('^2[Government Tax]^7 ESX Framework Detected')
    elseif Config.Framework == 'qbcore' then
        print('^2[Government Tax]^7 QBCore Framework Detected')
    else
        print('^1[Government Tax]^7 Invalid Framework Config')
        return
    end

    Wait(500)

    print('^3[Government Tax]^7 Connecting Database...')

    local success = pcall(function()
        MySQL.scalar.await('SELECT 1')
    end)

    if success then
        print('^2[Government Tax]^7 Database Connected')
    else
        print('^1[Government Tax]^7 Database Connection Failed')
        return
    end

    Wait(500)

    print('^3[Government Tax]^7 Loading Tax Tables...')

    Wait(500)

    print('^2[Government Tax]^7 Tax System Loaded Successfully')
    print('^2[Government Tax]^7 Collection Interval: ' .. Config.CollectionTime .. ' Minutes')
    print('^2[Government Tax]^7 Resource Ready')
end)
print([[
^2
=====================================
      GOVERNMENT TAX SYSTEM
=====================================
 Version: 1.0.0
 Author: Dakota Scripts
=====================================
^7
]])
local Framework = {}

if Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local SpendingTracker = {}

-----------------------------------------------------
-- FRAMEWORK FUNCTIONS
-----------------------------------------------------

function Framework.GetPlayer(src)
    if Config.Framework == 'esx' then
        return ESX.GetPlayerFromId(src)
    elseif Config.Framework == 'qbcore' then
        return QBCore.Functions.GetPlayer(src)
    end

    return nil
end

function Framework.GetIdentifier(Player)
    if Config.Framework == 'esx' then
        return Player.identifier
    elseif Config.Framework == 'qbcore' then
        return Player.PlayerData.citizenid
    end
end

function Framework.GetBankMoney(Player)
    if Config.Framework == 'esx' then
        return Player.getAccount('bank').money
    elseif Config.Framework == 'qbcore' then
        return Player.PlayerData.money.bank
    end

    return 0
end

function Framework.RemoveBankMoney(Player, amount)
    if Config.Framework == 'esx' then
        Player.removeAccountMoney('bank', amount)
    elseif Config.Framework == 'qbcore' then
        Player.Functions.RemoveMoney(
            'bank',
            amount,
            'government-tax'
        )
    end
end

function Framework.Notify(src, msg)
    if Config.Framework == 'esx' then
        TriggerClientEvent('esx:showNotification', src, msg)
    elseif Config.Framework == 'qbcore' then
        TriggerClientEvent('QBCore:Notify', src, msg, 'primary')
    end
end

-----------------------------------------------------
-- TAX FUNCTIONS
-----------------------------------------------------

function GetFederalTaxRate(bank)
    for _, bracket in pairs(Config.FederalBrackets) do
        if bank <= bracket.max then
            return bracket.rate
        end
    end

    return 1
end

function AddSpending(src, amount)
    SpendingTracker[src] = (SpendingTracker[src] or 0) + amount
end

exports('AddSpending', AddSpending)

RegisterNetEvent('government_tax:trackPurchase', function(amount)
    local src = source
    SpendingTracker[src] = (SpendingTracker[src] or 0) + amount
end)

-----------------------------------------------------
-- TAX COLLECTION
-----------------------------------------------------

CreateThread(function()
    while true do

        Wait(Config.CollectionTime * 60 * 1000)

        local players = GetPlayers()

        for _, playerId in pairs(players) do

            local src = tonumber(playerId)

            local Player = Framework.GetPlayer(src)

            if not Player then
                goto continue
            end

            local identifier =
                Framework.GetIdentifier(Player)

            local bank =
                Framework.GetBankMoney(Player)

            local taxRate =
                GetFederalTaxRate(bank)

            local federalTax =
                math.floor(bank * (taxRate / 100))

            local spent =
                SpendingTracker[src] or 0

            local spendingTax =
                math.floor(
                    spent *
                    (Config.SpendingTaxPercent / 100)
                )

            local propertyTax =
                Config.PropertyTax.House

            local trashFee =
                Config.TrashFee

            local totalTax =
                federalTax +
                spendingTax +
                propertyTax +
                trashFee

            if bank >= totalTax then

                Framework.RemoveBankMoney(
                    Player,
                    totalTax
                )

                Framework.Notify(
                    src,
                    ('Federal Revenue Service\n\nFederal Tax: $%s\nSpending Tax: $%s\nProperty Tax: $%s\nTrash Fee: $%s\n\nTotal Paid: $%s')
                    :format(
                        federalTax,
                        spendingTax,
                        propertyTax,
                        trashFee,
                        totalTax
                    )
                )

            else

                MySQL.insert.await(
                    'INSERT INTO tax_debt (identifier, amount, reason) VALUES (?, ?, ?)',
                    {
                        identifier,
                        totalTax,
                        'Unpaid Government Taxes'
                    }
                )

                Framework.Notify(
                    src,
                    ('Unable To Pay Taxes\nDebt Added: $%s')
                    :format(totalTax)
                )
            end

            SpendingTracker[src] = 0

            ::continue::
        end
    end
end)

-----------------------------------------------------
-- /TAXES COMMAND
-----------------------------------------------------

RegisterCommand('taxes', function(source)

    local Player =
        Framework.GetPlayer(source)

    if not Player then
        return
    end

    local bank =
        Framework.GetBankMoney(Player)

    local taxRate =
        GetFederalTaxRate(bank)

    local federalTax =
        math.floor(bank * (taxRate / 100))

    local spent =
        SpendingTracker[source] or 0

    local spendingTax =
        math.floor(
            spent *
            (Config.SpendingTaxPercent / 100)
        )

    local propertyTax =
        Config.PropertyTax.House

    local trashFee =
        Config.TrashFee

    local totalTax =
        federalTax +
        spendingTax +
        propertyTax +
        trashFee

    Framework.Notify(
        source,
        ('Federal Revenue Service\n\nFederal Tax: $%s\nSpending Tax: $%s\nProperty Tax: $%s\nTrash Fee: $%s\n\nEstimated Total: $%s')
        :format(
            federalTax,
            spendingTax,
            propertyTax,
            trashFee,
            totalTax
        )
    )

end, false)
