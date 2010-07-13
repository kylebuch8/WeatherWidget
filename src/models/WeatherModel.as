package models 
{
	import controllers.WeatherController;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import events.WeatherEvent;
	import events.AppEvent;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class WeatherModel extends Sprite
	{
		private static const WEATHER_BASE_URL:String = "http://xml.weather.yahoo.com/forecastrss/";
		
		private static var instance:WeatherModel;
		private static var allowInstantiation:Boolean;
		
		private var _controller:WeatherController;
		private var _forecastModel:ForecastModel;
		private var _preferences:XML;
		
		public static function getInstance():WeatherModel
		{
			if (instance == null)
			{
				allowInstantiation = true;
				instance = new WeatherModel();
				allowInstantiation = false;
			}
			
			return instance;
		}
		
		public function WeatherModel() 
		{
			if (!allowInstantiation)
			{
				throw new Error("Error: Instantiation failed: Use WeatherModel.getInstance() instead of new.");
			}
		}
		
		public function loadPreferences():void
		{
			var appStorage:File = File.applicationStorageDirectory;
			appStorage = appStorage.resolvePath("app-storage");
			
			if (!appStorage.exists)
			{
				appStorage.createDirectory();
				trace("WeatherModel :: Directory created");
			}
			else
			{
				trace("WeatherModel :: Directory not created");
			}
			
			checkForPreferencesFile();
		}
		
		private function checkForPreferencesFile():void
		{
			trace("WeatherModel :: checkForPreferencesFile()");
			
			var prefsFile:File = File.applicationStorageDirectory;
			prefsFile = prefsFile.resolvePath("app-storage/preferences.xml");
			
			if (!prefsFile.exists)
			{
				var file:File = File.applicationDirectory.resolvePath("app-storage/preferences.xml");
				if (file.exists)
				{
					trace("WeatherModel :: File exists. Copying");
					var prefsData:FileStream = new FileStream();
					prefsData.addEventListener(Event.COMPLETE, prefsDataCopy_completeHandler);
					prefsData.openAsync(file, FileMode.READ);
				}
			}
			else
			{
				trace("WeatherModel :: Preferences file already exists");
				readPreferencesXML();
			}
		}
		
		private function prefsDataCopy_completeHandler(pEvent:Event):void
		{
			trace("WeatherModel :: prefsDataCopy_completeHandler");
			var prefsXML:XML = XML(pEvent.target.readUTFBytes(pEvent.target.bytesAvailable));
			var folder:File = File.applicationStorageDirectory;
			var file:File = folder.resolvePath("app-storage/preferences.xml");
			
			var newFile:FileStream = new FileStream();
			newFile.open(file, FileMode.WRITE);
			newFile.writeUTFBytes(prefsXML);
			newFile.close();
			
			trace("WeatherModel :: Preferences file saved");
			readPreferencesXML();
		}
		
		private function readPreferencesXML():void
		{
			trace("WeatherModel :: readPreferencesXML()");
			
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath("app-storage/preferences.xml");
			
			if (!file.exists)
			{
				trace("WeatherModel :: File does not exist");
			}
			else
			{
				trace("WeatherModel :: File does exist - opening...");
				var prefsStream:FileStream = new FileStream();
				
				prefsStream.addEventListener(ProgressEvent.PROGRESS, prefsStream_progressHandler);
				prefsStream.addEventListener(IOErrorEvent.IO_ERROR, prefsStream_ioErrorHandler);
				prefsStream.addEventListener(Event.COMPLETE, prefsStream_completeHandler);
				
				prefsStream.openAsync(file, FileMode.READ);
			}
		}
		
		private function prefsStream_progressHandler(pEvent:ProgressEvent):void
		{
			trace("WeatherModel :: prefsStream_progressHandler - " + pEvent.target);
		}
		
		private function prefsStream_ioErrorHandler(pEvent:IOErrorEvent):void
		{
			trace("WeatherModel :: prefsStream_ioErrorHandler - " + pEvent.target);
		}
		
		private function prefsStream_completeHandler(pEvent:Event):void
		{
			trace("WeatherModel :: prefsStream_completeHandler - " + pEvent.target);
			_preferences = XML(pEvent.target.readUTFBytes(pEvent.target.bytesAvailable));
			trace("Preferences File: " + _preferences);
			
			// let the controller know that the preferences have loaded
			_controller.preferencesLoaded();
		}
		
		public function getWeather(pLocationsID:String):void
		{
			var url:String = WEATHER_BASE_URL + pLocationsID + "_f.xml";
			var urlRequest:URLRequest = new URLRequest(url);
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, getWeather_ioErrorHandler);
			urlLoader.addEventListener(Event.COMPLETE, getWeather_completeHandler);
			urlLoader.load(urlRequest);
		}
		
		private function getWeather_ioErrorHandler(pEvent:IOErrorEvent):void
		{
			trace("WeatherModel :: getWeather_ioErrorHandler() - " + pEvent);
		}
		
		private function getWeather_completeHandler(pEvent:Event):void
		{
			var weatherXML:XML = new XML(pEvent.target.data);
			_forecastModel = new ForecastModel(weatherXML);
			
			dispatchEvent(new WeatherEvent(WeatherEvent.LOADED));
		}
		
		public function saveLocation(pLocationObject:Object):void
		{
			_preferences.location[0] = pLocationObject.text;
			_preferences.location[0].@id = pLocationObject.id;
			
			savePreferences(false, true);
		}
		
		public function getLocation(pLocation:String):void
		{
			trace("WeatherModel :: getLocation() - " + pLocation);
			var url:String = "http://xoap.weather.com/search/search?where=" + pLocation + "&par=1117878557&key=756df1d3da6985f9";
			var urlRequest:URLRequest = new URLRequest(url);
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, getLocation_completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, getLocation_ioErrorHandler);
			urlLoader.load(urlRequest);
		}
		
		private function getLocation_ioErrorHandler(pEvent:IOErrorEvent):void
		{
			trace("WeatherModel :: getLocation_ioErrorHandler() - " + pEvent);
		}
		
		private function getLocation_completeHandler(pEvent:Event):void
		{
			trace("WeatherModel :: getLocation_completeHandler()");
			var xmlData:XML = new XML(pEvent.target.data);
			_controller.getLocation_completeHandler(xmlData);
		}
		
		public function savePosition(pXPos:Number, pYPos:Number):void
		{
			trace("Preferences Window: " + _preferences.window);
			_preferences.window.lastXPos[0] = pXPos;
			_preferences.window.lastYPos[0] = pYPos;
			
			savePreferences(true);
		}
		
		private function savePreferences(pClose:Boolean = false, pLocationUpdate:Boolean = false):void
		{
			var outputString:String = _preferences.toXMLString();
			outputString = outputString.replace(/\n/g, File.lineEnding);
			
			var prefsFile:File = File.applicationStorageDirectory.resolvePath("app-storage/preferences.xml");
			
			var stream:FileStream = new FileStream();
			stream.openAsync(prefsFile, FileMode.WRITE);
			stream.writeUTFBytes(outputString);
			stream.close();
			
			if (pClose)
			{
				trace("WeatherModel :: savePreferences() - Preferences saved. Sending AppEvent.CLOSE");
				dispatchEvent(new AppEvent(AppEvent.CLOSE));
			}
			else if (pLocationUpdate)
			{
				trace("WeatherModel :: savePreferences() - Preferences saved. Sending AppEvent.LOCATION_UPDATE");
				dispatchEvent(new AppEvent(AppEvent.LOCATION_UPDATE));
			}
			else
			{
				trace("WeatherModel :: savePreferences() - Preferences saved");
				dispatchEvent(new AppEvent(AppEvent.PREFERENCES_SAVED));
			}
		}
		
		// Getter and Setter Methods
		public function get controller():WeatherController { return _controller; }
		public function set controller(pController:WeatherController):void { _controller = pController; }
		public function get preferences():XML { return _preferences; }
		public function get forecastModel():ForecastModel { return _forecastModel; }
	}

}