package views.extended 
{
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.display.SpreadMethod;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;	
	import models.ForecastDayModel;
	import views.AbstractWeather;
	import MuseoSans;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class ExtendedWeatherDay extends AbstractWeather
	{
		private static const TOTAL_HEIGHT:Number = 150;
		private static const FONT_COLOR:uint = 0x666560;
		
		private var _totalWidth:Number;
		private var _weatherIcon:Sprite;
		private var _dateContainer:Sprite;
		private var _tempContainer:Sprite;
		private var _dayTextFormat:TextFormat;
		private var _dayTextField:TextField;
		private var _dateTextFormat:TextFormat;
		private var _dateTextField:TextField;
		private var _highTextFormat:TextFormat;
		private var _highTextField:TextField;
		private var _lowTextFormat:TextFormat;
		private var _lowTextField:TextField;
		private var _museoSans:MuseoSans = new MuseoSans();
		
		private var _currentDate:String;
		private var _currentDay:String;
		
		public function ExtendedWeatherDay(pWidth:Number, pEllipse:Number, pFirst:Boolean = false, pLast:Boolean = false) 
		{
			_totalWidth = pWidth;
			
			var type:String = GradientType.LINEAR;
			var alphas:Array = [1, 1, 1];
			var colors:Array = [0xFFFFFF, 0xDFDFDF, 0xFFFFFF];
			var ratios:Array = [0, 127, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(_totalWidth, TOTAL_HEIGHT, Math.PI / 2);
			var spreadMethod:String = SpreadMethod.PAD;
			
			//this.graphics.beginFill(0xEFEFEF);
			this.graphics.beginGradientFill(type, colors, alphas, ratios, matr, spreadMethod);
			
			if (pFirst)
			{
				this.graphics.drawRoundRectComplex(0, 0, pWidth, TOTAL_HEIGHT, 0, 0, pEllipse, 0);
			}
			else if (pLast)
			{
				this.graphics.drawRoundRectComplex(0, 0, pWidth, TOTAL_HEIGHT, 0, 0, 0, pEllipse);
			}
			else
			{
				this.graphics.drawRect(0, 0, pWidth, TOTAL_HEIGHT);
			}
			
			this.graphics.endFill();
			
			this.filters = [new DropShadowFilter(0, 90, 0xFFFFFF, 1, 4, 4, 1, 1, true)];
			
			_weatherIcon = new Sprite();
			_weatherIcon.x = this.width / 2;
			_weatherIcon.y = this.height / 2;
			addChild(_weatherIcon);
			
			_dateContainer = new Sprite();
			_dateContainer.y = 10;
			addChild(_dateContainer);
			
			_dayTextFormat = new TextFormat();
			_dayTextFormat.color = FONT_COLOR;
			_dayTextFormat.font = _museoSans.fontName;
			_dayTextFormat.size = 10;
			
			_dayTextField = new TextField();
			_dayTextField.antiAliasType = AntiAliasType.ADVANCED;
			_dayTextField.autoSize = TextFieldAutoSize.LEFT;
			_dayTextField.defaultTextFormat = _dayTextFormat;
			_dayTextField.embedFonts = true;
			_dayTextField.selectable = false;
			_dayTextField.y = 4;
			_dateContainer.addChild(_dayTextField);
			
			_dateTextFormat = new TextFormat();
			_dateTextFormat.color = FONT_COLOR;
			_dateTextFormat.font = _museoSans.fontName;
			_dateTextFormat.size = 24;
			
			_dateTextField = new TextField();
			_dateTextField.antiAliasType = AntiAliasType.ADVANCED;
			_dateTextField.autoSize = TextFieldAutoSize.LEFT;
			_dateTextField.defaultTextFormat = _dateTextFormat;
			_dateTextField.embedFonts = true;
			_dateTextField.selectable = false;
			_dateContainer.addChild(_dateTextField);
			
			_tempContainer = new Sprite();
			addChild(_tempContainer);
			
			_highTextFormat = new TextFormat();
			_highTextFormat.color = FONT_COLOR;
			_highTextFormat.font = _museoSans.fontName;
			_highTextFormat.size = 17;
			
			_highTextField = new TextField();
			_highTextField.antiAliasType = AntiAliasType.ADVANCED;
			_highTextField.autoSize = TextFieldAutoSize.LEFT;
			_highTextField.defaultTextFormat = _highTextFormat;
			_highTextField.embedFonts = true;
			_highTextField.selectable = false;
			_tempContainer.addChild(_highTextField);
			
			_lowTextFormat = new TextFormat();
			_lowTextFormat.color = FONT_COLOR;
			_lowTextFormat.font = _museoSans.fontName;
			_lowTextFormat.size = 12;
			
			_lowTextField = new TextField();
			_lowTextField.antiAliasType = AntiAliasType.ADVANCED;
			_lowTextField.autoSize = TextFieldAutoSize.LEFT;
			_lowTextField.defaultTextFormat = _lowTextFormat;
			_lowTextField.embedFonts = true;
			_lowTextField.selectable = false;
			_tempContainer.addChild(_lowTextField);
			
		}
		
		public function update(pForecastDayModel:ForecastDayModel):void
		{
			trace("ExtendedWeatherDay :: update() - " + pForecastDayModel);
			
			var newWeatherIcon:* = determineIcon(pForecastDayModel.conditionCode);
			newWeatherIcon.scaleX = 0.3;
			newWeatherIcon.scaleY = 0.3;
			
			if (_weatherIcon.numChildren > 0)
			{
				if (getQualifiedClassName(_weatherIcon.getChildAt(0)) != getQualifiedClassName(newWeatherIcon))
				{
					trace("ExtendedWeatherDay :: update() - removing _weatherIcon... replacing with new");
					trace("ExtendedWeatherDay :: update() - old: " + getQualifiedClassName(_weatherIcon.getChildAt(0)) + " new: " + getQualifiedClassName(newWeatherIcon));
					_weatherIcon.removeChildAt(0);
					_weatherIcon.addChild(newWeatherIcon);
				}
				else
				{
					trace("ExtendedWeatherDay :: update() - no current weather icon update needed");
				}
			}
			else
			{
				trace("ExtendedWeatherDay :: update() - no weather icon... adding");
				_weatherIcon.addChild(newWeatherIcon);
			}
			
			if (_currentDate != pForecastDayModel.date)
			{
				_currentDate = pForecastDayModel.date;
				
				_dateTextField.text = getDate(pForecastDayModel.date);
				_dayTextField.text = pForecastDayModel.day;
				_dayTextField.x = _dateTextField.textWidth + 2;
				
				_dateContainer.x = (_totalWidth / 2) - (_dateContainer.width / 2);
			}
			
			_highTextField.htmlText = pForecastDayModel.tempHigh + "°";
			_highTextField.x = (_tempContainer.width / 2) - (_highTextField.width / 2);
			
			_lowTextField.y = _highTextField.textHeight + 3;
			_lowTextField.htmlText = pForecastDayModel.tempLow + "°";
			_lowTextField.x = (_tempContainer.width / 2) - (_lowTextField.width / 2);
			
			_tempContainer.x = (_totalWidth / 2) - (_tempContainer.width / 2);
			_tempContainer.y = TOTAL_HEIGHT - _tempContainer.height - 10;
		}
		
		private function getDate(pDate:String):String
		{
			return pDate.split(" ")[0];
		}
		
	}

}