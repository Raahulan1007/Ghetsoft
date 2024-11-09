-- Id: 16596
-- More information about this indicator can be found at:
-- http://fxcodebase.com/code/viewtopic.php?f=31&t=63832

--+------------------------------------------------------------------+
--|                               Copyright © 2018, Gehtsoft USA LLC | 
--|                                            http://fxcodebase.com |
--+------------------------------------------------------------------+
--|                                      Developed by : Mario Jemic  |                    
--|                                          mario.jemic@gmail.com   |
--+------------------------------------------------------------------+
--|                                 Support our efforts by donating  | 
--|                                    Paypal: https://goo.gl/9Rj74e |
--|                    BitCoin : 15VCJTLaz12Amr7adHSBtL9v8XomURo9RF  |  
--|                BitCoin Cash: 1BEtS465S3Su438Kc58h2sqvVvHK9Mijtg  | 
--|           Ethereum : 0x8C110cD61538fb6d7A2B47858F0c0AaBd663068D  |  
--|                   LiteCoin : LLU8PSY2vsq7B9kRELLZQcKf5nJQrdeqwD  |  
--+------------------------------------------------------------------+

function Init() --The strategy profile initialization
    strategy:name("MTF DMI TWO Strategy");
    strategy:description("");
	strategy:setTag("NonOptimizableParameters", "Email,SendEmail,SoundFile,RecurrentSound,PlaySound, ShowAlert");
	
	strategy.parameters:addGroup("Price");
    strategy.parameters:addString("Type", "Price Type", "", "Bid");
    strategy.parameters:addStringAlternative("Type", "Bid", "", "Bid");
    strategy.parameters:addStringAlternative("Type", "Ask", "", "Ask");
	
	strategy.parameters:addString("TF", "Trading Time frame", "", "t1");
    strategy.parameters:setFlag("TF", core.FLAG_PERIODS);
	
	
	strategy.parameters:addGroup("1. Time Frame");
	strategy.parameters:addString("TF1", "Time frame", "", "H2");
    strategy.parameters:setFlag("TF1", core.FLAG_PERIODS);
	strategy.parameters:addInteger("N1", "Period", "Period", 4, 1, 1000);
    strategy.parameters:addString("Price1", "Price", "", "close");
    strategy.parameters:addStringAlternative("Price1", "close", "", "close");
    strategy.parameters:addStringAlternative("Price1", "open", "", "open");
    strategy.parameters:addStringAlternative("Price1", "high", "", "high");
    strategy.parameters:addStringAlternative("Price1", "low", "", "low");
    strategy.parameters:addStringAlternative("Price1", "median", "", "median");
    strategy.parameters:addStringAlternative("Price1", "typical", "", "typical");
    strategy.parameters:addStringAlternative("Price1", "weighted", "", "weighted");
	
	
	strategy.parameters:addDouble("BL1", "Buy Level", "Level", 20);
	strategy.parameters:addDouble("SL1", "Sell Level", "Level", 80);
	
	strategy.parameters:addGroup("2. Time Frame");
	strategy.parameters:addString("TF2", "Time frame", "", "H1");
    strategy.parameters:setFlag("TF2", core.FLAG_PERIODS);
    strategy.parameters:addInteger("N2", "Period", "Period", 4, 1, 1000);
    strategy.parameters:addString("Price2", "Price", "", "close");
    strategy.parameters:addStringAlternative("Price2", "close", "", "close");
    strategy.parameters:addStringAlternative("Price2", "open", "", "open");
    strategy.parameters:addStringAlternative("Price2", "high", "", "high");
    strategy.parameters:addStringAlternative("Price2", "low", "", "low");
    strategy.parameters:addStringAlternative("Price2", "median", "", "median");
    strategy.parameters:addStringAlternative("Price2", "typical", "", "typical");
    strategy.parameters:addStringAlternative("Price2", "weighted", "", "weighted");
	
	strategy.parameters:addDouble("BL2", "Buy Level", "Level", 20);
	strategy.parameters:addDouble("SL2", "Sell Level", "Level", 80);
   
--~    strategy.parameters:addGroup("3. Time Frame");
--~     strategy.parameters:addString("TF3", "Time frame", "", "H8");
--~     strategy.parameters:setFlag("TF3", core.FLAG_PERIODS);
--~    
--~    strategy.parameters:addInteger("N3", "Period", "Period", 14, 1, 1000);
--~     strategy.parameters:addString("Price3", "Price", "", "close");
--~     strategy.parameters:addStringAlternative("Price3", "close", "", "close");
--~     strategy.parameters:addStringAlternative("Price3", "open", "", "open");
--~     strategy.parameters:addStringAlternative("Price3", "high", "", "high");
--~     strategy.parameters:addStringAlternative("Price3", "low", "", "low");
--~     strategy.parameters:addStringAlternative("Price3", "median", "", "median");
--~     strategy.parameters:addStringAlternative("Price3", "typical", "", "typical");
--~     strategy.parameters:addStringAlternative("Price3", "weighted", "", "weighted");
--~ 	 
--~ 	 strategy.parameters:addDouble("BL3", "Buy Level", "Level", 20);
--~ 	strategy.parameters:addDouble("SL3", "Sell Level", "Level", 80);
    

    CreateTradingParameters();
end

function CreateTradingParameters()
    strategy.parameters:addGroup("Trading Parameters");

    strategy.parameters:addBoolean("AllowTrade", "Allow strategy to trade", "", false);   
    strategy.parameters:setFlag("AllowTrade", core.FLAG_ALLOW_TRADE);
	
 
	--strategy.parameters:addString("ExecutionType", "End of Turn / Live", "", "End of Turn");
   -- strategy.parameters:addStringAlternative("ExecutionType", "End of Turn", "", "End of Turn");
	--strategy.parameters:addStringAlternative("ExecutionType", "Live", "", "Live");
	
	strategy.parameters:addBoolean("CloseOnOpposite", "Close On Opposite", "", true);
    strategy.parameters:addString("CustomID", "Custom Identifier", "The identifier that can be used to distinguish strategy instances", "MTFRSIS");
	
	strategy.parameters:addInteger("MaxNumberOfPositionInAnyDirection", "Max Number Of Open Position In Any Direction", "", 2, 1, 100);
	strategy.parameters:addInteger("MaxNumberOfPosition", "Max Number Of Position In One Direction", "", 1, 1, 100);
    	
    strategy.parameters:addString("ALLOWEDSIDE", "Allowed side", "Allowed side for trading or signaling, can be Sell, Buy or Both", "Both");
    strategy.parameters:addStringAlternative("ALLOWEDSIDE", "Both", "", "Both");
    strategy.parameters:addStringAlternative("ALLOWEDSIDE", "Buy", "", "Buy");
    strategy.parameters:addStringAlternative("ALLOWEDSIDE", "Sell", "", "Sell");
	
	strategy.parameters:addString("Direction", "Type of Signal / Trade", "", "direct");
    strategy.parameters:addStringAlternative("Direction", "Direct", "", "direct");
    strategy.parameters:addStringAlternative("Direction", "Reverse", "", "reverse");

    strategy.parameters:addString("Account", "Account to trade on", "", "");
    strategy.parameters:setFlag("Account", core.FLAG_ACCOUNT);
    strategy.parameters:addInteger("Amount", "Trade Amount in Lots", "", 1, 1, 1000000);
    strategy.parameters:addBoolean("SetLimit", "Set Limit Orders", "", false);
    strategy.parameters:addInteger("Limit", "Limit Order in pips", "", 30, 1, 10000);
    strategy.parameters:addBoolean("SetStop", "Set Stop Orders", "", false);
    strategy.parameters:addInteger("Stop", "Stop Order in pips", "", 30, 1, 10000);
    strategy.parameters:addBoolean("TrailingStop", "Trailing stop order", "", false);
    strategy.parameters:addBoolean("Exit", "Use Optional Exit", "", true);
	
    strategy.parameters:addGroup("Alerts");
    strategy.parameters:addBoolean("ShowAlert", "ShowAlert", "", true);
    strategy.parameters:addBoolean("PlaySound", "Play Sound", "", false);
    strategy.parameters:addFile("SoundFile", "Sound File", "", "");
    strategy.parameters:setFlag("SoundFile", core.FLAG_SOUND);
    strategy.parameters:addBoolean("RecurrentSound", "Recurrent Sound", "", true);
    strategy.parameters:addBoolean("SendEmail", "Send Email", "", false);
    strategy.parameters:addString("Email", "Email", "", "");
    strategy.parameters:setFlag("Email", core.FLAG_EMAIL);
	
	strategy.parameters:addGroup("Time Parameters");	 
	strategy.parameters:addInteger("ToTime", "Convert the date to", "", 6);
    strategy.parameters:addIntegerAlternative("ToTime", "EST", "", 1);
    strategy.parameters:addIntegerAlternative("ToTime", "UTC", "", 2);
    strategy.parameters:addIntegerAlternative("ToTime", "Local", "", 3);
    strategy.parameters:addIntegerAlternative("ToTime", "Server", "", 4);
    strategy.parameters:addIntegerAlternative("ToTime", "Financial", "", 5);
	strategy.parameters:addIntegerAlternative("ToTime", "Display", "", 6);
	
    strategy.parameters:addString("StartTime", "Start Time for Trading", "", "00:00:00");
    strategy.parameters:addString("StopTime", "Stop Time for Trading", "", "24:00:00");

    strategy.parameters:addBoolean("UseMandatoryClosing", "Use Mandatory Closing", "", false);
    strategy.parameters:addString("ExitTime", "Mandatory Closing  Time", "", "23:59:00");
    strategy.parameters:addInteger("ValidInterval", "Valid interval for operation in second", "", 60);
	
	
end
 
local Source1, Source2,Source;
local MaxNumberOfPositionInAnyDirection, MaxNumberOfPosition;
local SoundFile = nil;
local RecurrentSound = false;
local ALLOWEDSIDE;
local AllowTrade;
local Offer;
local CanClose;
local Account;
local Amount;
local SetLimit;
local Limit;
local SetStop;
local Stop;
local TrailingStop;
local ShowAlert;
local Email;
local SendEmail;
local BaseSize;
--local ExecutionType;
local CloseOnOpposite
local first;
 
local Direction;
local CustomID;

local  DMI1;
local  DMI2;
--~ local  N3, Price3, DMI3;


local OpenTime, CloseTime, ExitTime;
local ValidInterval,UseMandatoryClosing;
local ToTime;
local TF;

--
function Prepare(nameOnly)
 
	CustomID = instance.parameters.CustomID;
	
    local name = profile:id() .. "( " .. instance.bid:name() .. "," .. CustomID ..  " )";
    instance:name(name); 

    if nameOnly then
        return ;
    end

	
	--ExecutionType = instance.parameters.ExecutionType;
    CloseOnOpposite = instance.parameters.CloseOnOpposite;
	MaxNumberOfPositionInAnyDirection = instance.parameters.MaxNumberOfPositionInAnyDirection;
	MaxNumberOfPosition = instance.parameters.MaxNumberOfPosition;
	Direction = instance.parameters.Direction == "direct";
	
	 
	
         BL1 = instance.parameters.BL1;
	 SL1 = instance.parameters.SL1;
	 N1 = instance.parameters.N1;
	 Price1 = instance.parameters.Price1;
	 
	 BL2 = instance.parameters.BL2;
	 SL2 = instance.parameters.SL2;
	 N2 = instance.parameters.N2;
	 Price2 = instance.parameters.Price2;
	 
	 
--~ 	 BL3 = instance.parameters.BL3;
--~ 	 SL3 = instance.parameters.SL3;
--~ 	 N3 = instance.parameters.N3;
--~ 	 Price3 = instance.parameters.Price3;
	 
	 
	 TF = instance.parameters.TF;

        assert(instance.parameters.TF1 ~= "t1", "1. time frame must not be tick");
	assert(instance.parameters.TF2 ~= "t1", "2. time frame must not be tick");
--~ 	assert(instance.parameters.TF3 ~= "t1", "3, time frame must not be tick");
	
	
	 local s, e, s1, e1, s2, e2, s3, e3;
         s, e = core.getcandle(TF, core.now(), 0, 0);
         s1, e1 = core.getcandle(instance.parameters.TF1, core.now(), 0, 0);
	 s2, e2 = core.getcandle(instance.parameters.TF2, core.now(), 0, 0);
--~ 	 s3, e3 = core.getcandle(instance.parameters.TF3, core.now(), 0, 0);
         assert ((e - s) <= (e1 - s1), "The chosen time frame must be equal to or bigger than the chart time frame!");
         assert ((e - s) <= (e2 - s2), "The chosen time frame must be equal to or bigger than the chart time frame!");
--~ 	 assert ((e - s) <= (e3 - s3), "The chosen time frame must be equal to or bigger than the chart time frame!");

    
   
    PrepareTrading();

    
	--if ExecutionType== "Live" then
	Source = ExtSubscribe(1, nil,  instance.parameters.TF, instance.parameters.Type == "Bid", "close");
	--end
	
        Source1 = ExtSubscribe(2, nil, instance.parameters.TF1, instance.parameters.Type == "Bid", "bar");
	Source2 = ExtSubscribe(3, nil, instance.parameters.TF2, instance.parameters.Type == "Bid", "bar");
--~ 	Source3 = ExtSubscribe(4, nil, instance.parameters.TF3, instance.parameters.Type == "Bid", "bar");
	
        DMI1 = core.indicators:create("DMI", Source1[Price1], N1);
	DMI2 = core.indicators:create("DMI", Source2[Price2], N2);
--~ 	DMI3 = core.indicators:create("DMI", Source3[Price3], N3);
	
	ToTime= instance.parameters.ToTime;
    ValidInterval = instance.parameters.ValidInterval;
    UseMandatoryClosing = instance.parameters.UseMandatoryClosing;	
	
	if ToTime == 1 then
	ToTime=core.TZ_EST;
	elseif ToTime == 2 then
	ToTime=core.TZ_UTC;
	elseif ToTime == 3 then
	ToTime=core.TZ_LOCAL;
	elseif ToTime == 4 then
	ToTime=core.TZ_SERVER;
	elseif ToTime == 5 then
	ToTime=core.TZ_FINANCIAL;
	elseif ToTime == 6 then
	ToTime=core.TZ_TS;
	end
	
	 local valid;
    OpenTime, valid = ParseTime(instance.parameters.StartTime);
    assert(valid, "Time " .. instance.parameters.StartTime .. " is invalid");
    CloseTime, valid = ParseTime(instance.parameters.StopTime);
    assert(valid, "Time " .. instance.parameters.StopTime .. " is invalid");
    ExitTime, valid = ParseTime(instance.parameters.ExitTime);
    assert(valid, "Time " .. instance.parameters.ExitTime .. " is invalid");
	
	if UseMandatoryClosing then
        core.host:execute("setTimer", 100, math.max(ValidInterval / 2, 1));
    end
	
	
end


 -- NG: create a function to parse time
function ParseTime(time)
    local Pos = string.find(time, ":");
    if Pos == nil then
        return nil, false;
    end
    local h = tonumber(string.sub(time, 1, Pos - 1));
    time = string.sub(time, Pos + 1);
    Pos = string.find(time, ":");
    if Pos == nil then
        return nil, false;
    end
    local m = tonumber(string.sub(time, 1, Pos - 1));
    local s = tonumber(string.sub(time, Pos + 1));
    return (h / 24.0 +  m / 1440.0 + s / 86400.0),                          -- time in ole format
           ((h >= 0 and h < 24 and m >= 0 and m < 60 and s >= 0 and s < 60) or (h == 24 and m == 0 and s == 0)); -- validity flag
end

function InRange(now, openTime, closeTime)
    if openTime < closeTime then
        return now >= openTime and now <= closeTime;
    end
    if openTime > closeTime then
        return now > openTime or now < closeTime;
    end

    return now == openTime;
end


function PrepareTrading()
    ALLOWEDSIDE = instance.parameters.ALLOWEDSIDE;

    local PlaySound = instance.parameters.PlaySound;
    if PlaySound then
        SoundFile = instance.parameters.SoundFile;
    else
        SoundFile = nil;
    end
    assert(not(PlaySound) or (PlaySound and SoundFile ~= ""), "Sound file must be chosen");

    ShowAlert = instance.parameters.ShowAlert;
    RecurrentSound = instance.parameters.RecurrentSound;

    SendEmail = instance.parameters.SendEmail;

    if SendEmail then
        Email = instance.parameters.Email;
    else
        Email = nil;
    end
    assert(not(SendEmail) or (SendEmail and Email ~= ""), "E-mail address must be specified");

    AllowTrade = instance.parameters.AllowTrade;
    Account = instance.parameters.Account;
    Amount = instance.parameters.Amount;
    BaseSize = core.host:execute("getTradingProperty", "baseUnitSize", instance.bid:instrument(), Account);
    Offer = core.host:findTable("offers"):find("Instrument", instance.bid:instrument()).OfferID;
    CanClose = core.host:execute("getTradingProperty", "canCreateMarketClose", instance.bid:instrument(), Account);
    SetLimit = instance.parameters.SetLimit;
    Limit = instance.parameters.Limit;
    SetStop = instance.parameters.SetStop;
    Stop = instance.parameters.Stop;
    TrailingStop = instance.parameters.TrailingStop;
end
 
local Last;
local LAST;
local ONE;


function ExtUpdate(id, source, period)  -- The method called every time when a new bid or ask price appears.

    now = core.host:execute("getServerTime");
	now= core.host:execute ("convertTime", core.TZ_EST, ToTime, now);
   -- get only time
    now = now - math.floor(now);		
	
	
	  if not InRange(now, OpenTime, CloseTime)
	  then            
      return ;
      end
	  
 
 
 
    if AllowTrade then
        if not(checkReady("trades")) or not(checkReady("orders")) then
            return ;
        end
    end
	
	
	if Source1:size()-1  < Source1:first()+2
	or Source2:size()-1  < Source2:first()+2
--~ 	or Source3:size()-1  < Source3:first()+2
	then
        return;
    end
	
	
	if    id ~= 1 
	then	
    return;  
	end
	
		
			period1= core.findDate (Source1.close, Source:date(period), false );		
			period2= core.findDate (Source2.close, Source:date(period), false );		
--~                          period3= core.findDate (Source3.close, Source:date(period), false );	
	 
	--period
	if period1 == -1
	or   period2 == -1
--~ 	or  period3 == -1
	then
       return;
    end

	 
	        
	        if ONE == Source:serial(period) then
			return;
			end
 
			
			
		 
 

  
  
   	if period1 == -1
	or   period2 == -1
--~ 	or  period3 == -1
	then
       return;
    end
	

    -- update indicators.
        DMI1:update(core.UpdateLast);
	DMI2:update(core.UpdateLast);
--~ 	DMI3:update(core.UpdateLast);
 
	
	
	
	 if DMI1.DIP.DATA[ period1]>DMI1.DIM.DATA[period1] and
	    DMI2.DIP.DATA[ period2]>DMI2.DIM.DATA[period2] 
	 
	    
	 
	 then
            if Direction then
                BUY();
            else
                SELL();
            end
		ONE= Source:serial(period);
    end
        if DMI1.DIP.DATA[ period1]<DMI1.DIM.DATA[period1] and
	   DMI2.DIP.DATA[ period2]<DMI2.DIM.DATA[period2]
    
    
	then
            if Direction then
                SELL();
            else
                BUY();
            end
		ONE= Source:serial(period);
    end
	
	
	--[[
	
        EXIT BUY
		RSI line 2 cross under RSI line 3

		EXIT SELL
		RSI line 2 cross over RSI line 3


	]]
	
	if Exit then
		            if      DMI1.DIP.DATA[ period1]>DMI1.DIM.DATA[period1] and
	    DMI2.DIP.DATA[ period2]>DMI2.DIM.DATA[period2] 
					then 			
								if   Direction then
										   if haveTrades("B") then
											   exitSpecific("B");
											   Signal ("Close Long");
										   end
							   else 
										 if haveTrades("S") then
											   exitSpecific("S");
											   Signal ("Close Short");
										   end
								   
								end
					  end
					  if   DMI1.DIP.DATA[ period1]<DMI1.DIM.DATA[period1] and
	   DMI2.DIP.DATA[ period2]<DMI2.DIM.DATA[period2]
		               then
								   if   Direction then    
										if haveTrades("S") then
										   exitSpecific("S");
										   Signal ("Close Short");
									   end 
								  
								  
							   else 
							   
									  if haveTrades("B") then
										   exitSpecific("B");
										   Signal ("Close Long");
									   end
								
							 
							 end
				
					end
	   end
 

end

-- NG: Introduce async function for timer/monitoring for the order results
function ExtAsyncOperationFinished(cookie, success, message)

    if cookie == 100 then
        -- timer
        if UseMandatoryClosing and AllowTrade then
            now = core.host:execute("getServerTime");
            now= core.host:execute ("convertTime", core.TZ_EST, ToTime, now);
            -- get only time
            now = now - math.floor(now);
			
            -- check whether the time is in the exit time period
            if now >= ExitTime and now < ExitTime +(ValidInterval / 86400.0) then
                if not checkReady("trades")  then
                    return ;
                end  
				
				     if haveTrades("B")  then
                     exitSpecific("B");
                     Signal ("Close Long");
					 end
					 
					 if haveTrades("S")  then
                     exitSpecific("S");
                     Signal ("Close Short");
					 end
            end
        end
    elseif cookie == 200 and not success then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "Open order failed" .. message, instance.bid:date(instance.bid:size() - 1));
    elseif cookie == 201 and not success then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "Close order failed" .. message, instance.bid:date(instance.bid:size() - 1));
		
	 end
	 
end

--===========================================================================--
--                    TRADING UTILITY FUNCTIONS                              --
--============================================================================--
function BUY()
    if AllowTrade then
        if CloseOnOpposite and haveTrades("S") then
            -- close on opposite signal
            exitSpecific("S");
            Signal ("Close Short");
        end

        if ALLOWEDSIDE == "Sell"  then
            -- we are not allowed buys.
            return;
        end 

        enter("B");
    else
        Signal ("Buy Signal");	
    end
end   
    
function SELL ()		
    if AllowTrade then
        if CloseOnOpposite and haveTrades("B") then
            -- close on opposite signal
            exitSpecific("B");
            Signal ("Close Long");
        end

        if ALLOWEDSIDE == "Buy"  then
            -- we are not allowed sells.
            return;
        end

        enter("S");
    else
        Signal ("Sell Signal");	
    end
end

function Signal (Label)
    if ShowAlert then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[NOW],  Label, instance.bid:date(NOW));
    end

    if SoundFile ~= nil then
        terminal:alertSound(SoundFile, RecurrentSound);
    end

    if Email ~= nil then
        terminal:alertEmail(Email, Label, profile:id() .. "(" .. instance.bid:instrument() .. ")" .. instance.bid[NOW]..", " .. Label..", " .. instance.bid:date(NOW));
    end
end								

function checkReady(table)
    local rc;
    if Account == "TESTACC_ID" then
        -- run under debugger/simulator
        rc = true;
    else
        rc = core.host:execute("isTableFilled", table);
    end

    return rc;
end

function tradesCount(BuySell) 
    local enum, row;
    local count = 0;
    enum = core.host:findTable("trades"):enumerator();
    row = enum:next();
    while row ~= nil do
        if row.AccountID == Account and row.OfferID == Offer and row.QTXT == CustomID and (row.BS == BuySell or BuySell == nil) then
            count = count + 1;
        end

        row = enum:next();
    end

    return count;
end

function haveTrades(BuySell) 
    local enum, row;
    local found = false;
    enum = core.host:findTable("trades"):enumerator();
    row = enum:next();
    while (row ~= nil) do
        if row.AccountID == Account and row.OfferID == Offer and row.QTXT == CustomID and (row.BS == BuySell or BuySell == nil) then
            found = true;
            break;
        end

        row = enum:next();
    end

    return found;
end

-- enter into the specified direction
function enter(BuySell)
    -- do not enter if position in the specified direction already exists
    if tradesCount(BuySell) >= MaxNumberOfPosition
	or ((tradesCount(nil)) >= MaxNumberOfPositionInAnyDirection)	
	then
        return true;
    end

    -- send the alert after the checks to see if we can trade.
    if (BuySell == "S") then
        Signal ("Sell Signal");	
    else
        Signal ("Buy Signal");	
    end

    return MarketOrder(BuySell);
end


-- enter into the specified direction
function MarketOrder(BuySell)
    local valuemap, success, msg;
    valuemap = core.valuemap();

    valuemap.Command = "CreateOrder";
    valuemap.OrderType = "OM";
    valuemap.OfferID = Offer;
    valuemap.AcctID = Account;
    valuemap.Quantity = Amount * BaseSize;
    valuemap.BuySell = BuySell;
    valuemap.CustomID = CustomID;

    -- add stop/limit
    valuemap.PegTypeStop = "O";
    if SetStop then 
        if BuySell == "B" then
            valuemap.PegPriceOffsetPipsStop = -Stop;
        else
            valuemap.PegPriceOffsetPipsStop = Stop;
        end
    end
    if TrailingStop then
        valuemap.TrailStepStop = 1;
    end

    valuemap.PegTypeLimit = "O";
    if SetLimit then
        if BuySell == "B" then
            valuemap.PegPriceOffsetPipsLimit = Limit;
        else
            valuemap.PegPriceOffsetPipsLimit = -Limit;
        end
    end

    if (not CanClose) then
        valuemap.EntryLimitStop = 'Y'
    end

    success, msg = terminal:execute(200, valuemap);

    if not(success) then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "Open order failed" .. msg, instance.bid:date(instance.bid:size() - 1));
        return false;
    end

    return true;
end

function exitSpecific(BuySell)

 if not AllowTrade then
 return;
 end
 
--side
-- closes all positions of the specified direction (B for buy, S for sell)
 
    local enum, row, valuemap;

    enum = core.host:findTable("trades"):enumerator();
    while true do
        row = enum:next();
        if row == nil then
            break;
        end
        if row.AccountID == Account and
           row.OfferID == Offer and
           row.BS == BuySell and
           row.QTXT == CustomID then
            -- if trade has to be closed

						if CanClose then
										-- non-FIFO account, create a close market order
										valuemap = core.valuemap();
										valuemap.OrderType = "CM";
										valuemap.OfferID = Offer;
										valuemap.AcctID = Account;
										valuemap.Quantity = row.Lot;
										valuemap.TradeID = row.TradeID;
										valuemap.CustomID = CustomID;
										if row.BS == "B" then
											valuemap.BuySell = "S";
										else
											valuemap.BuySell = "B";
										end
										success, msg = terminal:execute(201, valuemap);
										 if not(success) then
											terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "Close order failed" .. msg, instance.bid:date(instance.bid:size() - 1));
											return false;
										end
						  else
											-- FIFO account, create an opposite market order
											valuemap = core.valuemap();
											valuemap.OrderType = "OM";
											valuemap.OfferID = Offer;
											valuemap.AcctID = Account;
											--valuemap.Quantity = Amount*BaseSize;
							                valuemap.Quantity = row.Lot;
											valuemap.CustomID = CustomID;
											if row.BS == "B" then
												valuemap.BuySell = "S";
											else
												valuemap.BuySell = "B";
											end
											success, msg = terminal:execute(201, valuemap);
											 if not(success) then
												terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "Close order failed" .. msg, instance.bid:date(instance.bid:size() - 1));
												return false;
											end
						end
        end
    end
end 

dofile(core.app_path() .. "\\strategies\\standard\\include\\helper.lua");