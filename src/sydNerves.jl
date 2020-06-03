module SydNerves

# Makie

using Makie
import AbstractPlotting: pixelarea

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
SCENECOMPONENTS = Dict{String,Any}()
#Predictions =

function updateScores(track,score)
	global SongScores

	track=chomp(track)	
	# println("TRACK:")
	# println(track)
	# println("TRACK END")
	# println(SongList)
	SONGID = findfirst(isequal(track), SongList )
	# println(SONGID)
	GENRE  = GenreList[SONGID]
	ARTIST = ArtistList[SONGID]

	L = size(SongList,1)

	#Normalize Score
	score = (score*1.0)/L

	#Give Bonus score to same genre
	sameGenres = findall(isequal(GENRE), GenreList)
	SongScores[sameGenres] = SongScores[sameGenres] .+ score

	#Give Bonus score to same artist
	sameArtists = findall(isequal(ARTIST), ArtistList)
	SongScores[sameArtists] = SongScores[sameArtists] .+ score

	#Normalize ALL Scores
	S = sum(SongScores)

	SongScores=SongScores./S

	println(SongScores)
	
	#println("SUM: $S")
end

function pickNextSong(track)
	#Pick a song that wasn't the last track playing
	global SongScores, SongList

	track=chomp(track)	
	prevSONGID = findfirst(isequal(track), SongList )

	L = size(SongList,1)
	CumSums = zeros(L)

	for i in 1:L	
		CumSums[i:L] = CumSums[i:L] .+ SongScores[i]
	end

	SONGID = 0
	while true
		#pick a random number in 0,1
		target = rand(Float64)
		SONGID = findfirst(isequal(1), (CumSums .> target) )
		if prevSONGID == SONGID continue end
		break
	end

	track = SongList[SONGID]
	score = SongScores[SONGID]
	return Dict("track"=>track,"score"=>score)

end

function scoreSong(SCORE)

	liking = ""
	if SCORE < 0.2
		liking = "Let's try something different."
	elseif SCORE < 0.5
		liking = "How about something unusual?"
	elseif SCORE < 0.8
		liking = "You might like this."
	else
		liking = "I'm certain you'll like this!"
	end

    delete!(SCENECOMPONENTS["confidence"], SCENECOMPONENTS["confidence"][end])
    text!(SCENECOMPONENTS["confidence"],liking,textsize=6 )

end

#Track Changed
function updateTrack()
	global lastTrackPlaying
	global lastTrackScore

	currentTrackPlaying = chomp(String(read(`osascript AppleScripts/GetName.applescript`)))
	if currentTrackPlaying != lastTrackPlaying
		# println("Track changed to $(currentTrackPlaying)")
		# println("Previous track: $(lastTrackPlaying),\nScore: $(lastTrackScore)")
		# println("SAVE THESE SCORES SOMEWHERE!!!")
		updateScores(lastTrackPlaying,lastTrackScore)
		NEXTSONG = pickNextSong(lastTrackPlaying)

		toPlayNext = NEXTSONG["track"]
		read(`osascript AppleScripts/PlaySpecific.applescript "$(toPlayNext)"`)

		scoreSong(NEXTSONG["score"])

		lastTrackPlaying = toPlayNext
		lastTrackScore = 0
	end
end

#Song Info
function songInfo(heard)
	global lastTrackScore
	if occursin("ABOUT",heard) || occursin("INFO",heard)
		SONGID = findfirst(isequal(lastTrackPlaying), SongList )
		SydMouth.say(OutputName,"This song is $(SongList[SONGID]) by $(ArtistList[SONGID])")
		lastTrackScore += 5	
	end
end

#Skip Track
function skipTrack(heard)
	global lastTrackScore
	if occursin("SKIP",heard) || occursin("NEXT",heard)
		read(`osascript AppleScripts/NextTrack.applescript`)
		lastTrackScore -= 5	
	end
end

#Restart Track
function restartTrack(heard)
	global lastTrackScore
	if occursin("RESTART",heard) || occursin("REPLAY",heard) || occursin("TOP",heard)
		#SONGID = findfirst(isequal(lastTrackPlaying), SongList )
		#SydMouth.say(OutputName,"This song is $(SongList[SONGID]) by $(ArtistList[SONGID])")
		read(`osascript AppleScripts/RepeatTrack.applescript "$(lastTrackPlaying)"`)
		lastTrackScore += 10
	end
end

#Volume Updates
function updateVolume(heard)
	global lastTrackScore
	if occursin("VOLUME",heard) || occursin("SOUND",heard) || occursin("PLAY",heard) || occursin("SONG",heard)
		# println("VOLUME COMMAND RECEIVED")

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
			lastTrackScore += 2
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
			lastTrackScore += 2
		end
	end

	return false
end


#USE THIS TO SCAN ALL THE SONGS IN THE syd PLAYLISY
function init(sceneDict)

	global SongList,SongScores,GenreList,ArtistList

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

	# SongScores = zeros(size(SongList,1))
	L = size(SongList,1)
	SongScores = fill(1/L, L)

	println(SongList)
	println(GenreList)
	println(ArtistList)
	println(SongScores)

	#Register Scenes
	global SCENECOMPONENTS
	SCENECOMPONENTS = sceneDict
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
			SydMouth.say(OutputName,"Okay, here's a song from your playlist")
			read(`osascript AppleScripts/FirstPlay.applescript`)
			# read(`osascript AppleScripts/Play.applescript`)
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

		lastTrackScore+=positivity
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

			delete!(SCENECOMPONENTS["confidence"], SCENECOMPONENTS["confidence"][end])
    		text!(SCENECOMPONENTS["confidence"]," ",textsize=6 )
		end

		updateVolume(heard)
		songInfo(heard)

		#INSERT REWIND
		restartTrack(heard)

		#INSERT SKIP
		skipTrack(heard)

	#PausedSong
	elseif state == "pausedSong"
		lastTrackScore+=positivity

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
		songInfo(heard)

		#INSERT REWIND
		restartTrack(heard)

		#INSERT SKIP
		skipTrack(heard)

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
	TP = EmRec.positivity(savefile)

	pos = TP["positivity"]
	raw = TP["raw"]

	# println(raw)

	#Emotion Tracking
	# println("UPDATE EXCITEMENT")
	# println(raw)
    delete!(SCENECOMPONENTS["excitement"], SCENECOMPONENTS["excitement"][end])
    lines!(SCENECOMPONENTS["excitement"], 1:length(raw[1]), raw[1], color="orange" )[end]

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