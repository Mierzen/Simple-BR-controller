local dirCell = "left" -- direction of the energy cell
local dirMonitor = "top" -- direction of the advanced monitor
local dirModem = "bottom"
local reactor = peripheral.wrap('BigReactors-Reactor_0')
local cell = peripheral.wrap(dirCell)
local cellMaxEnergy = cell.getMaxEnergyStored(dirCell)
local monitor = peripheral.wrap(dirMonitor)
local modem = peripheral.wrap(dirModem)

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
	return math.floor(number*exp+0.5) / exp
end

stats={}
function updateValues()
	energyCell_temp = cell.getEnergyStored(dirCell)
	energyCell = round(energyCell_temp/1000000, 1) --mRF
	levelCell_temp = (energyCell_temp/cellMaxEnergy)*100
	levelCell = round(levelCell_temp, 1)
	
	energyReactor_temp = reactor.getEnergyStored()
	energyReactor = round(energyReactor_temp/1000000, 1) --mRF
	levelReactor_temp = (energyReactor_temp/10000000)*100 --divided by the reactor capacity
	levelReactor = round(levelReactor_temp, 1)
	
	power = round(reactor.getEnergyProducedLastTick()/1000, 2) --kRF/t
	
	fuel_temp = reactor.getFuelAmount()  --mB
	fuel = round(fuel_temp, 1)
	fuelPercent =  round((fuel_temp/reactor.getFuelAmountMax())*100, 1)
	
stats.isActive = isActive
stats.energyCell = energyCell
stats.levelCell = levelCell
stats.energyReactor = energyReactor
stats.levelReactor = levelReactor
stats.power = power
stats.fuel = fuel
stats.fuelPercent = fuelPercent
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


rednet.open(dirModem)



setHeadings()
while true do
	updateMonitor()
	rednet.broadcast(stats)

	print("stats sent")
	
	-- local reactor = peripheral.wrap('BigReactors-Reactor_0')
	
	if levelCell <= 10 then
		reactor.setActive(true)
		setHeadings()
	else
		if levelReactor >= 90 then
			reactor.setActive(false)
			setHeadings()
		end
	end
	
	local sleepTime = 5
	monitor.setTextColor(colors.gray)
	for i=1,sleepTime do
		monitor.setCursorPos(i,10)
		monitor.write(".")
		sleep(1)
	end
	monitor.clearLine()
	monitor.setTextColor(colors.white)
end
