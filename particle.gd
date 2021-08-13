extends Particles2D

var target = Vector2(-200, 400)
var spectrum
var debug_extents = Vector2(10, 10)
var beat = 0
var energy = 0
onready var player = $'../AudioStreamPlayer'

func _ready():
	self.lifetime = 1000000
	self.one_shot = false
	self.amount = 1000
	self.explosiveness = 1.0
	self.speed_scale = 1.0
	self.spectrum = AudioServer.get_bus_effect_instance(0,0)
	# var timer = Timer.new()
	# timer.one_shot = false
	# timer.wait_time = 30.0
	# timer.autostart = true
	# timer.connect('timeout', self, '_switch_target')
	# add_child(timer)
	# self.process_material.set_shader_param('target', target)

func _process(dt):
	target.x = sin(sin(OS.get_ticks_msec() * 0.0001) * 3.2) * 300
	target.y = sin(OS.get_ticks_msec() * 0.0001) * 100 + 400
	calculate_stats(dt)
	self.process_material.set_shader_param('target', target)
	self.process_material.set_shader_param('beat', beat)
	self.process_material.set_shader_param('energy', energy)
	update()

func calculate_stats(dt):
	beat *= 0.97
	var magnitude = clamp((60 + linear2db(spectrum.get_magnitude_for_frequency_range(0.0, 120.0).length())) / 60, 0, 1)
	magnitude = pow(magnitude, 4)
	beat = max(beat, magnitude)
	var current_energy = clamp((60 + linear2db(spectrum.get_magnitude_for_frequency_range(0.0, 10000.0).length())) / 60, 0, 1)
	energy = lerp(energy, current_energy, 0.1 * dt)
	debug_extents = Vector2(beat, beat) * 50

func _draw():
	var rect = Rect2(target - debug_extents / 2, debug_extents)
	draw_rect(rect, Color.white)

func _unhandled_input(event):
	if event.is_action_released("ui_accept"):
		player.seek(player.get_playback_position() + 10.0)

# func _switch_target():
# 	target.x = -target.x
# 	self.process_material.set_shader_param('target', target)

# func _unhandled_input(event):
# 	if event.is_action_released('ui_accept'):
# 		_switch_target()
