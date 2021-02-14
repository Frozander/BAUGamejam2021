extends Node2D

const PERSON = preload("res://Assets/Prefabs/Person.tscn")
const ENEMY_CAT = preload("res://Assets/Prefabs/EnemyCat.tscn")
const Cooldown = preload("res://Assets/Scripts/Cooldown.gd")

const ZONE_X = 210 #width of move zone
const ZONE_Y = 40

const PERSON_COUNT = 3
const PERSON_HEARING_MEOW_LOWER_LIMIT = 60

const PART_CHANGE_X_GAP = 70

var rng = RandomNumberGenerator.new()
var people = []
var enemy_cat = null
var current_part = 1
var meow_cooldown:Cooldown = Global.ability_cooldown_map["meow"]

var photographer = null

const BACKGROUNDS = [
	preload("res://Assets/Images/Backgrounds/background_second_floor_pixelart.png"),
	preload("res://Assets/Images/Backgrounds/background_first_floor_pixelart.png"),
	preload("res://Assets/Images/Backgrounds/background_garden_pixelart.png")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	reset()

func _physics_process(_delta):
	# sort_children($MoveZone)
	if get_node_or_null("MoveZone/EnemyCat"):
		stop_enemy_return_timer()
		
	if Input.is_action_just_pressed("pose"):
		if Global.ability_cooldown_map["pose"].is_ready():
			$MoveZone/Cat.on_pose()
			if is_photographer_facing_cat() and is_photographer_ready_to_take_photograph():
				Global.take_photo_and_finish_day()

func is_photographer_facing_cat():
	var is_cat_at_right =($MoveZone/Cat.position - photographer.position).x > 0
	return (is_cat_at_right and photographer.direction == 1) or (not is_cat_at_right and photographer.direction != 1) 
func is_photographer_ready_to_take_photograph():
	return people[current_part].has(photographer) and photographer.is_taking_photo and Global.pet_meter_current_value >= Global.pet_meter_max_value

func _unhandled_key_input(event):
	if Input.is_action_pressed("meow") and meow_cooldown.is_ready():
		on_cat_meow()

func random_positon_in_move_zone():
	var x = rng.randf_range(-ZONE_X, ZONE_X)
	var y = rng.randf_range(-ZONE_Y, ZONE_Y)
	return [x,y]

func change_part(part):
	if current_part < part:
		$MoveZone/Cat.position.x = -ZONE_X
	elif current_part > part:
		$MoveZone/Cat.position.x = ZONE_X
		
	if part != current_part:
		for p in len(people[current_part]):
			$MoveZone.remove_child(people[current_part][p])
		$MoveZone.remove_child(enemy_cat)
		start_enemy_return_timer()
		
	current_part = part
	
	if current_part == enemy_cat.current_part:
		$MoveZone.add_child(enemy_cat)
	
	for p in len(people[current_part]):
		$MoveZone.add_child(people[current_part][p])
	
		
	$Backgound.texture = BACKGROUNDS[current_part]

func on_cat_meow():
	var closest_person = find_closest_person_to_cat()
	if not closest_person:
		return
	var dist = dist_between_cat_and_person(closest_person)
	if dist < PERSON_HEARING_MEOW_LOWER_LIMIT:
		closest_person.on_hear_meow($MoveZone/Cat)
		

func _on_RightPort_area_entered(area):
	if current_part < len(BACKGROUNDS) - 1:
		if area.name == "CatBody":
			change_part(current_part + 1)
		elif area.name == "Person":
			move_person(area, 1)
		


func _on_LeftPort_area_entered(area):
	if current_part > 0:
		if area.name == "CatBody":
			change_part(current_part - 1)
		elif area.name == "Person":
			move_person(area, -1)
			
func move_person(area, dir = 1):
	pass
#	var index = area.current_index
#	$MoveZone.remove_child(people[current_part][index])
#	people[current_part + dir].append(people[current_part][index])
#	people[current_part].remove(index)
#	area.current_index = len(people[current_part + dir])
#	area.position.x = ZONE_X * dir

func find_closest_person_to_cat():
	if len(people[current_part]) > 0:
		var closest_person_to_cat = people[current_part][0]
		var min_dist = dist_between_cat_and_person(closest_person_to_cat)
		for person in people[current_part]:
			if person.is_photographer:
				continue
			var dist = dist_between_cat_and_person(person)
			if dist < min_dist:
				closest_person_to_cat = person
				min_dist = dist
		return closest_person_to_cat

func dist_between_cat_and_person(person):
	var diff = person.position - $MoveZone/Cat.position
	return abs(diff.x)


func _on_HUD_timeout():
	Global.finish_day()

func reset():
	init_people()
	init_enemy_cat()
	current_part = 1
	change_part(1)
	move_enemy_cat_to_part(1)
	
func init_people():
	people = []
	randomize()
	var photographer_index = randi() % (3 * PERSON_COUNT)
	print(photographer_index)
	for i in 3:
		people.append([])
		for p in PERSON_COUNT:
			var is_photo = (i * PERSON_COUNT) + p == photographer_index
			var person = PERSON.instance()
			person.current_index = p
			person.part_index = i
			if is_photo:
				person.make_photographer()
				photographer = person
#			person.current_index = p
			
			var rand = random_positon_in_move_zone();
			person.position.x += rand[0]
			person.position.y += rand[1]
			people[i].append(person)
	listen_people_hit_wall()
	
func listen_people_hit_wall():
	for i in len(people):
		for p in people[i]:
			p.connect("hit_wall",self, "on_person_hit_wall")

func on_person_hit_wall(person):
#	if person.is_last_hitted_wall_right and person.part_index == 2:
#		return
#	if not person.is_last_hitted_wall_right and person.part_index == 0:
#		return
	if person.is_last_hitted_wall_right:
		move_person_to_another_part(person,(person.part_index+1) % 3)
	else:
		move_person_to_another_part(person,(person.part_index-1 )% 3)		
		
func move_person_to_another_part(person,new_part):
	people[current_part].erase(person)
	$MoveZone.remove_child(person)
	person.part_index = new_part
	people[new_part].append(person)
	person.position.x = random_positon_in_move_zone()[0]

func init_enemy_cat():
	enemy_cat = ENEMY_CAT.instance()
	var random_pos = random_positon_in_move_zone()
	enemy_cat.position = Vector2(random_pos[0], random_pos[1])
	enemy_cat.current_part = current_part
	enemy_cat.connect("hit_wall",self,"change_enemy_cat_part")

func change_enemy_cat_part():
	if enemy_cat.is_last_hitted_wall_right and current_part == 2:
		return
	if not enemy_cat.is_last_hitted_wall_right and current_part == 0:
		return
	enemy_cat.position.x = random_positon_in_move_zone()[0]
	if enemy_cat.is_last_hitted_wall_right:
		enemy_cat.current_part = current_part + 1
	else:
		enemy_cat.current_part = current_part - 1
	$MoveZone.remove_child(enemy_cat)
	
func move_enemy_cat_to_part(part):
	var direction = enemy_cat.current_part - part
	if direction > 0:
		enemy_cat.position.x = ZONE_X
	elif direction < 0:
		enemy_cat.position.x = -ZONE_X
	
	enemy_cat.current_part = part
	$MoveZone.add_child(enemy_cat)

func start_enemy_return_timer():
	$EnemyTimer.wait_time = rand_range(5, 10) # 5 and 10 are placeholders
	$EnemyTimer.start()

func stop_enemy_return_timer():
	$EnemyTimer.stop()

func sort_children(node):
	var children = node.get_children()
	for child in children:
		if child is Area2D:
			child.z_index = child.get_node("CollisionShape2D").global_position.y


func _on_EnemyTimer_timeout():
	move_enemy_cat_to_part(current_part)
	
func _on_PersonTimer_timeout():
	if len(people[current_part]) <= 2:
		get_one_person_from_another_part()

func get_one_person_from_another_part():
	var other_part = (current_part + 1) % 3
	if len(people[other_part]) == 0:
		other_part = (current_part + 2) % 3
	var per = people[other_part].pop_back()
	#sağdan geldi
	if other_part > current_part:
		per.position.x = +ZONE_X
		per.direction = -1
	#soldan geldi 
	else:
		per.position.x = -ZONE_X
		per.direction = 1
	per.is_walking = true
	people[current_part].append(per)
	$MoveZone.add_child(per)	
