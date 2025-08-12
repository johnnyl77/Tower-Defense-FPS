extends KinematicBody

var target: KinematicBody = null
var targetref 
var lastpos
var speed = 1000



#func _ready():
	

func _process(delta):
	
	if targetref.get_ref():
		lastpos = target.translation
		var direction = (target.translation - translation).normalized()
		var xyz_direction = Vector3(direction.x, direction.y, direction.z).normalized()
		var movement = xyz_direction * speed
			
			
		move_and_slide(movement, Vector3.UP)
	else:
		var direction = (lastpos - translation).normalized()
		var xyz_direction = Vector3(direction.x, direction.y, direction.z).normalized()
		var movement = xyz_direction * speed
		move_and_slide(movement, Vector3.UP)
		
		



func _on_Area_body_entered(body):
	print("LKSJHJASKDFHSALDKFHSADLKFHJLKASDHFJSKLFHIWEURUQWPOIURWEIPORUWQEIFLDJKSFHALJKDFHLKS")
	print("Bullet hit: " + str(body))
	queue_free()
	
