package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class AppEvent extends Event
	{
		public static const CLOSE:String = "close";
		public static const PREFERENCES_SAVED:String = "preferencesSaved";
		public static const SETTINGS_KEYUP:String = "settingsKeyUp";
		public static const SETTINGS_DROPDOWN_SELECTED:String = "settingsDropdownSelected";
		public static const SETTINGS_DONE_CLICKED:String = "settingsDoneClicked";
		public static const LOCATION_UPDATE:String = "locationUpdate";
		
		public function AppEvent(pType:String, pBubbles:Boolean = false, pCancelable:Boolean = false) 
		{
			super(pType, pBubbles, pCancelable);
		}
		
		override public function clone():Event
		{
			return new AppEvent(type, bubbles, cancelable);
		}
		
	}

}