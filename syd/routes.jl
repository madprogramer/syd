using Genie.Router

route("/") do
  serve_static_file("sydstart.html")
end

route("/horse") do
	"HORSE"
end