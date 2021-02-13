extends Node2D

func _process(delta):
	var r = Global.pet_meter_current_value/Global.pet_meter_max_value
	set_percentage(r*100)

func set_percentage(percentage):
	$ProgressBar.value = percentage
