package game.hud 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.Game;
	import game.player.Pacman
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class Hud
	{
		private var _scoreText:TextField;
		private var _highScoreText:TextField;
		private var _lives:Array;
		private var _fruits:Array;
		private var _score:Number;
		private var _highScore:Number;
		private var extraCount:Number = 0;
		
		[Embed(source="../../../bin/PrStart.ttf",
			fontName = "PressStart", 
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
			private var PrssStart : Class;
				
		public function Hud() 
		{
			var tf:TextFormat = new TextFormat("PressStart", 6, 0xffffff);
			//check plaatje google voor hud
			_scoreText = new TextField();
			_highScoreText = new TextField();
			_lives = [];
			_fruits = [];
			
			
			_scoreText.defaultTextFormat = tf;
			Game.instance.addChild(_scoreText);
			_scoreText.x = 25;
			_scoreText.y = 5;
			_scoreText.text = "SCORE TEXT IS DIT!";
			_scoreText.embedFonts = true;
			
			_highScoreText.defaultTextFormat = tf;
			Game.instance.addChild(_highScoreText);
			_highScoreText.x = 50;
			_highScoreText.y = 12;
			_highScoreText.text = "HIGH SCORE TEXT IS DIT";
			_highScoreText.embedFonts = true;
			
			updateLifes();
		}
		private function updateLifes():void
		{
			var lives:Number = Pacman.lives;
			for (var i:int = 0; i < lives; i++) 
			{
				var newLife:Life = new Life();
				Game.instance.addChild(newLife);
				_lives.push(newLife);
				newLife.x = 20 + (20 * i);
				newLife.y = 280;
			}
		}
		public function reset():void
		{
			var l:int = _lives.length;
			for (var i:int = l - 1; i >= 0; i--)
			{
				Game.instance.removeChild(_lives[i]);
				_lives.splice(i, 1);
			}
			updateLifes();
		}
		public function loseLife():void
		{
			var l:int = _lives.length;
			Game.instance.removeChild(_lives[l - 1]);
			_lives.splice(l - 1, 1);
		}
		public function set highScore(value:Number):void 
		{
			_highScore = value;
			_highScoreText.text = "Highscore: " + _highScore;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
			_scoreText.text = "Score: " + _score;
		}
		public function addFruitPiece():void
		{
			var newFruit:Fruit = new Fruit();
			Game.instance.addChild(newFruit);
			_fruits.push(newFruit);
			newFruit.x = 180 + extraCount;
			newFruit.y = 280;
			extraCount += 5;
		}
	}
}