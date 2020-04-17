module SydNerves

#Globals 
InputName = "Built-in Microphone"
OutputName = "Built-in Output"

#Imports
using FileIO
include("./sydEar.jl")
include("./sydMouth.jl")
include("./sydBrain/sydBrain.jl")
include("./sydBrain/Commands.jl")
include("./sydBrain/States.jl")
#Import Namespaces
using .SydEar
using .SydMouth
using .SydBrain
using .Commands
using .States

export wakeUp, respondTo


#RESPONSE
function respondTo(understanding,state)
	#println("Should respond to $(understanding)")

	heard = understanding["semantics"]

	#print(typeof(state), typeof(idle), state == "idle")

	if state == "idle"
		if occursin("HELLO",heard) || occursin("HI",heard) || occursin("YO",heard)
			SydMouth.say(OutputName,"Oh Hey!")
		end
		if occursin("PLAY",heard)
			SydMouth.say(OutputName,"Unfortunately, I dunno a whole lot of songs, but let me see what I can do.")
			state="playingSong"
		end
	#PlayingSong
	elseif state == "playingSong"
		if occursin("PAUSE",heard)
			SydMouth.say(OutputName,"Ok, I paused.")
			state="pausedSong"
		end
		if occursin("STOP",heard)
			SydMouth.say(OutputName,"As you wish.")
			state="idle"
		end
	#PausedSong
	elseif state == "pausedSong"
		if occursin("PLAY",heard)
			SydMouth.say(OutputName,"Continuing...")
			state="playingSong"
		end
		if occursin("STOP",heard)
			SydMouth.say(OutputName,"As you wish")
			state="idle"
		end
	end

	return state
end

#What words does syd understand this recording as
function understand(sound,state)
	#println("NOW I UNDERSTAND")
	#SydMouth.sing(OutputName,sound)

	# savefile = "DeepSpeech/audio/2830-3980-0043.wav"
	savefile = "voicerecording.ogg"
	memorize(savefile, sound)

	#location = read(`pwd`,String)
	#println(location)
	#testRun = read(`DeepSpeech/deepspeech`, String)
	#println( testRun )
	# wordsUnderstood = read(`DeepSpeech/deepspeech --model DeepSpeech/models/output_graph.pbmm --audio $savefile`, String)
	# println( wordsUnderstood )
	comprehension = SydBrain.comprehend(read(`DeepSpeech/deepspeech --model DeepSpeech/models/output_graph.pbmm --audio $savefile`, String))
	#SydMouth.say(OutputName,wordsUnderstood)
	println(comprehension)

	return respondTo(comprehension,state)
end

#Save a recording to a file
function memorize(filename, sound)
	save(filename,sound)
end

# #Wake Up
# function wakeUp()
# 	SydBrain.wakeUp()
# 	while true
# 		SydBrain.act()
# 	end
# end

end