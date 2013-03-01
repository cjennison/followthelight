package com.jennison 
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import com.jennison.Main;
	import com.jennison.GameEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Chris Jennison
	 */
	public class GameClient extends MovieClip 
	{
		var gravity:b2Vec2;
		var sleep:Boolean = true;
		var world:b2World;
		var worldScale:Number = 30;
		
		var player:b2Body;
		
		var Left:Boolean = false;
		var Right:Boolean = false;
		var Up:Boolean = false;
		
		var speed:Number = 5;
		var jumping:Boolean = false;
		
		var customContactListener:CustomContactListener = new CustomContactListener();
		
		var creationTimer:Timer = new Timer(4000);
		public function GameClient() 
		{
			//defines gravity impact on game
			gravity = new b2Vec2(0, 12.81);
			world = new b2World(gravity, sleep);
			world.SetContactListener(customContactListener)
			
			createBall();
			createHero();
			createCloud(450, 10, 0, 400);
			createCloud(100, 10, 200, 300);
			createCloud(100, 10, 120, 200);
			createCloud(100, 10, 320, 100);
			createCloud(100, 10, 370, 00);
			creationTimer.start();
			
			debugDraw();
			
			addEventListener(Event.ENTER_FRAME, updateWorld);
			Main.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			Main.STAGE.addEventListener(KeyboardEvent.KEY_UP, KeyUp);
			creationTimer.addEventListener(TimerEvent.TIMER, createPlatform);
			
			customContactListener.dispatcher.addEventListener(GameEvent.PLAYER_ON_CLOUD, playerOnCloud);
		}
		
		private function createPlatform(e:TimerEvent):void 
		{
			
			var width = (Math.random() * 120) + 30
			var height = 10;
			var x = Math.random() * 450;
			var y = Math.random() * -20;
			
			createCloud(width, height, x, y);
		}
		
		
		
		private function KeyUp(e:KeyboardEvent):void 
		{
			switch (e.keyCode) {
                case 37 ://Left
                    Left = false;
                    break;
                case 38 ://Up
                    Up = false;
                    break;
                case 39 ://Right
                    Right = false;
                    break;
 
            }
		}
		
		private function KeyDown(e:KeyboardEvent):void 
		{
			trace(e.keyCode);
			switch (e.keyCode) {
                case 37 ://Left
                    Left = true;
                    break;
                case 38 ://Up
                    Up = true;
                    break;
                case 39 ://Right
                    Right = true;
                    break;
 
            }
		}
		
		private function createCloud(w:Number, h:Number, x:Number, y:Number) {
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(x / worldScale, y / worldScale);
			bodyDef.type = b2Body.b2_kinematicBody;
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(w / worldScale, h / worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			//fixtureDef.isSensor = true;
			
			var floor:b2Body = world.CreateBody(bodyDef);
			floor.CreateFixture(fixtureDef);
			floor.SetUserData("CLOUD");
		}
		
		private function createHero(x:Number = 450/2, y:Number = 300, width:Number = 10, height:Number = 30) {
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(x / worldScale, y / worldScale);
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.fixedRotation = true;
			//bodyDef.userData
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(width / worldScale, height / worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.1;
			fixtureDef.friction = 1;
			//fixtureDef.isSensor = true;
			
			var hero:b2Body = world.CreateBody(bodyDef);
			hero.CreateFixture(fixtureDef);
			hero.SetUserData("PLAYER");
			
			player = hero;
			
		}
		
		private function createBall() {
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(320 / worldScale, 30 / worldScale);
			bodyDef.type = b2Body.b2_dynamicBody;
			var circleShape:b2CircleShape;
			circleShape = new b2CircleShape(25 / worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.6;
			fixtureDef.friction = 0.1;
			
			var theBall:b2Body = world.CreateBody(bodyDef);
			theBall.CreateFixture(fixtureDef);
		}
		
		
		
		private function updateWorld(e:Event):void 
		{
			var vel:b2Vec2;
			var jump:Number = 4;			
			
			if (Up) {
				if (player.GetLinearVelocity().y > -1 && jumping == false ) {
					//var Hit = GetB
					jumping = true;
					player.ApplyImpulse(new b2Vec2(0, -15.0), player.GetWorldCenter());
				}
			}
			
			if (Right) {
				vel = new b2Vec2(speed, player.GetLinearVelocity().y);
				player.SetAwake(true);
				player.SetLinearVelocity(vel);
			}
			if (Left) {
				vel = new b2Vec2(-speed, player.GetLinearVelocity().y);
				player.SetAwake(true);
				player.SetLinearVelocity(vel);
			}

			var timeStep:Number = 1 / 30;
			var velIterations:int = 10;
			var posIterations:int = 10;
			world.Step(timeStep, velIterations, posIterations);
			world.ClearForces();
			world.DrawDebugData();
			
			for (var worldbody:b2Body = world.GetBodyList(); worldbody; worldbody = worldbody.GetNext()) {
				//trace(worldbody.GetUserData());
				if (worldbody.GetUserData() == "CLOUD") {
					worldbody.SetLinearVelocity(new b2Vec2(0, 1));
				}
			}
		}
		
		private function playerOnCloud(e:Event):void 
		{
			jumping = false;
		}
		
		private function debugDraw() {
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		
	}

}