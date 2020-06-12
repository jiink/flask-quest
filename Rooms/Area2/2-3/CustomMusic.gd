extends Node

onready var player = global.get_player(1)

func _ready():
	add_to_group("tick")
	$DougApproaching.play()
	$DougEntry.play()

# this music is stopped in the room's script

func _tick():
	# the closer player is to douglas throne, the more it transitions away from doug_approaching.ogg to doug_entry.ogg
	# 1500y is -25db, 0y is 0db
	var d_approaching_linear_v = player.position.y * 0.0008 # 1/1250
	d_approaching_linear_v = clamp(d_approaching_linear_v, 0.0, 1.0)
	var d_entry_linear_v = 1.0 - d_approaching_linear_v
	$DougApproaching.set_volume_db(linear2db(d_approaching_linear_v))
	$DougEntry.set_volume_db(linear2db(d_entry_linear_v))
	# MusicManager.set_volume( -(player.position.y * 0.017))

func stop():
	print("stopping music")
	$DougApproaching.stop()
	$Tween.interpolate_property($DougEntry, "volume_db", null, -80, 5.0)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	$DougEntry.stop()
	print("stopped music")
