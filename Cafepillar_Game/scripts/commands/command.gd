class_name Command
extends Node2D

enum Status {
	ACTIVE,
	DONE,
	ERROR,
}

func execute() -> Status:
	return Status.DONE
