extends Node2D

var current_percentage = -1.0
var is_camera_enabled = false

func _process(delta):
	var r = Global.pet_meter_current_value/Global.pet_meter_max_value
	set_percentage(min(100, r*100))
	$RightIcon/shine_resized.rotation += delta * 3

func set_percentage(percentage):
	if current_percentage == percentage:
		return
	is_camera_enabled = percentage == 100
	if is_camera_enabled:
		$RightIcon/shine_resized.show()
	else:
		$RightIcon/shine_resized.hide()
	current_percentage = percentage
	$ProgressBar.value = percentage

