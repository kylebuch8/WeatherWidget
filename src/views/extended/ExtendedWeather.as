package views.extended 
{
	import flash.display.Sprite;
	import views.AbstractWeather;
	import models.ForecastDayModel;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class ExtendedWeather extends AbstractWeather
	{
		private var _numForecastDays:Number;
		private var _totalWidth:Number;
		private var _totalHeight:Number;
		private var _ellipse:Number;
		private var _extendedWeatherDays:Array = new Array();
		
		public function ExtendedWeather(pNumForecastDays:Number, pTotalWidth:Number, pTotalHeight:Number, pEllipse:Number) 
		{
			_numForecastDays = pNumForecastDays;
			_totalWidth = pTotalWidth;
			_totalHeight = pTotalHeight;
			_ellipse = pEllipse;
			
			for (var i:int = 0; i < _numForecastDays; i++)
			{
				var first:Boolean = false;
				var last:Boolean = false;
				
				if (i == 0)
				{
					first = true;
				}
				
				if (i == _numForecastDays - 1)
				{
					last = true;
				}
				
				var extendedWeatherDay:ExtendedWeatherDay = new ExtendedWeatherDay(_totalWidth / _numForecastDays, _ellipse / 2, first, last);
				extendedWeatherDay.x = i * _totalWidth / _numForecastDays;
				addChild(extendedWeatherDay);
				
				_extendedWeatherDays.push(extendedWeatherDay);
			}
			
			this.y = _totalHeight - this.height;
		}
		
		public function update(pExtendedForecast:Array):void
		{
			trace("ExtendedWeather :: update()");
			for (var i:int = 0; i < _numForecastDays; i++)
			{
				_extendedWeatherDays[i].update(pExtendedForecast[i]);
			}
		}
		
	}

}