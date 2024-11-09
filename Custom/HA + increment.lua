function Init()
    strategy:name("HA + increment")
    strategy:description("Stochastic slope + Bar-Color + increment + MVA")
    strategy:type(core.Both)

    strategy.parameters:addGroup("Indicator Parameters")
    strategy.parameters:addString("TimeFrame", "TimeFrame", "TimeFrame", "m15")
    strategy.parameters:setFlag("TimeFrame", core.FLAG_PERIODS)
    
    strategy.parameters:addInteger("HA Periods", "HA Periods", "HA Periods", 1)
    
       
    
    strategy.parameters:addGroup("Trading Parameters")
    strategy.parameters:addString("Account", "Account", "Account", "")
    strategy.parameters:setFlag("Account", core.FLAG_ACCOUNT)
    strategy.parameters:addInteger("LotSize", "Lot Size", "Lot Size", 1, 1)
    strategy.parameters:addBoolean("AllowTrading", "Allow Trading", "Allow Trading", true)
    strategy.parameters:setFlag("AllowTrading", core.FLAG_ALLOW_TRADE)
    strategy.parameters:addBoolean("CloseAndReverse", "Close and Reverse", "Close and Reverse", true)
    strategy.parameters:addInteger("MagicNumber", "Magic Number", "Magic Number", 1, 1)
    strategy.parameters:addDouble("StopLoss", "Stop Loss", "Stop Loss", 0, 0)
    strategy.parameters:addInteger("TrailStop", "Trailing Stop", "Trailing Stop", 0, 0)
    strategy.parameters:addDouble("TakeProfit", "Take Profit", "Take Profit", 0, 0)

    strategy.parameters:addGroup("Alert Parameters")
    strategy.parameters:addBoolean("ShowAlert", "ShowAlert", "", false)
    strategy.parameters:addBoolean("PlaySound", "PlaySound", "", false)
    strategy.parameters:addBoolean("RecurrentSound", "RecurrentSound", "", false)
    strategy.parameters:addFile("SoundFile", "SoundFile", "", "")
    strategy.parameters:setFlag("SoundFile", core.FLAG_SOUND)
    strategy.parameters:addBoolean("SendEmail", "SendEmail", "", false)
    strategy.parameters:addString("Email", "Email", "Email", "")
    strategy.parameters:setFlag("Email", core.FLAG_EMAIL)
end

local source
local accountId
local offerId
local stopLoss
local trailStop
local takeProfit
local lotSize
local customText
local soundFile
local email
local recurrentSound
local canClose
local allowTrading
local closeAndReverse

local HA

function Prepare(onlyName)
    source = ExtSubscribe(1, instance.bid:instrument(), instance.parameters["TimeFrame"], true, "bar")
    offerId = core.host:findTable("offers"):find("Instrument", instance.bid:instrument()).OfferID
    accountId = instance.parameters["Account"]
    stopLoss = instance.parameters["StopLoss"]
    trailStop = instance.parameters["TrailStop"]
    takeProfit = instance.parameters["TakeProfit"]
    allowTrading = instance.parameters["AllowTrading"]
    closeAndReverse = instance.parameters["CloseAndReverse"]
    lotSize =
        instance.parameters["LotSize"] *
        core.host:execute("getTradingProperty", "baseUnitSize", instance.bid:instrument(), accountId)
    canClose = core.host:execute("getTradingProperty", "canCreateMarketClose", instance.bid:instrument(), accountId)
    customText =
        string.format(
        "%s-%s-%d",
        "FXES_EXTB",
        "Stochastic slope + Bar-Color + increment + MVA",
        instance.parameters["MagicNumber"]
    )
    instance:name(
        string.format(
            "%s-%s-%d",
            "Stochastic slope + Bar-Color + increment + MVA",
            instance.bid:instrument(),
            instance.parameters["MagicNumber"]
        )
    )

    if instance.parameters["PlaySound"] then
        soundFile = instance.parameters["SoundFile"]
        recurrentSound = instance.parameters["RecurrentSound"]
    end

    if instance.parameters["SendEmail"] then
        email = instance.parameters["Email"]
    end

    local alertName =
        string.format(
        "%s-%s-%d:",
        "Stochastic slope + Bar-Color + increment + MVA",
        instance.bid:instrument(),
        instance.parameters["MagicNumber"]
    )
    ExtSetupSignal(alertName, instance.parameters["ShowAlert"])
    ExtSetupSignalMail(alertName)
    
    HA = core.indicators:create("HA", source, instance.parameters["HA Periods"]);
    
end

function ExtUpdate(id, source, period)
    if id == 1 then
    
        HA:update(core.UpdateLast);
        

                

        -- BUY EXIT CONDITION
        if allowTrading and HasTrade("B") then
            if
                HA.close[period] < HA.open[period - 1] and
	        HA.close[period] < HA.open[period] 
             then
                core.host:trace(
                    "BUY exit condition met. Condition: 'source.close[period] < source.open[period] and source.close[period] < source.open[period - 1] and MVA.MVA[period] < MVA1.MVA[period] and STOCHASTIC.K[period] < STOCHASTIC.K[period - 1]'"
                )
                ExtSignal(source, period, "Exit BUY Signal Created", soundFile, email, recurrentSound)
                MarketCloseAll("B")
            end
        end

        -- SELL EXIT CONDITION
        if allowTrading and HasTrade("S") then
            if
                HA.close[period] > HA.open[period - 1] and
	        HA.close[period] > HA.open[period] 
             then
                core.host:trace(
                    "SELL exit condition met. Condition: 'source.close[period] > source.open[period] and source.close[period] > source.open[period - 1] and MVA.MVA[period] > MVA1.MVA[period] and STOCHASTIC.K[period] > STOCHASTIC.K[period - 1]'"
                )
                ExtSignal(source, period, "Exit SELL Signal Created", soundFile, email, recurrentSound)
                MarketCloseAll("S")
            end
        end

        -- BUY ENTRY CONDITION
        if
             HA.close[period] > HA.open[period - 1] and
	     HA.close[period] > HA.open[period] 
         then
            core.host:trace(
                "BUY condition met. Condition: 'source.close[period] > source.open[period] and source.close[period] > source.open[period - 1] and MVA.MVA[period] > MVA1.MVA[period] and STOCHASTIC.K[period] > STOCHASTIC.K[period - 1]'"
            )
            ExtSignal(source, period, "BUY Signal Created", soundFile, email, recurrentSound)

            if allowTrading and not HasTrade("B") then
                local hasOtherSide = HasTrade("S")
                if not hasOtherSide or closeAndReverse then
                    if hasOtherSide then
                        core.host:trace("Closing opposite side (SELL)")
                        MarketCloseAll("S")
                    end
                    core.host:trace("Entering new trade BUY trade")
                    CreateMarketOrder("B")
                end
            end
        end

        -- SELL ENTRY CONDITION
        if
                HA.close[period] < HA.open[period - 1] and
	        HA.close[period] < HA.open[period] 
         then
            core.host:trace(
                "SELL condition met. Condition: 'source.close[period] < source.open[period] and source.close[period] < source.open[period - 1] and MVA.MVA[period] < MVA1.MVA[period] and STOCHASTIC.K[period] < STOCHASTIC.K[period - 1]'"
            )
            ExtSignal(source, period, "SELL Signal Created", soundFile, email, recurrentSound)

            if allowTrading and not HasTrade("S") then
                local hasOtherSide = HasTrade("B")
                if not hasOtherSide or closeAndReverse then
                    if hasOtherSide then
                        core.host:trace("Closing opposite side (BUY)")
                        MarketCloseAll("B")
                    end
                    core.host:trace("Entering new trade SELL trade")
                    CreateMarketOrder("S")
                end
            end
        end
    end
end

function HasTrade(side)
    local enum, row

    enum = core.host:findTable("trades"):enumerator()
    row = enum:next()

    while row ~= nil do
        if
            accountId == row.AccountID and offerId == row.OfferID and customText == row.QTXT and
                (side == nil or side == row.BS)
         then
            return true
        end
        row = enum:next()
    end

    return false
end

function GetMarketOrderRequest(side)
    local valuemap = core.valuemap()

    valuemap.Command = "CreateOrder"
    valuemap.OrderType = "OM"
    valuemap.OfferID = offerId
    valuemap.AcctID = accountId
    valuemap.Quantity = lotSize
    valuemap.BuySell = side
    valuemap.CustomID = customText

    if takeProfit > 0 then
        valuemap.PegTypeLimit = "M"
        if side == "B" then
            valuemap.PegPriceOffsetPipsLimit = takeProfit
        else
            valuemap.PegPriceOffsetPipsLimit = -takeProfit
        end
    end

    if stopLoss > 0 then
        valuemap.PegTypeStop = "M"
        if side == "B" then
            valuemap.PegPriceOffsetPipsStop = -stopLoss
        else
            valuemap.PegPriceOffsetPipsStop = stopLoss
        end

        if trailStop > 0 then
            valuemap.TrailStepStop = trailStop
        end
    end

    if not canClose and (takeProfit > 0 or stopLoss > 0) then
        valuemap.EntryLimitStop = "Y"
    end

    return valuemap
end

function CreateMarketOrder(side)
    local success, msg = terminal:execute(100, GetMarketOrderRequest(side))
    if not success then
        core.host:trace("Create market order failed due to: " .. tostring(msg))
    end
end

function MarketCloseAll(side)
    local enum, row
    enum = core.host:findTable("trades"):enumerator()
    row = enum:next()
    while row ~= nil do
        if
            accountId == row.AccountID and offerId == row.OfferID and customText == row.QTXT and
                (side == nil or side == row.BS)
         then
            local success, msg = terminal:execute(100, GetMarketCloseRequest(row))
            if not success then
                core.host:trace("Market close failed due to: " .. tostring(msg))
            end
        end
        row = enum:next()
    end
end

function GetMarketCloseRequest(row)
    local valuemap = core.valuemap()
    valuemap.Command = "CreateOrder"
    valuemap.OrderType = "CM"
    valuemap.OfferID = row.OfferID
    valuemap.AcctID = row.AccountID
    valuemap.Quantity = row.Lot
    valuemap.TradeID = row.TradeID
    valuemap.CustomID = customText
    if row.BS == "B" then
        valuemap.BuySell = "S"
    else
        valuemap.BuySell = "B"
    end
    return valuemap
end

dofile(core.app_path() .. "\\strategies\\standard\\include\\helper.lua")
