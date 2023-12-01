--[[=============================================================================
    Enphase IQ/Envoy Gateway Solar Driver
===============================================================================]]

JSON = require("drivers-common-public.module.json")
require("drivers-common-public.global.handlers")
require("drivers-common-public.global.lib")
require("drivers-common-public.global.url")
require("drivers-common-public.global.timer")
require("drivers-common-public.module.mdns")

--[[=============================================================================
    Constants
===============================================================================]]

do	--Globals
	PRODUCTION = false
	ENPHASE = {}
	HEADERS = HEADERS or {}
	OPTIONS = {
		["ssl_verify_host"] = false,
		["ssl_verify_peer"] = false,
	}
	gPollInterval = 30
	gEnvoyAddress = "0.0.0.0"
	gEnvoySerial = nil
	gDiscovered = false
	gAuth = false
	gNeedAuth = true
	gAuthUser = nil
	gAuthPass = nil
	gAuthSessionID = nil
	gAuthToken = nil
	APIBase = "http://" .. gEnvoyAddress
	SessionURI = "https://enlighten.enphaseenergy.com/login/login.json?"
	TokenURI = "https://entrez.enphaseenergy.com/tokens"
	ReadingsURI = nil
end

--[[=============================================================================
    Driver initialization and destruction
===============================================================================]]

function OnDriverLateInit()
	KillAllTimers()
	C4:urlSetTimeout(20)
	C4:UpdateProperty("Driver Name", C4:GetDriverConfigInfo("name"))
	C4:UpdateProperty("Driver Version", C4:GetDriverConfigInfo("version"))
	if (Select (PersistData, "PollInterval")) then
		gPollInterval = PersistData.PollInterval or 30
	end
	if (Select (PersistData, "IP")) then
		gEnvoyAddress = PersistData.IP
	end
	if (Select (PersistData, "Serial")) then
		gEnvoySerial = PersistData.Serial
	end
	if (Select (PersistData, "User")) then
		gAuthUser = PersistData.User
	end
	if (Select (PersistData, "Pass")) then
		gAuthPass = PersistData.Pass
	end
	if (Select (PersistData, "SessionID")) then
		gAuthSessionID = PersistData.SessionID
	end
	if (Select (PersistData, "Token")) then
		gAuthToken = PersistData.Token
	end
	if (Select (PersistData, "Version")) then
		if (PersistData.Version < 7) then
			gAuth = true
			gNeedAuth = false
			APIBase = "http://" .. gEnvoyAddress
			ReadingsURI = "/production.json"
		else
			gAuth = false
			gNeedAuth = true
			APIBase = "https://" .. gEnvoyAddress
			ReadingsURI = "/ivp/meters/readings"
		end
	end
	if (not (Variables and Variables.PRODUCTION_KW)) then
		C4:AddVariable("PRODUCTION_KW", "", "INT", true, false)
		C4:SetVariable("PRODUCTION_KW", "")
	end
	if (not (Variables and Variables.CONSUMPTION_KW)) then
		C4:AddVariable("CONSUMPTION_KW", "", "INT", true, false)
		C4:SetVariable("CONSUMPTION_KW", "")
	end
	if (not (Variables and Variables.GRID_POWER_KW)) then
		C4:AddVariable("GRID_POWER_KW", "", "INT", true, false)
		C4:SetVariable("GRID_POWER_KW", "")
	end
	if (not (Variables and Variables.DAILY_ENERGY_PRODUCTION_KWH)) then
		C4:AddVariable("DAILY_ENERGY_PRODUCTION_KWH", "", "INT", true, false)
		C4:SetVariable("DAILY_ENERGY_PRODUCTION_KWH", "")
	end
	if (not (Variables and Variables.DAILY_ENERGY_CONSUMPTION_KWH)) then
		C4:AddVariable("DAILY_ENERGY_CONSUMPTION_KWH", "", "INT", true, false)
		C4:SetVariable("DAILY_ENERGY_CONSUMPTION_KWH", "")
	end
	if (not (Variables and Variables.EXCESS_SOLAR)) then
		C4:AddVariable("EXCESS_SOLAR", "0", "BOOL", true, false)
		C4:SetVariable("EXCESS_SOLAR", "0")
	end
	if (not (Variables and Variables.EXCESS_SOLAR_KW)) then
		C4:AddVariable("EXCESS_SOLAR_KW", "", "INT", true, false)
		C4:SetVariable("EXCESS_SOLAR_KW", "")
	end
	for property, _ in pairs(Properties) do
		OnPropertyChanged(property)
	end
	SetTimer("PollGateway", gPollInterval * ONE_SECOND)
	InitGateway()
end

function OnDriverDestroyed()
	KillAllTimers()
end

--[[=============================================================================
    Properties
===============================================================================]]

function OPC.Driver_Version (value)
	local version = C4:GetDriverConfigInfo("version")
	if (not(PRODUCTION)) then
		version = version .. " [BETA Version]"
	end
	C4:UpdateProperty("Driver Version", version)
end

function OPC.Debug_Mode(value)
	if (DEBUGPRINT) then
		DEBUGPRINT = CancelTimer(DEBUGPRINT)
	end
	if (value == "On") then
		local _timer = function(timer)
			C4:UpdateProperty("Debug Mode", "Off")
			OnPropertyChanged("Debug Mode")
		end
		DEBUGPRINT = SetTimer(DEBUGPRINT, 36000000, _timer)
	end
end

function OPC.Polling_Interval(value)
	if (value) then
		gPollInterval = value
		PersistData.PollInterval = gPollInterval
		PollGateway()
		SetTimer("PollGateway", gPollInterval * ONE_SECOND)
	end
end

function OPC.Username(value)
	if (value) then
		gAuthUser = value
		PersistData.User = gAuthUser
	end
	if (gAuthUser ~= nil) and (gAuthPass ~= nil) then
		PollGateway()
	end
end

function OPC.Password(value)
	if (value) then
		gAuthPass = value
		PersistData.Pass = gAuthPass
	end
	if (gAuthUser ~= nil) and (gAuthPass ~= nil) then
		PollGateway()
	end
end

--[[=============================================================================
    Enphase Gateway data functions
===============================================================================]]

function PollGateway()
	if (gDiscovered == false) then 
		InitGateway()
		return 
	end
	GetGatewayInfo()
	GetProductionData()
	GetTotals()
	SetTimer("PollGateway", gPollInterval * ONE_SECOND)
end

function InitGateway()
	local serviceName = "_enphase-envoy._tcp.local"
	dbg("Starting MDNS query of " .. serviceName)
	local res = mdns_query(serviceName)
	if (res) then
		for k,v in pairs(res) do
			for k1,v1 in pairs(v) do
				if (k1 == "ipv4") then
					dbg("Gateway found: " .. v1)
					gEnvoyAddress = v1
					APIBase = "http://" .. gEnvoyAddress
					PersistData.IP = gEnvoyAddress
					gDiscovered = true
					GetGatewayInfo()
					GetProductionData()
					GetTotals()
				end
			end
		end
	else
		dbg("No MDNS result")
		gDiscovered = false
	end
end

function GetGatewayInfo()
	local url = MakeURL("/info")
	HEADERS["Content-Type"] = "application/xml"
	urlGet(url, HEADERS, GetDataResponse, { data_type = "gateway-info" }, OPTIONS)
end

function GetProductionData()
	if (gNeedAuth == true) and (gAuth == false) then return end
	if (gNeedAuth == true) and (gAuth == true) then
		if (gAuthToken == nil) then
			dbg("GetProductionData(): No Auth Token yet, not continuing.")
			return
		elseif (type(gAuthToken) ~= "string") then
			dbg("GetProductionData(): No Auth Token yet, not continuing.")
			return
		else
			HEADERS["Authorization"] = "Bearer " .. gAuthToken
		end
	end
	local url = MakeURL(ReadingsURI)
	HEADERS["Content-Type"] = "application/json"
	urlGet(url, HEADERS, GetDataResponse, { data_type = "solar-production" }, OPTIONS)
end

function GetTotals()
	if (gNeedAuth == true) and (gAuth == false) then return end
	if (gNeedAuth == true) and (gAuth == true) then
		if (gAuthToken == nil) then
			dbg("GetProductionData(): No Auth Token yet, not continuing.")
			return
		elseif (type(gAuthToken) ~= "string") then
			dbg("GetProductionData(): No Auth Token yet, not continuing.")
			return
		else
			HEADERS["Authorization"] = "Bearer " .. gAuthToken
		end
	end
	local url = MakeURL("/production.json")
	HEADERS["Content-Type"] = "application/json"
	urlGet(url, HEADERS, GetDataResponse, { data_type = "solar-totals" }, OPTIONS)
end

function GetDataResponse(strError, responseCode, tHeaders, data, context, url)
	if (strError) then
		dbg("Error GetDataResponse: " .. strError)
		if string.find("timeout", strError) then
			if (context["data_type"] == "gateway-info") then
				dbg("Retrying command...")
				GetGatewayInfo()
			elseif (context["data_type"] == "solar-production") then
				dbg("Retrying command...")
				GetProductionData()
			elseif (context["data_type"] == "solar-totals") then
				dbg("Retrying command...")
				GetTotals()
			end
		end
		return
	end
	if (responseCode == 200) then
		if (context["data_type"] == "gateway-info") then
			local t = C4:ParseXml(data)
			local sn = ""
			local pn = ""
			local ver = ""
			for _, v in pairs(t.ChildNodes) do
				if (v.Name == "device") then
					for _, value in pairs(v.ChildNodes) do
						if (value.Name == "sn") then
							sn = value.Value
							gEnvoySerial = sn
							PersistData.Serial = gEnvoySerial
							ENPHASE.SerialNumber(sn)
						elseif (value.Name == "pn") then
							pn = value.Value
							ENPHASE.PartNumber(pn)
						elseif (value.Name == "software") then
							ver = value.Value
							check_ver = tonumber(string.sub(ver, 2, 2))
							if (check_ver < 7) then -- version 4/5 doesnt require https or auth
								PersistData.Version = 4
								APIBase = "http://" .. gEnvoyAddress
								ReadingsURI = "/production.json"
								gAuth = true
								gNeedAuth = false
							else -- version 7 or higher requires https and auth
								PersistData.Version = 7
								APIBase = "https://" .. gEnvoyAddress
								ReadingsURI = "/ivp/meters/readings"
								gNeedAuth = true
								if (gAuthToken == nil) then CreateAuth() end
							end
							if (gInit == false) then gInit = true end
							ENPHASE.SoftwareVersion(ver)
						end
					end
				end
			end
		elseif (context["data_type"] == "solar-production") then
			local production_now
			local consumption_now
			if (ReadingsURI == "/production.json") then
				production_now = data["production"][2]["wNow"]
				consumption_now = data["consumption"][1]["wNow"]
				ENPHASE.Production(production_now)
				ENPHASE.Consumption(consumption_now)
				ENPHASE.Grid(production_now, consumption_now)
				ENPHASE.Excess(production_now, consumption_now)
			else
				data = C4:JsonDecode(data)
				production_now = data[1]["activePower"]
				consumption_now = data[2]["activePower"]
				ENPHASE.Production(production_now)
				local consumption_calc = tonumber(production_now) + tonumber(consumption_now)
				ENPHASE.Consumption(consumption_calc)
				ENPHASE.Grid(consumption_calc, production_now)
				ENPHASE.Excess(production_now, consumption_calc)
			end
		elseif (context["data_type"] == "solar-totals") then
			local production_today = data["production"][2]["whToday"]
			local consumption_today = data["consumption"][1]["whToday"]
			ENPHASE.DailyProduction(production_today)
			ENPHASE.DailyConsumption(consumption_today)
		end
	elseif (responseCode == 400) then
		dbg("GetDataResponse: " .. context.data_type .. " Error 400.")
	elseif (responseCode == 401) then
		dbg("GetDataResponse: " .. context.data_type .. " Error 401.")
		gAuthToken = nil
		CreateAuth()
	elseif (responseCode == 404) then
		dbg("GetDataResponse: " .. context.data_type .. " Error 404.")
	end
end

function CreateAuth()
	if (gEnvoySerial == nil) or (gEnvoySerial == "") then return end
	if (gAuthUser == nil) or (gAuthPass == nil) then return end
	if (gAuthUser == "") or (gAuthPass == "") then return end
	if (gAuthToken) then return end
	local sessionTable = {
		user = {
			email = gAuthUser,
			password = gAuthPass
		}
	}
	local sessionData = C4:JsonEncode(sessionTable)
	HEADERS["Content-Type"] = "application/json"
	urlPost(SessionURI, sessionData, HEADERS, function(strError, responseCode, tHeaders, responseData, context, url)
			if (strError) then
				print("Error getting Session ID: " .. strError)
				return
			end
			gSessionID = responseData['session_id']
			PersistData.SessionID = gSessionID
			local tokenTable = {
				session_id = responseData['session_id'],
				serial_num = gEnvoySerial,
				username = gAuthUser
			}
			local tokenData = C4:JsonEncode(tokenTable)
			urlPost(TokenURI, tokenData, HEADERS, function(strError, responseCode, tHeaders, responseData, context, url)
					if (strError) then
						print("Error getting Token: " .. strError)
						return
					end
					gAuthToken = responseData
					PersistData.Token = gAuthToken
					gAuth = true
					gNeedAuth = true
				end, nil, nil)
		end, nil, nil)
end

function ENPHASE.SerialNumber(data)
	C4:UpdateProperty("Serial Number", data)
end

function ENPHASE.PartNumber(data)
	C4:UpdateProperty("Part Number", data)
end

function ENPHASE.SoftwareVersion(data)
	C4:UpdateProperty("Software Version", data)
end

function ENPHASE.Production(data)
	local value = string.format("%.2f", data / 1000)
	C4:SetVariable("PRODUCTION_KW", value)
	C4:UpdateProperty("Production (kW)", tostring(value))
end

function ENPHASE.Consumption(data)
	local value = string.format("%.2f", data / 1000)
	C4:SetVariable("CONSUMPTION_KW", value)
	C4:UpdateProperty("Consumption (kW)", tostring(value))
end

function ENPHASE.Grid(consumption_now, production_now)
	if (consumption_now and production_now) then
		local data = 0
		if (ReadingsURI == "/production.json") then
			data = tonumber(production_now) - tonumber(consumption_now)
		else
			data = tonumber(consumption_now) - tonumber(production_now)
		end
		local value = string.format("%.2f", data / 1000)
		C4:SetVariable("GRID_POWER_KW", value)
		C4:UpdateProperty("Grid (kW)", tostring(value))
	end
end

function ENPHASE.DailyProduction(data)
	local value = string.format("%.2f", data / 1000)
	C4:SetVariable("DAILY_ENERGY_PRODUCTION_KWH", value)
	C4:UpdateProperty("Production Today (kWh)", tostring(value))
end

function ENPHASE.DailyConsumption(data)
	local value = string.format("%.2f", data / 1000)
	C4:SetVariable("DAILY_ENERGY_CONSUMPTION_KWH", value)
	C4:UpdateProperty("Consumption Today (kWh)", tostring(value))
end

function ENPHASE.Excess(consumption_now, production_now)
	if (consumption_now and production_now) then
		local value = tonumber(consumption_now) - tonumber(production_now)
		local excess = "0"
		if (value < 0) then
			excess = "0"
			value = "0.00"
		else
			excess = "1"
			value = string.format("%.2f", value / 1000)
		end
		C4:SetVariable("EXCESS_SOLAR", excess)
		C4:SetVariable("EXCESS_SOLAR_KW", value)
		C4:UpdateProperty("Excess Solar (kW)", tostring(value))
	end
end
