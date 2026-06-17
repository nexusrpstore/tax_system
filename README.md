# tax_system
taxing system for fivem (qbcore,esx,qbox,standalone)

# Government Tax System

## Overview

Government Tax System is a lightweight economy management resource for FiveM that automatically collects taxes from player bank accounts.

Designed for ESX and QBCore servers, this script helps reduce inflation by creating realistic recurring expenses such as:

* Federal Taxes
* Property Taxes
* Trash Collection Fees
* Spending Taxes
* Tax Debt Tracking

---

## Features

✅ ESX Support

✅ QBCore Support

✅ Automatic Tax Collection

✅ Bank Account Taxation

✅ Spending-Based Tax System

✅ Property Taxes

✅ Trash Collection Fees

✅ Tax Debt Tracking

✅ Database Integration

✅ Startup Logging

✅ Configurable Tax Brackets

✅ Framework Auto Functions

---

## Installation

### 1. Upload Resource

Place the resource into your server resources folder.

Example:


resources/[standalone]/government_tax


### 2. Import SQL

Run:


CREATE TABLE IF NOT EXISTS tax_debt (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60),
    amount INT NOT NULL,
    reason VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


### 3. Add To Server Config


ensure government_tax


### 4. Configure Framework

Inside `config.lua`

ESX:


Config.Framework = 'esx'


QBCore:


Config.Framework = 'qbcore'

---

## Configuration

### Collection Time

Minutes between tax collections.


Config.CollectionTime = 30


Example:


Config.CollectionTime = 7200


Collect taxes every 5 days.

---

### Trash Fee


Config.TrashFee = 50


---

### Property Tax


Config.PropertyTax = {
    House = 250
}


---

### Spending Tax


Config.SpendingTaxPercent = 5


Players pay 5% of tracked spending.

---

### Federal Tax Brackets

Example:


Config.FederalBrackets = {
    { max = 10000, rate = 0.25 },
    { max = 50000, rate = 0.50 },
    { max = 100000, rate = 0.75 },
    { max = 500000, rate = 1.00 },
    { max = 10000000, rate = 1.00 }
}


A player with $1,000,000 in the bank would pay approximately:

Federal Tax: $10,000


---

## Commands

### /taxes

Displays:

* Federal Tax
* Spending Tax
* Property Tax
* Trash Fee
* Estimated Total

Example:


Federal Revenue Service

Federal Tax: $10,000
Spending Tax: $500
Property Tax: $250
Trash Fee: $50

Estimated Total: $10,800


---

## Export

Track spending from other resources:


exports['government_tax']:AddSpending(
    source,
    amount
)


Example:


exports['government_tax']:AddSpending(
    source,
    5000
)


The player will then be taxed based on the configured SpendingTaxPercent.

---

## Tax Debt

If a player cannot afford taxes:

* Taxes are not collected.
* Debt is stored in the database.
* Debt can be reviewed later.
* Future updates may include:

  * Tax Warrants
  * Property Seizures
  * Business Closures
  * Vehicle Registration Suspensions

---

## Console Startup

Example:
[Government Tax] Starting Resource...
[Government Tax] Loading Configuration...
[Government Tax] Connecting Framework...
[Government Tax] ESX Framework Detected
[Government Tax] Connecting Database...
[Government Tax] Database Connected
[Government Tax] Tax System Loaded Successfully
[Government Tax] Resource Ready


---

## Support

Frameworks Supported:

* ESX
* QBCore

Compatible with:

* oxmysql
* ESX Legacy
* Modern QBCore Builds

--

Created By Dakota Scripts
