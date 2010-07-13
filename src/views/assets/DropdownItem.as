package views.assets 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import MuseoSans;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class DropdownItem extends Sprite
	{
		private static const WIDTH:Number = 200;
		private static const HEIGHT:Number = 25;
		
		private var _background:Sprite;
		private var _text:String;
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		private var _museoSans:MuseoSans = new MuseoSans();
		private var _value:String;
		
		public function DropdownItem(pText:String, pValue:String, pNoSelect:Boolean = false) 
		{
			_text = pText;
			_value = pValue;
			
			this.mouseChildren = false;
			
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			this.graphics.endFill();
			
			_background = new Sprite();
			_background.graphics.beginFill(0x1E90FF);
			_background.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			_background.graphics.endFill();
			_background.alpha = 0;
			addChild(_background);
			
			_textFormat = new TextFormat();
			
			if (pNoSelect)
			{
				_textFormat.color = 0x666666;
			}
			else
			{
				_textFormat.color = 0x000000;
			}
			
			_textFormat.font = _museoSans.fontName;
			_textFormat.size = 12;
			
			_textField = new TextField();
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.defaultTextFormat = _textFormat;
			_textField.embedFonts = true;
			_textField.selectable = false;
			_textField.text = _text;
			_textField.x = 10;
			_textField.y = (this.height / 2) - (_textField.textHeight / 2);
			addChild(_textField);
			
			if (!pNoSelect)
			{
				this.buttonMode = true;
				addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
				addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			}
		}
		
		private function mouseOverHandler(pEvent:MouseEvent):void
		{
			Tweener.addTween(_background, { alpha: 1, time: 0.5 } );
		}
		
		private function mouseOutHandler(pEvent:MouseEvent):void
		{
			Tweener.addTween(_background, { alpha: 0, time: 0.5 } );
		}
		
		// Getter and Setter Methods
		public function get background():Sprite { return _background; }
		public function get text():String { return _text; }
		public function set text(pString:String):void { _text = pString; }
		public function get value():String { return _value; }
		public function set value(pString:String):void { _value = pString; }
		
	}

}