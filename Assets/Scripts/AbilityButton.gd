extends TextureButton

const Cooldown = preload("res://Assets/Scripts/Cooldown.gd")

export(String) var action_key = "meow"
export(Resource) var icon
export(String) var ability_label
var cooldown:Cooldown

func _ready():
	texture_normal = icon
	$AbilityLabel.text = ability_label
	cooldown = Global.ability_cooldown_map[action_key]
	set_to_ready_state()
	init_texture_progress()

func _process(delta):
	cooldown.tick(delta)
	if Input.is_action_just_pressed(action_key):
		if cooldown.is_ready():
			cooldown.start()
	elif cooldown.is_ready():
		set_to_ready_state()
	else:
		set_to_cooldown_state()
		update_label_value()
		update_texture_progress_value()
		

func _unhandled_input(event):
	if Input.is_action_just_pressed(action_key) and cooldown.is_ready():
		set_to_cooldown_state()

func init_texture_progress():
	$TextureProgress.texture_progress = texture_normal
	$TextureProgress.value = 0
	
func update_label_value():
	$TimeLabel.text = "%3.1f" % cooldown.time
	
func update_texture_progress_value():
	$TextureProgress.value = int((cooldown.get_time_left()/cooldown.max_time)*100)

func set_to_ready_state():
	$TextureProgress.value = 0
	disabled = false
	$TimeLabel.hide()
	
func set_to_cooldown_state():
	disabled = true
	$TimeLabel.show()
