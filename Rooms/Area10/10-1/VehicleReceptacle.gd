extends Area2D

onready var vehicle = get_tree().get_current_scene().get_node("MaintenanceVehicles/MaintenanceVehicle")
onready var remote_transform = get_tree().get_current_scene().get_node(
			"MaintenanceVehicles/MaintenanceVehicle/RemoteTransform2D")
export(bool) var vehicle_exited = false # The first receptacle will have this set to 'true'
onready var green = global.get_player(1)
onready var dropoff_pos = $Position2D.global_position


func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
	
func _on_body_entered(body):
	if body == global.get_player(1) and vehicle.driving == false:
		remote_transform.update_position = true
		vehicle.driving = true
		vehicle_exited = false
		green.frozen = true
		green.visible = false
		print("VEHICLE IS NOW BEING DRIVIN!!!")
		
	if body == vehicle and vehicle.driving == true and vehicle_exited:
		remote_transform.update_position = false
		vehicle.driving = false
		green.position = dropoff_pos

func _on_body_exited(body):
	if body == vehicle:
		vehicle_exited = true
