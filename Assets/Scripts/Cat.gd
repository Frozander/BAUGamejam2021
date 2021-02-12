extends Area2D

export var speed = 1
export var run_multiplier = 2
var movement_vector = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	movement_vector = Vector2(0, 0)
	if Input.is_action_pressed("ui_up"): movement_vector += Vector2.UP
	if Input.is_action_pressed("ui_down"): movement_vector += Vector2.DOWN
	if Input.is_action_pressed("ui_left"): movement_vector += Vector2.LEFT
	if Input.is_action_pressed("ui_right"): movement_vector += Vector2.RIGHT
	
	if Input.is_action_pressed("ui_select"):
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false
		
	if movement_vector.x == -1:
		$AnimatedSprite.flip_h = false
		if sign($Particles2D.position.x) == 1:
			$Particles2D.position.x *= -1
	elif movement_vector.x == 1:
		$AnimatedSprite.flip_h = true
		if sign($Particles2D.position.x) == -1:
			$Particles2D.position.x *= -1
	
	var mov = movement_vector.normalized() * speed
	
	if mov == Vector2.ZERO:
		$AnimatedSprite.play('idle')
	elif Input.is_action_pressed("ui_run"):
		mov *= run_multiplier
		$AnimatedSprite.play('run')
	elif movement_vector != Vector2.ZERO:
		$AnimatedSprite.play('walk')
	
	
	self.position += mov
