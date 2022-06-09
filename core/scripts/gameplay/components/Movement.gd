tool
extends Component
class_name Movement2D, "res://core/scripts/icons/icon_component_movement.svg"

enum MovementMode {
	FREE, DISCRETE
}

var vz := 0.0
var velocity := Vector2.ZERO
var input_vector := Vector2.ZERO

onready var texture = get_node(custom_properties["Animation/Visual Sprite"])

################################## CODE ###################################

func _physics_process(delta):
	if Engine.editor_hint:
		return
	
	# Get the input vector
	input_vector = Input.get_vector(
		custom_properties["Input/Action LEFT"],
		custom_properties["Input/Action RIGHT"],
		custom_properties["Input/Action UP"],
		custom_properties["Input/Action DOWN"]
	)
	
	# Move!
	match custom_properties["Motion/Mode"]:
		MovementMode.FREE:
			move_free(delta)
	
	# Juicy Effects
	if custom_properties["Animation/Squash and Stretch/Active"]:
		var target_scale = custom_properties["Animation/Squash and Stretch/Target Scale"]
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			texture.scale.x = target_scale.x * 2.0
			texture.scale.y = target_scale.y * 0.5
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			texture.scale.x = target_scale.x * 0.5
			texture.scale.y = target_scale.y * 2.0
		texture.scale = texture.scale.move_toward(
			target_scale,
			delta * 10.0 * target_scale.x
		)

func move_free(delta):
	# If gravity is active, move horizontally and fall
	if custom_properties["Motion/Gravity/Active"]:
		velocity.x = move_toward(velocity.x, input_vector.x * custom_properties["Motion/Maximum Speed"], custom_properties["Motion/Acceleration"] * delta)
		velocity += custom_properties["Motion/Gravity/Direction"] * custom_properties["Motion/Gravity/Magnitude"] * delta
		get_parent().position += velocity * delta
		if get_parent().position.y > 600:
			velocity.y = -custom_properties["Motion/Gravity/Magnitude"] * custom_properties["Motion/Gravity/Jump Strength"]
	else:
		velocity = velocity.move_toward(
			input_vector *\
			custom_properties["Input/Scale"] *\
			custom_properties["Motion/Maximum Speed"],
			custom_properties["Motion/Acceleration"] * delta
		)
		get_parent().position += velocity * delta
		custom_properties["Motion/Z"] += vz * delta
		texture.position.y = - custom_properties["Motion/Z"]
		var target_scale = custom_properties["Animation/Squash and Stretch/Target Scale"]
		var z = custom_properties["Motion/Z"]
		
		if z > 0.0:
			vz -= custom_properties["Motion/Gravity/Magnitude"] * delta * 2
		if z < 0.0:
			custom_properties["Motion/Z"] = 0.0
			vz = 0.0
			texture.scale.x = target_scale.x * 2.0
			texture.scale.y = target_scale.y * 0.5
		if z == 0 and Input.is_action_pressed(custom_properties["Input/Action SPECIAL"]):
				vz = custom_properties["Motion/Gravity/Magnitude"] * custom_properties["Motion/Gravity/Jump Strength"]
				texture.scale.x = target_scale.x * 0.5
				texture.scale.y = target_scale.y * 2.0

######################### EDITOR CONFIGURATION #########################
func _get_property_list():
	
	var properties = []
	
	# Input
	properties += [
		{"name": "Input/Action UP", "type": TYPE_STRING},
		{"name": "Input/Action LEFT", "type": TYPE_STRING},
		{"name": "Input/Action DOWN", "type": TYPE_STRING},
		{"name": "Input/Action RIGHT", "type": TYPE_STRING},
		{"name": "Input/Action SPECIAL", "type": TYPE_STRING},
		{"name": "Input/Scale", "type": TYPE_VECTOR2},
	]
	
	# Movement
	properties += [
		{"name": "Motion/Mode", "type": TYPE_INT, "hint": PROPERTY_HINT_ENUM, "hint_string":"Free,Discrete"},
		{"name": "Motion/Maximum Speed", "type": TYPE_REAL},
		{"name": "Motion/Acceleration", "type": TYPE_REAL},
		{"name": "Motion/Gravity/Active", "type": TYPE_BOOL},
	]
	
	if custom_properties["Motion/Mode"] == MovementMode.FREE:
		properties.append({
			"name": "Motion/Sidescroller", "type": TYPE_BOOL,
			})
		if not custom_properties["Motion/Sidescroller"] and custom_properties["Motion/Gravity/Active"]:
			properties.append({"name": "Motion/Z", "type": TYPE_REAL})
	
	if custom_properties["Motion/Gravity/Active"]:
		properties += [
			{"name": "Motion/Gravity/Direction", "type": TYPE_VECTOR2},
			{"name": "Motion/Gravity/Magnitude", "type": TYPE_REAL},
			{"name": "Motion/Gravity/Jump Strength", "type": TYPE_REAL}
		]
		
	
	# Animation
	properties += [
		{"name": "Animation/Visual Sprite", "type": TYPE_NODE_PATH},
		{"name": "Animation/Active", "type": TYPE_BOOL}
	]
	
	if custom_properties["Animation/Active"]:
		properties.append({"name": "Animation/Squash and Stretch/Active", "type": TYPE_BOOL})
		if custom_properties["Animation/Squash and Stretch/Active"]:
			properties.append({"name": "Animation/Squash and Stretch/Target Scale", "type": TYPE_VECTOR2})
	
	return properties

var custom_properties : Dictionary = {
	"Input/Action UP": "ui_up",
	"Input/Action LEFT": "ui_left",
	"Input/Action DOWN": "ui_down",
	"Input/Action RIGHT": "ui_right",
	"Input/Action SPECIAL": "OK",
	"Input/Scale": Vector2.ONE,
	
	"Motion/Mode": 0,
	"Motion/Maximum Speed": 768,
	"Motion/Acceleration": 12288,
	"Motion/Gravity/Active": false,
	"Motion/Gravity/Direction": Vector2.DOWN,
	"Motion/Gravity/Magnitude": 2048,
	"Motion/Gravity/Jump Strength": 0.5,
	"Motion/Sidescroller": false,
	"Motion/Z": 0,
	
	"Animation/Visual Sprite": null,
	"Animation/Active": false,
	"Animation/Squash and Stretch/Active": false,
	"Animation/Squash and Stretch/Target Scale": Vector2.ONE,
}

func _set(property, value):
	if custom_properties.has(property):
		custom_properties[property] = value
		property_list_changed_notify()
		return true
	return false

func _get(property):
	if custom_properties.has(property):
		return custom_properties[property]

func _get_configuration_warning():
	if not get_parent() is KinematicBody2D:
		return "Parent must be of type KinematicBody2D"
	return ""
