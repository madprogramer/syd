#TEMPORARY SOLUTION BEGIN

using Knet: Knet, AutoGrad, gpu, param, param0, mat, RNN, relu, Data, adam, progress, nll, zeroone

# chain of layers
struct Chain
    layers
    Chain(layers...) = new(layers)
end
(c::Chain)(x) = (for l in c.layers; x = l(x); end; x)
(c::Chain)(x,y) = nll(c(x),y)


# Redefine dense layer 
struct Dense; w; b; f; end
Dense(i::Int,o::Int,f=identity) = Dense(param(o,i), param0(o), f)
(d::Dense)(x) = d.f.(d.w * mat(x,dims=1) .+ d.b)

struct DenseRelu; w; b; f; end
DenseRelu(i::Int,o::Int,f=relu) = DenseRelu(param(o,i), param0(o), f)
(d::DenseRelu)(x) = d.f.(d.w * mat(x,dims=1) .+ d.b)

#TEMPORARY FIX END

module syd

# Makie

using Makie
import AbstractPlotting: pixelarea

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


#include("./EmRec.jl")
#using .EmRec

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
		SydNerves.understand(SydEar.waitAndListen(InputName,trackupdates=false))
	end
end

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function test()
	read(`osascript AppleScripts/Pause.applescript`)
	run(`osascript AppleScripts/Play.applescript`)
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


function dummy()
	SydNerves.updateTrack()
end

function dummy2()
	return
end

#Take Action
function act(state, DISPLAYSCENE)

#Start Up
if state  == "startUp"
	R = SydNerves.init()
	if R==-1 exit() end
	SydMouth.say(OutputName,"syd is now Ready!")
	println("syd is now Ready!")
	state = "idle"
#Idling
elseif state == "idle"
	#println("Idling")
	state = SydNerves.understand(SydEar.waitAndListen(InputName,dummy2),state)
#PlayingSong
elseif state  == "playingSong"
	state = SydNerves.understand(SydEar.waitAndListen(InputName,dummy),state)
#PausedSong
elseif state == "pausedSong"
	state = SydNerves.understand(SydEar.waitAndListen(InputName,dummy),state)
end

#Return Last State
return state end


#Main Function Call
function main()
MENTALSTATE = "startUp"
while true

	#GET A NEW SCENE
	DISPLAYSCENE = Scene(resolution=(900,1600))

	#Experiment using IJulia!

	MENTALSTATE=act(MENTALSTATE,DISPLAYSCENE)
end
end


# basic()
main()

# test()
end