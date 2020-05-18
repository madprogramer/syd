## Log for Week 1

### Summary

This week was mostly devoted to research and requirements analysis. 
Some progress has been made with the code but the focus has been on making design choices. 

### Building the Skeleton 

The latest notebook is a simple demo with functions for listening to speech whenever sound being spoken is detected in an environment and then returning the clip as output.
This was mostly an exercize to test the capabilities of and get a general feel for Julia's audio libraries. Which brings up an important point, currently the goal is to use Julia as the main language for the project. Syd is afterall being designed to be easily modifyable so even if within the span of the time I end up having to relly on a non-Julia dependency or two, I'm at least trying my best to make those components as easily "plug and play" as I best as I can. 

### Speech Synthesis

Following comments during the first biweekly meeting, I decided to switch from espeak to Apple's "Karen", at least for the time being. The goal here was just to find a less mechanical voice.

### Speech2Text

I am currently undecided between using Google's [Speech-to-Text API](https://cloud.google.com/speech-to-text/) and Mozilla's implementation of Baidu's [DeepSpeech](https://github.com/mozilla/DeepSpeech).

### Music Location

Another thing I have been considering throughout the week is where to store the music files, should they be added by the user or directly streamed? The first option promises greater freedom in song options but at the cost of storage, whereas with streaming there is no issue so long as everything operates in real time. I've taken a look at the Spotify API and might continue with it if I think it'll work "good enough".   

### Design Related Research

As stated before, syd is intended to be integrable into multiple environments, but for the sake of visualization I've decided to also include a very simple visualization app which 
will [look like this.](https://marvelapp.com/110i17dj)

### The Beauty of Ambiguity

I decided to consult a member of the alumni in the MAVA department on a number of design issues. Initially I wanted to ask about how I could possibly do an "evaluation for usability testing" for a project such as syd, their recommendation was to give users a few days to use syd and keep a short journal where they describe what they liked or didn't like about it. 

But the greatest take-away from this conversation was the subject of **ambiguity** and how it might really help make syd's dialogue and music choices a lot more enjoyable. They referred me to two articles:
- **Ambiguity as a Resource for Design** by Gaver, Beaver and Benford.
- **The Prayer Companion: Openness and Specificity, Materiality and Spirituality** by Gaver et al.

Inspired by the work here (and also an "interactive" musical act I'd attended a few weeks ago), I've decided to try and integrate a form of ambiguity into syd's decission making. That is to say, what I had before alluded to as "syd's mind of its own" will be more of a hidden bias, indepedent of the user, which will occasionally make unusal decisions which might not exactly match the user's current mood. By doing this I believe I'll be able to get syd to ellicit more reactions out of users. Whether this will come off as irritating or endearing is yet to be determined... 
