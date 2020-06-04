# syd

Mood/Preference based Music Recommendation

School project, let's see where it'll take us...

### Notes:

Only tested on MacOS Catalina.
See [logs](/logs) for more details.

#### Prerequisites:

1. Download [Julia 1.4](https://julialang.org/downloads/)
    1.0  Launch Julia
    1.1. Hit ] then type `add "FileIO,LibSndFile, Makie, AbstractPlotting, SampledSignals,https://github.com/JuliaAudio/PortAudio.jl.git`"
2. Install [Homebrew](https://brew.sh)
    2.1  Execute `brew install sox`

### Usage:

!!!UPDATE THIS!!!
1. Download v0.0.3 from Releases
2. Make sure iTunes/Apple Music is launched.
3. Run with 
`julia syd.jl` from inside `src/`
