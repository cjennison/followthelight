package com.jennison 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Chris Jennison
	 */
	public class GameDispatcher extends EventDispatcher
	{
		
		public function GameDispatcher() 
		{
			
		}
		
		public function dispatchPlayerOnCloud() {
			this.dispatchEvent(new Event(GameEvent.PLAYER_ON_CLOUD));
		}
		
	}

}