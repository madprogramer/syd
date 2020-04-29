#Genie Router
using Genie, Genie.Router, Genie.Assets


route("/") do
  Assets.channels_support()
  println(Genie.WebChannels.connected_clients())
end

#sydCore imports
using sydMouth

"""
route("/") do
	sydMouth.say("me","horses")
	serve_static_file("sydstart.html")
end
"""

channel("/mic") do
	println("GONNA BE LISTENING TO MIC FROM HERE")
end


channel("/__") do
	println("GONNA BE LISTENING TO MIC FROM HERE")
end