extends Node2D

export(int) var start_in_seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = start_in_seconds
	$Timer.start()
	
func _process(delta):
	$Label.text = convert_second_to_minute_string($Timer.time_left)

func convert_second_to_minute_string(seconds):
	var minute_part = int(seconds/60)
	var second_part = int(seconds - minute_part*60)
	var second_part_string = str(second_part)
	if second_part < 10:
		second_part_string = "0" + second_part_string
	return str(minute_part) + ':' + second_part_string
