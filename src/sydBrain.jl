module SydBrain

export comprehend


#What to comprehend from these words?
function comprehend(words)
	comprehension = Dict{String,Any}()

	comprehension["raw"] = words
	comprehension["word count"] = count(i->(i==' '), words)+1
	comprehension["saidPlay"] = occursin("play", words)
	comprehension["saidPause"] = occursin("pause", words)

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

#As Heard
test(["i want to play game\n","lena sink amily playe\n","play seing emily plaing\n","play the emely place\n",
	"this is so sod\n","ah suh er migdt leke to go to de show\n","down me as some thing ar luoning usasha\n",
	"cold iron hands cleff\n","nake our name like a ghost\n"])

end