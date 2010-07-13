package views 
{
	import models.ForecastModel;
	import views.AbstractWeather;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class CurrentWeather extends AbstractWeather
	{
		private static const MAX_CITY_FONT_SIZE:Number = 20;
		private static const FONT_COLOR:uint = 0x666560;
		
		private var _totalWidth:Number;
		private var _currentWeatherIcon:Sprite;
		private var _cityTextField:TextField;
		private var _cityTextFormat:TextFormat;
		private var _regionTextField:TextField;
		private var _regionTextFormat:TextFormat;
		private var _currentTempTextFormat:TextFormat;
		private var _currentTempTextField:TextField;
		private var _currentConditionTextFormat:TextFormat;
		private var _currentConditionTextField:TextField;
		private var _museoSans:MuseoSans = new MuseoSans();
		
		private var _currentCity:String;
		
		public function CurrentWeather(pTotalWidth:Number) 
		{
			_totalWidth = pTotalWidth;
			
			_currentWeatherIcon = new Sprite();
			_currentWeatherIcon.y = 25;
			addChild(_currentWeatherIcon);
			
			_cityTextFormat = new TextFormat();
			_cityTextFormat.color = FONT_COLOR;
			_cityTextFormat.font = _museoSans.fontName;
			_cityTextFormat.size = MAX_CITY_FONT_SIZE;
			
			_cityTextField = new TextField();
			_cityTextField.antiAliasType = AntiAliasType.ADVANCED;
			_cityTextField.autoSize = TextFieldAutoSize.LEFT;
			_cityTextField.defaultTextFormat = _cityTextFormat;
			_cityTextField.embedFonts = true;
			_cityTextField.selectable = false;
			_cityTextField.x = 5;
			_cityTextField.y = 5;
			addChild(_cityTextField);
			
			_regionTextFormat = new TextFormat();
			_regionTextFormat.color = FONT_COLOR;
			_regionTextFormat.font = _museoSans.fontName;
			_regionTextFormat.size = 10;
			
			_regionTextField = new TextField();
			_regionTextField.antiAliasType = AntiAliasType.ADVANCED;
			_regionTextField.autoSize = TextFieldAutoSize.LEFT;
			_regionTextField.defaultTextFormat = _regionTextFormat;
			_regionTextField.embedFonts = true;
			_regionTextField.selectable = false;
			addChild(_regionTextField);
			
			_currentTempTextFormat = new TextFormat();
			_currentTempTextFormat.color = FONT_COLOR;
			_currentTempTextFormat.font = _museoSans.fontName;
			_currentTempTextFormat.size = 40;
			
			_currentTempTextField = new TextField();
			_currentTempTextField.antiAliasType = AntiAliasType.ADVANCED;
			_currentTempTextField.autoSize = TextFieldAutoSize.LEFT;
			_currentTempTextField.defaultTextFormat = _currentTempTextFormat;
			_currentTempTextField.embedFonts = true;
			_currentTempTextField.selectable = false;
			_currentTempTextField.x = 5;
			_currentTempTextField.y = 25;
			addChild(_currentTempTextField);
			
			_currentConditionTextFormat = new TextFormat();
			_currentConditionTextFormat.color = FONT_COLOR;
			_currentConditionTextFormat.font = _museoSans.fontName;
			_currentConditionTextFormat.size = 12;
			
			_currentConditionTextField = new TextField();
			_currentConditionTextField.antiAliasType = AntiAliasType.ADVANCED;
			_currentConditionTextField.autoSize = TextFieldAutoSize.LEFT;
			_currentConditionTextField.defaultTextFormat = _currentConditionTextFormat;
			_currentConditionTextField.embedFonts = true;
			_currentConditionTextField.selectable = false;
			addChild(_currentConditionTextField);
		}
		
		public function update(pForecastModel:ForecastModel):void
		{
			var newWeatherIcon:* = determineIcon(pForecastModel.conditionCode);
			newWeatherIcon.scaleX = 0.6;
			newWeatherIcon.scaleY = 0.6;
			
			if (_currentWeatherIcon.numChildren > 0)
			{
				if (getQualifiedClassName(_currentWeatherIcon.getChildAt(0)) != getQualifiedClassName(newWeatherIcon))
				{
					trace("CurrentWeather :: update() - removing _currentWeatherIcon... replacing with new");
					trace("CurrentWeather :: update() - old: " + getQualifiedClassName(_currentWeatherIcon.getChildAt(0)) + " new: " + getQualifiedClassName(newWeatherIcon));
					_currentWeatherIcon.removeChildAt(0);
					_currentWeatherIcon.addChild(newWeatherIcon);
				}
				else
				{
					trace("CurrentWeather :: update() - no current weather icon update needed");
				}
			}
			else
			{
				trace("CurrentWeather :: update() - no weather icon... adding");
				_currentWeatherIcon.addChild(newWeatherIcon);
			}
			
			_currentWeatherIcon.x = _totalWidth - (_currentWeatherIcon.getRect(this).width / 2) - 5; // registration point for all weather icons is centered
			
			_cityTextField.text = pForecastModel.city + ",";
			//_cityTextField.text = "Truth or Consequences,";
			_regionTextField.text = pForecastModel.region;
			
			if (_currentCity != pForecastModel.city + ",")
			{
				_currentCity = pForecastModel.city + ",";
				positionCityRegionText();
			}
			
			_currentTempTextField.text = pForecastModel.currentTemp + "°";
			
			_currentConditionTextField.text = pForecastModel.currentCondition;
			_currentConditionTextField.x = _currentTempTextField.getRect(this).right;
			_currentConditionTextField.y = _currentTempTextField.y + _currentTempTextField.getLineMetrics(0).ascent - _currentConditionTextField.getLineMetrics(0).ascent;
		}
		
		private function positionCityRegionText():void
		{
			trace("CurrentWeather :: positionCityRegionText()");
			
			_regionTextField.x = _cityTextField.getRect(this).right;
			_regionTextField.y = _cityTextField.y + _cityTextField.getLineMetrics(0).ascent - _regionTextField.getLineMetrics(0).ascent;
			
			if (_regionTextField.getRect(this).right > _currentWeatherIcon.getRect(this).left)
			{
				while (_regionTextField.getRect(this).right > _currentWeatherIcon.getRect(this).left)
				{
					_cityTextFormat.size = Number(_cityTextFormat.size) - 1;
					_cityTextField.setTextFormat(_cityTextFormat);
					_cityTextField.defaultTextFormat = _cityTextFormat;
					_regionTextField.x = _cityTextField.x + _cityTextField.getRect(this).width;
					_regionTextField.y = _cityTextField.y + _cityTextField.getLineMetrics(0).ascent - _regionTextField.getLineMetrics(0).ascent;
				}
			}
			else
			{
				while (_regionTextField.getRect(this).right < _currentWeatherIcon.getRect(this).left && _cityTextFormat.size < MAX_CITY_FONT_SIZE)
				{
					_cityTextFormat.size = Number(_cityTextFormat.size) + 1;
					_cityTextField.setTextFormat(_cityTextFormat);
					_cityTextField.defaultTextFormat = _cityTextFormat;
					_regionTextField.x = _cityTextField.x + _cityTextField.getRect(this).width;
					_regionTextField.y = _cityTextField.y + _cityTextField.getLineMetrics(0).ascent - _regionTextField.getLineMetrics(0).ascent;
					
					if (_regionTextField.getRect(this).right > _currentWeatherIcon.getRect(this).left)
					{
						_cityTextFormat.size = Number(_cityTextFormat.size) - 1;
						_cityTextField.setTextFormat(_cityTextFormat);
						_cityTextField.defaultTextFormat = _cityTextFormat;
						_regionTextField.x = _cityTextField.x + _cityTextField.getRect(this).width;
						_regionTextField.y = _cityTextField.y + _cityTextField.getLineMetrics(0).ascent - _regionTextField.getLineMetrics(0).ascent;
						break;
					}
				}
			}
		}
		
	}

}