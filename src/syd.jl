module syd

#Globals 
InputName = "Built-in Microphone"
OutputName = "Built-in Output"

#Imports
include("./SydEar.jl")
include("./SydMouth.jl")
include("./SydNerves.jl")

#Import Namespaces
using .SydEar
using .SydMouth
using .SydNerves

#Basic,
#Basically for trying basic things 
function basic()
	# SydEar.startListening()
	# SydMouth.say(OutputName,"Goo DAY")
	# SydEar.startListening(InputName)
	# SydMouth.say(OutputName,"Goo DAY")
	#SydEar.startListening(InputName)
	while true
		SydNerves.understand(SydEar.waitAndListen(InputName))
	end
end

#Main Function Call
function main()
	
end

basic()
# main()
end