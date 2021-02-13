extends TextureButton

onready var time_label = $Label
export var cooldown = 1.0
export(String) var action_key
export(Resource) var icon

func _ready():
	self.texture_normal = icon
	$Timer.wait_time = cooldown
	set_to_ready_state()
	init_texture_progress()

func _process(delta):
	print("process")
	update_label_value()
	update_texture_progress_value()

func _unhandled_input(event):
	if not Input.is_action_just_pressed(action_key) or $Timer.time_left > 0:
		return
	set_cooldown_state()

func _on_Timer_timeout():
	set_to_ready_state()



func init_texture_progress():
	$TextureProgress.texture_progress = texture_normal
	$TextureProgress.value = 0
	
func update_label_value():
	time_label.text = "%3.1f" % $Timer.time_left
	
func update_texture_progress_value():
	$TextureProgress.value = int(($Timer.time_left/cooldown)*100)

func set_to_ready_state():
	$TextureProgress.value = 0
	disabled = false
	time_label.hide()
	set_process(false)
	
func set_cooldown_state():
	disabled = true
	set_process(true)
	$Timer.start()
	time_label.show()
