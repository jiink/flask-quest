extends Node2D

export var zone_width = 32
export var zone_height = 32
var cheese_zone = Rect2(Vector2(384/2 - zone_width/2, 216/2 - zone_height/2), \
Vector2(zone_width, zone_height))

#func _draw():
#	draw_rect(cheese_zone, Color(1,1,1,1), true)
	
func _process(delta):
	if get_node_or_null("Bullet") != null:
		if cheese_zone.has_point($Bullet.position):
			$BulletParticles.emitting = true
			$Bullet.queue_free()
	if get_node_or_null("Bullet2") != null:
		if cheese_zone.has_point($Bullet2.position):
			$BulletParticles2.emitting = true
			$Bullet2.queue_free()
	if get_node_or_null("Bullet3") != null:
		if cheese_zone.has_point($Bullet3.position):
			$BulletParticles3.emitting = true
			$Bullet3.queue_free()
	if get_node_or_null("Bullet4") != null:
		if cheese_zone.has_point($Bullet4.position):
			$BulletParticles4.emitting = true
			$Bullet4.queue_free()

