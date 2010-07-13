package views 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class AbstractWeather extends Sprite
	{
		
		public function AbstractWeather() 
		{
			
		}
		
		protected function determineIcon(pConditionCode:String):*
		{
			trace("AbstractWeather :: determineIcon() - Condition Code: " + pConditionCode);
			var weatherIcon:*;
			
			switch (pConditionCode)
			{
				case "19":
				case "20":
				case "21":
				case "22":
				case "23":
				case "26":
				case "28":
					weatherIcon = new WeatherCloudy();
				break;
				
				case "31":
				case "33":
					weatherIcon = new WeatherMoon();
				break;
				
				case "30":
				case "44":
					weatherIcon = new WeatherPartlyCloudyDay();
				break;
				
				case "27":
				case "29":
					weatherIcon = new WeatherPartlyCloudyNight();
				break;
				
				case "9":
				case "10":
				case "11":
				case "12":
				case "17":
				case "35":
				case "40":
					weatherIcon = new WeatherRain();
				break;
				
				case "13":
				case "14":
				case "15":
				case "16":
				case "41":
				case "42":
				case "43":
				case "46":
					weatherIcon = new WeatherSnow();
				break;
				
				case "24":
				case "25":
				case "32":
				case "34":
				case "36":
				case "3200":
					weatherIcon = new WeatherSunny();
				break;
				
				case "0":
				case "1":
				case "2":
				case "3":
				case "4":
				case "37":
				case "38":
				case "39":
				case "45":
				case "47":
					weatherIcon = new WeatherThunderstorm();
				break;
				
				case "5":
				case "6":
				case "7":
				case "8":
				case "18":
					weatherIcon = new WeatherWintryMix();
				break;
			}
			
			return weatherIcon;
		}
		
	}

}