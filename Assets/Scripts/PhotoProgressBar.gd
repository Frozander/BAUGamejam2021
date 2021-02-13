extends Node2D

func _process(delta):
	var r = Global.pet_meter_current_value/Global.pet_meter_max_value
	if r*100 > 100:
		print("Pet meter is higher than 100, rounding")
	set_percentage(min(100, r*100))

func set_percentage(percentage):
	if percentage == 100:
		print("Pet meter is full!")
	$ProgressBar.value = percentage
