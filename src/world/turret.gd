extends Node3D

var tween: Tween

@onready var base_rotation: Vector3 = rotation
@onready var camera: PhantomCamera3D
@onready var gpu_particles: GPUParticles3D = $GPUParticles3D
@onready var player_phantom_camera_noise_emitter_3d: PhantomCameraNoiseEmitter3D = %PlayerPhantomCameraNoiseEmitter3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	G.main.mistakes_count_changed.connect(look_at_player)


func look_at_player(count:int) -> void:
	if !camera:
		camera = G.main.camera
	var target_transform: Transform3D = Transform3D()
	target_transform.origin = global_transform.origin
	target_transform = target_transform.looking_at(camera.global_transform.origin, Vector3.UP)

	var target_rotation: Vector3 = Vector3(0, target_transform.basis.get_euler().y, 0)
	
	if count >= 10:
		if tween:
			tween.kill()
	
		camera.priority = 1000
		camera.look_at_targets = [self]
	
		# wait before starting tween
		await get_tree().create_timer(2).timeout
	
		# create and execute tween properly
		tween = create_tween()
		tween.tween_property(self, "rotation", target_rotation, 1.5)
	
		await tween.finished
	
		# continue actions after tween completes
		await get_tree().create_timer(2).timeout
		gpu_particles.emitting = true
		player_phantom_camera_noise_emitter_3d.emit()
		audio_stream_player.play()
	
		await get_tree().create_timer(0.25).timeout
	
		G.main.phantom_camera_dead.priority = 1001
		G.main.end.show_end()
	else:
		if tween:
			tween.kill()
		
		tween = create_tween()
		tween.tween_property(self, "rotation", target_rotation, 1.5)
		tween.tween_interval(1)
		tween.tween_property(self, "rotation", base_rotation, 1.5)
		
		await tween.finished

		
