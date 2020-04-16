module SydEar

InputName = "Built-in Microphone"

export startListening

function startListening()
	println("How I wish, how I wish I could hear!")
	# run(`osascript AppleScripts/Speaker.applescript`)
	run(`osascript src/AppleScripts/Listener.applescript`)
end

end