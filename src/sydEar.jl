module SydEar

using PortAudio, SampledSignals, LibSndFile

# Makie

using Makie
import AbstractPlotting: pixelarea

#include("./sydNerves.jl")
#using .sydNerves

#Constants
listenDuration = 0.5s
maxDuration = 5s

export waitAndListen

louderThanNoise(x) = x > 0.01
square(x) = x^2;

#Wait until syd hears a sound
#Then begin capturing 0.5second frames for a maximum of 5 seconds
function waitAndListen(from, SCENECOMPONENTS, updateFunction::Function=nothing)
	println("Come on say something!")
	attention = false
	currentDuration = 0s

	PortAudioStream(from, 2, 0) do stream
		fullbuf = read(stream, 0s)
		lastbuf = read(stream, 0s)
        while(true)

            #Check for track updates
            if updateFunction != nothing
                # print("syd is now listening")
                delete!(SCENECOMPONENTS["listening"], SCENECOMPONENTS["listening"][end])
                text!(SCENECOMPONENTS["listening"],"syd is listening...",textsize=6 )

                updateFunction()
            end

        	#print(currentDuration)
            lastbuf = read(stream, listenDuration)
            if any(louderThanNoise, lastbuf) && currentDuration < maxDuration
                if !attention
                    #println("YOU DON't HAVE MY ATTENTION!")
                    attention = true
                    fullbuf = lastbuf
                else
                    # println("YOU HAVE MY ATTENTION!")
                    # println(fullbuf[:,1])
                    currentDuration += listenDuration
                    fullbuf = vcat(fullbuf,lastbuf)
                    #try updating buffer in realtime, try fullbuff only otherwise
                    delete!(SCENECOMPONENTS["sound"], SCENECOMPONENTS["sound"][end])
                    lines!(SCENECOMPONENTS["sound"], 1:length(fullbuf[:,1]), fullbuf[:,1], color="blue")[end]

                end
            elseif attention == false
                continue
            else
            	currentDuration += listenDuration
            	fullbuf = vcat(fullbuf,lastbuf)

                #print("BOI: ")
                #println(size(fullbuf))
                delete!(SCENECOMPONENTS["sound"], SCENECOMPONENTS["sound"][end])
                lines!(SCENECOMPONENTS["sound"], 1:length(fullbuf[:,1]), fullbuf[:,1], color="blue")[end]

                delete!(SCENECOMPONENTS["listening"], SCENECOMPONENTS["listening"][end])
                text!(SCENECOMPONENTS["listening"],"syd is thinking...",textsize=6 )

                #Update
                return fullbuf
            end
        end
    end

end

end