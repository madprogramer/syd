module syd

#Imports
include("./SydEar.jl")

#Import Namespaces
using .SydEar

#Basic,
#Basically for trying basic things 
function basic()
	SydEar.startListening()
end

#Main Function Call
function main()
	
end

basic()
# main()
end