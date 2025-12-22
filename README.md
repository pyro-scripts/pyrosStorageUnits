# pyrosStorageUnits - Storage Unit System for QB-Core<br>
<br>
Showcase: https://youtu.be/R7MGx10wrjg<br>
Download: https://github.com/pyro-scripts/pyrosStorageUnits/releases/latest<br>
Github Page: https://github.com/pyro-scripts<br>
<br>

### Multiple Locations Supported<br>
- **2 Preconfigured Locations:** Strawberry (Under Olympic Fwy) & Bank on Route 68<br>
- **Easy to read configuration**<br>
- **Custom Blips for  each location and unit**<br>
- **Interactive NPCs**<br>
<br>
### Compatibility<br>
- **Notifications, Inventory System and Target System compatible with QB-Core & OX**<br>
-  **Compatible with *pyrosNotifs* for Notifications** https://github.com/pyro-scripts/pyrosNotifs/releases/latest<br>

# 📋 Installation Guide<br>
### 1. Database<br>
Execute the provided ***pyrosStorageUnits.sql*** file to create the required table:<br>
- storage_units<br>
### 2. Resource<br>
- Extract the zip file into your **resources** folder<br>
- Add to your `server.cfg`: `ensure pyrosStorageUnits`<br>
- Configure the settings in the **config.lua**<br>
- Restart your server<br>
### 3. Dependencies<br>
- qb-core - Currently qb-core is **required** to take money from the users account<br>
- qb-core, ox_lib *OR* pyrosNotifs<br>
- qb-target *OR* ox_target<br>
- qb-inventory *OR* ox_inventory
