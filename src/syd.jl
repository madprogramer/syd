module syd

#Imports
include("./SydEar.jl")
include("./SydMouth.jl")

#Import Namespaces
using .SydEar
using .SydMouth

#Basic,
#Basically for trying basic things 
function basic()
	#SydEar.startListening()
	SydMouth.say("G'DAY")
	SydEar.startListening()
end

#Main Function Call
function main()
	
end

basic()
# main()
end