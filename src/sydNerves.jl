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

export wakeUp, respondTo, init, updateTrack

#Globals
lastTrackPlaying = ""
lastTrackScore = 0
SongList = zeros(0)
GenreList = zeros(0)
ArtistList = zeros(0)
SongScores = zeros(0)
#Predictions =

function updateTrack()
	global lastTrackPlaying
	global lastTrackScore
	currentTrackPlaying = String(read(`osascript AppleScripts/GetName.applescript`))
	if currentTrackPlaying != lastTrackPlaying
		println("Track changed to $(currentTrackPlaying)")
		println("Previous track: $(lastTrackPlaying),\nScore: $(lastTrackScore)")
		println("SAVE THESE SCORES SOMEWHERE!!!")
		lastTrackPlaying = currentTrackPlaying
		lastTrackScore = 0
	end
end

function updateVolume(heard)
	if occursin("VOLUME",heard) || occursin("SOUND",heard) || occursin("PLAY",heard) || occursin("SONG",heard)
		println("VOLUME COMMAND RECEIVED")

		#MUTE
		if occursin("MUTE",heard) || occursin("QUIET",heard)
			run(`osascript AppleScripts/VolumeMute.applescript`)
			return true
		#LOWER
		elseif occursin("DOWN",heard) || occursin("LOWER",heard)
			run(`osascript AppleScripts/VolumeLower.applescript`)
			return true
		#RAISE
		elseif occursin("RAISE",heard) || occursin("UP",heard) || occursin("LOUDER",heard)
			run(`osascript AppleScripts/VolumeRaise.applescript`)
			return true
		end
	else
		#MUTE
		if occursin("MUTE",heard) || occursin("QUIET",heard)
			run(`osascript AppleScripts/VolumeMute.applescript`)
			return true
		#LOWER
		elseif occursin("DOWN",heard) || occursin("LOWER",heard)
			run(`osascript AppleScripts/VolumeLower.applescript`)
			return true
		#RAISE
		elseif occursin("RAISE",heard) || occursin("UP",heard) || occursin("LOUDER",heard)
			run(`osascript AppleScripts/VolumeRaise.applescript`)
			return true
		end
	end

	return false
end


#USE THIS TO SCAN ALL THE SONGS IN THE syd PLAYLISY
function init()

	global SongList,SongScores

	#Check if syd playlist exists
	#println("AM I SCANNING ALL THE SONGS?")

	k = String(read(`osascript AppleScripts/GetSongNames.applescript`))

	if k=="-1" 
		SydMouth.say(OutputName,"Oh dear! Your Music App appears to be missing a playlist named syd. Please add your songs there first, before using me! Good bye.")
		return -1 
	end

	SongList = split( chomp(String(k)) ,r", ")
	GenreList = split( chomp(String(read(`osascript AppleScripts/GetGenres.applescript`))) ,r", ")
	ArtistList = split( chomp(String(read(`osascript AppleScripts/GetArtists.applescript`))) ,r", ")

	SongScores = zeros(size(SongList,1))

	println(SongList)
	println(GenreList)
	println(ArtistList)
	println(SongScores)

end

#RESPONSE
# function respondTo(understanding,state,emo)
# 	global lastTrackPlaying
# 	global lastTrackScore

# 	#println("Should respond to $(understanding)")

# 	heard = understanding["semantics"]

# 	#print(typeof(state), typeof(idle), state == "idle")

# 	if state == "idle"
# 		if occursin("HELLO",heard) || occursin("HI",heard) || occursin("YO",heard)
# 			if emo == "joy"
# 				SydMouth.say(OutputName,"You sure seem in good spirits today!")
# 			else
# 				SydMouth.say(OutputName,"Oh Hey!")
# 			end
# 		end
# 		if occursin("PLAY",heard)
# 			SydMouth.say(OutputName,"Unfortunately, I dunno a whole lot of songs, but let me see what I can do.")
# 			read(`osascript AppleScripts/Play.applescript`)
# 			read(`osascript AppleScripts/Play.applescript`)
# 			lastTrackPlaying = String(read(`osascript AppleScripts/GetName.applescript`))
# 			lastTrackScore = 0
# 			println("NOW PLAYING $(lastTrackPlaying)")
# 			state="playingSong"
# 		end
# 	#PlayingSong
# 	elseif state == "playingSong"

# 		#CHECK IF SONG CHANGED
# 		#WE'RE BEING LAZY, IF SONG CHANGED BETWEEN AND NEITHER USER OR SYD NOTICE
# 		#IT'S EQUIVALENT TO GIVING IT A 0

# 		updateTrack()

# 		#COMMANDS
# 		if occursin("PAUSE",heard) or occursin("BACK",heard)
# 			artistname = String(read(`osascript AppleScripts/GetArtist.applescript`))
# 			read(`osascript AppleScripts/Pause.applescript`)
# 			SydMouth.say(OutputName,"Ok, I paused.")
# 			if emo == "joy"
# 				SydMouth.say(OutputName,"You seem to like this song. It's by $(artistname). You might want to check them out.")
# 			end
# 			state="pausedSong"
# 		end
# 		if occursin("STOP",heard)
# 			read(`osascript AppleScripts/Stop.applescript`)
# 			SydMouth.say(OutputName,"As you wish.")
# 			state="idle"
# 		end

# 		#INSERT VOLUME UP

# 		#INSERT VOLUME DOWN

# 		#INSERT SONG INFO

# 		#INSERT REWIND

# 		#INSERT SKIP

# 	#PausedSong
# 	elseif state == "pausedSong"
# 		if occursin("PLAY",heard)
# 			read(`osascript AppleScripts/Play.applescript`)
# 			SydMouth.say(OutputName,"Continuing...")
# 			state="playingSong"
# 		end
# 		if occursin("STOP",heard)
# 			read(`osascript AppleScripts/Stop.applescript`)
# 			SydMouth.say(OutputName,"As you wish")
# 			state="idle"
# 		end
# 	end

# 	return state
# end

function respond2(understanding,state,positivity)
	#println("Should respond to $(understanding)")
	global lastTrackPlaying
	global lastTrackScore

	heard = understanding["semantics"]

	#print(typeof(state), typeof(idle), state == "idle")

	if state == "idle"
		if occursin("HELLO",heard) || occursin("HI",heard) || occursin("YO",heard)
			if positivity > 1
				SydMouth.say(OutputName,"You sure seem in good spirits today!")
			else
				SydMouth.say(OutputName,"Oh Hey!")
			end
		end
		if occursin("PLAY",heard)
			SydMouth.say(OutputName,"Unfortunately, I dunno a whole lot of songs, but let me see what I can do.")
			read(`osascript AppleScripts/Play.applescript`)
			read(`osascript AppleScripts/Play.applescript`)
			lastTrackPlaying = String(read(`osascript AppleScripts/GetName.applescript`))
			lastTrackScore = 0
			println("NOW PLAYING $(lastTrackPlaying)")
			state="playingSong"
		end
	#PlayingSong
	elseif state == "playingSong"
		#CHECK IF SONG CHANGED
		#WE'RE BEING LAZY, IF SONG CHANGED BETWEEN AND NEITHER USER OR SYD NOTICE
		#IT'S EQUIVALENT TO GIVING IT A 0

		updateTrack()

		if occursin("PAUSE",heard) || occursin("BACK",heard)
			artistname = String(read(`osascript AppleScripts/GetArtist.applescript`))
			read(`osascript AppleScripts/Pause.applescript`)
			SydMouth.say(OutputName,"Ok, I paused.")
			if positivity > 1
				SydMouth.say(OutputName,"You seem to like this song. It's by $(artistname). You might want to check them out.")
			end
			state="pausedSong"
		end
		if occursin("STOP",heard)
			read(`osascript AppleScripts/Stop.applescript`)
			SydMouth.say(OutputName,"As you wish.")
			state="idle"
		end

		updateVolume(heard)

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

		updateVolume(heard)

		#INSERT SONG INFO

		#INSERT REWIND

		#INSERT SKIP

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
	# emo = EmRec.detect(savefile)
	pos = EmRec.positivity(savefile)

	#SydMouth.say(OutputName,wordsUnderstood)
	println(comprehension)
	# println("Emotion read: $(emo)")
	println("Positivity read: $(pos)")

	# return respondTo(comprehension,state,emo)

	# print("IMPLEMENT RESPOND2")
	respond2(comprehension,state,pos)
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