extends KinematicBody

export var speed = 30
export var gravity = -98.1
onready var target = get_node_or_null("../Player") 
var levelstarted = true

var HP = 5

var IsZombie = true


export var damage = 10
signal hitPlayer

func _ready():
	connect("hitPlayer", target, "on_hit_Player")
	$FallTimer.start()
	pass

func _physics_process(delta):
	if levelstarted:
		if target != null:
			var direction = (target.translation - translation).normalized()
			var xz_direction = Vector3(direction.x, 0, direction.z).normalized()
			var movement = xz_direction * speed
			movement.y = gravity
			
			
			move_and_slide(movement, Vector3.UP)
			var player_position = target.global_transform.origin
		


			var target_position = Vector3(player_position.x, self.translation.y, player_position.z)
			
		
			self.look_at(target_position, Vector3.UP)
			
	

	if HP < 0:
		queue_free()

			
			
		
func _on_StartCounter_timeout():
	levelstarted = true
	
	


func _on_AnimationPlayer_ready():
	pass





func _on_Area_body_entered(body):
	if body==target:
		
		emit_signal("hitPlayer", damage)
		print("Cross product: " + str(crossXZ()))
		$Area.set_deferred("monitoring", false)
		$AttackCD.start()
		


func _on_AttackCD_timeout():
	$Area.set_deferred("monitoring", true)
	#$Area.get_overlapping_bodies()


func _on_FallTimer_timeout():
	gravity = -9.81
	
func crossXZ():
	var normalSelf = global_transform.origin.normalized()
	var normalPlayer = target.global_transform.origin.normalized()
	
	return float(normalSelf.z * normalPlayer.x - normalSelf.x * normalPlayer.z)

func on_TowerShot(Damage: int):
	HP = HP - Damage
	
	if HP < 0:
		playHit()
		target._on_Score_timer_timeout(20)
		get_parent().increaseGold(10)
		$KillZombieTimer.start()
		
		
		
func on_Stun(Damage: int):
	$lowpolyzombie2/RootNode/AnimationPlayer.stop()
	$StunTimer.wait_time = Damage
	$StunTimer.start()
	levelstarted = false
	
func playHit():
	$HitMarker.play()

func _on_KillZombieTimer_timeout():
	queue_free()
	



func _on_StunTimer_timeout():
	$lowpolyzombie2/RootNode/AnimationPlayer.play()
	levelstarted = true
