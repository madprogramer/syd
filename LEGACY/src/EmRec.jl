
using Knet: Knet, AutoGrad, gpu, param, param0, mat, RNN, relu, Data, adam, progress, nll, zeroone

# chain of layers
struct Chain
    layers
    Chain(layers...) = new(layers)
end
(c::Chain)(x) = (for l in c.layers; x = l(x); end; x)
(c::Chain)(x,y) = nll(c(x),y)


# Redefine dense layer 
struct Dense; w; b; f; end
Dense(i::Int,o::Int,f=identity) = Dense(param(o,i), param0(o), f)
(d::Dense)(x) = d.f.(d.w * mat(x,dims=1) .+ d.b)


struct DenseRelu; w; b; f; end
DenseRelu(i::Int,o::Int,f=relu) = DenseRelu(param(o,i), param0(o), f)
(d::DenseRelu)(x) = d.f.(d.w * mat(x,dims=1) .+ d.b)

module EmRec

#INCLUDES
using DSP

using FileIO: load, save, loadstreaming, savestreaming
import LibSndFile
using Serialization

using MFCC
using Pkg; for p in ("Knet","IterTools","Plots"); haskey(Pkg.installed(),p) || Pkg.add(p); end
using Random: shuffle!
using Base.Iterators: flatten
using IterTools: ncycle, takenth
using Knet: Knet, AutoGrad, gpu, param, param0, mat, RNN, relu, Data, adam, progress, nll, zeroone
using JLD2
#GLOBALS 
FRAME_LENGTH = 0.025 # ms
FRAME_INTERVAL = 0.010 # ms

export detect


function preprocess(wavFile)
    samps, sr = load(wavFile)
    samps = vec(samps)
    
    #.+ eps to avoid Inf's and NaN's
    samps.+=eps()

    #26 FEATURES
    #Kind of handles resampling! Consider lowering quality of training data if accuracy is too off
    mfccs, _, _ = mfcc(samps, sr, :rasta; wintime=FRAME_LENGTH, steptime=FRAME_INTERVAL)
    mfccDeltas = deltas(mfccs, 2)
    features = hcat(mfccs, mfccDeltas)
    
    toReturn = Float32.(features)
    return toReturn
end


function tag(M,features,S)
	emotions = ["neutral","happy"]
    #labels = emotions[(x->x[1]).(argmax(Array(model(reshape(SAMPLES,features,1,L))),dims=1))]
    labels = emotions[(x->x[1]).(argmax(Array(M(S)),dims=1))]
    return labels
end

function detect(fileLoc)

	SAMPLES = (preprocess(fileLoc))
	#LOAD MODEL
	#model = Knet.load("EmRec256.jld2","model")
	#println(size(SAMPLES))
    L = size(SAMPLES)[1]

	#KNET LOAD BROKEN REPORT THIS!
	#Knet.@load "EmRec256.jld2"
    Knet.@load "BIGEMREC.jld2"
	println(model)

	#model = deserialize("EmRec160")

    #println(summary(reshape(SAMPLES,26,1,598)))

    #(model(reshape(SAMPLES,26,1,598)))
	#reshape(Xs[1],26,1,328)

	#TAG
	tags = tag(model, 26, reshape(SAMPLES,26,1,L))
	#COUNT TAG

    if L > 50
        k = 50
        while L >= k+50
            #IF THERE IS MORE JOY IN THIS FRAME THAN NEUTRAL, DETECT JOY!
            #println(count( i->(i=="happy"), tags[k:k+50] ) / 50)
            if count( i->(i=="happy"), tags[k:k+50] ) / 50 > 0.5  
                return "joy"
            end

            k+=50
        end
    end
    return "neutral"
end


function test(fileLoc)
	println(detect(fileLoc))
end

# test("etsworking.wav")

end