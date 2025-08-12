extends KinematicBody

#used as a state varible that updates wether it is being dragged or not

#TODO make it so that the canPlace radius never changes
var x = false
var Ground

signal thisCanBeDragged
signal StopDragging
signal TowerShot

export var Dmg = 5


#Change this 
export var thisScene = "res://Towers/GatlingGun.tscn"
export var Name = "Gatling Gun"
export var IconPath = "res://Control Assets/GatlingGun.png"

#var Bullet = preload("res://Towers/Bullet.tscn")



var curArea = null

var canPlace = false
var towerIsPlaced = true

var towerRaycast = null
var currentTarget = null
var enemies = []
var enemiesInRange = []

var curDist = 9999999
var minDist = float("1e5")
var enemyToTarget = null

onready var AttackTimer = get_node("AttackSpeed")





func _ready():
	
	var cameraMain = get_node("../../../CameraPivot/Camera")
	connect("thisCanBeDragged", cameraMain, "addToDrag", [self])
	emit_signal("thisCanBeDragged")
	connect("StopDragging", cameraMain, "drop")
	
	Ground = get_node("../../../Terrain/Ground")
	
	
	
	
	
	# Don't detect collisions with the turret itself
	towerRaycast = $GunBarrel/RayCast
	towerRaycast.add_exception(self)
	towerRaycast.enabled = false
	
	

	# Add all enemies to the enemies array
	#Not good because this only works once when the tower is spawned so when ew enemies spawn they won't be added to the enemy array
	# I changed it so it always works with any enemy
	#for enemy in get_tree().get_nodes_in_group("enemies"):
	#	enemies.append(enemy)

#these functions execute when the signal is sent from main
func on_Drag():
	canPlace = true

	x = true
	towerIsPlaced = false
	get_node("../Area/MeshInstance").visible = true

func on_Stop_Drag():
	if canPlace:
		emit_signal("StopDragging")
		
		towerIsPlaced = true
		x = false
		get_node("../Area/MeshInstance").visible = false
		
		# If there is an enemy in range, lock onto the closest one
		#if enemiesInRange > 0:
		#	LockOnClosestEnemy()
	else:
		towerIsPlaced = false
		
	
#updates tower translation to go with mouse
func _process(fl):
	
	if translation.z < 3:
		translation.z = 3
	if x == true:
		
		
		var newPos = ScreenPointToRay()
		
		
		get_parent().translation = Vector3(newPos.x, 0, newPos.z)
		
		
	
	# Check if there is a current target and the raycast is enabled
	if enemiesInRange.size() > 0 && towerIsPlaced:
		
		if currentTarget:
			#var direction = (currentTarget.global_transform.origin - self.global_transform.origin).normalized()
			look_at(currentTarget.translation, Vector3(0, 1, 0))
			#look_at(currentTarget.translation, Vector3(0, 1, 0))
			
			
			
		else:
			
			for i in enemiesInRange:
				curDist = EuclideanDist(self.translation, i.translation)
				if curDist < minDist:
					minDist = curDist
					enemyToTarget = i
			currentTarget = enemyToTarget
			if (currentTarget != null):
				AttackTimer.start()
				connect("TowerShot", currentTarget, "on_TowerShot")
			
			
		
		towerRaycast.enabled = true
		# Check if the raycast intersects the current target
		#var raycastCollider = towerRaycast.get_collider()
		#LockOnClosestEnemy()
	else:
		towerRaycast.enabled = false
		currentTarget = null
	

	
func EuclideanDist(p1: Vector3, p2: Vector3):
	var xPos = (p2.x - p1.x)*(p2.x - p1.x)
	var y = (p2.y - p1.y)*(p2.y - p1.y)
	var z = (p2.z - p1.z)*(p2.z - p1.z)
	return sqrt(xPos+y+z)
#function used to get the mouse position in 3d
func ScreenPointToRay():
	#just more rays
	var spaceState = get_world().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera()
	var rayOrigin = camera.project_ray_origin(mouse_pos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mouse_pos) * 2000
	
	
	var rayArray = spaceState.intersect_ray(rayOrigin, rayEnd)
	if rayArray.get("collider") == Ground:
		return rayArray["position"]
	else:
		return get_parent().translation

func _on_Area_area_entered(area):
	canPlace = false
		


func _on_Area_area_exited(area):
	if get_node("../Area").get_overlapping_areas().size() == 0:
		canPlace = true
	


func _on_TowerRange_body_entered(body):
	
	# Enable the raycast and set its position and target to the barrel
	
	
		
		#currentTarget = body
	enemiesInRange.append(body)
	


func _on_TowerRange_body_exited(body):
	# Disable the raycast and clear the current target
	if body == currentTarget:
		
		#towerRaycast.enabled = false
		enemiesInRange.erase(body)
		disconnect("TowerShot", currentTarget, "on_TowerShot")
		currentTarget = null
		minDist = 999999
		AttackTimer.stop()
		
		
		
		
	

	enemiesInRange.erase(body)
		
	
	

#func Shoot():
#	print("pew")
#	var bullet_instance = Bullet.instance()
#	bullet_instance.get_node("BulletBody").translation = Vector3(translation.x, translation.y - 3, translation.z)
#	add_child(bullet_instance)
#	bullet_instance.setTarget(currentTarget)



func _on_AttackSpeed_timeout():
	emit_signal("TowerShot", Dmg)
	$"../AudioStreamPlayer3D".play()
	$GunBarrel/Sprite3D.visible = true
	$GunBarrel/Sprite3D2.visible = true
	#Shoot()
	$TowerRange/muzzleFlash_T.start()
	
		


func _on_muzzleFlash_T_timeout():
	$GunBarrel/Sprite3D.visible = false
	$GunBarrel/Sprite3D2.visible = false
	
