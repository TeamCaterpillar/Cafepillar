class_name DayNightCycle
extends Node2D

# Time management
@export var day_length: float = 60.0  # Duration of one day in seconds
var time_of_day: float = 0.0  # Normalized time (0.0 = midnight, 0.5 = noon)
var day_ended: bool = false  # Track if the day has ended

# Nodes
@onready var background: ColorRect = $Background
@onready var light: Light2D = $Light
@onready var end_of_day_screen: Panel = $EndOfDayScreen
@onready var restart_button: Button = $EndOfDayScreen/NextDay
@onready var skip_button: Button = $SkipDay
@onready var timer_label: Label = $TimerLabel


func _ready():
	# Connect button signals
	restart_button.pressed.connect(_on_restart_button_pressed)
	skip_button.pressed.connect(_on_skip_button_pressed)


func _process(delta):
	# Update time of day
	if not day_ended:
		time_of_day = fmod(time_of_day + delta / day_length, 1.0)

		# Check if it's the end of the day
		if time_of_day > 0.5:  # End of day (close to midnight)
			end_day()

		# Update background and light
		update_background()
		update_light()
		update_timer()


func update_background():
	# Smooth gradient between night (dark blue) and day (light blue)
	var gradient = sin(time_of_day * PI)  # Smooth transition
	background.color = Color(0.05, 0.05, 0.2).lerp(Color(0.5, 0.8, 1.0), gradient)


func update_light():
	# Change light intensity and color based on time of day
	if time_of_day < 0.25 or time_of_day > 0.75:  # Dawn/Dusk
		light.energy = lerp(0.1, 1.0, abs(time_of_day - 0.5) * 4.0)
	else:  # Daytime
		light.energy = 1.0

	# Optional: Change light color to be warmer during the day and cooler at night
	light.color = Color(1.0, 0.9, 0.7).lerp(Color(0.5, 0.6, 1.0), 1.0 - light.energy)


func update_timer():
	# Calculate hours and minutes from time_of_day
	var total_minutes = int(time_of_day * 24 * 60)  # Total minutes in a day
	@warning_ignore("integer_division")
	var hours = (total_minutes / 60 + 6) % 24  # Offset by 6 hours (6:00 AM start)
	var minutes = total_minutes % 60  # Remainder for minutes

	# Update the TimerLabel
	timer_label.text = "%02d:%02d" % [hours, minutes]


func end_day():
	# Mark the day as ended
	day_ended = true
	
	# Emit day_ended signal to trigger connected functions in other components
	GameSignals.day_ended.emit()
	
	# Show the End of Day screen
	end_of_day_screen.visible = true


func _on_restart_button_pressed():
	# Reset the day
	day_ended = false
	time_of_day = 0.0
	
	# emit signal to let other components know that next day has started
	GameSignals.next_day_started.emit()

	# Hide the End of Day screen
	end_of_day_screen.visible = false


func _on_skip_button_pressed():
	# Skip to the end of the day
	time_of_day = 0.99
	update_background()
	end_day()

func _remove_card_from_slot(card: Control, slot: Control) -> void:
	# Remove the card from its current parent
	if card.get_parent():
		card.get_parent().remove_child(card)
	
	slot.remove_child(card)
