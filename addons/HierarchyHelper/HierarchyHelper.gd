extends Node

func get_parent_sibling(parent_sibling : String, focus : Object):
	var node = focus.get_parent().get_parent().get_node_or_null(parent_sibling)
	return node

func get_descendant(descendant : String, focus : Object, generations : int):
	var g = 2
	var group = []
	var groupnames = []
	if not focus.get_children().empty():
		group += focus.get_children()
		while g < generations:
			for i in group:
				if not i.get_children().empty():
					if not group.has(i.get_child(0)):
						group += i.get_children()
			g += 1
		for i in group:
			groupnames.append(i.name)
		return group[groupnames.find(descendant)]

func get_ancestor(ancestor : String, focus : Object):
	var current_checking = focus
	while not current_checking.name == ancestor:
		current_checking = current_checking.get_parent()
	if current_checking.name == ancestor:
		return current_checking

func get_grandparent(focus : Object):
	var node = focus.get_parent().get_parent()
	return node

func get_sibling(sibling : String, focus : Object):
	var node = focus.get_parent().get_node_or_null(sibling)
	return node

func get_all_descendants(focus : Object, generations : int):
	var g = 2
	var group = []
	if not focus.get_children().empty():
		group += focus.get_children()
		while g < generations:
			for i in group:
				if not i.get_children().empty():
					if not group.has(i.get_child(0)):
						group += i.get_children()
			g += 1
		return group
