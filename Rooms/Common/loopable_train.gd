extends Node2D

var TRAINCAR_SCENE = preload("res://Rooms/Area8/8-2/TrainCar.tscn")
onready var tween = $Tween
onready var base_car = $TrainCar
export(Vector2) var car_offset = Vector2(-2,0) 
export(Vector2) var speed_offset = Vector2(500, 0)
var true_speed_offset = Vector2(0,0)

export(int) var car_number = 10
var looping = false

func _process(delta):
		var trash_offset = (speed_offset * Vector2(delta, delta))
		
		if looping:
			var offset = (true_speed_offset * Vector2(delta, delta))
			for car in get_tree().get_nodes_in_group("traincar"):
				car.position = car.position + offset
			
		for car in get_tree().get_nodes_in_group("literal_trash"):
			car.position = car.position + trash_offset
#			print("moving trash car by %s" % trash_offset)

func _ready():
	$EndArea.connect("area_entered", self, "_on_area_entered")
	yield(get_tree().create_timer(1), "timeout")
	for i in car_number: # Duplicate the cars and set their positions!
		var traincar_dupe = TRAINCAR_SCENE.instance()
#		get_tree().get_current_scene().get_node("YSort").add_child(traincar_dupe)
		add_child(traincar_dupe)
		traincar_dupe.position = Vector2(0,0) - (car_offset * i)
	
	
	
func activate(time = 0, launch_time = 5, stop_time = 5, pre_offset = Vector2(0,0)): # time must be greater than launch time (i think)!
#	summon trains
	launch(launch_time, pre_offset)
	if time == 0: # timer activates if value is above 0, else train runs continuously and must be manually stopped
		pass
	else:
		yield(get_tree().create_timer(time), "timeout")
		deactivate(stop_time)
		
		
		
func deactivate(deceleration_time = 5):
	tween.interpolate_property(self, "true_speed_offset",
		null, Vector2(0,0), deceleration_time, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	for car in get_tree().get_nodes_in_group("traincar"):
			car.position = car.position.round()
			
	looping = false



func launch(acceleration_time = 5, pre_offset = Vector2(0,0)):
	looping = true
	print(true_speed_offset)
	for car in get_tree().get_nodes_in_group("traincar"):
		car.position = car.position + pre_offset
		
	tween.interpolate_property(self, "true_speed_offset",
		Vector2(0,0), speed_offset, acceleration_time, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")


	print(true_speed_offset)
		
#	if looping:
#		launch()
#	else:
##		reset()
#		pass
		
func reset(): # Make sure to give enough time for old train cars to clear out
	for car in get_tree().get_nodes_in_group("traincar"):
		car.add_to_group("literal_trash")
		car.remove_from_group("traincar")
	
	deactivate(0.1)
	
	yield(get_tree().create_timer(1), "timeout")
	for i in car_number: # Duplicate the cars and set their positions!
		var traincar_dupe = TRAINCAR_SCENE.instance()
#		get_tree().get_current_scene().get_node("YSort").add_child(traincar_dupe)
		add_child(traincar_dupe)
		traincar_dupe.position = Vector2(0,0) - (car_offset * i)
		


func _on_area_entered(area):
	if area.is_in_group("traincar"):
		area.position = Vector2(0,0)
	elif area.is_in_group("literal_trash"):
		area.queue_free()
