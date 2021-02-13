export var time = 0.0
export var max_time = 0.0

func _init(max_time):
	self.max_time = max_time
	self.time = max_time

func tick(delta):
	time = max(time - delta, 0)

func is_ready():
	if time > 0:
		return false
	reset()
	return true
	
func reset():
	time = max_time
	
