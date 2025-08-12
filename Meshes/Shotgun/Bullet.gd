extends RigidBody

var damage = 5

export var speed = 100 # change this value to adjust the bullet's speed

func _ready():
	
	$"../Timer".start()
	$"../DespawnTimer".start()

func _on_Timer_timeout():
	# get the bullet's current position and rotation
	var direction = -global_transform.basis.z
	var position = global_transform.origin
	
	# set the bullet's velocity to launch it forward
	var velocity = direction * speed
	set_linear_velocity(velocity)


func _on_DespawnTimer_timeout():
	queue_free()
	
	


func _on_RigidBody_body_entered(body):
	# check if the object collided with is on layer 8
	
	if "IsZombie" in body:
		if "HP" in body:
			body.HP -= damage
			
			
			body.playHit()\
			

	queue_free()
func on_TowerShot(damage):
	pass 
