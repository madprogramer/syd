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


end