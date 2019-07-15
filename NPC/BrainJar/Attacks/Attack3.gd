extends Node2D


func _on_BetweenDropsTimer_timeout():
	if $ThoughtCloud.get_child_count() > 0:
		$BetweenDropsTimer.wait_time = randf() * 0.4 + 0.4
		$ThoughtCloud.get_child(randi() % $ThoughtCloud.get_child_count()).drop()
