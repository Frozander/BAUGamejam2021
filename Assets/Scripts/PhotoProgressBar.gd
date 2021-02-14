extends Node2D

var current_percentage = -1.0

func _process(delta):
	var r = Global.pet_meter_current_value/Global.pet_meter_max_value
	set_percentage(min(100, r*100))

func set_percentage(percentage):
	if current_percentage == percentage:
		return
	if percentage == 100:
		print("Pet meter is full!")
	current_percentage = percentage
	$ProgressBar.value = percentage
