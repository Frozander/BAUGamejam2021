extends Area2D

const SPEED_Y_REF = [.25,0,0,0,-.25]

var speed_x = .5
var speed_y = 0

var direction = 1
var delta_count = 0
var is_walking = false

var movment = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	delta_count = rand_range(-2,2)
	calc_move()

func _process(delta):	
	delta_count += delta
	
	if(delta_count > 3):
		calc_move()
			
	if is_walking:
		movment.x = speed_x * direction
		movment.y = speed_y * direction
		var areas = get_overlapping_areas()
		for area in areas:
			if "Person" in area.name:
				collide_with_person(area)
			else:
				exclusion_check(area)
		self.position += movment
		self.z_index = $BodyShape.position.y
		
func calc_move():
	direction = rand_dir()
	delta_count = 0
	is_walking = rand_bool()
	speed_y = SPEED_Y_REF[randi() % SPEED_Y_REF.size()]
	if is_walking:
		idle()
	else:
		 walk()
	self.scale = Vector2(direction, 1)

func rand_dir():
	return pow(-1, randi() % 2);
	
func rand_bool():
	var val = true
	if randi() % 2:
		val = false  
	return val

func walk():
	$AnimatedSprite.play("walk")
	is_walking = true
	
func idle():
	$AnimatedSprite.play("idle")
	is_walking = false

func exclusion_check(area):
	match area.name:
		"TopExclusion":
			movment.y = 0 if movment.y < 0 else movment.y
		"BottomExclusion":
			movment.y = 0 if movment.y > 0 else movment.y
		"LeftExclusion":
			movment.x = 0 if movment.x < 0 else movment.x
		"RightExclusion":
			movment.x = 0 if movment.x > 0 else movment.x

func collide_with_person(person_area):
	if global_position.x < person_area.global_position.x:
		movment.x = 0 if movment.x > 0 else movment.x
	if global_position.x > person_area.global_position.x:
		movment.x = 0 if movment.x < 0 else movment.x
	if global_position.y < person_area.global_position.y:
		movment.y = 0 if movment.y > 0 else movment.y
	if global_position.y > person_area.global_position.y:
		movment.y = 0 if movment.y < 0 else movment.y

func _on_Person_area_entered(area):
#	print("Person Area Entered: %s" % area.name)
	pass

func _on_PetArea_area_entered(area):
#	print("Pet Area Entered: %s" % area.name)
	pass
