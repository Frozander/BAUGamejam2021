extends Node2D

const ZONE_X = 240
const ZONE_Y = 40
const PERSON_COUNT = 4

var rng = RandomNumberGenerator.new()

var people = []

const PERSON = preload("res://Assets/Prefabs/Person.tscn")

var current_part = 0

const BACKGROUNDS = [preload("res://Assets/Images/Backgrounds/background_00.png")]


# Called when the node enters the scene tree for the first time.
func _ready():
	change_part()
	rng.randomize()
	for i in 3:
		people.append([])
		for p in PERSON_COUNT:
			var person = PERSON.instance()
			var rand = random_positon_in_move_zone();
			person.position.x += rand[0]
			person.position.y += rand[1]
			people[i].append(person)
		
	for p in len(people[current_part]):
		$MoveZone.add_child(people[current_part][p])

func random_positon_in_move_zone():
	var x = rng.randf_range(-ZONE_X, ZONE_X)
	var y = rng.randf_range(-ZONE_Y, ZONE_Y)
	return [x,y]

func change_part ():
	$Backgound.texture = BACKGROUNDS[current_part]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
