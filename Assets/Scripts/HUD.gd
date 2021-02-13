extends Node2D

signal timeout
export(int) var start_in_seconds

func _ready():
	$CountDownLabel.set_start_in_secodnds(start_in_seconds)

func _on_CountDownLabel_timeout():
	emit_signal("timeout")
