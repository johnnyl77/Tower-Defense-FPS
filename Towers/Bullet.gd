extends Spatial

func setTarget(body):
	$BulletBody.target = body
	$BulletBody.targetref = weakref(body)
	
