using Godot;
using System;
using System.Diagnostics;

/// <summary>
/// Adds gravity to the owner CharacterBody3D.
/// </summary>
public partial class GravityComponent : Node3D
{
	[Export] public CharacterBody3D ComponentOwner {get; set;}

	// Contains how long the ComponentOwner hasn't stood on solid ground.
	private double TimeInAir;

	// How many seconds before a character starts being affected by gravity.
	private const float COYOTE_TIME = 0.12f;

	private const float FALLING_SPEED = 4.0f;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Debug.Assert(ComponentOwner != null, "Component must have an owner set!!!");
		TimeInAir = 0.0f;
	}

    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
		_CoyoteTimeGravity(delta);

    }
    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
	{
	}

	private void _CoyoteTimeGravity(double delta)
	{
		// If component owner is on floor set TimeInAir to zero, else increment by delta
		TimeInAir = ComponentOwner.IsOnFloor() ? 0.0 : TimeInAir + delta;

		bool shouldFall = TimeInAir > COYOTE_TIME;

		if(shouldFall){
			Vector3 gravity = ComponentOwner.GetGravity();
			ComponentOwner.Velocity += gravity * (float)delta * FALLING_SPEED;
		}
	}
}
