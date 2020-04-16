module SydNerves

#Globals 
InputName = "Built-in Microphone"
OutputName = "Built-in Output"

#Imports
include("./SydMouth.jl")

#Import Namespaces
using .SydMouth

export understand

function understand(sound)
	#println("NOW I UNDERSTAND")
	SydMouth.sing(OutputName,sound)
end

end