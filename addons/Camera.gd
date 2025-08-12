extends Camera

#signals sent to the "towers" to set their state 
signal DraggingObject
signal StopDragging

#externally set varible to determine what qualifies as a "tower# within the script
#TODO: change to an array of var so that multiple instances can be set as towers
#Done! all draggable things (Towers, walls etc) can will be instantiated with the draggable signal template found in the towers

var Draggable = []



#Used to create the items in the inventory.
export var itemTemplate: PackedScene

#boolean used to see if the next left click is used to drag or drop the object the mouse is currently hovering over
var isDragging = false

#position of the mouse relative to viewport
var mouse = Vector2()

#a pointer to the object currently being dragged
var objectDragged = null



onready var ItemHolder = get_node_or_null("../../BuildOverlay/MarginContainer/CenterContainer/ItemHolder")
onready var Inventory = get_node("../../BuildOverlay/MarginContainer/CenterContainer")
onready var Shop = get_node("../../ShopLayer/Shop")

onready var BuildOverlay = get_node("../../BuildOverlay")



func _input(event):
	
	if event.is_action_pressed("Change_view"):
		if !isDragging and current == true and get_node("../../RelicLayer").visible == false:
			BuildOverlay.visible = false
	
	if event.is_action_pressed("StoreInInventory"):
		if isDragging:
			addToInventory(objectDragged.Name, objectDragged.IconPath, objectDragged.thisScene)
			BuildOverlay.visible = true
	
			
	#if the mouse is moved
	if event.is_action_pressed("OpenInventory"):
		if !isDragging and get_node("../../RelicLayer").visible == false:
			_on_InventoryButton_pressed()
	
	if event.is_action_pressed("OpenShop"):
		if !isDragging and get_node("../../RelicLayer").visible == false:
			_on_ShopButton_pressed()
	
	if event is InputEventMouse:
		# then update the pos of the mouse
		mouse = event.position
	#if they left click
	if event is InputEventMouseButton and event.pressed and current == true:
		if event.button_index == BUTTON_LEFT:
			
			#if nothing is currently being dragged
			if !isDragging:
				#then get the thing being clicked on (if anything)
				get_selection()
				
			else:
				
				emit_signal("StopDragging")
				
				
				#otherwise drop the current object
				#drop()
				#isDragging = false
	
	

#function that shoots a ray from the mouse position into the depths of the viewport and stops at the first thing it intersects with
func get_selection():
	
	#defines the rays
	var worldspace = get_world().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_position(mouse, 1000)
	
	#the result after all the ray math is a dict containing the info of the thing it collides with
	# will be empty if nothing collided with it
	var result = worldspace.intersect_ray(start, end)
	var collider = result.get("collider")
	#if the collider is a tower
	#TODO: change this to work with an array
	if collider in Draggable:
		#then start dragging the object relative to mouse pos
		isDragging = true
		connect("DraggingObject", collider, "on_Drag")
		objectDragged = collider
		emit_signal("DraggingObject")
		BuildOverlay.visible = false
		connect("StopDragging", objectDragged, "on_Stop_Drag")
		
	
#function made for dropping the currently dragged object
#Changed to only drop if the thing it is dragging can be viabally placed 
func drop():
	
	#connect("StopDragging", objectDragged, "on_Stop_Drag")
	#emit_signal("StopDragging")
	if objectDragged != null:
		disconnect("DraggingObject", objectDragged, "on_Drag")
		disconnect("StopDragging", objectDragged, "on_Stop_Drag")
	isDragging = false
	objectDragged = null
	BuildOverlay.visible = true
	
	
#whenever an object calls this it will be added to the draggable objects 
func addToDrag(obj):
	Draggable.append(obj)
	

func addToInventory(Name: String, Icon: String, Scene):
	var newItem = itemTemplate.instance()
	newItem.text = Name
	newItem.icon = ResourceLoader.load(Icon)
	newItem.StoredObject = load(Scene)
	
	if (objectDragged != null):
		objectDragged.get_parent().queue_free()
	
	drop()
	
	ItemHolder.add_child(newItem)
	

	
func on_spawnTower(towerToSpawn):
	
	var newTower = towerToSpawn.instance()
	newTower.get_node("TowerBody").Dmg = newTower.get_node("TowerBody").Dmg + ((Shop.Bonuses[newTower.get_node("TowerBody").Name]) *newTower.get_node("TowerBody").Dmg)
	isDragging = true
	get_parent().get_parent().get_node("Added Towers").add_child(newTower)
	connect("DraggingObject", newTower.get_node("TowerBody"), "on_Drag")
	connect("StopDragging", newTower.get_node("TowerBody"), "on_Stop_Drag")
	objectDragged = newTower.get_node("TowerBody")
	emit_signal("DraggingObject")
	BuildOverlay.visible = false
	get_node("../../BuildOverlay/MarginContainer/CenterContainer").visible = false
	


func _on_InventoryButton_pressed():
	Inventory.visible = !Inventory.visible


func _on_ShopButton_pressed():

	Shop.visible = !Shop.visible
