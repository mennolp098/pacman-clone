package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import game.Game;
	
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class Main extends Sprite 
	{
		private var _game:Game;
		private var _mainMenu:MainMenu;
		private var _mask:Mask;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_mainMenu = new MainMenu();
			_mask = new Mask();
			addChild(_mainMenu);
			addChild(_mask);
			_mainMenu.addEventListener("startgame", startgame);
			//_game = new Game();
			//addChild(_game);
		}
		private function startgame(e:Event):void
		{
			_game = new Game();
			addChild(_game);
		}
	}
	
}