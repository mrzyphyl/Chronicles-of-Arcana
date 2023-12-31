@tool
extends EditorPlugin

const HELPERS_AUTOLOAD = "Helpers"
var update_dialog_scene: UpdateGodot2DEssentialsButton

func _enter_tree():
	add_autoload_singleton(HELPERS_AUTOLOAD, "res://addons/2d_essentials/autoload/helpers.tscn")
	add_custom_type("HealthComponent", "Node2D", preload("res://addons/2d_essentials/survivability/health_component.gd"), preload("res://addons/2d_essentials/icons/suit_hearts.svg"))
	add_custom_type("VelocityComponent2D", "Node2D", preload("res://addons/2d_essentials/movement/velocity_component_2d.gd"), preload("res://addons/2d_essentials/icons/arrow_cross.svg"))
	add_custom_type("ShakeCameraComponent2D", "Node2D", preload("res://addons/2d_essentials/camera/shake_camera_component.gd"), preload("res://addons/2d_essentials/icons/video.png"))
	add_custom_type("RotatorComponent", "Node2D", preload("res://addons/2d_essentials/movement/rotator_component.gd"), preload("res://addons/2d_essentials/icons/arrow_clockwise.svg"))
	
	_setup_update_notificator()

func _exit_tree():
	remove_autoload_singleton(HELPERS_AUTOLOAD)
	remove_custom_type("HealthComponent")
	remove_custom_type("VelocityComponent2D")
	remove_custom_type("ShakeCameraComponent2D")
	remove_custom_type("RotatorComponent")
	
	_remove_update_notificator()

func _setup_update_notificator():
	update_dialog_scene = load("res://addons/2d_essentials/update/update_plugin_button.tscn").instantiate() as UpdateGodot2DEssentialsButton
	Engine.get_main_loop().root.call_deferred("add_child", update_dialog_scene)
	
	update_dialog_scene.editor_plugin = self
	
func _remove_update_notificator():
	if update_dialog_scene:
		Engine.get_main_loop().root.call_deferred("remove_child", update_dialog_scene)
