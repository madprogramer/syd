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
		SydNerves.understand(SydEar.waitAndListen(InputName,SCENECOMPONENTS,trackupdates=false))
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
function act(state, SCENECOMPONENTS)

#Start Up
if state  == "startUp"
	delete!(SCENECOMPONENTS["status"], SCENECOMPONENTS["status"][end])
	text!(SCENECOMPONENTS["status"],"Loading...",textsize=6 )
	R = SydNerves.init()
	if R==-1 exit() end
	SydMouth.say(OutputName,"syd is now Ready!")
	# println("syd is now Ready!")
	state = "idle"
#Idling
elseif state == "idle"
	#println("Idling")
	delete!(SCENECOMPONENTS["status"], SCENECOMPONENTS["status"][end])
	text!(SCENECOMPONENTS["status"],"Ready",textsize=6 )
	state = SydNerves.understand(SydEar.waitAndListen(InputName,SCENECOMPONENTS,dummy2),state)
#PlayingSong
elseif state  == "playingSong"
	delete!(SCENECOMPONENTS["status"], SCENECOMPONENTS["status"][end])
	text!(SCENECOMPONENTS["status"],"Playing",textsize=6 )
	state = SydNerves.understand(SydEar.waitAndListen(InputName,SCENECOMPONENTS,dummy),state)
#PausedSong
elseif state == "pausedSong"
	delete!(SCENECOMPONENTS["status"], SCENECOMPONENTS["status"][end])
	text!(SCENECOMPONENTS["status"],"Paused",textsize=6 )
	state = SydNerves.understand(SydEar.waitAndListen(InputName,SCENECOMPONENTS,dummy),state)
end

#Return Last State
return state end


#Main Function Call
function main()
MENTALSTATE = "startUp"

#GET A NEW SCENE USING MAKIE
DISPLAYSCENE = Scene(resolution=(900,1200))
SCENECOMPONENTS = Dict()
#Excitement Tracker
area1 = map(pixelarea(DISPLAYSCENE)) do hh
    pad, w, h = 30, 870, 185
    FRect(Point2f0(30, 30), Point2f0(w,h))
end

#Voice Tracker
area2 = map(pixelarea(DISPLAYSCENE)) do hh
    pad, w, h = 30, 870, 185
    FRect(Point2f0(30, h+2*pad), Point2f0(w,h))
end

#Syd is listening/thinking indicator
area3 = map(pixelarea(DISPLAYSCENE)) do hh
    pad, w, h = 30, 870, 185
    FRect(Point2f0(30, 2*h+2*pad), Point2f0(w,h))
end

#Add confidence

#Misc. Text

#Syd is listening/thinking indicator
area4 = map(pixelarea(DISPLAYSCENE)) do hh
    pad, w, h = 30, 870, 185
    FRect(Point2f0(30, 3*h+2*pad), Point2f0(w,h))
end

#Syd is listening/thinking indicator
area5 = map(pixelarea(DISPLAYSCENE)) do hh
    pad, w, h = 30, 870, 185
    FRect(Point2f0(30, 4*h+2*pad), Point2f0(w,h))
end

scene1 = Scene(DISPLAYSCENE, area1)
scene2 = Scene(DISPLAYSCENE, area2)
scene3 = Scene(DISPLAYSCENE, area3)
scene4 = Scene(DISPLAYSCENE, area4)
scene5 = Scene(DISPLAYSCENE, area5)

lines!(scene1, 1:100, rand(100),color="orange")[end]
lines!(scene2, 1:100, rand(100), color="blue")[end]
text!(scene3,"Society",textsize=6,show_axis=false )
#lines!(scene3, 1:100, rand(100), color="blue")[end]
#lines!(scene4, 1:100, rand(100), color="red")[end]
text!(scene4,"Initializing...",textsize=6,show_axis=false )
text!(scene5," ",textsize=5,show_axis=false )
#syd is listening...

SCENECOMPONENTS["excitement"] = scene1
SCENECOMPONENTS["sound"] = scene2
SCENECOMPONENTS["text"] = scene3
SCENECOMPONENTS["status"] = scene4
SCENECOMPONENTS["listening"] = scene5

#DISPLAYSCENE
display(DISPLAYSCENE)
while true
	MENTALSTATE=act(MENTALSTATE,SCENECOMPONENTS)
end

end


# basic()
main()

# test()
end