package game.manager 
{
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class SuperDot extends Dot
	{
		
		public function SuperDot() 
		{
			_dot.scaleX = 2;
			_dot.scaleY = 2;
			_dot.x -= 4;
			_dot.y -= 4;
			id = 2;
		}
		
	}

}