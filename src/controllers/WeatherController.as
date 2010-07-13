package controllers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import air.net.URLMonitor;
	import models.WeatherModel;
	import events.WeatherEvent;
	import events.AppEvent;
	import views.WeatherView;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class WeatherController extends EventDispatcher 
	{
		private static const TIMER_DURATION:Number = 5 * 60 * 1000 // minutes times seconds times 1000
		
		private var _monitor:URLMonitor;
		private var _model:WeatherModel;
		private var _view:WeatherView;
		private var _timer:Timer;
		private var _networkConnection:Boolean = true;
		private var _settingsViewShown:Boolean = false;
		
		public function WeatherController():void 
		{
			_monitor = new URLMonitor(new URLRequest("http://www.google.com"));
			_monitor.addEventListener(StatusEvent.STATUS, monitor_statusHandler);
			_monitor.start();
			
			_timer = new Timer(TIMER_DURATION);
		}
		
		private function monitor_statusHandler(pEvent:StatusEvent):void
		{
			trace("WeatherController :: monitor_statusHandler() - " + pEvent);
			var connection:Boolean;
			switch (pEvent.code)
			{
				case "Service.available":
					trace("WeatherController :: monitor_statusHandler() - Service.available");
					connection = true;
					break;
					
				case "Service.unavailable":
					trace("WeatherController :: monitor_statusHandler() - Service.unavailable");
					connection = false;
					break;
			}
			
			if (connection == false && _networkConnection == true)
			{
				networkDisconnected();
			}
			
			if (connection == true && _networkConnection == false)
			{
				networkConnected();
			}
		}
		
		public function networkDisconnected():void
		{
			_networkConnection = false;
			if (_timer.running)
			{
				_timer.stop();
			}
			
			_view.showStatusMessage("Network Error: Failed to connect!");
		}
		
		public function networkConnected():void
		{
			_networkConnection = true;
			
			if (!_timer.running)
			{
				_timer.reset();
				_timer.start();
			}
			
			_view.hideStatusMessage();
			getWeather();
		}
		
		private function setUpView(pView:WeatherView):void
		{
			_view = pView;
			_view.addEventListener(AppEvent.SETTINGS_KEYUP, view_settingsKeyUpHandler);
			_view.addEventListener(AppEvent.SETTINGS_DONE_CLICKED, view_settingsDoneClickedHandler);
		}
		
		public function addListeners():void
		{
			_model.addEventListener(AppEvent.LOCATION_UPDATE, model_locationUpdateHandler);
		}
		
		public function loadPreferences():void
		{
			_model.loadPreferences();
		}
		
		public function preferencesLoaded():void
		{
			trace("WeatherController :: preferencesLoaded()");
			dispatchEvent(new Event(Event.COMPLETE));
			
			_timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
			_timer.start();
			
			getWeather();
		}
		
		private function timer_timerHandler(pEvent:TimerEvent):void
		{
			trace("WeatherController :: timer_timerHandler() - " + pEvent);
			getWeather();
		}
		
		public function getWeather():void
		{
			_model.addEventListener(WeatherEvent.LOADED, model_weatherLoadedHandler);
			_model.getWeather(_model.preferences.location.@id);
		}
		
		private function model_weatherLoadedHandler(pEvent:WeatherEvent):void
		{
			trace("WeatherController :: model_weatherLoadedHandler() - " + pEvent);
			trace("City: " + model.forecastModel.city);
			
			_view.update(_model.forecastModel);
		}
		
		private function view_settingsKeyUpHandler(pEvent:AppEvent):void
		{
			trace("WeatherController :: view_settingsKeyUpHandler() - " + pEvent);
			_model.getLocation(_view.tempLocation);
		}
		
		private function view_settingsDoneClickedHandler(pEvent:AppEvent):void
		{
			trace("WeatherController :: view_settingsDoneClickedHandler() - " + pEvent);
			trace(_view.locationObject.id + " " + _view.locationObject.text);
			
			if (_networkConnection)
			{
				_model.saveLocation(_view.locationObject);
				_view.hideSettingsView();
			}
		}
		
		private function model_locationUpdateHandler(pEvent:AppEvent):void
		{
			trace("WeatherController :: model_locationUpdateHandler() - " + pEvent);
			trace("WeatherController :: model_locationUpdateHandler() - Resetting timer. Starting Timer. Getting Weather");
			
			_timer.reset();
			_timer.start();
			getWeather();
		}
		
		public function getLocation_completeHandler(pXMLData:XML):void
		{
			trace("WeatherController :: getLocation_completeHandler() - " + pXMLData);
			if (pXMLData.toString() != "")
			{
				_view.showLocations(pXMLData);
			}
			else
			{
				_view.showLocations(pXMLData, true);
			}
		}
		
		public function stopUpdates():void
		{
			trace("WeatherController :: stopUpdates() - Stopping updates!");
			_timer.stop();
		}
		
		// Getter and Setter Methods
		public function get model():WeatherModel { return _model; }
		public function set model(pModel:WeatherModel):void { _model = pModel; }
		public function get view():WeatherView { return _view; }
		public function set view(pView:WeatherView):void { setUpView(pView); }
		public function get networkConnection():Boolean { return _networkConnection; }
		public function get settingsViewShown():Boolean { return _settingsViewShown; }
		public function set settingsViewShown(pBoolean:Boolean):void { _settingsViewShown = pBoolean; }
		
	}
	
}