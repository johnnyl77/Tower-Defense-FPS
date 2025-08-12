extends Control


var Bonuses = {"Canon": 0, "Sniper Tower": 0, "Gatling Gun": 0, "Tesla Tower": 0}

var Canon = preload("res://Towers/Tower2.tscn")
var Sniper = preload("res://Towers/SniperTower.tscn")
var Gatling = preload("res://Towers/GatlingGun.tscn")
var Tesla = preload("res://Towers/TeslaTower.tscn")

var CanonUpgradeCost = 600
var SniperUpgradeCost = 1600
var GatlingUpgradeCost = 2000
var TeslaUpgradeCost = 1000


onready var buildCamera = get_node("../../CameraPivot/Camera")
onready var rootNode = get_node("../..")



func _on_Cannon_pressed():
	if rootNode.Gold >= 300:
		var newCanon = Canon.instance()
		var towerBody = newCanon.get_node("TowerBody")
		buildCamera.addToInventory(towerBody.Name, towerBody.IconPath, towerBody.thisScene)
		rootNode.increaseGold(-300)


func _on_Machine_Gun_pressed():
	if rootNode.Gold >= 1000:
		var newGatling = Gatling.instance()
		var towerBody = newGatling.get_node("TowerBody")
		buildCamera.addToInventory(towerBody.Name, towerBody.IconPath, towerBody.thisScene)
		rootNode.increaseGold(-1000)


func _on_Sniper_pressed():
	if rootNode.Gold >= 800:
		var newSniper = Sniper.instance()
		var towerBody = newSniper.get_node("TowerBody")
		buildCamera.addToInventory(towerBody.Name, towerBody.IconPath, towerBody.thisScene)
		rootNode.increaseGold(-800)


func _on_Tesla_pressed():
	if rootNode.Gold >= 500:
		var newTesla = Tesla.instance()
		var towerBody = newTesla.get_node("TowerBody")
		buildCamera.addToInventory(towerBody.Name, towerBody.IconPath, towerBody.thisScene)
		rootNode.increaseGold(-500)


func _on_CanonUpgrade_pressed():
	
	if rootNode.Gold >= CanonUpgradeCost:
		var allCanons = get_tree().get_nodes_in_group("Canon")
	
		for towers in allCanons:
			towers.Dmg = towers.Dmg + 10
	
		Bonuses.Canon = Bonuses.Canon + 1
		CanonUpgradeCost = CanonUpgradeCost + 300
		get_node("MarginContainer/CenterContainer/GridContainer/CanonUpgrade/Cost").text = str(CanonUpgradeCost)
		print(Bonuses)
		rootNode.increaseGold(-CanonUpgradeCost)


func _on_GatlingTowerUpgrade_pressed():
	if rootNode.Gold >= GatlingUpgradeCost:
		var allGatlings = get_tree().get_nodes_in_group("Gatling")
	
		for towers in allGatlings:
			towers.Dmg = towers.Dmg + 5

		Bonuses["Gatling Gun"] = Bonuses["Gatling Gun"] + 1
		GatlingUpgradeCost = GatlingUpgradeCost + 1000
		get_node("MarginContainer/CenterContainer/GridContainer/GatlingTowerUpgrade/Cost").text = str(GatlingUpgradeCost)
		print(Bonuses)
		rootNode.increaseGold(-GatlingUpgradeCost)


func _on_SniperUpgrade_pressed():
	if rootNode.Gold >= SniperUpgradeCost:
		var allSnipers = get_tree().get_nodes_in_group("Sniper")
	
		for towers in allSnipers:
			towers.Dmg = towers.Dmg + 50
	

		Bonuses["Sniper Tower"] = Bonuses["Sniper Tower"] + 1
		SniperUpgradeCost = SniperUpgradeCost + 800
		get_node("MarginContainer/CenterContainer/GridContainer/SniperUpgrade/Cost").text = str(SniperUpgradeCost)
		
		print(Bonuses)
		rootNode.increaseGold(-SniperUpgradeCost)


func _on_TeslaUpgrade_pressed():
	if rootNode.Gold >= TeslaUpgradeCost:
		var allTesla = get_tree().get_nodes_in_group("Tesla")
	
		for towers in allTesla:
			towers.Dmg = towers.Dmg + 1
	
		Bonuses["Tesla Tower"] = Bonuses["Tesla Tower"] + 1
		TeslaUpgradeCost = TeslaUpgradeCost + 500
		get_node("MarginContainer/CenterContainer/GridContainer/TeslaUpgrade/Cost").text = str(TeslaUpgradeCost)
		
		print(Bonuses)
		rootNode.increaseGold(-TeslaUpgradeCost)
