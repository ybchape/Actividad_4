extends CharacterBody2D

@export var SPEED = 300.0
@export var SALTO = -650.0
@export var GRAVEDAD = 2000.0
@export var VELOCIDAD_DASH = 1200.0
@export var DURACION_DASH = 0.3
 
var haciendo_dash = false
var direccion_mirada = 1
@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor() and not haciendo_dash:
		velocity.y += GRAVEDAD * delta

	#Salto
	if is_on_floor() and Input.is_action_just_pressed("move_salto") and not haciendo_dash:
			velocity.y = SALTO 
	if Input.is_action_just_released("move_salto") and velocity.y < 0:
		velocity.y = velocity.y * 0.5

	# Dash
	if Input.is_action_just_pressed("move_dash") and not haciendo_dash:
		ejecutar_dash()

	
	# Direccion
	var direction := Input.get_axis("move_izquierda","move_derecha")
	if haciendo_dash:
		velocity.y = 0
		velocity.x = direccion_mirada * VELOCIDAD_DASH
	else:
		if direction !=0:
			velocity.x = direction * SPEED
			direccion_mirada = direction
			anim.flip_h = (direccion_mirada ==-1) 
		else:
			velocity.x = 0

	#Control de animacion
	actualizar_animacion(direction)
	
	move_and_slide()
	#position.x = clamp(position.x,0,1920) # restrincion de pantalla
func actualizar_animacion(direction):
	#dash
	if haciendo_dash:
		anim.play("Dash")
		return
	#aire (salto)
	if not is_on_floor():
		anim.play("salto")
	
	#MOVIMIENTO SUELO
	else:
		if Input.is_action_pressed("move_abajo"):
			anim.play("abajo")
			velocity.x = 0 
		elif direction !=0:
			anim.play("Correr")
		else:
			anim.play("Idle")		

func ejecutar_dash():
	haciendo_dash = true
	await get_tree().create_timer(DURACION_DASH).timeout
	haciendo_dash = false
	velocity.x = direccion_mirada * SPEED  
