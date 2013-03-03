package com.jennison 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Chris Jennison
	 */
	public class Main extends MovieClip
	{
		
		private var background:Background;
		private var player:Player;
		private var demons:Demons;
		
		private var leftPressed:Boolean = false;
		private var rightPressed:Boolean = false;
		private var upPressed:Boolean = false;
		private var downPressed:Boolean = false;
		
		private var leftBumping:Boolean = false;
		private var rightBumping:Boolean = false;
		private var upBumping:Boolean = false;
		private var downBumping:Boolean = false;
		
		private var leftBumpPoint:Point = new Point( -30, -55);
		private var rightBumpPoint:Point = new Point( 30, -55);
		private var upBumpPoint:Point = new Point( 0, -120);
		private var downBumpPoint:Point = new Point( 0, 0);
		
		var scrollX:Number = 0;
		var scrollY:Number = 0;

		var xSpeed:Number = 0;
		var ySpeed:Number = 0;

		var speedConstant:Number = 4;
		var frictionConstant:Number = 0.6;
		var gravityConstant:Number = 3.9;
		var jumpConstant:Number = -95;
		var maxSpeedConstant:Number = 18;
		var jumped:Boolean = false;
		var readyToJump:Boolean = true;
		
		private var cloudTimer:Timer = new Timer(2000);
		var lastY:Number = -450;
		
		public function Main() 
		{
			
			placePlayer();
			placeBackground();
			placeDemons();
			
			cloudTimer.addEventListener(TimerEvent.TIMER, createNewCloud);
			cloudTimer.start();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function createNewCloud(e:TimerEvent):void 
		{
			var cloud:Cloud = new Cloud();
			cloud.x = Math.random() * stage.stageWidth;
			var height = lastY - (Math.random() * 40) - 40;
			cloud.y = height;
			lastY = height;
			background.assets.addChild(cloud);
		}
		
		private function placeDemons():void 
		{
			demons = new Demons();
			background.addChild(demons);
			demons.y = 600;
		}
		
		private function placePlayer():void 
		{
			player = new Player();
			
			addChild(player);
			player.y = 400;
			player.x = 320;
		}
		
		private function placeBackground():void 
		{
			background = new Background();
			addChild(background);
			
		}
		
		private function update(e:Event):void 
		{
			testHit();
			
			if (leftPressed) {
				if (downBumping) {
					player.gotoAndPlay("PitchRun");
				}
				xSpeed += speedConstant;
				player.scaleX = 1;
			}
			else if (rightPressed) {
				if (downBumping) {
					player.gotoAndPlay("PitchRun");
				}
				xSpeed -= speedConstant;
				player.scaleX = -1;
			}
			else if (upPressed) {
				//ySpeed -= speedConstant;
			}
			else if (downPressed) {
				//ySpeed += speedConstant;
			} else {
				if (Math.abs(xSpeed) < 1 && downBumping) {
					player.gotoAndPlay("PitchIdle");
				} 
			}
			
			if(leftBumping){
				if(xSpeed < 0){
					xSpeed *= -0.5;
				}
			}

			if(rightBumping){
				if(xSpeed > 0){
					xSpeed *= -0.5;
				}
			}

			if(upBumping){
				if(ySpeed < 0){
					//ySpeed *= -0.5;
				}
			}

			if (downBumping) { //if we are touching the floor
				jumped = false;
				if(ySpeed > 0){ 
					ySpeed = -.1; //set the y speed to zero
				}
				if(upPressed && !jumped && readyToJump){ //and if the up arrow is pressed
					jumped = true;
					readyToJump = false;
					ySpeed =  jumpConstant; //set the y speed to the jump constant
				}
			} else { //if we are not touching the floor
				ySpeed += gravityConstant; //accelerate downwards
					player.gotoAndPlay("PitchFall");
			}
			
			if(xSpeed > maxSpeedConstant){ //moving right
				xSpeed = maxSpeedConstant;
			} else if(xSpeed < (maxSpeedConstant * -1)){ //moving left
				xSpeed = (maxSpeedConstant * -1);
			}

			
			
			
			xSpeed *= frictionConstant;
			ySpeed *= frictionConstant;
			
			scrollX -= xSpeed;
			scrollY -= ySpeed;
			
			
			player.x = scrollX + stage.stageWidth/2;
			//background.x = scrollX;
			background.y = scrollY;
			demons.y--;
		}
		
		private function testHit():void 
		{
			if(background.assets.hitTestPoint(player.x + leftBumpPoint.x, player.y + leftBumpPoint.y, true)){
				trace("leftBumping");
				leftBumping = true;
			} else {
				leftBumping = false;
			}

			if(background.assets.hitTestPoint(player.x + rightBumpPoint.x, player.y + rightBumpPoint.y, true)){
				trace("rightBumping");
				rightBumping = true;
			} else {
				rightBumping = false;
			}

			if(background.assets.hitTestPoint(player.x + upBumpPoint.x, player.y + upBumpPoint.y, true)){
				trace("upBumping");
				upBumping = true;
			} else {
				upBumping = false;
			}

			if(background.assets.hitTestPoint(player.x + downBumpPoint.x, player.y + downBumpPoint.y, true)){
				trace("downBumping");
				downBumping = true;
			} else {
				downBumping = false;
			}
		}
		
		private function keyUpHandler(e:KeyboardEvent):void 
		{
			if(e.keyCode == Keyboard.LEFT){
			trace("left pressed");
			leftPressed = false;

			} else if(e.keyCode == Keyboard.RIGHT){
			trace("right pressed");
			rightPressed = false;

			} else if(e.keyCode == Keyboard.UP){
			trace("up pressed");
			readyToJump = true;
			upPressed = false;

			} else if(e.keyCode == Keyboard.DOWN){
			trace("down pressed");
			downPressed = false;
			}
		}
		
		private function keyDownHandler(e:KeyboardEvent):void 
		{
			if(e.keyCode == Keyboard.LEFT){
			trace("left released");
			leftPressed = true;

			} else if(e.keyCode == Keyboard.RIGHT){
			trace("right released");
			rightPressed = true;

			} else if(e.keyCode == Keyboard.UP){
			trace("up released");
			upPressed = true;

			} else if(e.keyCode == Keyboard.DOWN){
			trace("down released");
			downPressed = true;
			}
		}
		
	}

}