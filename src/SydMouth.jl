module SydMouth

using PortAudio, SampledSignals, LibSndFile

export say, sing

function say(to, text)
	println("Saying: $text")
	# run(`osascript AppleScripts/Speaker.applescript $text`)
	run(`osascript src/AppleScripts/Speaker.applescript $text`)
end

function sing(to, song)
	PortAudioStream(to, 0, 2) do stream
		write(stream,song)
	end
end


end

