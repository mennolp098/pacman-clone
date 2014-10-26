package game 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import game.hud.Hud;
	import game.manager.DotManager;
	import game.manager.FruitManager;
	import game.manager.TileManager;
	import game.ghost.GhostBehavior;
	import game.player.Pacman;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class Game extends Sprite
	{
		public static var instance:Game;
		private var _tileManager:TileManager;
		private var _soundManager:SoundManager;
		private var _fruitManager:FruitManager;
		private var _dotManager:DotManager;
		private var _redGhost:GhostBehavior;
		private var _pinkGhost:GhostBehavior;
		private var _tealGhost:GhostBehavior;
		private var _orangeGhost:GhostBehavior;
		private var _pacman:Pacman;
		private var _gameIsStarted:Boolean;
		private var _hud:Hud;
		private var _score:Number = 0;
		private var _highScore:Number;
		private var _readyText:TextField;
		
		[Embed(source= "../../bin/PrStart.ttf",
			fontName = "PressStart", 
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
			private var PrssStart : Class;
		public function Game() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var highscore:SharedObject = SharedObject.getLocal("pacmanHighScore");
			if (highscore.data.score == null)
			{
				highscore.data.score = 0;
			}
			_highScore = highscore.data.score;
			
			instance = this;
			_hud = new Hud();
			_hud.score = _score;
			_hud.highScore = _highScore;
			_tileManager = new TileManager();
			_soundManager = new SoundManager();
			_fruitManager = new FruitManager();
			_dotManager = new DotManager();
			_pacman = new Pacman(108, 212);
			
			_redGhost = new GhostBehavior(112, 116, redGhost, false, [1,0], 0);
			_tealGhost = new GhostBehavior(96, 140, tealGhost, true, [0,1], 5);
			_pinkGhost = new GhostBehavior(112, 140, pinkGhost, true, [0,-1], 0.5);
			_orangeGhost = new GhostBehavior(128, 140, orangeGhost, true, [0, 1], 10);
			
			_readyText = new TextField();
			var tf:TextFormat = new TextFormat("PressStart", 12, 0xffffff);
			_readyText.defaultTextFormat = tf;
			_readyText.x = 85;
			_readyText.y = 155;
			_readyText.text = "Ready!";
			_readyText.selectable = false;
			_readyText.embedFonts = true;
			addChild(_readyText);
			startGame();
		}
		private function startGame():void
		{
			SoundManager.playSound(SoundManager.SOUND_BEGIN);
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			var startTimer:Timer = new Timer(2000, 2);
			startTimer.start();
			startTimer.addEventListener(TimerEvent.TIMER, startCounter);
		}
		private function startCounter(e:TimerEvent):void
		{
			var t:Timer = e.target as Timer;
			switch(t.currentCount) {
				case 0:
					_readyText.text = "Ready!";
					break;
				case 1:
					_readyText.text = "Go!";
					_gameIsStarted = true;
					break;
				case 2:
					_readyText.text = "";
			}
		}
		private function update(e:Event):void
		{
			if (_gameIsStarted)
			{
				_redGhost.update();
				_tealGhost.update();
				_pinkGhost.update();
				_orangeGhost.update();
				_pacman.update();
				_soundManager.update();
				
				ghostHitTest(_redGhost);
				ghostHitTest(_tealGhost);
				ghostHitTest(_orangeGhost);
				ghostHitTest(_pinkGhost);
			}
		}
		private function ghostHitTest(currentGhost:GhostBehavior):void
		{
			if (currentGhost.ghost.hitTestObject(_pacman.player))
			{
				if (currentGhost.dieAble)
				{
					currentGhost.die();
				} else {
					_pacman.die();
				}
			}
		}
		private function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode) {
			case Keyboard.W:
				_pacman.movement(0, -1);
				break;
			case Keyboard.S:
				_pacman.movement(0, 1);
				break;
			case Keyboard.A:
				_pacman.movement(-1, 0);
				break;
			case Keyboard.D:
				_pacman.movement(1, 0);
				break;
			case Keyboard.UP:
				_pacman.movement(0, -1);
				break;
			case Keyboard.DOWN:
				_pacman.movement(0, 1);
				break;
			case Keyboard.LEFT:
				_pacman.movement(-1, 0);
				break;
			case Keyboard.RIGHT:
				_pacman.movement(1, 0);
				break;
			}
		}
		public function activateSpecial():void
		{
			_redGhost.beScared();
			_tealGhost.beScared();
			_orangeGhost.beScared();
			_pinkGhost.beScared();
		}
		public function diePauze():void
		{
			_hud.loseLife();
			stage.removeEventListener(Event.ENTER_FRAME, update);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			var dieTimer:Timer = new Timer(500, 2);
			dieTimer.start();
			dieTimer.addEventListener(TimerEvent.TIMER, dieCounter);
		}
		private function dieCounter(e:TimerEvent):void
		{
			var t:Timer = e.target as Timer;
			switch(t.currentCount) {
				case 1:
					_readyText.text = "Ready!";
					_redGhost.resetPos();
					_tealGhost.resetPos();
					_orangeGhost.resetPos();
					_pinkGhost.resetPos();
					_pacman.reset();
					break;
				case 2:
					_readyText.text = "";
					stage.addEventListener(Event.ENTER_FRAME, update);
					stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
					break;
			}
		}
		public function resetLevel():void
		{
			_gameIsStarted = false;
			_dotManager.reset();
			_pacman.reset();
			Pacman.lives = 3;
			_redGhost.resetPos();
			_tealGhost.resetPos();
			_orangeGhost.resetPos();
			_pinkGhost.resetPos();
			_hud.reset();
			startGame();
		}
		public function addScore(amount:Number):void
		{
			_score += amount;
			if (_score > _highScore)
			{
				_highScore = _score;
				var highscore:SharedObject = SharedObject.getLocal("pacmanHighScore");
				highscore.data.score = _highScore;
			}
			_hud.score = _score;
			_hud.highScore = _highScore;
		}
		public function loseGame():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, update);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			var loseTimer:Timer = new Timer(500, 1);
			loseTimer.start();
			loseTimer.addEventListener(TimerEvent.TIMER, loseCounter);
		}
		private function loseCounter(e:TimerEvent):void
		{
			var t:Timer = e.target as Timer;
			switch(t.currentCount) {
				case 1:
					_score = 0;
					_hud.score = _score;
					resetLevel();
					break;
			}
		}
		public function addFruit():void
		{
			_hud.addFruitPiece();
		}
	}
}