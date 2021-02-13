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
		self.position += movment
		
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
