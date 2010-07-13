package views.assets 
{
	import events.AppEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import fl.controls.ScrollPolicy;
	import fl.containers.ScrollPane;
	import views.SettingsView;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class Dropdown extends Sprite
	{
		protected var _items:Array;
		protected var _itemsContainer:Sprite;
		protected var _scrollPane:ScrollPane;
		protected var _maxWidth:Number;
		protected var _maxHeight:Number;
		protected var _selected:DropdownItem;
		protected var _numItems:Number;
		protected var _view:SettingsView;
		
		public function Dropdown(pMaxWidth:Number = 100, pMaxHeight:Number = 300) 
		{
			_maxWidth = pMaxWidth;
			_maxHeight = pMaxHeight;
			
			_itemsContainer = new Sprite();
			_scrollPane = new ScrollPane();
			_scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
			
			addChild(_scrollPane);
		}
		
		private function item_mouseUpHandler(pEvent:MouseEvent):void
		{
			Tweener.addTween(pEvent.target.background, { alpha: 0, time: 0.1, onComplete: function():void 
			{
				Tweener.addTween(this, { alpha: 1, time: 0.1, onComplete: function():void
				{
					_selected = pEvent.target as DropdownItem;
					dispatchEvent(new AppEvent(AppEvent.SETTINGS_DROPDOWN_SELECTED));
					_selected = null;
				} } );
			} } );
		}
		
		public function loadItems(pItems:Array, pNoLocation:Boolean):void
		{
			clearNumItems();
			var container:Sprite = new Sprite();
			
			if (pNoLocation)
			{
				var noLocationDropdownItem:DropdownItem = new DropdownItem("No locations found", "", true);
				container.addChild(noLocationDropdownItem);
			}
			else
			{
				for (var i:int = 0; i < pItems.length; i++)
				{
					var dropdownItem:DropdownItem = new DropdownItem(pItems[i].text, pItems[i].value);
					dropdownItem.y = i * dropdownItem.height;
					dropdownItem.addEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler, false, 0, true);
					container.addChild(dropdownItem);
				}
			}
			
			if (container.height < _maxHeight)
			{
				_scrollPane.setSize(_maxWidth, container.height);
			}
			else
			{
				_scrollPane.setSize(_maxWidth, _maxHeight);
			}
			
			_numItems = container.numChildren;
			
			_scrollPane.refreshPane();
			_scrollPane.source = container;
		}
		
		public function clearNumItems():void
		{
			_numItems = 0;
		}
		
		// Getter and Setter Methods
		public function get items():Array { return _items; }
		public function set items(pArray:Array):void { _items = pArray; }
		public function get selected():DropdownItem { return _selected; }
		public function get numItems():Number { return _numItems; }
		public function get view():SettingsView { return _view; }
		public function set view(pView:SettingsView):void { _view = pView; }
		
	}

}