package com.jennison 
{
	import flash.display.MovieClip;
	import com.jennison.GameClient;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Chris Jennison
	 */
	public class Main extends MovieClip 
	{
		public static var STAGE:Stage;
		public var _gameClient:GameClient;
		
		public function Main() 
		{	STAGE = this.stage;
			STAGE.focus = STAGE;
			trace("I AM WORKING");
			initgame();
		}
		
		public function initgame() {
			_gameClient = new GameClient();
			addChild(_gameClient);
		}
		
	}

}