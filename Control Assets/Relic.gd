extends Button

var id: int

signal RelicChosen
var RelicToolTip

var Desc = "This is a relic Description blah blah blah checkForTextWrapping"
var FlavourText = "This is the relic flavour text"

func _ready():
	var SpatialRoot = get_parent().get_parent().get_parent().get_parent().get_parent()
	connect("RelicChosen", SpatialRoot, "_on_RelicChosen")
	RelicToolTip = get_node("../../../ToolTipDialogue")


func _on_Relic_pressed():
	emit_signal("RelicChosen", id)


func _on_Relic_mouse_entered():
	RelicToolTip.get_node("MarginContainer/Label").text = FlavourText
	RelicToolTip.get_node("Description").text = Desc


func _on_Relic_mouse_exited():
	RelicToolTip.get_node("MarginContainer/Label").text = ""
	RelicToolTip.get_node("Description").text = ""
