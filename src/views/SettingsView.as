package views 
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import events.AppEvent;
	import MuseoSans;
	import views.assets.Dropdown;
	import views.assets.DropdownItem;
	import WeatherChannelLogo;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class SettingsView extends Sprite
	{
		private var _background:Sprite;
		private var _inputContainer:Sprite;
		private var _container:Sprite;
		private var _locationTextFormat:TextFormat;
		private var _locationTextField:TextField;
		private var _locationInputTextFormat:TextFormat;
		private var _locationInputTextField:TextField;
		private var _museoSans:MuseoSans = new MuseoSans;
		private var _doneButtonTextFormat:TextFormat;
		private var _doneButtonTextField:TextField;
		private var _doneButton:Sprite;
		private var _dropdown:Dropdown;
		private var _weatherChannelLogo:WeatherChannelLogo;
		private var _locationObject:Object;
		private var _locationFound:Boolean;
		
		public function SettingsView(pWidth:Number, pHeight:Number, pEllipse:Number) 
		{
			_background = new Sprite();
			_background.graphics.beginFill(0x000000, 0.85);
			_background.graphics.drawRoundRect(0, 0, pWidth, pHeight, pEllipse, pEllipse);
			_background.graphics.endFill();
			_background.x = -pWidth / 2;
			_background.y = -pHeight / 2;
			_background.alpha = 0;
			addChild(_background);
			
			_inputContainer = new Sprite();
			
			_container = new Sprite();
			_container.graphics.beginFill(0x999999, 0.75);
			_container.graphics.drawRoundRect(0, 0, pWidth - 50, pHeight - 25, pEllipse, pEllipse);
			_container.graphics.endFill();
			_container.x = -(pWidth - 50) / 2;
			_container.y = -(pHeight - 25) / 2;
			_inputContainer.addChild(_container);
			
			_locationTextFormat = new TextFormat();
			_locationTextFormat.color = 0xFFFFFF;
			_locationTextFormat.font = _museoSans.fontName;
			_locationTextFormat.size = 12;
			
			_locationTextField = new TextField();
			_locationTextField.antiAliasType = AntiAliasType.NORMAL;
			_locationTextField.autoSize = TextFieldAutoSize.LEFT;
			_locationTextField.defaultTextFormat = _locationTextFormat;
			_locationTextField.embedFonts = true;
			_locationTextField.selectable = false;
			_locationTextField.text = "City, State or Zip Code:";
			_locationTextField.x = 10;
			_locationTextField.y = 10;
			_container.addChild(_locationTextField);
			
			_locationInputTextFormat = new TextFormat();
			_locationInputTextFormat.color = 0x000000;
			_locationInputTextFormat.font = _museoSans.fontName;
			_locationInputTextFormat.size = 14;
			
			_locationInputTextField = new TextField();
			_locationInputTextField.background = true;
			_locationInputTextField.backgroundColor = 0xFFFFFF;
			_locationInputTextField.defaultTextFormat = _locationInputTextFormat;
			_locationInputTextField.embedFonts = true;
			_locationInputTextField.text = "Enter something";
			_locationInputTextField.type = TextFieldType.INPUT;
			_locationInputTextField.width = 200;
			_locationInputTextField.height = _locationInputTextField.textHeight + 5;
			_locationInputTextField.x = 10;
			_locationInputTextField.y = _locationTextField.getRect(this).bottom + 10;
			_locationInputTextField.addEventListener(KeyboardEvent.KEY_UP, locationInputTextField_keyUpHandler);
			_container.addChild(_locationInputTextField);
			
			_doneButtonTextFormat = new TextFormat();
			_doneButtonTextFormat.color = 0xFFFFFF;
			_doneButtonTextFormat.font = _museoSans.fontName;
			_doneButtonTextFormat.size = 12;
			
			_doneButtonTextField = new TextField();
			_doneButtonTextField.autoSize = TextFieldAutoSize.LEFT;
			_doneButtonTextField.defaultTextFormat = _doneButtonTextFormat;
			_doneButtonTextField.embedFonts = true;
			_doneButtonTextField.text = "DONE";
			_doneButtonTextField.selectable = false;
			
			var type:String = GradientType.LINEAR;
			var colors:Array = [0x696969, 0x000000];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(_doneButtonTextField.textWidth + 10, _locationInputTextField.textHeight + 5, Math.PI / 2);
			var spreadMethod:String = SpreadMethod.PAD;
			
			_doneButton = new Sprite();
			_doneButton.buttonMode = true;
			_doneButton.mouseChildren = false;
			_doneButton.graphics.beginGradientFill(type, colors, alphas, ratios, matr, spreadMethod);
			_doneButton.graphics.drawRoundRect(0, 0, _doneButtonTextField.textWidth + 10, _locationInputTextField.textHeight + 5, 5, 5);
			_doneButton.graphics.endFill();
			_doneButton.x = _locationInputTextField.getRect(this).right + 15;
			_doneButton.y = _locationInputTextField.y;
			_doneButton.addEventListener(MouseEvent.MOUSE_UP, doneButton_mouseUpHandler);
			
			_doneButtonTextField.x = (_doneButton.width / 2) - (_doneButtonTextField.width / 2);
			_doneButtonTextField.y = (_doneButton.height / 2) - (_doneButtonTextField.height / 2);
			_doneButton.addChild(_doneButtonTextField);
			_container.addChild(_doneButton);
			
			_weatherChannelLogo = new WeatherChannelLogo();
			_weatherChannelLogo.x = (_container.width / 2) - (_weatherChannelLogo.width / 2);
			_weatherChannelLogo.y = ((_container.height - (_locationInputTextField.y + _locationInputTextField.height)) / 2) - (_weatherChannelLogo.height / 2) + (_locationInputTextField.y + _locationInputTextField.height);
			_container.addChild(_weatherChannelLogo);
			
			_inputContainer.scaleX = 0.5;
			_inputContainer.scaleY = 0.5;
			_inputContainer.alpha = 0;
			addChild(_inputContainer);
			
			_dropdown = new Dropdown(_locationInputTextField.width, _container.height - (_locationInputTextField.y + _locationInputTextField.height) - 1);
			_dropdown.view = this;
			_dropdown.x = _locationInputTextField.x;
			_dropdown.y = _locationInputTextField.y + _locationInputTextField.height + 1;
			_dropdown.addEventListener(AppEvent.SETTINGS_DROPDOWN_SELECTED, dropdown_settingsDropdownSelectedHandler);
			_dropdown.visible = false;
			_container.addChild(_dropdown);
		}
		
		private function locationInputTextField_keyUpHandler(pEvent:KeyboardEvent):void
		{
			trace("SettingsView :: locationInputTextField_keyUpHandler() - " + pEvent);
			if (_locationInputTextField.text.length > 1)
			{
				dispatchEvent(new AppEvent(AppEvent.SETTINGS_KEYUP));
			}
			else
			{
				hideDropdown();
			}
		}
		
		private function dropdown_settingsDropdownSelectedHandler(pEvent:AppEvent):void
		{
			trace("SettingsView :: dropdown_settingsDropdownSelectedHandler() - " + pEvent);
			_locationInputTextField.text = _dropdown.selected.text;
			
			_locationObject = new Object();
			_locationObject.id = _dropdown.selected.value;
			_locationObject.text = _dropdown.selected.text;
			
			trace(_locationObject);
			hideDropdown();
		}
		
		private function doneButton_mouseUpHandler(pEvent:MouseEvent):void
		{
			if (_locationFound)
			{
				trace("SettingsView :: doneButton_mouseUpHandler() - " + pEvent);
				dispatchEvent(new AppEvent(AppEvent.SETTINGS_DONE_CLICKED));
			}
		}
		
		public function show():void
		{
			this.visible = true;
			this.stage.focus = _locationInputTextField;
			
			_locationFound = true;
			_locationInputTextField.setSelection(0, _locationInputTextField.text.length);
			
			Tweener.addTween(_background, { alpha: 1, time: 0.5, onComplete: function():void
			{
				Tweener.addTween(_inputContainer, { alpha: 1, scaleX: 1, scaleY: 1, time: 0.75 } );
			} } );
		}
		
		public function hide():void
		{
			hideDropdown();
			Tweener.addTween(_inputContainer, { alpha: 0, time: 0.5, onComplete: function():void
			{
				this.scaleX = 0.5;
				this.scaleY = 0.5;
				Tweener.addTween(_background, { alpha: 0, time: 0.5, onComplete: makeInvisible} );
			} } );
		}
		
		private function makeInvisible():void
		{
			this.visible = false;
		}
		
		public function showDropdown(pArray:Array, pNoLocation:Boolean = false):void
		{
			if (pNoLocation)
			{
				_locationFound = false;
			}
			else
			{
				_locationFound = true;
			}
			
			_dropdown.loadItems(pArray, pNoLocation);
			_dropdown.visible = true;
		}
		
		public function hideDropdown():void
		{
			_dropdown.visible = false;
			_dropdown.clearNumItems();
		}
		
		// Getter and Setter Methods
		public function get location():String { return _locationInputTextField.text; }
		public function set location(pString:String):void { _locationInputTextField.text = pString; }
		public function get locationObject():Object { return _locationObject; }
		public function set locationObject(pObject:Object):void { _locationObject = pObject; }
		
	}

}