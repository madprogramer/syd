module SydMouth

OutputName = "Built-in Output"

export say

function say(text)
	println("Saying: $text")
	# run(`osascript AppleScripts/Speaker.applescript $text`)
	run(`osascript src/AppleScripts/Speaker.applescript $text`)

end

end