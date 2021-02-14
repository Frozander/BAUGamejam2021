extends Area2D

enum particleState {Happy, Sad, Meow, Attack}
enum enemyState { Patrol, Alert, Attack, Flee}

export(float) var speed = 1
export var run_multiplier = 2

var movement_vector = Vector2(0, 0)
var is_playing_audio = false
var delta_count = 0
var target = null
var current_part = 1

var current_state = enemyState.Patrol
var particle_state = particleState.Happy
var heart = preload("res://Assets/Sprites/heart.png")
var broken_heart = preload("res://Assets/Sprites/broken_heart.png")

var meow = preload("res://Assets/Sounds/meow.wav")
var purr = preload("res://Assets/Sounds/purr.wav")
var angry = preload("res://Assets/Sounds/angry.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent().get_node("Cat")
	delta_count = rand_range(-2,2)

func _physics_process(delta):
	delta_count += delta
	
	match current_state:
		enemyState.Patrol:
			if delta_count > 2:
				delta_count = 0
				movement_vector = random_vector2()
			if (self.global_position - target.global_position).abs() < (get_viewport_rect().size / 2):
				if target.is_petting:
					play_audio(angry)
					current_state = enemyState.Attack
		enemyState.Attack:
			var target = get_parent().get_node("Cat")
			if target:
				movement_vector = target.global_position - global_position
				if collide_with_person(target):
					print("hit player")
					get_attack()
					target.hit()
					current_state = enemyState.Patrol
				
	
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
			if "Cat" == area.name:
				collide_with_person(area)
			else:
				exclusion_check(area)
	
	var mov = movement_vector.normalized() * speed 
	
	if mov == Vector2.ZERO:
		$AnimatedSprite.play('idle')
	elif Input.is_action_pressed("ui_run"):
		mov *= run_multiplier
		$AnimatedSprite.play('run')
	elif movement_vector != Vector2.ZERO:
		$AnimatedSprite.play('walk')
	
	match particle_state:
		particleState.Happy:
			$Particles2D.set_texture(heart)
		particleState.Sad:
			$Particles2D.set_texture(broken_heart)
		particleState.Attack:
			$Particles2D.set_texture(broken_heart)
	
	self.z_index = $CollisionShape2D.global_position.y
	self.position += mov

func play_audio(stream = meow):
	if !is_playing_audio:
		is_playing_audio = true
		$AudioStreamPlayer.stream = stream
		$AudioStreamPlayer.play()

func get_pet():
	particle_state = particleState.Happy
	$Particles2D.emitting = true
	play_audio(purr)

func get_angry():
	particle_state = particleState.Sad
	$Particles2D.emitting = true
	play_audio(angry)

func get_attack():
	particle_state = particleState.Attack
	$Particles2D.emitting = true
	play_audio(angry)

func random_vector2():
	return Vector2(rand_range(-1, 1), rand_range(-1, 1))

func collide_with_person(person_area):
	var collision = false
	if overlaps_area(person_area):
		collision = true
		if global_position.x < person_area.global_position.x:
			movement_vector.x = 0 if movement_vector.x > 0 else movement_vector.x
		if global_position.x > person_area.global_position.x:
			movement_vector.x = 0 if movement_vector.x < 0 else movement_vector.x
		if global_position.y < person_area.global_position.y:
			movement_vector.y = 0 if movement_vector.y > 0 else movement_vector.y
		if global_position.y > person_area.global_position.y:
			movement_vector.y = 0 if movement_vector.y < 0 else movement_vector.y
	return collision

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
