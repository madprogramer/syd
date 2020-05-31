using Makie
import AbstractPlotting: pixelarea

scene = Scene(resolution=(900,1600))

area1 = map(pixelarea(scene)) do hh
    pad, w, h = 30, 870, 370
    FRect(Point2f0(30, 30), Point2f0(w,h))
end

area2 = map(pixelarea(scene)) do hh
    pad, w, h = 30, 870, 370
    FRect(Point2f0(30, h+2*pad), Point2f0(w,h))
end

area3 = map(pixelarea(scene)) do hh
    pad, w, h = 30, 870, 370
    FRect(Point2f0(30, 2*h+2*pad), Point2f0(w,h))
end

area4 = map(pixelarea(scene)) do hh
    pad, w, h = 30, 870, 370
    FRect(Point2f0(30, 3*h+2*pad), Point2f0(w,h))
end

scene1 = Scene(scene, area1)
scene2 = Scene(scene, area2)
scene3 = Scene(scene, area3)
scene4 = Scene(scene, area4)
lines!(scene1, 1:10, rand(10),color="blue")[end]
lines!(scene2, 1:10, rand(10), color="blue")[end]
lines!(scene3, 1:10, rand(10), color="blue")[end]
#lines!(scene4, 1:10, rand(10), color="blue")[end]

scene

display(scene)

