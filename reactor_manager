local dirCell = "left" -- direction of the energy cell
local dirMonitor = "top" -- direction of the advanced monitor
local reactor = peripheral.wrap('BigReactors-Reactor_0')

local cell = peripheral.wrap(dirCell)
local cellMaxEnergy = cell.getMaxEnergyStored(dirCell)
local monitor = peripheral.wrap(dirMonitor)

function setHeadings()
	-- requires a 3x2 colour monitor
	monitor.setCursorPos(1,1)
	monitor.clearLine()
	monitor.setTextColor(colors.red)
	monitor.write("Big Reactor status")
	
	local isActive = reactor.getActive()
	if isActive == true then
		monitor.write("      ON")
	else
		monitor.write("     OFF")
	end
end

function updateValues()
	--get the values and round them to 1 decimal.  The rounding is not working!
	energyCell_temp = cell.getEnergyStored(dirCell)
	energyCell = tonumber( string.format("%.1f", energyCell_temp/1000000, 10) ) --mRF
	levelCell_temp = (energyCell_temp/cellMaxEnergy)*100
	levelCell = tonumber( string.format("%.1f", levelCell_temp), 10 )
	
	energyReactor_temp = reactor.getEnergyStored()
	energyReactor = tonumber( string.format("%.1f", energyReactor_temp/1000000, 10) ) --mRF
	levelReactor_temp = (energyReactor_temp/10000000)*100 --divided by the reactor capacity
	levelReactor = tonumber(string.format("%.1f", levelReactor_temp), 10)
	
	power = tonumber( string.format("%.1f", reactor.getEnergyProducedLastTick()/1000), 10 ) --kRF/t
	
	fuel_temp = reactor.getFuelAmount()  --mB
	fuel = tonumber( string.format("%.1f", valFuel_temp), 10 )
	fuelPercent =  tonumber( string.format("%.1f", (valFuel_temp/reactor.getFuelAmountMax())*100), 10 )
end

function drawMonitorLine(a, b, c) --a = line number on monitor (num), b = label (string), c = what needs to be written (string)
	monitor.setCursorPos(1,a)
	monitor.clearLine()
	monitor.setTextColor(colors.yellow)
	monitor.write(b)
	monitor.setTextColor(colors.white)
	monitor.write(c)
end

function updateMonitor()
	updateValues()
	
	drawMonitorLine(4, "Energy cell: ", energyCell.." mRF ("..levelCell.."%)")
	drawMonitorLine(6, "Reactor energy: ", energyReactor.." mRF ("..levelReactor.."%)")
	drawMonitorLine(7, "Power: ", power.." kRF/t")
	drawMonitorLine(8, "Fuel: ", fuel.." mB ("..fuelPercent.."%)")
end

------------------
setHeadings()

while true do
	updateMonitor()
	
	if levelCell <= 10 then
		reactor.setActive = True
		setHeadings()
	else
		if levelReactor >= 90 then
			reactor.setActive = False
			setHeadings()
		end
	end
	
	-- just an arbitrary sleep time
	-- I don't know if having no sleep time will affect performance in-game, so I set it just in case
	-- Should it be changed?
	sleep(2)
end
