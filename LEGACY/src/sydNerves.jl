module SydNerves

#Globals 
InputName = "Built-in Microphone"
OutputName = "Built-in Output"

#Imports
using FileIO
using WAV
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

#TEMP 
include("./EmRec.jl")
using .EmRec

export wakeUp, respondTo


#RESPONSE
function respondTo(understanding,state,emo)
	#println("Should respond to $(understanding)")

	heard = understanding["semantics"]

	#print(typeof(state), typeof(idle), state == "idle")

	if state == "idle"
		if occursin("HELLO",heard) || occursin("HI",heard) || occursin("YO",heard)
			if emo == "joy"
				SydMouth.say(OutputName,"You sure seem in good spirits today!")
			else
				SydMouth.say(OutputName,"Oh Hey!")
			end
		end
		if occursin("PLAY",heard)
			SydMouth.say(OutputName,"Unfortunately, I dunno a whole lot of songs, but let me see what I can do.")
			read(`osascript AppleScripts/Play.applescript`)
			read(`osascript AppleScripts/Play.applescript`)
			state="playingSong"
		end
	#PlayingSong
	elseif state == "playingSong"
		if occursin("PAUSE",heard)
			artistname = read(`osascript AppleScripts/GetArtist.applescript`)
			read(`osascript AppleScripts/Pause.applescript`)
			SydMouth.say(OutputName,"Ok, I paused.")
			if emo == "joy"
				SydMouth.say(OutputName,"You seem to like this song. It's by $(artistname). You might want to check them out.")
			end
			state="pausedSong"
		end
		if occursin("STOP",heard)
			read(`osascript AppleScripts/Stop.applescript`)
			SydMouth.say(OutputName,"As you wish.")
			state="idle"
		end
	#PausedSong
	elseif state == "pausedSong"
		if occursin("PLAY",heard)
			read(`osascript AppleScripts/Play.applescript`)
			SydMouth.say(OutputName,"Continuing...")
			state="playingSong"
		end
		if occursin("STOP",heard)
			read(`osascript AppleScripts/Stop.applescript`)
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
	savefile = "voicerecording.wav"
	memorize(savefile, sound)

	#location = read(`pwd`,String)
	#println(location)
	#testRun = read(`DeepSpeech/deepspeech`, String)
	#println( testRun )
	# wordsUnderstood = read(`DeepSpeech/deepspeech --model DeepSpeech/models/output_graph.pbmm --audio $savefile`, String)
	# println( wordsUnderstood )
	comprehension = SydBrain.comprehend(read(`DeepSpeech/deepspeech --model DeepSpeech/models/output_graph.pbmm --audio $savefile`, String))
	emo = EmRec.detect(savefile)
	#SydMouth.say(OutputName,wordsUnderstood)
	println(comprehension)
	println("Emotion read: $(emo)")

	return respondTo(comprehension,state,emo)
end

#Save a recording to a file
function memorize(filename, sound)
	#save(filename,sound)
	#save("${filename}.ogg",sound)
	#save("${filename}.wav",sound)
	#wavwrite(sound, filename, Fs=16000)
	wavwrite(sound, filename, Fs=44100)
end

# #Wake Up
# function wakeUp()
# 	SydBrain.wakeUp()
# 	while true
# 		SydBrain.act()
# 	end
# end

end