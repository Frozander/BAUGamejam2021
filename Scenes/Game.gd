extends Node2D

const ZONE_X = 240
const ZONE_Y = 40
const PERSON_COUNT = 4

const PART_CHANGE_X_GAP = 30

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

func random_positon_in_move_zone():
	var x = rng.randf_range(-ZONE_X, ZONE_X)
	var y = rng.randf_range(-ZONE_Y, ZONE_Y)
	return [x,y]

func change_part (part):
	if current_part < part:
		$Cat.position.x = 0 + PART_CHANGE_X_GAP
	elif current_part > part:
		$Cat.position.x = (2 * ZONE_X) - (2.5 * PART_CHANGE_X_GAP)
		
	for p in len(people[current_part]):
			$MoveZone.remove_child(people[current_part][p])
		
	current_part = part
	
	for p in len(people[current_part]):
		$MoveZone.add_child(people[current_part][p])
		
	$Backgound.texture = BACKGROUNDS[current_part]

func _on_RightPort_area_entered(area):
	if area == $Cat:
		if current_part < len(BACKGROUNDS):
			change_part(current_part + 1)
		


func _on_LeftPort_area_entered(area):
	if area == $Cat:
		if current_part > 0:
			change_part(current_part - 1)
