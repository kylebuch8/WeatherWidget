package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class WeatherEvent extends Event
	{
		public static const LOADED:String = "loaded";
		
		public function WeatherEvent(pType:String, pBubbles:Boolean = false, pCancelable:Boolean = false) 
		{
			super(pType, pBubbles, pCancelable);
		}
		
		override public function clone():Event
		{
			return new WeatherEvent(type, bubbles, cancelable);
		}
		
	}

}