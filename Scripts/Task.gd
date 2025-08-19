extends HBoxContainer

class_name Task

@onready var Task_Label : Label = $Label
@onready var Task_Button : Button = $Button

var title : String 
var description : String
var state : bool

func update_stuff() -> void:
    title = Task_Label.text

func _ready():
    Task_Label.text = title
    Task_Button.button_pressed = state

"""
func _init(Title : String, Description : String, State : bool) -> void:
    title = Title
    description = Description
    state = State
"""

func create(Title : String, Description : String, State : bool) -> void:
    title = Title
    description = Description
    state = State
    
func create_and_save(Title : String, Description : String, State : bool) -> void:
    create(Title, Description, State)
    Global.AddTaskToDictionary(title, description, state)

func _on_button_toggled(toggled_on : bool) -> void:
    state = toggled_on
    Global.ChangeStateOfTask(title, toggled_on)

func _on_delete_button_pressed() -> void:
    Global.DeleteTask(title)
    queue_free()

func _on_press_task() -> void:
    Global.Set_Selected_Description(description)

func _on_double_press_task() -> void:
    Global.CreateViewerWindow(title, description)

func _gui_input(event: InputEvent) -> void:
    if (event is InputEventMouseButton):
        if event.button_index != MOUSE_BUTTON_LEFT: return
        if event.double_click:
            _on_double_press_task()
        elif event.pressed:
            _on_press_task()
