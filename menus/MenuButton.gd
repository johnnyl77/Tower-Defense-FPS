tool
extends TextureButton

export(String) var text = "Text button"
export(int) var arrow_margin_from_center = 100

func _ready():
	setup_text()
	
	set_focus_mode(true)
	$RichTextLabel.set("custom_colors/default_color", Color(1,1,1,1))
	hide_all_arrows()

func _process(delta):
	if Engine.editor_hint:
		setup_text()
		show_arrows()

func setup_text():
	$RichTextLabel.bbcode_text = "[center] %s [/center]" % [text]

func show_arrows():
	for arrow in [$LeftArrow, $RightArrow]:
		arrow.visible = true
		arrow.global_position.y = rect_global_position.y + (rect_size.y / 3.2)

	var center_x = rect_global_position.x + (rect_size.x / 2)
	$LeftArrow.global_position.x = center_x - arrow_margin_from_center
	$RightArrow.global_position.x = center_x + arrow_margin_from_center
	$RichTextLabel.set("custom_colors/default_color", Color(1,0,0,1))
	

func hide_arrows():
	for arrow in [$LeftArrow, $RightArrow]:
		arrow.visible = false
	$RichTextLabel.set("custom_colors/default_color", Color(1,1,1,1))
		
func hide_all_arrows():
	var allMenuButtons = get_tree().get_nodes_in_group("MenuButton")
	for button in allMenuButtons:
		button.get_node("RightArrow").visible = false
		button.get_node("LeftArrow").visible = false

func _on_TextureButton_focus_entered():
	show_arrows()

func _on_TextureButton_focus_exited():
	hide_arrows()

func _on_Start_pressed():
	print("Start Pressed")
	get_tree().change_scene("res://addons/Level.tscn")


func _on_Instructions_pressed():
	print("Instructions Pressed")
	get_tree().change_scene("res://menus/Instructions.tscn")


func _on_Exit_pressed():
	print("Exit Pressed")
	get_tree().quit()

func _on_TextureButton_mouse_entered():
	hide_all_arrows()
	show_arrows()
	grab_focus()


