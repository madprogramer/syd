#Genie Router

using Genie, Genie.Router, Genie.Assets


route("/") do
  Assets.channels_support()
  println(Genie.WebChannels.connected_clients())
end

#sydCore imports
using sydMouth

channel("/mic") do
	println("GONNA BE LISTENING TO MIC FROM HERE")
end


channel("/__") do
	println("GONNA BE LISTENING TO MIC FROM HERE")

end