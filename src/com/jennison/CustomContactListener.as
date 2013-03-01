package com.jennison 
{
	import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Dynamics.Joints.*;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Common.*;
    import Box2D.Common.Math.*;
	import flash.events.EventDispatcher;
	import com.jennison.GameDispatcher;
	import com.jennison.GameEvent;
	/**
	 * ...
	 * @author Chris Jennison
	 */
	public class CustomContactListener extends b2ContactListener
	{
		public var dispatcher:GameDispatcher = new GameDispatcher();

		override public function BeginContact(contact:b2Contact):void {
            // getting the fixtures that collided
            var fixtureA:b2Fixture = contact.GetFixtureA();
            var fixtureB:b2Fixture = contact.GetFixtureB();
			
			if (fixtureA.GetBody().GetUserData() == "PLAYER" || fixtureB.GetBody().GetUserData() == "PLAYER") {
				if (fixtureA.GetBody().GetUserData() == "CLOUD" || fixtureB.GetBody().GetUserData() == "CLOUD") {
					trace("Contact With Cloud");
					dispatcher.dispatchPlayerOnCloud();
					/*
					trace(fixtureA.GetBody().GetUserData());
					if (fixtureA.GetBody().GetUserData() == "PLAYER") {
						trace("PLAYER: " + fixtureA.GetBody().GetPosition().y);
						trace("FLOOR: " + fixtureB.GetBody().GetPosition().y);
						if (fixtureA.GetBody().GetPosition().y > fixtureB.GetBody().GetPosition().y) {
							trace("UNDER");
							fixtureA.SetSensor(true);
						} else {
							fixtureA.SetSensor(false);
						}
					}
					*/
				}
			}
			
			//trace(fixtureA.GetBody().GetUserData());
			
            
        }
		
	}

}