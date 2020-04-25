extends Node

var Subscribers = {}

func tick():
	for key in Subscribers:
		if not is_instance_valid(Subscribers[key]):
			unregister(key)
			continue
		Subscribers[key].tick()

func register(key, instance):
	Subscribers[key] = instance

func unregister(key):
	Subscribers.erase(key)
