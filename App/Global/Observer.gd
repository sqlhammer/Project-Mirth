extends Node

var Subscribers = {}

func trigger():
	for key in Subscribers:
		if not is_instance_valid(Subscribers[key]["instance"]):
			misfire(key)
			continue
		Subscribers[key]["instance"].call(Subscribers[key]["method"])

func subscribe(key, instance, method, args):
	Subscribers[key] = {"instance":instance, "method":method, "args":args}

func misfire(key):
	unsubscribe(key)

func unsubscribe(key):
	Subscribers.erase(key)
