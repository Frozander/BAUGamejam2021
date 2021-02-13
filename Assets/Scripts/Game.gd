extends Node2D

const ZONE_X = 210 #width of move zone
const ZONE_Y = 40
const PERSON_COUNT = 4
const PERSON_HEARING_MEOW_LOWER_LIMIT = 75

const PART_CHANGE_X_GAP = 70

var rng = RandomNumberGenerator.new()

var people = []

const PERSON = preload("res://Assets/Prefabs/Person.tscn")

var current_part = 1

const BACKGROUNDS = [
	preload("res://Assets/Images/Backgrounds/background_second_floor_pixelart.png"),
	preload("res://Assets/Images/Backgrounds/background_first_floor_pixelart.png"),
	preload("res://Assets/Images/Backgrounds/background_garden_pixelart.png")
]


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	for i in 3:
		people.append([])
		for p in PERSON_COUNT:
			var person = PERSON.instance()
			var rand = random_positon_in_move_zone();
			person.position.x += rand[0]
			person.position.y += rand[1]
			people[i].append(person)
	change_part(1)

func _unhandled_key_input(event):
	if Input.is_action_pressed("ui_accept"):
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
		
	current_part = part
	
	for p in len(people[current_part]):
		$MoveZone.add_child(people[current_part][p])
		
	$Backgound.texture = BACKGROUNDS[current_part]

func on_cat_meow():
	$MoveZone/Cat.play_audio()
	var closest_person = find_closest_person_to_cat()
	var dist = dist_between_cat_and_person(closest_person)
	if dist < PERSON_HEARING_MEOW_LOWER_LIMIT:
		closest_person.on_hear_meow($MoveZone/Cat)
		

func _on_RightPort_area_entered(area):
	if area == $MoveZone/Cat:
		if current_part < len(BACKGROUNDS) - 1:
			change_part(current_part + 1)
		


func _on_LeftPort_area_entered(area):
	if area == $MoveZone/Cat:
		if current_part > 0:
			change_part(current_part - 1)
			

func find_closest_person_to_cat():
	var closest_person_to_cat = people[current_part][0]
	var min_dist = dist_between_cat_and_person(closest_person_to_cat)
	for person in people[current_part]:
		var dist = dist_between_cat_and_person(person)
		if dist < min_dist:
			closest_person_to_cat = person
			min_dist = dist
	return closest_person_to_cat

func dist_between_cat_and_person(person):
	var diff = person.position - $MoveZone/Cat.position
	return abs(diff.x)


func _on_HUD_timeout():
	get_tree().change_scene("res://Scenes/FadeIn.tscn")
