package models 
{
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class ForecastModel
	{
		private var _xml:XML;
		private var _city:String;
		private var _region:String;
		private var _currentTemp:String;
		private var _currentCondition:String;
		private var _conditionCode:String;
		private var _extendedForecast:Array;
		
		public function ForecastModel(pXML:XML) 
		{
			_xml = pXML;
			
			_extendedForecast = new Array();
			var yweather:Namespace = _xml.namespace("yweather");
			
			_city = _xml.channel.yweather::location[0].@city;
			_region = _xml.channel.yweather::location[0].@region;
			_currentTemp = _xml.channel.item.yweather::condition[0].@temp;
			_currentCondition = _xml.channel.item.yweather::condition[0].@text;
			_conditionCode = _xml.channel.item.yweather::condition[0].@code;
			
			for (var i:int = 0; i < 5; i++)
			{
				var forecastXML:XML = _xml.channel.item.yweather::forecast[i];
				var day:String = forecastXML.@day;
				var date:String = forecastXML.@date;
				var low:String = forecastXML.@low;
				var high:String = forecastXML.@high;
				var code:String = forecastXML.@code;
				
				var forecast:ForecastDayModel = new ForecastDayModel(day, date, low, high, code);
				_extendedForecast.push(forecast);
			}
		}
		
		// Getter and Setter Methods
		public function get city():String { return _city; }
		public function set city(pString:String):void { _city = pString; }
		public function get region():String { return _region; }
		public function set region(pString:String):void { _region = pString; }
		public function get currentTemp():String { return _currentTemp; }
		public function set currentTemp(pString:String):void { _currentTemp = pString; }
		public function get currentCondition():String { return _currentCondition; }
		public function set currentCondition(pString:String):void { _currentCondition = pString; }
		public function get conditionCode():String { return _conditionCode; }
		public function set conditionCode(pString:String):void { _conditionCode = pString; }
		public function get extendedForecast():Array { return _extendedForecast; }
	}

}