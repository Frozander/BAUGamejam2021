var time = 0.0
var max_time = 0.0

func _init(max_time):
	self.max_time = max_time
	self.time = 0

func tick(delta):
	time = max(time - delta, 0)

func is_ready():
	return time == 0
	
func get_time_left():
	return max_time - time

func start():
	time = max_time
