extends Area2D

enum particleState {Happy, Sad, Meow}

export(float) var speed = 1
export var run_multiplier = 2

var movement_vector = Vector2(0, 0)
var is_playing_audio = false

var current_state = particleState.Happy
var heart = preload("res://Assets/Sprites/heart.png")
var broken_heart = preload("res://Assets/Sprites/broken_heart.png")

var meow = preload("res://Assets/Sounds/meow.wav")
var purr = preload("res://Assets/Sounds/purr.wav")
var angry = preload("res://Assets/Sounds/angry.wav")

var last_played_audio
var is_petting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(_delta):
	movement_vector = Vector2(0, 0)
	if is_petting == false:
		if Input.is_action_pressed("ui_up"): movement_vector += Vector2.UP
		if Input.is_action_pressed("ui_down"): movement_vector += Vector2.DOWN
		if Input.is_action_pressed("ui_left"): movement_vector += Vector2.LEFT
		if Input.is_action_pressed("ui_right"): movement_vector += Vector2.RIGHT
	
	if Input.is_action_just_pressed("meow"):
		on_meow()
	elif Input.is_action_just_pressed("leave"):
		on_leave()
		
	if movement_vector.x < 0:
		$AnimatedSprite.flip_h = false
		if sign($Particles2D.position.x) == 1:
			$Particles2D.position.x *= -1
	elif movement_vector.x > 0:
		$AnimatedSprite.flip_h = true
		if sign($Particles2D.position.x) == -1:
			$Particles2D.position.x *= -1
	
	# Exclusion Zone Collision
	var areas = get_overlapping_areas()
	for area in areas:
		if "Person" in area.name or "Enemy" in area.name:
			collide_with_person(area)
		else:
			exclusion_check(area)
	
	var mov = movement_vector.normalized() * speed 
	
	if mov == Vector2.ZERO:
		if is_petting:
			play_audio(purr)
			current_state = particleState.Happy
			$Particles2D.emitting = true
			$AnimatedSprite.play('sit')
		else:
			$AnimatedSprite.play('idle')
	elif Input.is_action_pressed("ui_run"):
		mov *= run_multiplier
		$AnimatedSprite.play('run')
	elif movement_vector != Vector2.ZERO:
		$AnimatedSprite.play('walk')
	
	match current_state:
		particleState.Happy:
			$Particles2D.set_texture(heart)
		particleState.Sad:
			$Particles2D.set_texture(broken_heart)
	
	self.position += mov
	self.z_index = $CollisionShape2D.position.y

func play_audio(stream = meow):
	if !is_playing_audio:
		is_playing_audio = true
		$AudioStreamPlayer.stream = stream
		$AudioStreamPlayer.play()
		last_played_audio = stream

func start_petting():
	is_petting = true
	
func finish_petting():
	is_petting = false

func get_angry():
	current_state = particleState.Sad
	$Particles2D.emitting = true
	play_audio(angry)

func on_meow():
	if Global.ability_cooldown_map["meow"].is_ready():
		play_audio()
	
func on_leave():
	if Global.ability_cooldown_map["leave"].is_ready():
		$AudioStreamPlayer.stop()
		finish_petting()

func collide_with_person(person_area):
	if global_position.x < person_area.global_position.x:
		movement_vector.x = 0 if movement_vector.x > 0 else movement_vector.x
	if global_position.x > person_area.global_position.x:
		movement_vector.x = 0 if movement_vector.x < 0 else movement_vector.x
	if global_position.y < person_area.global_position.y:
		movement_vector.y = 0 if movement_vector.y > 0 else movement_vector.y
	if global_position.y > person_area.global_position.y:
		movement_vector.y = 0 if movement_vector.y < 0 else movement_vector.y

func exclusion_check(area):
	match area.name:
		"TopExclusion":
			movement_vector.y = 0 if movement_vector.y < 0 else movement_vector.y
		"BottomExclusion":
			movement_vector.y = 0 if movement_vector.y > 0 else movement_vector.y
		"LeftExclusion":
			movement_vector.x = 0 if movement_vector.x < 0 else movement_vector.x
		"RightExclusion":
			movement_vector.x = 0 if movement_vector.x > 0 else movement_vector.x

func _on_AudioStreamPlayer_finished():
	is_playing_audio = false
	match last_played_audio:
		purr:
			Global.pet_meter_current_value += Global.pet_meter_step

func _on_Cat_area_entered(area):
	pass
