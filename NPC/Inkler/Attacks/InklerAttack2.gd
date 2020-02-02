extends Node2D

var color

func _ready():
	#155-230
	var newpos = randf()*(230-155)+155
	print("chganin that to %s" % newpos)	
	$PourLocation.position.x = randf()*(230-155)+155
	
	if randf()>0.5:
		$PourLocation/GenericProjectile.type = 2
		$PourLocation.modulate = global.ORANGE_COLOR
	else:
		$PourLocation/GenericProjectile.type = 1
		$PourLocation.modulate = global.GREEN_COLOR
	
