extends Spatial

var n = constant.n
var r = constant.r
export var rotation_speed = PI / 2
# zoom settings
var max_zoom = r / tan(0.4) # make this vary by FOV once you implement FOV
var min_zoom = r + 4
var zoom_speed = 1

var zoom = r / tan(0.6)

var mouse_sensitivity = 0.005

func _process(delta):
	get_input_keyboard(delta)
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, 1.4)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)

func _unhandled_input(event):
	if Input.is_action_pressed("cam_mouse_rotation") and event is InputEventMouseMotion:
		if event.relative.x != 0:
			rotate_object_local(Vector3.DOWN, event.relative.x * mouse_sensitivity)
		if event.relative.y != 0:
			var y_rotation = clamp(event.relative.y, -30, 30)
			$InnerGimbal.rotate_object_local(Vector3.LEFT, y_rotation * mouse_sensitivity)
	
	if event.is_action_pressed("cam_zoom_in"):
		zoom -= zoom_speed
	if event.is_action_pressed("cam_zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)

func get_input_keyboard(delta):
	# rotate CameraGimbal around y axis
	var y_rotation = 0
	if Input.is_action_pressed("cam_right"):
		y_rotation += 1
	if Input.is_action_pressed("cam_left"):
		y_rotation += -1
	rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
	# rotate InnerGimbal around x axis
	var x_rotation = 0
	if Input.is_action_pressed("cam_up"):
		x_rotation += -1
	if Input.is_action_pressed("cam_down"):
		x_rotation += 1
	$InnerGimbal.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)
