extends Node2D

export(int) var start_in_seconds
signal timeout

func _ready():
	set_start_in_secodnds(Global.DEFAULT_DAY_LENGTH_IN_SECONDS)

func _process(delta):
	$Label.text = convert_second_to_minute_string($Timer.time_left)

func convert_second_to_minute_string(seconds):
	var minute_part = int(seconds/60)
	var second_part = int(seconds - minute_part*60)
	var second_part_string = str(second_part)
	if second_part < 10:
		second_part_string = "0" + second_part_string
	return str(minute_part) + ':' + second_part_string

func set_start_in_secodnds(val):
	start_in_seconds = val
	$Timer.wait_time = start_in_seconds
	$Timer.start()
	
func _on_Timer_timeout():
	emit_signal("timeout")
