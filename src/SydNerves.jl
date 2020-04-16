module SydNerves

#Globals 
InputName = "Built-in Microphone"
OutputName = "Built-in Output"

#Imports
using FileIO

include("./SydMouth.jl")
#Import Namespaces
using .SydMouth

export understand

function understand(sound)
	#println("NOW I UNDERSTAND")
	SydMouth.sing(OutputName,sound)

	# savefile = "DeepSpeech/audio/2830-3980-0043.wav"
	savefile = "voicerecording.ogg"
	memorize(savefile, sound)

	#location = read(`pwd`,String)
	#println(location)
	#testRun = read(`DeepSpeech/deepspeech`, String)
	#println( testRun )
	wordsUnderstood = read(`DeepSpeech/deepspeech --model DeepSpeech/models/output_graph.pbmm --audio $savefile`, String)
	println( wordsUnderstood )
	SydMouth.say(OutputName,wordsUnderstood)
end

function memorize(filename, sound)
	save(filename,sound)
end

end