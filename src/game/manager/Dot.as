package game.manager 
{
	import flash.display.Sprite;
	import game.Game;
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class Dot extends Sprite
	{
		protected var _dot:cookie;
		public var id:int;
		public var removeable:Boolean;
		public function Dot() 
		{
			_dot = new cookie();
			addChild(_dot);
			id = 1;
		}
	}
}