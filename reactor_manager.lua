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

function round(number, places)
	local exp = 10 ^ places
	return (math.floor(number*exp)+0.5) / exp
end

function updateValues()
	--get the values and round them to 1 decimal.  The rounding is not working!
	energyCell_temp = cell.getEnergyStored(dirCell)
	energyCell = round(energyCell_temp/1000000, 1) --mRF
	levelCell_temp = (energyCell_temp/cellMaxEnergy)*100
	levelCell = round(levelCell_temp, 1)
	
	energyReactor_temp = reactor.getEnergyStored()
	energyReactor = round(energyReactor_temp/1000000, 1) --mRF
	levelReactor_temp = (energyReactor_temp/10000000)*100 --divided by the reactor capacity
	levelReactor = round(levelReactor_temp, 1)
	
	power = round(reactor.getEnergyProducedLastTick()/1000, 1) --kRF/t
	
	fuel_temp = reactor.getFuelAmount()  --mB
	fuel = round(valFuel_temp, 1)
	fuelPercent =  round((valFuel_temp/reactor.getFuelAmountMax())*100, 1)
end

function drawMonitorLine(line, label, inscription) --a = line number on monitor (num), b = label (string), c = what needs to be written (string)
	monitor.setCursorPos(1,line)
	monitor.clearLine()
	monitor.setTextColor(colors.yellow)
	monitor.write(label)
	monitor.setTextColor(colors.white)
	monitor.write(inscription)
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
		reactor.setActive(True)
		setHeadings()
	else
		if levelReactor >= 90 then
			reactor.setActive(False)
			setHeadings()
		end
	end
	
	-- just an arbitrary sleep time
	-- I don't know if having no sleep time will affect performance in-game, so I set it just in case
	-- Should it be changed?
	sleep(5)
end
