extends Spatial

var relicTemplate = preload("res://Control Assets/Relic.tscn")
var object_scene = preload("res://Monsters/Lowpolyzombie.tscn")
var faster_zombie = preload("res://Monsters/FasterZombie.tscn")
var Goliath = preload("res://Monsters/Goliath.tscn")
var basic_SpawnRate = 100
var fast_SpawnRate = 0
var Goliath_SpawnRate = 0


var zombiecount = 0
var startCounting: bool = false
var totalZombieTypes = 3

var WaveGrowth = 0
var maxZombies = 10
var hordeNumber = 10
var curHorde = 0
var bonusWaveGold = 0
var bonusHealthRegen = 0

var Gold = 0


onready var Player = get_node("Player")

#Update this when you make a new relic
var TotalRelics = 22

onready var player_object = get_node("Player")
onready var Camera_Object = get_node("CameraPivot/Camera")


func _ready():
	randomize()
	pass

func spawn_object():
	if(zombiecount < maxZombies):
		
		#TODO: Make it so that different zombies spawn 
		var object_instance = getRandomZombie().instance()
		var mob_spawn_location = $Spawn_points/Spawn_location
		mob_spawn_location.unit_offset = randf()
		object_instance.transform.origin = mob_spawn_location.translation
		object_instance.HP = object_instance.HP +  (object_instance.HP * 0.1) * WaveGrowth
		#object_instance.speed += 1 * WaveGrowth
		add_child(object_instance)
		zombiecount = zombiecount + 1
		curHorde = curHorde	+ 1
		if curHorde >= hordeNumber:
			curHorde = 0
			yield(get_tree().create_timer(5), "timeout")

func getRandomZombie():
	var randNum = randi() % 100
	if randNum <= basic_SpawnRate:
		return object_scene
	elif randNum <= basic_SpawnRate + fast_SpawnRate:
		return faster_zombie
	elif randNum <= basic_SpawnRate + fast_SpawnRate + Goliath_SpawnRate:
		return Goliath
func _process(delta):
	if (startCounting):
		if (get_tree().get_nodes_in_group("enemies").size() == 0):
			get_node("Timers/ZombieTimer").stop()
			startCounting = false
			player_object._on_UpdateWave()
			WaveGrowth += 1
			if maxZombies < 100:
				maxZombies = maxZombies + 10
				if maxZombies/4 >= hordeNumber:
					hordeNumber = hordeNumber + 5
			zombiecount  = 0
			
			if basic_SpawnRate > 30:
				basic_SpawnRate = basic_SpawnRate - 5
			if fast_SpawnRate < 70:
				fast_SpawnRate = fast_SpawnRate + 5
			if WaveGrowth > 10:
				Goliath_SpawnRate = Goliath_SpawnRate + 1
				basic_SpawnRate = basic_SpawnRate - 1
			
			get_node("CameraPivot/Camera").current = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_node("Player").get_node("UserOverlay").visible = false
			get_node("RelicLayer").visible = true
			increaseGold(bonusWaveGold)
			player_object. on_hit_Player(-bonusHealthRegen)
			
			for i in range(3):
				#createRelic(2)
				createRelic(randi() % TotalRelics)
				randomize()
			
			
			
			
	


func createRelic(id: int):
	if id == 0:
		createRelic(randi() % TotalRelics)
	
	if id == 1:
		addRelic("Hostile's Heart", "res://Control Assets/Heart-removebg-preview.png", id, "Max Health increases by 50", "For the longest time I thought your experiements were on the dead!")
		
	elif id == 2:
		createRelic(randi() % TotalRelics)
	elif id == 3:
		addRelic("Bloodied Boots", "res://Control Assets/pngwing.com.png", id, "Increases the Player's movespeed by 10%", "Stealing from the dead once again. How ironic.")
		
	elif id == 4:
		addRelic("Obscene Experiment",  "res://Control Assets/Heart-removebg-preview.png", id, "Restores health to full", "I can't believe how you thought this was ok.")
	
	elif id == 5:
		addRelic("Buddha's Visage", "res://Control Assets/Praying_Hands.png", id, "The player will now glow", "Taking up religion won't save you now, my friend.")
	elif id == 6:
		addRelic("War Bonds", "res://Control Assets/Moneybags-removebg-preview.png", id, "Gain 250 gold", "Ya'know, I really hoped that your funding was legal.")
	elif id == 7:
		addRelic("Nambu's Pistol", "res://Control Assets/Crosshair.png", id, "Increase the hand gun's damage by 5", "I still remember you watched as the barrel graced my temple.")
	elif id == 8:
		addRelic("Civilian's Tears", "res://Control Assets/Shield-removebg-preview.png", id, "Gain 2 Defence", "I don't understand; how you could ignore their cries??")
	elif id == 9:
		addRelic("Innocent's Dread", "res://Control Assets/Crosshair.png", id, "Cut reload time in half", "Now you can finally feel what they felt.")
	elif id == 10:
		createRelic(randi() % TotalRelics)
	elif id == 11:
		addRelic("Last Respite", "res://Control Assets/108988.png", id, "Increases all Canon damage by 10%", "This is obviously a joke; there isn't any rest for the wicked.")
	elif id == 12:
		addRelic("Futile Resistance", "res://Control Assets/LightHouse.png", id, "Increases all Sniper damage by 10%", "You really thought the world was gonna let you get away with it?")
	elif id == 13:
		addRelic("Hateful Animosity", "res://Control Assets/GatlingGun.png", id, "Increases all Gatling damage by 10%", " I don't care what you used to justify it. It still sickens me.")
	elif id == 14:
		createRelic(randi() % TotalRelics)
	elif id == 15:
		createRelic(randi() % TotalRelics)
	elif id == 16:
		createRelic(randi() % TotalRelics)
	elif id == 17:
		createRelic(randi() % TotalRelics)
	elif id == 18:
		createRelic(randi() % TotalRelics)
	elif id == 19:
		addRelic("Scandalous Profit", "res://Control Assets/Moneybags-removebg-preview.png", id, "Receive 50 Gold after each wave", "Lying really is profitable, huh?")
	elif id == 20:
		createRelic(randi() % TotalRelics)
	elif id == 21:
		addRelic("Vile Mutation", "res://Control Assets/First_Aid.png", id, "Regen 20 hp after every wawve", "Are you even satisfied with the results?")
		
func addRelic(name: String, iconPath: String, id: int, Description: String, FlavourText: String):
	var newRelic = relicTemplate.instance()
	newRelic.text = name
	newRelic.icon = ResourceLoader.load(iconPath)
	newRelic.id = id
	newRelic.Desc = Description
	newRelic.FlavourText = FlavourText
	$RelicLayer/MarginContainer/CenterContainer/HBoxContainer.add_child(newRelic)

func _on_ZombieTimer_timeout():
	spawn_object()
	startCounting = true
	
func _on_RelicChosen(id: int):
	if (id  == 0):
		createRelic(randi() % TotalRelics)
	if (id == 1):
		
		Player.HP += 50
		Player.maxHP += 50
		Player.on_hit_Player(0)
	
	if (id == 2):
		createRelic(randi() % TotalRelics)
	if (id == 3):
		Player.speed = Player.speed + 3
	if (id == 4):
		Player.HP = Player.maxHP
		Player.on_hit_Player(0)
	if (id == 5):
		player_object.get_node("Head/Camera/BuddhaVisage").visible = true
		pass
	if (id == 6):
		increaseGold(250)
		
	if (id == 7):
		player_object.playerDamageBuff = player_object.playerDamageBuff + 5
	
	if (id == 8):
		player_object.Defence = player_object.Defence + 2
	if id == 9:
		player_object.get_node("Head/Camera/Sprite3D/Reloadtimer").wait_time = 0.5
	if id == 11:
		var allTowers = get_tree().get_nodes_in_group("Canon")
		for towers in allTowers:
			towers.Dmg = towers.Dmg + 1
	if id == 12:
		var allTowers = get_tree().get_nodes_in_group("Sniper")
		for towers in allTowers:
			towers.Dmg = towers.Dmg + 10
	if id == 13:
		var allTowers = get_tree().get_nodes_in_group("Gatling")
		for towers in allTowers:
			towers.Dmg = towers.Dmg + 1
	if id == 19:
		bonusWaveGold = bonusWaveGold + 50
	if id == 21:
		bonusHealthRegen = bonusHealthRegen + 20

	$RelicLayer.visible = false
	get_node("BuildOverlay").visible = true
	for i in $RelicLayer/MarginContainer/CenterContainer/HBoxContainer.get_children():
		i.queue_free()
	
	
func increaseGold(amount: int):
	Gold = Gold + amount
	$BuildOverlay/MarginContainer/VBoxContainer/GoldLabel.text = "Gold: " + str(Gold)

	
