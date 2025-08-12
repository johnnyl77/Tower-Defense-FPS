extends Node
	
	


func _on_Start_pressed():
	print("Start Pressed")
	get_tree().change_scene("res://addons/Level.tscn")


func _on_Options_pressed():
	print("Options Pressed")


func _on_Instructions_pressed():
	print("Instructions Pressed")
	get_tree().change_scene("res://menus/Instructions.tscn")

func _on_Exit_pressed():
	print("Exit Pressed")
	get_tree().quit()
	


func _on_FullScreenTimer_timeout():
	OS.window_fullscreen = true
	$FocusTimer.start() 
	


func _on_FocusTimer_timeout():
	$CanvasLayer/MarginContainer/VBoxContainer/VBoxContainer/Start.grab_focus()
		
