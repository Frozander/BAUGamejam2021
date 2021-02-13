extends Area2D

const SPEED_Y_REF = [.25,0,0,0,-.25]
const MAX_CAT_FOLLOWING_DISTANCE = 125

var speed_x = .5
var speed_y = 0

var direction = 1
var delta_count = 0
var is_walking = false
var is_going_to_cat = false
var is_waiting_cat = false
var cat: Node2D
 
var movement = Vector2()


func _ready():
	delta_count = rand_range(-2,2)
	calc_move()

func _process(delta):	
	delta_count += delta
	
	if delta_count > 3 and not is_going_to_cat and not is_waiting_cat:
		calc_move()
			
	if is_walking and not is_going_to_cat and not is_waiting_cat:
		movement.x = speed_x * direction
		movement.y = speed_y * direction
		var areas = get_overlapping_areas()
		for area in areas:
			if "Person" in area.name:
				collide_with_person(area)
			else:
				exclusion_check(area)
		self.position += movement
		self.z_index = $BodyShape.position.y

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
	self.scale = Vector2(direction, 1)

func rand_dir():
	return pow(-1, randi() % 2);
	
func rand_bool():
	return randi() % 2 == 0

func walk():
	$AnimatedSprite.play("walk")
	is_walking = true
	
func idle():
	$AnimatedSprite.play("idle")
	is_walking = false

func on_hear_meow(cat):
	is_going_to_cat = true
	self.cat = cat
	face_to_cat()
	
func go_to_cat():
	is_going_to_cat = true
	if is_waiting_cat:
		is_going_to_cat = false
		return
	$AnimatedSprite.play("walk")
	movement.x = speed_x * direction
	movement.y = speed_y * direction
	position += movement

func wait_for_cat():
	is_waiting_cat = true
	is_walking = false
	$AnimatedSprite.play("pet")
	$AnimatedSprite.stop()

func pet_cat():
	$AnimatedSprite.play("pet")	

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
			movement.y = 0 if movement.y < 0 else movement.y
		"BottomExclusion":
			movement.y = 0 if movement.y > 0 else movement.y
		"LeftExclusion":
			movement.x = 0 if movement.x < 0 else movement.x
		"RightExclusion":
			movement.x = 0 if movement.x > 0 else movement.x

func collide_with_person(person_area):
	if global_position.x < person_area.global_position.x:
		movement.x = 0 if movement.x > 0 else movement.x
	if global_position.x > person_area.global_position.x:
		movement.x = 0 if movement.x < 0 else movement.x
	if global_position.y < person_area.global_position.y:
		movement.y = 0 if movement.y > 0 else movement.y
	if global_position.y > person_area.global_position.y:
		movement.y = 0 if movement.y < 0 else movement.y

func _on_Person_area_entered(area):
#	print("Person Area Entered: %s" % area.name)
	pass

func _on_PetArea_area_entered(area):
#	print("Pet Area Entered: %s" % area.name)
	pass
