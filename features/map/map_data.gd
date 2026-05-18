class_name MapData extends RefCounted

var cells: Dictionary[Vector2i, CellData]
var features: Dictionary[Vector2i, CellFeature.Type]
var bounds: Rect2i
