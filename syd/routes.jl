#Genie Router
using Genie.Router

#sydCore imports
using sydMouth

route("/") do
	sydMouth.say("me","horses")
	serve_static_file("sydstart.html")
end

route("/horse") do
	"HORSE"
end

route("/shutdown") do
	down()
end