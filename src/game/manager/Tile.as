package game.manager 
{
	
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class Tile extends Sprite
	{
		public var id:int;
		public function Tile() 
		{
			
			graphics.lineStyle(1,0x66FF00);
			//graphics.beginFill(0x00000)
			graphics.moveTo(-4, -4);
			graphics.lineTo(4, -4);
			graphics.lineTo(4, 4);
			graphics.lineTo(-4, 4);
			graphics.lineTo(-4, -4);
			this.visible = false;
			this.width = 8;
			this.height = 8;
		}
		
		public function changeColor():void
		{
			var my_color:ColorTransform = new ColorTransform();
			if (id == 1)
			{
				my_color.color = 0xFFFFFF;
			}else if(id == 2) {
				my_color.color = 0xFF6600;
			} else if(id == 3) {
				my_color.color = 0x66FFFF;
			} else {
				my_color.color = 0x66FF00;
			}
			this.transform.colorTransform = my_color;
		}
		
	}
}