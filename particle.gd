extends Particles2D

var target = Vector2(-200, 400)

func _ready():
	self.lifetime = 1000000
	self.one_shot = false
	self.amount = 1000
	self.explosiveness = 1.0
	self.speed_scale = 1.0
	# var timer = Timer.new()
	# timer.one_shot = false
	# timer.wait_time = 30.0
	# timer.autostart = true
	# timer.connect('timeout', self, '_switch_target')
	# add_child(timer)
	# self.process_material.set_shader_param('target', target)

func _process(_dt):
	target.x = sin(sin(OS.get_ticks_msec() * 0.0001) * 3.2) * 300
	target.y = sin(OS.get_ticks_msec() * 0.0001) * 100 + 400
	self.process_material.set_shader_param('target', target)
	update()

func _draw():
	draw_circle(target, 5, Color.white)

# func _switch_target():
# 	target.x = -target.x
# 	self.process_material.set_shader_param('target', target)

# func _unhandled_input(event):
# 	if event.is_action_released('ui_accept'):
# 		_switch_target()
