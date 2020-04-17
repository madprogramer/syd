module SydBrain

export comprehend

#Levenshtein Distance
#Using from https://rosettacode.org/wiki/Levenshtein_distance until I optimize this myself
function levendist(s::AbstractString, t::AbstractString)
    ls, lt = length.((s, t))
    ls == 0 && return lt
    lt == 0 && return ls
 
    s₁, t₁ = s[2:end], t[2:end]
    ld₁ = levendist(s₁, t₁)
    s[1] == t[1] ? ld₁ : 1 + min(ld₁, levendist(s, t₁), levendist(s₁, t))
end

#Semantics
function semantics(words::AbstractString)

	#Highlight words which might be "play"
	#println(length.((words, "**play**")))

	N = length(words)-length("**play**")+1
	distances = zeros(N)

	# for i in 1:N
	#  	println( (words[i:length("**play**")+i-1] ,"**play**" ) )
	# 	distances[i] = levendist( words[i:length("**play**")+i-1] ,"**play**" )
	# end
	distAtPosition(i) = levendist( words[i:length("**play**")+i-1] ,"**play**" ) 
	positions = collect(1:N)

	# distances = distAtPosition.(positions).-4
	candidates = (distAtPosition.(positions).-4).<=2
	# println(candidates)

	newWords = ""
	missingLetters = 0
	#Clip on start
	if candidates[1]
		newWords = string(newWords,"PLAY ")
		missingLetters = 4
		#Catch missing letters
	else
		newWords = words[1:length("**play**")]
	end


	#Clip in between
	for i in 2:length(candidates)
		missingLetters = max(0,missingLetters-1)
		#println(missingLetters)
		#No Frame in sight
		if !candidates[i-1] && !candidates[i]
			newWords = string(newWords,words[i+length("**play**")-1])
			continue
		#Entered Frame
		elseif !candidates[i-1] && candidates[i]
			#Delete preceeding
			newWords = string(newWords[1:findlast(' ',newWords)],"PLAY ")
			continue
		#Leaving Frame
		elseif candidates[i-1] && !candidates[i] 
			#newWords = string(newWords,words[i])
			if missingLetters > 0
				println("SNEAKING IN:",words[length("**play**")-missingLetters:i+length("**play**")-1] )
				newWords = string(newWords,words[length("**play**")-missingLetters:i+length("**play**")-1])
				missingLetters = 0
			else
				newWords = string(newWords,words[i+length("**play**")-1])
			end

			continue
		#Inside Frame
		else#if candidates[i-1] && candidates[i]
			continue
		end
	end

	# #Clip at end
	# if candidates[end]
	# 	newWords = string(newWords,"PLAY")
	# end

	return newWords
end

#What to comprehend from these words?
function comprehend(words::AbstractString)
	comprehension = Dict{String,Any}()

	#Clip off newline
	words=words[1:end-1]

	comprehension["raw"] = words
	comprehension["word count"] = count(i->(i==' '), words)+1
	# comprehension["saidPlay"] = occursin("play", words)
	# comprehension["saidPause"] = occursin("pause", words)
	comprehension["semantics"] = semantics(words)

	return comprehension
end

#For testing string related stuff
function test(tests)
	for words in tests
		println(comprehend(words))
	end
end

# Said
# test(["I wanna play a game\n","Play sing emily play\n","Play sing emily play\n","Play see emily play\n",
# 	"this is so sad\n","So ya thought ya might like to go to the show\n","Tell me is something eluding you, sunshine?\n",
# 	"Cold iron hands clap\n","Make your name like a ghost\n"])

# #As Heard
# test(["i want to play game\n","lena sink amily playe\n","play seing emily plaing\n","play the emely place\n",
# 	"this is so sod\n","ah suh er migdt leke to go to de show\n","down me as some thing ar luoning usasha\n",
# 	"cold iron hands cleff\n","nake our name like a ghost\n"])

# test(["i want to play game"])

end