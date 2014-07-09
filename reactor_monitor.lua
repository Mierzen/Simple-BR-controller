local dirMonitor = "right" -- direction of the advanced monitor
local dirModem = "back"

local monitor = peripheral.wrap(dirMonitor)
modem = peripheral.wrap(dirModem)

function updateValues()
	isActive = stats.isActive
	energyCell = stats.energyCell
	levelCell = stats.levelCell
	energyReactor = stats.energyReactor
	levelReactor = stats.levelReactor
	power = stats.power
	fuel = stats.fuel
	fuelPercent = stats.fuelPercent
end

function setHeadings()
	-- requires a 3x2 colour monitor
	monitor.setCursorPos(1,1)
	monitor.clearLine()
	monitor.setTextColor(colors.red)
	monitor.write("Big Reactor status")
	
	if isActive == true then
		monitor.write("      ON")
	else
		monitor.write("     OFF")
	end
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
	drawMonitorLine(4, "Energy cell: ", energyCell.." mRF ("..levelCell.."%)")
	drawMonitorLine(6, "Reactor energy: ", energyReactor.." mRF ("..levelReactor.."%)")
	drawMonitorLine(7, "Power: ", power.." kRF/t")
	drawMonitorLine(8, "Fuel: ", fuel.." mB ("..fuelPercent.."%)")
end




rednet.open(dirModem)
while true do
	print("listening")
  
	senderID, stats, protocol = rednet.receive()
	
	updateValues()
	setHeadings()
	updateMonitor()
	
end
