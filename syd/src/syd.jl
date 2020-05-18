module syd

using Logging, LoggingExtras

function main()
  Base.eval(Main, :(const UserApp = syd))

  include(joinpath("..", "genie.jl"))

  Base.eval(Main, :(const Genie = syd.Genie))
  Base.eval(Main, :(using Genie))
end; main()

end
