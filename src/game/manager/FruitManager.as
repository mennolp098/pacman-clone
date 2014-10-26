package game.manager 
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import game.Game;
	import game.manager.TileManager;
	import game.SoundManager;
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class FruitManager 
	{
		public static var allFruits:Array;
		public static var allTexts:Array;
		
		[Embed(source= "../../../bin/PrStart.ttf",
			fontName = "PressStart", 
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
			private var PrssStart : Class;
		public function FruitManager() 
		{
			allFruits = [];
			allTexts = [];
			setTimeout(spawnFruit, 120000);
		}
		public function spawnFruit():void
		{
			var newFruit:Fruit = new Fruit();
			newFruit.x = 128;
			newFruit.y = 160;
			Game.instance.addChild(newFruit);
			allFruits.push(newFruit);
			setTimeout(spawnFruit, 120000);
		}
		public static function hittingFruit(x:Number, y:Number):void
		{
			var fruitLength:Number = allFruits.length;
			for (var i:int = fruitLength - 1; i >= 0; i--)
			{
				if (allFruits[i].x+4 == x && allFruits[i].y+4 == y)
				{
					Game.instance.addScore(250);
					Game.instance.addFruit();
					SoundManager.playSound(SoundManager.SOUND_EATFRUIT);
					Game.instance.removeChild(allFruits[i]);
					allFruits.splice(i, 1);
					splashScore(x,y);
				}
			}
			var textLenth:Number = allTexts.length;
			for (i = textLenth - 1; i >= 0; i--)
			{
				allTexts[i].y -= 1;
			}
		}
		public static function splashScore(x:Number, y:Number):void
		{
			var text:TextField = new TextField();
			var tf:TextFormat = new TextFormat("PressStart", 6, 0xffffff);
			text.defaultTextFormat = tf;
			Game.instance.addChild(text);
			text.x = x;
			text.y = y;
			text.text = "250";
			allTexts.push(text);
			setTimeout(deleteText, 2000);
		}
		public static function deleteText():void
		{
			var textLenth:Number = allTexts.length;
			for (var i:int = textLenth - 1; i >= 0; i--)
			{
				Game.instance.removeChild(allTexts[i]);
				allTexts.splice(i, 1);
			}
		}
	}
}