extends KinematicBody

var speed = 30

var gravity = 9.8

var jump = 7

var MainCam

var levelstarted = true


var cameraAccelleration = 50
var sens = 0.1

var snap 

var HP = 100
var maxHP = 100
var IFrame = 0.5
var isInvincible = false
var Score = 0
var Wave = 0
var Defence = 0

var canShoot = true

var playerDamageBuff = 0




var readytoJump 




var direction = Vector3()
var velocity = Vector3()
var gravityVector = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("Change_view"):
		if !get_node("../CameraPivot/Camera").isDragging and get_node("../CameraPivot/Camera").current == true and get_node("../RelicLayer").visible == false:
			$Head/Camera.current = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$UserOverlay.visible = true
			
			get_node("../Timers/ZombieTimer").start()
	
	if $Head/Camera.current == true and levelstarted:
		if event is InputEventMouseMotion:
			rotate_y(deg2rad(-event.relative.x * sens))
			head.rotate_x(deg2rad(-event.relative.y * sens))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-90),deg2rad(90))
	pass
	
	
	if event is InputEventMouseButton and event.pressed and MainCam.current == false:
		if event.button_index == BUTTON_LEFT:
			shoot()
			

func shoot() -> void:
	if(canShoot):
	
	
		$Head/Camera/Sprite3D/AudioStreamPlayer3D.play()
		$Head/Camera/Sprite3D.visible = true
		$Head/Camera/Sprite3D2.visible = true
		$Head/Camera/Sprite3D/AudioStreamPlayer3D.play()
		$Head/Camera/GunMuzzle_T.start()
		$Head/Camera/Sprite3D/PumpReload.play()
		$Head/Camera/Sprite3D/Reloadtimer.start()
		canShoot = false
		
		var bullet = preload("res://Meshes/Shotgun/Bullet.tscn").instance()
		bullet.get_node("RigidBody").damage += playerDamageBuff
		get_tree().current_scene.add_child(bullet)
		bullet.global_rotation = $Head/Camera/BulletStart.rotation
		bullet.global_transform = $Head/Camera/BulletStart.global_transform


	
func _ready() -> void:
	
	MainCam = get_node("../CameraPivot/Camera")
	$GameOver.visible = false
	_on_RestartBTN_pressed()
	
	
	
	
func _physics_process(delta: float) -> void:
		
	
		if $Head/Camera.current == true and levelstarted:
			move_and_slide(Vector3(0, -1, 0), Vector3.UP)
		
	
			direction = Vector3.ZERO
			var horizontalRot = global_transform.basis.get_euler().y
			var forwardInput = Input.get_action_strength("moveBack") - Input.get_action_strength("moveForward")
			var horizontalInput = Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")
			direction = Vector3(horizontalInput, 0, forwardInput).rotated(Vector3.UP, horizontalRot).normalized()
		else:
			direction = Vector3(0,0,0)
		
		if is_on_floor():
			snap = get_floor_normal()
			gravityVector = Vector3.ZERO
			
		else:
			snap = Vector3.DOWN
			gravityVector += Vector3.DOWN * gravity * delta
		if Input.is_action_just_pressed("Jump"):
			if $Head/Camera.current == true:
				if is_on_floor():
					
					snap = Vector3.ZERO
					gravityVector = Vector3.UP * jump

		snap = Vector3.ZERO
		
		
			
			
		
		velocity = velocity.linear_interpolate(direction * speed, delta)
		movement = velocity + gravityVector
		
	
		move_and_slide_with_snap(movement, snap, Vector3.UP)

func on_hit_Player(damage: int):
	if camera.current == true:
		$DamageIndicator.visible = true
		$Indicator.start()
	if (Defence > damage):
		HP = HP -1
	else:
		HP = HP - damage + Defence
	
	if HP <= 0:
		HP = 0
		game_over()
	$UserOverlay/MarginContainer/VBoxContainer/HBoxContainer/HP_Label.text = "HP: "+str(HP)+"/" + str(maxHP)
		
func game_over():
	
	$GameOver/MarginContainer/VBoxContainer/FinalScore.text = "Final Score: " + str(Score)
	levelstarted = false
	$GameOver.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	





func _on_Fullscreen_timeout():
	OS.window_fullscreen = true 


func _on_UpdateWave():
	Wave += 1
	get_node("UserOverlay/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Wave_Label").text = "Wave: " + str(Wave)

func _on_QuitBTN_pressed():
	get_tree().quit()


func _on_RestartBTN_pressed():
	get_parent().startCounting = false
	for i in get_tree().get_nodes_in_group("enemies"):
		i.queue_free()
	translation = Vector3(500, 4 , 600)
	MainCam.current = true
	$GameOver.visible = false
	Score = 0
	HP = 100
	maxHP = 100
	Wave = 0
	Defence = 0
	get_parent().WaveGrowth = 0
	get_parent().maxZombies = 10
	get_parent().hordeNumber = 10
	get_parent().basic_SpawnRate = 100
	get_parent().fast_SpawnRate = 0
	get_parent().Goliath_SpawnRate = 0
	get_parent().Gold = 0
	get_parent().bonusHealthRegen = 0
	get_parent().bonusWaveGold = 0
	playerDamageBuff = 0
	get_parent().get_node("ShopLayer/Shop").Bonuses = {"Canon": 0, "Sniper Tower": 0, "Gatling Gun": 0, "Tesla Tower": 0}
	get_parent().get_node("ShopLayer/Shop").CanonUpgradeCost = 600
	get_parent().get_node("ShopLayer/Shop").SniperUpgradeCost = 1600
	get_parent().get_node("ShopLayer/Shop").GatlingUpgradeCost = 2000
	get_parent().get_node("ShopLayer/Shop").TeslaUpgradeCost = 1000
	$Head/Camera/Sprite3D/Reloadtimer.wait_time = 1
	$Head/Camera/BuddhaVisage.visible = false
	#TODO change text for labels aswell
	$UserOverlay/MarginContainer/VBoxContainer/HBoxContainer/HP_Label.text = "HP: 100/100"
	$UserOverlay/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Score_Label.text = "Score: 0"
	$UserOverlay.visible = false
	levelstarted = true
	$"../Timers/ZombieTimer".stop()
	$"../".zombiecount = 0
	for items in get_parent().get_node("BuildOverlay/MarginContainer/CenterContainer/ItemHolder").get_children():
		items.queue_free()
	for Towers in get_parent().get_node("Added Towers").get_children():
		Towers.queue_free()
	
	var StartingTower = preload("res://Towers/Tower2.tscn")
	var z = 550
	for i in range(3):
		var newTower = StartingTower.instance()
		newTower.translation= Vector3(650, 0, z)
		z = z + 50
		get_parent().get_node("Added Towers").add_child(newTower)
	
	z = 550


func _on_Score_timer_timeout(ScoretoAdd):
	Score = Score + ScoretoAdd
	$UserOverlay/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Score_Label.text = "Score: " + str(Score)
	


func _on_GunMuzzle_T_timeout():
	$Head/Camera/Sprite3D.visible = false
	$Head/Camera/Sprite3D2.visible = false


func _on_Reloadtimer_timeout():
	canShoot = true


func _on_Indicator_timeout():
	$DamageIndicator.visible = false
