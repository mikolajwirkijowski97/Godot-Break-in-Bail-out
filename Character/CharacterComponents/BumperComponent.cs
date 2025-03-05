using Godot;
using System;
using System.Diagnostics;
/// <summary>
/// Class BumperComponent bumps its parent away from colliding physics bodies.
/// </summary>
public partial class BumperComponent : Area3D
{
	/// <summary>
	/// How strongly the body should be repelled on collision
	/// </summary>
	[Export] public float BumpStrength {get; set;}
	[Export] public CharacterBody3D ComponentOwner {get; set;}

 	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Debug.Assert(ComponentOwner != null, "Component must have an owner set!!!");
	}

	public override void _PhysicsProcess(double delta)
	{
		base._PhysicsProcess(delta);
		foreach(Node3D body in GetOverlappingBodies()){
			if(body == GetParent() || !(body is CharacterBody3D))
				continue;

			Vector3 bumpDirection = (ComponentOwner.GlobalPosition - body.GlobalPosition).Normalized();
			
			// Modify the velocity of the owner of the component
			Vector3 impactDirectionMask = new Vector3(1.0f, 0.0f, 1.0f);

			Vector3 impactVector = bumpDirection * BumpStrength * impactDirectionMask;
			ComponentOwner.Velocity += impactVector;
			
			// TODO: Add an animation for getting bumped into so that weird shit stops happening. 
		}
	}
}
