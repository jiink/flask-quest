extends Node2D

func _on_puzzle_valve_turned():
    $LiquidSprite.queue_free()