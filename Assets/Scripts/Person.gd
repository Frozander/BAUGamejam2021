extends Area2D

const SPEED_Y_REF = [.25,0,0,0,-.25]
const MAX_CAT_FOLLOWING_DISTANCE = 125
const PETTING_DURATIONS = [3,5,7]

var current_index = 0

var speed_x = .5
var speed_y = 0

var direction = 1
var delta_count = 0
var is_walking = false
var is_going_to_cat = false
var is_waiting_cat = false
var is_petting_cat = false
var is_petted_cat = false
var cat: Node2D


var sprites = [
	preload("res://Assets/AnimatedSprites/Person.tres"),
	preload("res://Assets/AnimatedSprites/Person2.tres"),
	preload("res://Assets/AnimatedSprites/Person3.tres"),	
	preload("res://Assets/AnimatedSprites/Person5.tres"),	
	]
 
var photographer_sprite = preload("res://Assets/AnimatedSprites/Person4.tres")

var is_photographer = false

var movement = Vector2()

var petting_duration = 3

var lastColidedArea = null

func _ready():
	delta_count = rand_range(-2,2)
	if is_photographer:
		$AnimatedSprite.frames = photographer_sprite
	else:
		$AnimatedSprite.frames = sprites[randi() % len(sprites)]
	calc_move()
		

func _process(delta):	
	delta_count += delta
	
	if is_petting_cat:
		if delta_count > petting_duration:
			end_petting()
	else:
		if delta_count > 3 and not is_going_to_cat and not is_waiting_cat:
			calc_move()
				
		if is_walking and not is_going_to_cat and not is_waiting_cat:
			movement.x = speed_x * direction
			movement.y = speed_y * direction
			var areas = get_overlapping_areas()
			for area in areas:
				if area.name == "PersonBody" or area.name == "CatBody":
					collide_with_person(area)
				else:
					exclusion_check(area)
			self.position += movement			
			self.scale = Vector2(direction, 1)

		#50 needen becouse person's center not real center look 2d :/
		self.z_index = $PersonBody.global_position.y + 50
		
		calc_coliders()
		
		if not self.cat:
			return

		var dist_to_cat = position.distance_to(cat.position)
		if (is_going_to_cat or is_waiting_cat) and dist_to_cat > MAX_CAT_FOLLOWING_DISTANCE:
			stop_following_cat()
		if is_going_to_cat:
			face_to_cat()
			if dist_to_cat < 55:
				wait_for_cat()
			else:
				go_to_cat()
				
		calc_coliders()
		
		
	if Input.is_action_just_pressed("leave"):
		end_petting()

func calc_coliders():
	if is_waiting_cat or is_petting_cat:
		$PersonBody.position.x = -10
		$BodyShape.position.x = -10
		$PersonPetZone.show()
	else:
		$PersonBody.position.x = 0
		$BodyShape.position.x = 0
		$PersonPetZone.hide()		
		
func make_photographer():
	$AnimatedSprite.frames = photographer_sprite
	is_photographer = true
	calc_move()
		
func calc_move():
	direction = rand_dir()
	delta_count = 0
	is_walking = rand_bool()
	speed_x = .5
	speed_y = SPEED_Y_REF[randi() % SPEED_Y_REF.size()]
					
	if is_walking:
		idle()
	else:
		 walk()
	
	
func take_photo():
	$AnimatedSprite.play("photo")

func rand_dir():
	return pow(-1, randi() % 2);
	
func rand_bool():
	return randi() % 2 == 0

func walk():
	$AnimatedSprite.play("walk")
	is_walking = true
	
func idle():
	if is_photographer and (randi() % 3) < 2:
		take_photo()
	else:
		$AnimatedSprite.play("idle")
	is_walking = false

func on_hear_meow(cat):
	if not is_petted_cat:
		is_going_to_cat = true
		self.cat = cat
		face_to_cat()
	
func go_to_cat():
	is_going_to_cat = true
	if is_waiting_cat:
		is_going_to_cat = false
		return
	$AnimatedSprite.play("walk")
	movement = (cat.position - position).normalized() / 2
	position += movement

func wait_for_cat():
	if is_petting_cat == false:
		is_waiting_cat = true
		is_walking = false
		$AnimatedSprite.play("pet")
		$AnimatedSprite.stop()

func pet_cat():
	delta_count = 0
	petting_duration = PETTING_DURATIONS[randi() % PETTING_DURATIONS.size()]
	is_petting_cat = true
	is_waiting_cat = false
	self.cat.start_petting()
	$AnimatedSprite.play("pet")

func end_petting():
	is_petting_cat = false
	is_petted_cat = true
	is_waiting_cat = false
	is_going_to_cat = false
	calc_move()
	delta_count = 0
	self.cat.finish_petting()

func face_to_cat():
	if position.x < cat.position.x:
		direction = 1
	else:
		direction = -1
	self.scale = Vector2(direction, 1)

func stop_following_cat():
	is_waiting_cat = false
	is_going_to_cat = false
	is_walking = true
	calc_move()

func exclusion_check(area):
	match area.name:
		"TopExclusion":
			if movement.y < 0:
				movement.y = 0
				lastColidedArea = area
		"BottomExclusion":
			if movement.y > 0:
				movement.y = 0
				lastColidedArea = area
		"LeftExclusion":
			if movement.x < 0:
				movement.x *= -1
				direction *= -1
				lastColidedArea = area
		"RightExclusion":
			if movement.x > 0:
				movement.x *= -1
				direction *= -1
				lastColidedArea = area

func collide_with_person(person_area):
	if person_area != lastColidedArea:
		if global_position.x < person_area.global_position.x:
			if movement.x > 0:
				movement.x *= -1 
				direction *= -1
				lastColidedArea = person_area
		if global_position.x > person_area.global_position.x:
			if movement.x:
				movement.x *= -1
				direction *= -1
				lastColidedArea = person_area
		if global_position.y < person_area.global_position.y:
			if movement.y:
				movement.y *= -1
				direction *= -1
				lastColidedArea = person_area
		if global_position.y > person_area.global_position.y:
			if movement.y:
				movement.y *= -1
				direction *= -1
				lastColidedArea = person_area

func _on_Person_area_entered(area):
#	print("Person Area Entered: %s" % area.name)
	pass


func _on_PetZone_area_entered(area):
	if is_waiting_cat && area.name == "CatPetZone":
		pet_cat()
		
