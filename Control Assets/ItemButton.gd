extends Button

var StoredObject
signal spawnTower

func _ready():
	var SpatialRoot = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("CameraPivot/Camera")
	connect("spawnTower", SpatialRoot, "on_spawnTower")
	


func _on_ItemButton_pressed():
	emit_signal("spawnTower", StoredObject)
	queue_free()
