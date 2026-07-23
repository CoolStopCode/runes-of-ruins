class_name Editor
extends Control

@export_category("Nodes")
@export var workspace : Container
@export var palettespace : Container
@export var mouse : MouseRuneInstance

@export_category("Scenes")
@export var palette_rune_instance_scene : PackedScene
@export var workspace_rune_instance_scene : PackedScene

var workspace_index : int = 0
var workspace_rune_instances : Array[WorkspaceRuneInstance]
var palette_rune_instances : Array[PaletteRuneInstance]

@export var player : Player = Player.new()
@export var test_palette : Palette

const workspace_spacing : int = 18
const workspace_start_pos : int = 2

var slide_tween : Tween

func load_from_world_data(world_data : WorldData):
	var palette : Palette = world_data.palette
	var workspace_length : int = world_data.workspace_length
	
	workspace_index = 0
	if slide_tween: slide_tween.stop()
	workspace.position.y = workspace_start_pos
	for child in workspace.get_children(): child.queue_free()
	for child in palettespace.get_children(): child.queue_free()
	
	palette_rune_instances.clear()
	for palette_part : PalettePart in palette.parts:
		var palette_rune_instance : PaletteRuneInstance = palette_rune_instance_scene.instantiate()
		palette_rune_instance.setup_from_structure(palette_part.rune_structure, palette_part.count)
		palette_rune_instance.pressed.connect(pick_up_rune_from_palette)
		palette_rune_instances.append(palette_rune_instance)
		palettespace.add_child(palette_rune_instance)
	
	workspace_rune_instances.clear()
	workspace.size.y = 100 * workspace_length
	for i in range(workspace_length):
		var workspace_rune_instance : WorkspaceRuneInstance = workspace_rune_instance_scene.instantiate()
		workspace_rune_instance.setup_from_structure(null)
		workspace_rune_instance.index = i
		workspace_rune_instance.pressed.connect(pick_up_rune_from_workspace)
		workspace_rune_instances.append(workspace_rune_instance)
		workspace.add_child(workspace_rune_instance)
	
	mouse.rune_dropped.connect(drop_rune)

func pick_up_rune_from_palette(palette_rune_instance : PaletteRuneInstance):
	palette_rune_instance.rune_count -= 1
	mouse.pick_up_rune(palette_rune_instance.rune_structure)

func pick_up_rune_from_workspace(workspace_rune_instance : WorkspaceRuneInstance):
	if workspace_rune_instance.rune_structure != null:
		mouse.pick_up_rune(workspace_rune_instance.rune_structure)
		workspace_rune_instance.setup_from_structure(null)

func drop_rune(structure : RuneStructure):
	var hovered := get_hovered_workspace_rune()
	if hovered != null:
		if hovered.rune_structure != null:
			for palette_rune_instance in palette_rune_instances:
				if palette_rune_instance.rune_structure == hovered.rune_structure:
					palette_rune_instance.rune_count += 1
		hovered.setup_from_structure(structure)
	else:
		for palette_rune_instance in palette_rune_instances:
			if palette_rune_instance.rune_structure == structure:
				palette_rune_instance.rune_count += 1
	mouse.held_rune_structure = null

func get_hovered_workspace_rune() -> WorkspaceRuneInstance:
	for workspace_rune_instance in get_top_workspace_rune_instances():
		var mouse_position := get_global_mouse_position()
		if workspace_rune_instance.get_global_rect().has_point(mouse_position):
			return workspace_rune_instance
	return null

func get_top_workspace_rune_instances() -> Array[WorkspaceRuneInstance]:
	var array : Array[WorkspaceRuneInstance] = []
	for workspace_rune_instance in workspace_rune_instances.slice(workspace_index, workspace_index + 10):
		array.append(workspace_rune_instance)
	return array

func _process(delta: float) -> void:
	if mouse.active:
		var mouse_position := get_global_mouse_position()
		for workspace_rune_instance in get_top_workspace_rune_instances():
			if workspace_rune_instance.get_global_rect().has_point(mouse_position):
				workspace_rune_instance.outline.show()
			else:
				workspace_rune_instance.outline.hide()

func pulse():
	#workspace_rune_instances[workspace_index].rune_structure.execute(player)
	workspace_index += 1
	
	for workspace_rune_instance in get_top_workspace_rune_instances():
		workspace_rune_instance.hovering = false
		workspace_rune_instance.outline.hide()
	slide_tween = get_tree().create_tween()
	slide_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	slide_tween.tween_property(workspace, "position:y", workspace_start_pos - workspace_spacing * workspace_index, 0.5)

#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("ui_accept"):
		#pulse()
	#if Input.is_action_just_pressed("ui_down"):
		#build(test_palette, 100)
