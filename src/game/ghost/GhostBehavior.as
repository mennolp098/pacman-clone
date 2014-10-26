package game.ghost 
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import game.manager.Tile;
	import game.manager.TileManager;
	import game.Game;
	import game.player.Pacman;
	import flash.utils.Timer;
	import game.SoundManager;
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class GhostBehavior extends Sprite
	{
		public var ghost:MovieClip;
		private var _movement:Array;
		private var _openTiles:Array;
		private var _speed:int = 2;
		private var _currentOppositeDirectionX:int;
		private var _currentOppositeDirectionY:int;
		private var _currentOppositeDirection:int;
		private var _currentTile:Tile;
		private var _oldMoveTile:Tile;
		private var _standingInMiddle:Boolean;
		private var _isFollowing:Boolean;
		private var _isInCage:Boolean;
		private var _movingToNewPoint:Boolean;
		private var _moveTimer:Timer;
		private var _justOutCage:Boolean;
		public var dieAble:Boolean;
		private var _cagePos:Point;
		public static var allTexts:Array;
		private var _scareTimer:Timer = new Timer(10000, 1);
		public function GhostBehavior(x:int, y:int, ghostMovieclip:Class, inCage:Boolean, movement:Array, waitTime:Number ) 
		{
			ghost = new ghostMovieclip();
			allTexts = [];
			Game.instance.addChild(ghost);
			ghost.x = x;
			ghost.y = y;
			_cagePos = new Point(x, y);
			_openTiles = [false, false, false, false];
			_movement = movement;
			_currentOppositeDirectionY = 0;
			_currentOppositeDirectionX = 0;
			_isFollowing = false;
			_isInCage = inCage;
			
			_moveTimer = new Timer(waitTime * 1000, 1);
			
		}
		public function update():void
		{
			_currentTile = TileManager.getTile(new Point(ghost.x, ghost.y));
			if (_isFollowing && _currentTile != null)
			{
				followMode();
			} else if(!_isInCage) {
				floatAroundStage();
			} else {
				cageMovement();
				_moveTimer.start();
			}
			
			ghost.x += _movement[0] * _speed;
			ghost.y += _movement[1] * _speed;
			if (!dieAble)
			{
				ghost.gotoAndStop(_currentOppositeDirection + 1);
			} else {
				ghost.gotoAndStop(_currentOppositeDirection + 5);
			}
			
			if (ghost.x >= 224 + 24)
			{
				ghost.x = 0 - 20;
			}else if (ghost.x <= 0 - 24)
			{
				ghost.x = 224 + 20;
			}
			if (_moveTimer.currentCount == 1)
			{
				goOutCage();
				_moveTimer.stop();
				_moveTimer.reset();
			}
			if (ghost.y == 116 && _justOutCage)
			{
				_movement = [1, 0];
				_justOutCage = false;
			}
			var textLenth:Number = allTexts.length;
			for (var i:int = textLenth - 1; i >= 0; i--)
			{
				allTexts[i].y -= 0.1;
			}
		}
		public function die():void
		{
			SoundManager.playSound(SoundManager.SOUND_EATGHOST);
			splashScore(ghost.x, ghost.y);
			Game.instance.addScore(300);
			resetPos();
			
		}
		public static function splashScore(x:Number, y:Number):void
		{
			var text:TextField = new TextField();
			var tf:TextFormat = new TextFormat("PressStart", 6, 0xffffff);
			text.defaultTextFormat = tf;
			Game.instance.addChild(text);
			text.x = x;
			text.y = y;
			text.text = "300";
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
		private function cageMovement():void
		{
			_movement[0] = 0;
			if (_movement[1] == 0)
			{
				_movement[1] = 1;
			}
			if (ghost.y >= 148)
			{
				_movement[1] = -1;
			} else if (ghost.y <= 132)
			{
				_movement[1] = 1;
			}
		}
		private function goOutCage():void
		{
			ghost.x = 116;
			_movement = [0, -1]
			_isInCage = false;
			_justOutCage = true;
		}
		private function floatAroundStage():void
		{
			if (_currentTile != null)
			{
				if (ghost.x == _currentTile.x && ghost.y == _currentTile.y)
				{
					if (!checkTile(_movement[0], _movement[1]) || TileManager.getTileId(new Point(ghost.x,ghost.y)) == 2 && _currentTile != _oldMoveTile)
					{
						checkSurrounding();
					}
				}
			} 
		}
		private function moveToNewPoint():void
		{
			var startMoving:Boolean = false;
			var random:int = Math.random() * 4;
			
			while (random == _currentOppositeDirection && !_openTiles[random])
			{
				random = Math.random() * 4;
			}
			
			if (_openTiles[random] && !startMoving)
			{
				switch(random) 
				{
				case 0:
					move( -1, 0);
					_currentOppositeDirection = 2;
					break;
				case 1:
					move(0, -1);
					_currentOppositeDirection = 3;
					break;
				case 2:
					move(1, 0);
					_currentOppositeDirection = 0;
					break;
				case 3:
					move(0, 1);
					_currentOppositeDirection = 1;
					break;
				}
				startMoving = true;
			} else {
				moveToNewPoint();
			}
		}
		private function checkTile(xMovement:int,yMovement:int):Boolean
		{
			var tileId:int;
			tileId = TileManager.getTileId(new Point(ghost.x + (8 * xMovement), ghost.y + (8 * yMovement)));
			if (tileId != 1)
			{
				return true;
			} else {
				return false;
			}
			return null;
		}
		private function checkSurrounding():void
		{
			_oldMoveTile = _currentTile;
			var tiles:Array = [];
			for (var i:int = 4 - 1; i >= 0; i--)
			{
				switch(i) {
					case 0:
						tiles[0] = TileManager.getTileId(new Point(ghost.x - 8, ghost.y));
						break;
					case 1:
						tiles[1] = TileManager.getTileId(new Point(ghost.x,ghost.y - 8));
						break;
					case 2:
						tiles[2] = TileManager.getTileId(new Point(ghost.x + 8,ghost.y));
						break;
					case 3:
						tiles[3] = TileManager.getTileId(new Point(ghost.x, ghost.y + 8));
						break;
				}
				if (tiles[i] == 0)
				{
					_openTiles[i] = true;
				} else {
					_openTiles[i] = false;
				}
				_openTiles[_currentOppositeDirection] = false;
			}
			moveToNewPoint();
		}
		private function followMode():void
		{
			if (_currentTile.id == 2 && _currentTile != _oldMoveTile)
			{
				changeDirection(Pacman.getPacmanPos());
				_movingToNewPoint = false;
			}
		}
		private function changeDirection(target:Point):void
		{
			var difX:int = target.x - ghost.x;
			var difY:int = target.y - ghost.y;
			var newMovement:Point = new Point(0, 0);
			if (!_movingToNewPoint)
			{
				if (ghost.x != target.x || ghost.y != target.y)
				{
					if (difX != 0)
					{
						newMovement.x = Math.abs(difX) / difX;
					}
					if (difY != 0)
					{
						newMovement.y = Math.abs(difY) / difY;
					}
					if (_currentTile.x == ghost.x && _currentTile.y == ghost.y)
					{
						if (checkTile(newMovement.x, 0) && difX != 0 && _currentOppositeDirectionX == newMovement.x)
						{
							_movement[0] = newMovement.x;
							_movement[1] = 0;
						} else if (checkTile(0, newMovement.y) && difY != 0 && _currentOppositeDirectionY == newMovement.y) {
							_movement[0] = 0;
							_movement[1] = newMovement.y;
						} else if (_currentTile.id == 2) 
						{
							checkSurrounding();
							_movingToNewPoint = true;
						}
					}
				}
			}
		}
		private function move(movementX:int,movementY:int):void
		{
			_movement[0] = movementX;
			_movement[1] = movementY;
			_currentOppositeDirectionX = movementX * -1;
			_currentOppositeDirectionY = movementY * -1;
		}
		public function beScared():void
		{
			if (!_isInCage)
			{
				dieAble = true;
				_scareTimer.reset();
				_scareTimer.start();
				_scareTimer.addEventListener(TimerEvent.TIMER, stopBeingScared);
			}
		}
		private function stopBeingScared(e:TimerEvent):void
		{
			var t:Timer = e.target as Timer;
			switch(t.currentCount) {
				case 1:
					dieAble = false;
					break;
			}
		}
		public function resetPos():void
		{
			ghost.x = _cagePos.x;
			ghost.y = _cagePos.y;
			_justOutCage = false;
			_isInCage = true;
			dieAble = false;
			_moveTimer.reset();
			_moveTimer.start();
		}
	}
}