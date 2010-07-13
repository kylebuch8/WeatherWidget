package views.assets 
{
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import MuseoSans;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class StatusMessage extends Sprite
	{
		private static const WIDTH:Number = 200;
		private static const HEIGHT:Number = 150;
		private static const FONT_COLOR:uint = 0xFFFFFF;
		private static const FONT_SIZE:Number = 12;
		
		private var _container:Sprite;
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		private var _museoSans:MuseoSans = new MuseoSans();
		private var _dropshadow:DropShadowFilter = new DropShadowFilter(0, 90, 0, 0.71, 15, 15);
		
		public function StatusMessage() 
		{
			var type:String = GradientType.LINEAR;
			var colors:Array = [0x696969, 0x292929];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(WIDTH, HEIGHT, Math.PI / 2);
			var spreadMethod:String = SpreadMethod.PAD;
			
			_container = new Sprite();
			_container.graphics.beginGradientFill(type, colors, alphas, ratios, matr, spreadMethod);
			_container.graphics.drawRoundRect(0, 0, WIDTH, HEIGHT, 20, 20);
			_container.graphics.endFill();
			
			_textFormat = new TextFormat();
			_textFormat.align = TextFormatAlign.CENTER;
			_textFormat.color = FONT_COLOR;
			_textFormat.font = _museoSans.fontName;
			_textFormat.size = FONT_SIZE;
			
			_textField = new TextField();
			//_textField.autoSize = TextFieldAutoSize.CENTER;
			_textField.defaultTextFormat = _textFormat;
			_textField.embedFonts = true;
			_textField.selectable = false;
			//_textField.text = "Status Message";
			_textField.width = WIDTH - 20;
			_textField.height = HEIGHT - 20;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.x = (WIDTH / 2) - (_textField.width / 2);
			_textField.y = (HEIGHT / 2) - (_textField.height / 2);
			_container.addChild(_textField);
			
			_container.x = -WIDTH / 2;
			_container.y = -HEIGHT / 2;
			addChild(_container);
			
			this.filters = [_dropshadow];
		}
		
		public function setText(pString:String):void
		{
			_textField.text = pString;
			_textField.y = (HEIGHT / 2) - (_textField.textHeight / 2);
		}
		
	}

}