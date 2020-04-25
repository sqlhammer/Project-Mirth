extends Node

var Subscribers = {}

func trigger():
	for key in Subscribers:
		if not is_instance_valid(Subscribers[key]["instance"]):
			unregister(key)
			continue
		Subscribers[key]["instance"].call(Subscribers[key]["method"])

func register(key, instance, method):
	Subscribers[key] = {"instance":instance, "method":method}

func unregister(key):
	Subscribers.erase(key)
