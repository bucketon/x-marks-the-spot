extends CharacterBody3D

@export var speed = 8
@export var sprintSpeed = 12
@export var fall_acceleration = 75
@export var flag_time = 2
@export var shake_amt = 0.5

signal victory
signal defeat
signal mapOpen
signal mapClose
signal pause
signal unpause
signal step(loc:Vector2, rot:Vector3)

var target_velocity = Vector3.ZERO
var mouse_captured: bool = false
var look_dir: Vector2 
var is_touching_goal: bool = false
var flag_held_seconds: float = 0
var map_is_open = false
var paused = false
var footprintTimer = 0

@onready var camera: Camera3D = $camera
@onready var initialCameraPos = $camera.transform

func _ready() -> void:
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	

func capture_mouse() -> void:
	print("captured")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
	

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * sens_mod, -1.5, 1.5)
	

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 2.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = not paused
		if paused:
			pause.emit()
			release_mouse()
		else:
			unpause.emit()
			capture_mouse()
	
	if paused:
		return
	
	var is_moving = false
	var direction = Vector3.ZERO
	if not Input.is_action_pressed("action"):
		if Input.is_action_pressed("move_right"):
			direction.x += 1
			is_moving = true
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
			is_moving = true
		if Input.is_action_pressed("move_back"):
			direction.z += 1
			is_moving = true
		if Input.is_action_pressed("move_forward"):
			direction.z -= 1
			is_moving = true
			
	var magnitude = speed
	var footstepPeriod = 0.4
	if Input.is_action_pressed("sprint"):
		magnitude = sprintSpeed
		footstepPeriod = 0.3
		
	if Input.is_action_pressed("action"):
		flag_held_seconds += delta
		var rng = RandomNumberGenerator.new()
		var m = flag_held_seconds/flag_time * -1
		var n = flag_held_seconds/flag_time
		var cameraShake = Vector3(rng.randf_range(m, n)*shake_amt, rng.randf_range(m, n)*shake_amt, rng.randf_range(m, n)*shake_amt)
		$camera.transform = $camera.transform.translated(cameraShake)
	else:
		flag_held_seconds = 0
		$camera.transform.origin = Vector3.ZERO
		
	if mouse_captured: _handle_joypad_camera_rotation(delta)
	
	if Input.is_action_just_pressed("map"):
		if map_is_open:
			mapClose.emit()
			capture_mouse()
			map_is_open = false
		else: 
			mapOpen.emit()
			release_mouse()
			map_is_open = true
	
	if flag_held_seconds >= flag_time:
		if is_touching_goal:
			$victory.emitting = true
			victory.emit()
			release_mouse()
		else:
			defeat.emit()
			release_mouse()
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = 30
		
	var _forward: Vector3 = camera.global_transform.basis * Vector3(direction.x, 0, direction.z)
	target_velocity.x = _forward.normalized().x * magnitude
	target_velocity.z = _forward.normalized().z * magnitude
	
	if (is_on_floor() and is_moving):
		footprintTimer += delta
		if footprintTimer > footstepPeriod:
			footprintTimer = 0
			step.emit(Vector2(position.x, position.z), $camera.rotation)
	else:
		footprintTimer = 0
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	velocity = target_velocity
	move_and_slide()
	
	$radial.value = flag_held_seconds / flag_time
	

func _on_area_3d_area_entered(_area: Area3D) -> void:
	is_touching_goal = true
	

func _on_area_3d_area_exited(_area: Area3D) -> void:
	is_touching_goal = false
	
