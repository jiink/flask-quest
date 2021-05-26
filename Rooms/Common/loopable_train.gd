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
	if looping:
		var offset = (true_speed_offset * Vector2(delta, delta))
		for car in get_tree().get_nodes_in_group("traincar"):
			car.position = car.position + offset


func _ready():
	yield(get_tree().create_timer(1), "timeout")
	for i in car_number: # Duplicate the cars and set their positions!
		var traincar_dupe = TRAINCAR_SCENE.instance()
#		get_tree().get_current_scene().get_node("YSort").add_child(traincar_dupe)
		add_child(traincar_dupe)
		traincar_dupe.position = traincar_dupe.position - (car_offset * i)
		
	activate(30, 10, 10)
	
	
	
func activate(time = 0, launch_time = 5, stop_time = 5): # time must be greater than launch time (i think)!
#	summon trains
	launch(launch_time)
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



func launch(acceleration_time = 5):
	looping = true
	print(true_speed_offset)
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
		
func reset():
	pass


func _on_EndArea_body_entered(body):
	if body.is_in_group("traincar"):
		body.position = Vector2(0,0)
