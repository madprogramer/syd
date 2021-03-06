module sydMain

#Imports
include("./sydEar.jl")
include("./sydMouth.jl")
include("./sydNerves.jl")

include("./sydBrain/States.jl")

#Import Namespaces
using .SydEar
using .SydMouth
using .SydNerves
using .States

#Globals 
InputName = "Built-in Microphone"
OutputName = "Built-in Output"

#Basic,
#Basically for trying basic things 
function basic()
	# SydEar.startListening()
	# SydMouth.say(OutputName,"Goo DAY")
	# SydEar.startListening(InputName)
	# SydMouth.say(OutputName,"Goo DAY")
	#SydEar.startListening(InputName)
	println("READY!")
	while true
		SydNerves.understand(SydEar.waitAndListen(InputName))
	end
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function test()
	read(`osascript AppleScripts/Pause.applescript`)
	run(`osascript AppleScripts/Play.applescript`)
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Take Action
function act(state)

#Start Up
if state  == "startUp"
	SydMouth.say(OutputName,"syd is now Ready!")
	println("syd is now Ready!")
	state = "idle"
#Idling
elseif state == "idle"
	#println("Idling")
	state = SydNerves.understand(SydEar.waitAndListen(InputName),state)
#PlayingSong
elseif state  == "playingSong"
	state = SydNerves.understand(SydEar.waitAndListen(InputName),state)
#PausedSong
elseif state == "pausedSong"
	state = SydNerves.understand(SydEar.waitAndListen(InputName),state)
end

#Return Last State
return state end


#Main Function Call
function main()
MENTALSTATE = "startUp"
while true
	MENTALSTATE=act(MENTALSTATE)
end
end


# basic()
main()

# test()
end