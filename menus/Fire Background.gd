extends VideoPlayer

# Loops the video when it stops playing
func _process(delta):
	if !is_playing():
		play()
