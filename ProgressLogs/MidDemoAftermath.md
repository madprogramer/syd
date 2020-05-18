## Log: May 3 (Finalized May 18)

### Summary

I had initially hoped for this to be a semester where I could devote myself to my courses especially. Yet one thing let to another and this project, which I'd intended to work bit by bit everyday, turned into something I could only work in intense bursts every 1-2 weeks. 

The past month or so I really over-extended. Trying to set up both a UI and real-time voice analysis proved to be far too taxing, as I was unable to merge work on this and another branch. Eventually this led me to reworking my past code, which I'd marked as LEGACY, for the mid-demo.

And now, still under similar constraints I see that I don't have much of an option other than to continue from there. While this might mean that I'll have to sacrificise quite a bit from any and all visual appeal, in a sense it's forcing me back to my roots. I migh still be using Apple Music as the primary music source, but I'm on the way to making a final submission with focus on the audio-based interaction, although seeing as how exhausting this project was I am half tempted to switch to a text-based assistant if I am to later continue syd.... 

### Engagement Based-Scoring

In order to better "observe" the user, I am switching from raw emotion recognition to "engagement scoring". 

The favorability of a song is determined by the user's behaviour, and their emotion when giving commands to syd:

* Asking for song info is a positive action, which indicates active engagement.
* Pausing or lowering the volume are neutral actions, since the user might need to do this if they have to talk to someone else.
* Skipping a song is a negative action.
* The intensity of emotion while giving commands adds a *bonus* to the engagement score.

Once this score is calculated, syd will use a small set of features to predict another song to have the next highest score based on its similarity to this one and play that next.

To this end I'll be adding a few more voice commands, since it's easier to get engagement out of these, then any dialogue out of syd.

### Taking Turns

While I might not be able to finish the "4 scenario" example I'd presented before, I'm going with "2 scenarios":

1. syd chooses a random track (low probability)
2. syd chooses a favorable track, according to the profile of the current user (high probability)

For the time being, I've dropped the idea of giving *syd* it's own personal taste, reducing it to randomness, for the sake of meeting deadlines.

