using Godot;
using System;

public partial class BumperComponent : Area3D
{
	[Export] public float BumpStrength {get; set;}

	public override void _PhysicsProcess(double delta)
	{
		base._PhysicsProcess(delta);
		foreach(Node3D body in GetOverlappingBodies()){
			if(body == GetParent()){continue;}

			Vector3 bumpDirection = (GlobalPosition - body.GlobalPosition).Normalized();
			
			// Modify the velocity of the owner of the component
			Vector3 impactDirectionMask = new Vector3(1.0f, 0.0f, 1.0f);

			Vector3 impactVector = (bumpDirection * BumpStrength) * impactDirectionMask;
			GetParent<CharacterBody3D>().Velocity += impactVector;
		}
	}
}
