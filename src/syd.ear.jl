using PortAudio, LibSndFile
 

module syd.ear
	function recTest
		stream = PortAudioStream("Microphone (USB Microphone)", 1, 0) 

		# 44100 samples/sec
		rate = 44100
		time = 0.5

		buf = read(stream, rate*time)

		save("recording.wav", buf)
	end
end