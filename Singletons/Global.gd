extends Node

const Cooldown = preload("res://Assets/Scripts/Cooldown.gd")

const DEFAULT_DAY_LENGTH_IN_SECONDS = 120
const LAST_DAY = 5
var current_day = 0

var pet_meter_step = 10.0
var pet_meter_current_value = 0.0
var pet_meter_max_value = 100.0

var ability_cooldown_map = {
	"meow": Cooldown.new(3.0),
	"pose": Cooldown.new(10.0),
	"leave": Cooldown.new(5.0)
}

var DAY_IMAGE_MAP = {
	1: preload("res://Assets/Images/Polaroids/1.jpg"),
	2: preload("res://Assets/Images/Polaroids/2.jpg"),
	3: preload("res://Assets/Images/Polaroids/3.jpg"),
	4: preload("res://Assets/Images/Polaroids/4.jpg"),
	5: preload("res://Assets/Images/Polaroids/5.png")
}

var taken_image_keys = []

func start_game():
	reset_pet_meter_values()
	if current_day == LAST_DAY:
		current_day = 0
	go_to_next_day()

func get_current_day_image():
	return DAY_IMAGE_MAP[current_day]

func take_photo_and_finish_day():
	if not taken_image_keys.has(current_day):
		taken_image_keys.append(current_day)
	finish_day()

func finish_day():
	get_tree().change_scene("res://Scenes/FadeIn.tscn")
	
func go_to_next_day():
	reset_cooldowns()
	reset_pet_meter_values()
	current_day += 1

func reset_cooldowns():
	for c in ability_cooldown_map.values():
		c.reset()

func reset_pet_meter_values():
	pet_meter_current_value = 0.0

