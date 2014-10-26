package game.player 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import game.Game;
	import flash.events.Event;
	import game.hud.Hud;
	import game.manager.DotManager;
	import game.manager.Tile;
	import game.manager.TileManager;
	import game.SoundManager;
	import game.manager.FruitManager;
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class Pacman 
	{
		public static var _pacmanPos:Point;
		public static var lives:int = 3;
		
		private var _moveObject:MovieClip;
		public var player:pacman;
		private var _movement:Array;
		private var _speed:int;
		private var _nextMove:Array;
		private var _firstMove:Array;
		private var _currentTile:Tile;
		
		public function Pacman(x:int,y:int) 
		{
			_pacmanPos = new Point(0, 0);
			_moveObject = new MovieClip();
			player = new pacman();
			_moveObject.addChild(player);
			Game.instance.addChild(_moveObject);
			_moveObject.x = x;
			_moveObject.y = y;
			_movement = [-1, 0];
			_nextMove = [0, 0];
			_firstMove = [0, 0];
			_speed = 2;
			player.gotoAndStop(0);
		}
		public function update():void
		{
			_pacmanPos.x = _moveObject.x;
			_pacmanPos.y = _moveObject.y;
			changeMovement();
			_currentTile = TileManager.getTile(new Point(_moveObject.x, _moveObject.y));
			
			if (_moveObject.x >= 224 + 24)
			{
				_moveObject.x = 0 - 20;
			}else if (_moveObject.x <= 0 - 24)
			{
				_moveObject.x = 224 + 20;
			}
			if (checkFrontTile(_movement[0],_movement[1]))
			{
				_moveObject.x += _movement[0] * _speed;
				_moveObject.y += _movement[1] * _speed;
				changeMovementAnim(_movement[0],_movement[1]);
			} else {
				_moveObject.x = _currentTile.x;
				_moveObject.y = _currentTile.y;
				player.gotoAndStop(0);
				changeMovement();
				_nextMove[0] = 0;
				_nextMove[1] = 0;
			}
		}
		private function changeMovement():void
		{			
			if (_currentTile != null)
			{
				if (_moveObject.x == _currentTile.x && _moveObject.y == _currentTile.y)
				{
					DotManager.hittingDot(_moveObject.x, _moveObject.y);
					FruitManager.hittingFruit(_moveObject.x, _moveObject.y);
					if (_nextMove[0] != 0 || _nextMove[1] != 0) 
					{
						if (_currentTile.id == 2 || checkFrontTile(_nextMove[0],_nextMove[1]))
						{
							_firstMove[0] = _nextMove[0];
							_firstMove[1] = _nextMove[1];
							_nextMove[0] = 0;
							_nextMove[1] = 0;
							changeMovement();
						}
					} 
					else if (_firstMove[0] != 0 || _firstMove[1] != 0)
					{
						if (checkFrontTile(_firstMove[0], _firstMove[1]))
						{
							_movement[0] = _firstMove[0];
							_movement[1] = _firstMove[1];
							_firstMove[0] = 0;
							_firstMove[1] = 0;
						}
					}
				}
			}
		}
		public function movement(xMovement:int, yMovement:int):void
		{
			
			if (checkFrontTile(xMovement,yMovement))
			{
				_firstMove[0] = xMovement;
				_firstMove[1] = yMovement;
			}
			else {
				_nextMove[0] = xMovement;
				_nextMove[1] = yMovement;
			}
		}
		private function changeMovementAnim(xMovement:int, yMovement:int):void
		{
			if (xMovement != 0)
			{
				_moveObject.rotation = 90 * xMovement;
			} else if (yMovement == 1) {
				_moveObject.rotation = 180;
			} else {
				_moveObject.rotation = 0;
			}
			player.gotoAndStop(2);
		}
		public function die():void
		{
			Game.instance.diePauze();
			lives -= 1;
			player.gotoAndStop(3);
			SoundManager.playSound(SoundManager.SOUND_DEATH);
			if (lives == 0)
			{
				Game.instance.loseGame();
			}
		}
		private function checkFrontTile(xMovement:int,yMovement:int):Boolean
		{
			var tileId:int;
			tileId = TileManager.getTileId(new Point(_moveObject.x + (8 * xMovement), _moveObject.y + (8 * yMovement)));
			if (tileId == 1 || tileId == 3)
			{
				return false;
			} else {
				return true;
			}
			return null;
		}
		public static function getPacmanPos():Point
		{
			return new Point(_pacmanPos.x, _pacmanPos.y);
		}
		public function reset():void
		{
			player.gotoAndStop(0);
			_moveObject.x = 108;
			_moveObject.y = 212;
			_nextMove = [0,0];
			_movement = [ -1, 0];
		}
	}
}