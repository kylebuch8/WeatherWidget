package 
{
	import controllers.WeatherController;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindowDisplayState;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import models.WeatherModel;
	import views.WeatherView;
	import events.AppEvent;
	
	/**
	 * ...
	 * @author Kyle Buchanan
	 */
	public class Main extends Sprite 
	{
		private var weatherController:WeatherController;
		private var weatherModel:WeatherModel;
		private var weatherView:WeatherView;
		private var canSavePosition:Boolean = true;
		
		public function Main():void 
		{			
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init():void
		{
			trace("WeatherWidget :: v1.0");
			
			stage.nativeWindow.visible = false;
			stage.nativeWindow.addEventListener(Event.CLOSING, closingHandler);
			stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, displayChangeHandler);
			
			weatherController = new WeatherController();
			weatherController.addEventListener(Event.COMPLETE, weatherController_completeHandler);
			
			weatherModel = WeatherModel.getInstance();
			
			weatherView = new WeatherView(weatherModel, weatherController);
			weatherView.x = stage.stageWidth / 2;
			weatherView.y = stage.stageHeight / 2 + 12;
			addChild(weatherView);
			
			// let everyone communicate with each other
			weatherController.model = weatherModel;
			weatherController.view = weatherView;
			weatherModel.controller = weatherController;
			
			weatherController.addListeners();
			weatherController.loadPreferences();
		}
		
		private function weatherController_completeHandler(pEvent:Event):void
		{
			trace("Main :: weatherController_completeHandler - " + pEvent);
			stage.nativeWindow.x = Number(weatherModel.preferences.window.lastXPos);
			stage.nativeWindow.y = Number(weatherModel.preferences.window.lastYPos);
			stage.nativeWindow.activate();
			stage.nativeWindow.visible = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function mouseDownHandler(pEvent:MouseEvent):void
		{
			trace("Main :: mouseDownHandler() - " + pEvent);
			trace("Main :: mouseDownHandler() - " + pEvent.target);
			if (!(pEvent.target is SettingsIcon) && !(pEvent.target is TextField))
			{
				trace("Main :: mouseDownHandler() - starting move");
				stage.nativeWindow.startMove();
			}
		}
		
		private function mouseOverHandler(pEvent:MouseEvent):void
		{
			if (weatherController.networkConnection && !weatherController.settingsViewShown)
			{
				weatherView.showSettingsIcon();
			}
		}
		
		private function mouseOutHandler(pEvent:MouseEvent):void
		{
			weatherView.hideSettingsIcon();
		}
		
		private function displayChangeHandler(pEvent:NativeWindowDisplayStateEvent):void
		{
			trace("Main :: displayChangeHandler() - " + pEvent);
			
			if (pEvent.afterDisplayState == NativeWindowDisplayState.NORMAL)
			{
				canSavePosition = true;
			}
			else
			{
				canSavePosition = false;
			}
		}
		
		private function closingHandler(pEvent:Event):void
		{
			trace("Main :: closingHandler() - " + pEvent);
			pEvent.preventDefault();
			
			trace("Window xPos: " + stage.nativeWindow.x + " Window yPos: " + stage.nativeWindow.y);
			weatherModel.addEventListener(AppEvent.CLOSE, weatherModel_closeHandler);
			
			if (canSavePosition)
			{
				weatherModel.savePosition(stage.nativeWindow.x, stage.nativeWindow.y);
			}
		}
		
		private function weatherModel_closeHandler(pEvent:AppEvent):void
		{
			close();
		}
		
		public function close():void
		{
			stage.nativeWindow.close();
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}