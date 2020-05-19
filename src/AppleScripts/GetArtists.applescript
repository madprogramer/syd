tell application "Music"
	if get name of playlists contains "syd" then
		set P to user playlist "syd"
		set T to tracks of P
		set N to {}
		repeat with TTT in T
			set end of N to (get artist of TTT)
		end repeat
		N
	else
		-1
	end if
end tell