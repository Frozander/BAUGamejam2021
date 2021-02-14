extends Node

const Cooldown = preload("res://Assets/Scripts/Cooldown.gd")

const DEFAULT_DAY_LENGTH_IN_SECONDS = 120
var current_day = 1

var pet_meter_step = 10.0
var pet_meter_current_value = 0.0
var pet_meter_max_value = 100.0

var ability_cooldown_map = {
	"meow": Cooldown.new(3.0),
	"pose": Cooldown.new(40.0),
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

func get_current_day_image():
	return DAY_IMAGE_MAP[current_day]

func finish_day():
	if is_image_taken():
		taken_image_keys.append(current_day)
	reset_cooldowns()
	reset_pet_meter_values()
	current_day += 1

func reset_cooldowns():
	for c in ability_cooldown_map.values():
		c.reset()

func is_image_taken():
	return pet_meter_current_value >= pet_meter_max_value

func reset_pet_meter_values():
	pet_meter_current_value = 0.0

