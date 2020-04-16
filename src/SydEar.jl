module SydEar

using PortAudio, SampledSignals, LibSndFile

#Constants
listenDuration = 0.5s
maxDuration = 5s

export waitAndListen

louderThanNoise(x) = x > 0.01
square(x) = x^2;

function waitAndListen(from)
	println("Waiting")
	attention = false
	currentDuration = 0s

	PortAudioStream(from, 2, 0) do stream
		fullbuf = read(stream, 0s)
		lastbuf = read(stream, 0s)
        while(true)
        	#print(currentDuration)
            lastbuf = read(stream, listenDuration)
            if any(louderThanNoise, lastbuf) && currentDuration < maxDuration
                if !attention
                    #println("YOU DON't HAVE MY ATTENTION!")
                    attention = true
                    fullbuf = lastbuf
                else
                    #println("YOU HAVE MY ATTENTION!")
                    currentDuration += listenDuration
                    fullbuf = vcat(fullbuf,lastbuf)
                end
            elseif attention == false
            	continue
            else
            	currentDuration += listenDuration
            	fullbuf = vcat(fullbuf,lastbuf)
                return fullbuf
            end
        end
    end

end

end