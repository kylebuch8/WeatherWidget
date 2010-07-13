package views 
{
	import controllers.WeatherController;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import models.ForecastModel;
	import models.WeatherModel;
	import views.AbstractWeather;
	import views.CurrentWeather;
	import views.extended.ExtendedWeather;
	import views.SettingsView;
	import events.AppEvent;
	import SettingsIcon;
	import views.assets.StatusMessage;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class WeatherView extends AbstractWeather
	{
		private static const TOTAL_WIDTH:Number = 325;
		private static const TOTAL_HEIGHT:Number = 225;
		private static const ELLIPSE:Number = 20;
		private static const FORECAST_DAYS:Number = 5;
		
		private var _model:WeatherModel;
		private var _controller:WeatherController;
		
		private var _container:Sprite;
		private var _currentWeather:CurrentWeather;
		private var _extendedWeather:ExtendedWeather;
		private var _settingsView:SettingsView;
		private var _settingsIcon:SettingsIcon;
		private var _location:String;
		private var _tempLocation:String;
		private var _locationObject:Object;
		private var _statusMessage:StatusMessage;
		private var _settingsViewShown:Boolean = false;
		
		private var _dropshadow:DropShadowFilter = new DropShadowFilter(0, 90, 0, 0.71, 15, 15);
		
		public function WeatherView(pModel:WeatherModel, pController:WeatherController) 
		{
			_model = pModel;
			_controller = pController;
			
			_container = new Sprite();
			_container.graphics.beginFill(0xFFFFFF); 
			_container.graphics.drawRoundRect(0, 0, TOTAL_WIDTH, TOTAL_HEIGHT, ELLIPSE, ELLIPSE);
			_container.graphics.endFill();
			
			_currentWeather = new CurrentWeather(TOTAL_WIDTH);
			_container.addChild(_currentWeather);
			
			_extendedWeather = new ExtendedWeather(FORECAST_DAYS, TOTAL_WIDTH, TOTAL_HEIGHT, ELLIPSE);
			_container.addChild(_extendedWeather);
			
			_settingsIcon = new SettingsIcon();
			_settingsIcon.scaleX = 0.1;
			_settingsIcon.scaleY = 0.1;
			_settingsIcon.alpha = 0;
			_settingsIcon.visible = false;
			_settingsIcon.x = TOTAL_WIDTH - (_settingsIcon.width / 2) - 5;
			_settingsIcon.y = TOTAL_HEIGHT - (_settingsIcon.height / 2) - 5;
			_settingsIcon.buttonMode = true;
			_settingsIcon.addEventListener(MouseEvent.MOUSE_UP, settingsIcon_mouseUpHandler);
			_container.addChild(_settingsIcon);
			
			_settingsView = new SettingsView(TOTAL_WIDTH, TOTAL_HEIGHT, ELLIPSE);
			_settingsView.x = TOTAL_WIDTH / 2;
			_settingsView.y = TOTAL_HEIGHT / 2;
			_settingsView.visible = false;
			_settingsView.addEventListener(AppEvent.SETTINGS_KEYUP, settingsView_settingsKeyUpHandler);
			_settingsView.addEventListener(AppEvent.SETTINGS_DONE_CLICKED, settingsView_settingsDoneClickedHandler);
			_container.addChild(_settingsView);
			
			_statusMessage = new StatusMessage();
			_statusMessage.visible = false;
			_statusMessage.x = TOTAL_WIDTH / 2;
			_statusMessage.y = TOTAL_HEIGHT / 2;
			_statusMessage.scaleX = 0;
			_statusMessage.scaleY = 0;
			_container.addChild(_statusMessage)
			
			addChild(_container);
			_container.x = -TOTAL_WIDTH / 2;
			_container.y = -TOTAL_HEIGHT / 2;
			
			this.filters = [_dropshadow];
		}
		
		public function update(pForecastModel:ForecastModel):void
		{
			_settingsView.location = _model.preferences.location.toString();
			
			var locationObject:Object = new Object();
			locationObject.id = _model.preferences.location.@id.toString();
			locationObject.text = _model.preferences.location.toString();
			_settingsView.locationObject = locationObject;
			
			_currentWeather.update(pForecastModel);
			_extendedWeather.update(pForecastModel.extendedForecast);
		}
		
		private function settingsIcon_mouseUpHandler(pEvent:MouseEvent):void
		{
			trace("WeatherView :: settingsIcon_mouseUpHandler() - " + pEvent);
			showSettingsView();
			hideSettingsIcon();
		}
		
		private function settingsView_mouseUpHandler(pEvent:MouseEvent):void
		{
			hideSettingsView();
		}
		
		public function showSettingsIcon():void
		{
			_settingsIcon.visible = true;
			Tweener.addTween(_settingsIcon, { alpha: 1, time: 1 } );
		}
		
		public function hideSettingsIcon():void
		{
			Tweener.addTween(_settingsIcon, { alpha: 0, time: 1, onComplete: function():void
			{
				_settingsIcon.visible = false;
			} } );
		}
		
		public function showSettingsView():void
		{
			_controller.settingsViewShown = true;
			_controller.stopUpdates();
			_settingsView.show();
		}
		
		public function hideSettingsView():void
		{
			_controller.settingsViewShown = false;
			_settingsView.hide();
		}
		
		private function settingsHandler_mouseUpHandler(pEvent:MouseEvent):void
		{
			trace("WeatherView :: settingsHandler_mouseUpHandler() - " + pEvent);
		}
		
		private function settingsView_settingsKeyUpHandler(pEvent:AppEvent):void
		{
			trace("WeatherView :: settingsView_settingsKeyUpHandler() - " + pEvent);
			_tempLocation = _settingsView.location;
			dispatchEvent(pEvent);
		}
		
		private function settingsView_settingsDoneClickedHandler(pEvent:AppEvent):void
		{
			trace("WeatherView :: settingsView_settingsDoneClickedHandler() - " + pEvent);
			_locationObject = _settingsView.locationObject;
			dispatchEvent(pEvent);
		}
		
		public function showLocations(pXMLData:XML, pNoLocations:Boolean = false):void
		{
			if (!pNoLocations)
			{
				var array:Array = new Array();
				for each (var location:XML in pXMLData.loc)
				{
					var object:Object = new Object();
					object.value = location.@id;
					object.text = location.toString();
					array.push(object);
				}
				
				_settingsView.showDropdown(array);
			}
			else
			{
				_settingsView.showDropdown([], true);
			}
		}
		
		public function showStatusMessage(pMessage:String):void
		{
			_statusMessage.scaleX = 0;
			_statusMessage.scaleY = 0;
			_statusMessage.alpha = 1;
			_statusMessage.visible = true;
			_statusMessage.setText(pMessage);
			Tweener.addTween(_statusMessage, { scaleX: 1, scaleY: 1, time: 1 } );
		}
		
		public function hideStatusMessage():void
		{
			Tweener.addTween(_statusMessage, { alpha: 0, time: 1, onComplete: function():void
			{
				this.visible = false;
			} } );
		}
		
		// Getter and Setter Methods
		public function get model():WeatherModel { return _model; }
		public function set model(pModel:WeatherModel):void { _model = pModel; }
		public function get controller():WeatherController { return _controller; }
		public function set controller(pController:WeatherController):void { _controller = pController; }
		public function get location():String { return _location; }
		public function set location(pString:String):void { _location = pString; }
		public function get tempLocation():String { return _tempLocation; }
		public function set tempLocation(pString:String):void { _tempLocation = pString; }
		public function get locationObject():Object { return _locationObject; }
		public function get settingsViewShown():Boolean { return _settingsViewShown; }
		
	}

}