package models 
{
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class ForecastDayModel
	{
		private var _day:String;
		private var _date:String;
		private var _tempLow:String;
		private var _tempHigh:String;
		private var _conditionCode:String;
		
		public function ForecastDayModel(pDay:String, pDate:String, pTempLow:String, pTempHigh:String, pConditionCode:String) 
		{
			_day = pDay;
			_date = pDate;
			_tempLow = pTempLow;
			_tempHigh = pTempHigh;
			_conditionCode = pConditionCode;
		}
		
		// Getter and Setter Methods
		public function get day():String { return _day; }
		public function set day(pString:String):void { _day = pString; }
		public function get date():String { return _date; }
		public function set date(pString:String):void { _date = pString; }
		public function get tempLow():String { return _tempLow; }
		public function set tempLow(pString:String):void { _tempLow = pString; }
		public function get tempHigh():String { return _tempHigh; }
		public function set tempHigh(pString:String):void { _tempHigh = pString; }
		public function get conditionCode():String { return _conditionCode; }
		public function set conditionCode(pString:String):void { _conditionCode = pString; }
		
	}

}