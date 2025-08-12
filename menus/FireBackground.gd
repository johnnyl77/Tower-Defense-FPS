extends VideoPlayer

# Loops the video when it stops playing (Same as main menu)
func _process(delta):
	if !is_playing():
		play()
