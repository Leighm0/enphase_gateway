![Enphase Logo](./icons/enphase_logo.png)

# Enphase Envoy/IQ Gateway Solar Driver

## Overview

This driver is used to get the solar values from an Enphase Envoy/IQ Gateway unit. It stores the values in variables, so you can do any kind of programming with it. Also the driver provides a simple webview, where you can see the values.

Following values are supported:
- Consumption
- Solar Production
- Grid Power
- Excess Solar
- Total values for the day (Production & Consumption)

### Envoy/IQ Gateway requirements

An Enphase Envoy S (Metered) or IQ Gateway is required, this will not work with the Standard (Non-metered) Gateways.

Supported Models:
- IQ Gateway
- Envoy S Metered

### Configuring the driver

Enter your Enphase Enlighten Username (e-mail) and Password (**Required if your Envoy is running firmware version 7 or higher**).

#### Properties

**Driver Version**	
Shows the version of the driver.

**Debug Mode**	
Set debug mode to On or Off.

**Polling Interval**	
Choose the time in seconds at which the Gateway should be read for updated data.

**Username**	
Your Enlighten Username. **Required if firmware is v7 or higher**

**Password**	
Your Enlighten Password. **Required if firmware is v7 or higher**

**Serial Number (read-only)**	
Serial number of your Gateway.

**Part Number (read-only)**	
Part number of your Gateway.

**Software Version (read-only)**	
Current software version running on your Gateway.

**Production (kW) (read-only)**	
Production from the solar panels.

**Consumption (kW) (read-only)**	
Consumption of all loads.

**Grid (kW) (read-only)**	
Power from or to the grid.

**Production Today (kWh) (read-only)**	
Total solar power produced today.

**Consumption Today (kWh) (read-only)**	
Total power used today in your home (both solar and grid, if any).

**Excess Solar (kW) (read-only)**	
Current excess solar available for use.

#### Variables

**PRODUCTION_KW (Int)**	
Power in kW from the solar panels.  

**CONSUMPTION_KW (Int)**	
Consumption of all loads in kW.

**GRID_POWER_KW (Int)**	
Power in kW from or to the grid.  

**DAILY_ENERGY_PRODUCTION_KWH (Int)**	
Daily energy produced in kWh.  

**DAILY_ENERGY_CONSUMPTION_KWH (Int)**	
Daily energy consumed in kWh.  

**EXCESS_SOLAR (Bool)**	
If there is currently excess solar.

**EXCESS_SOLAR_KW (Int)**	
Excess energy available in kW.

### Limitations

- Daily energy kWh grid import/export totals are not available currently.

### Change Log

- **v1**
  - Initial release
  
- **v2**
  - Added MDNS discovery of Envoy Gateway
  
- **v3**
  - Changed to using different URLs for data (will swap to Stream/websocket data later)

- **v4**
  - Added Authorization option for Envoy version 7 or higher

- **v5**
  - Additional settings/changes for Authorization

- **v6**
  - Additional settings/changes for Authorization

- **v7**
  - Add Envoy Readings URL selection
  
- **v8**
  - Bug fixes
  
- **v9**
  - Bug fixes

- **v10**
  - Fix for ivp/meters/readings data
  
- **v11**
  - Update to WebView design

- **v12**
  - Update to UI Icon and WebView design

- **v13**
  - Bug fix for version check

- **v14**
  - Bug fix for authentication and session token problem

- **v15**
  - Revamped WebView to use watched Variables instead of DataToUI
