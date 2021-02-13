extends Node2D

signal timeout

func _on_CountDownLabel_timeout():
	emit_signal("timeout")
