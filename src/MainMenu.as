package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class MainMenu extends Sprite
	{
		private var introMovieclip:intro;
		private var myStartButton:StartButton;
		private var myControlsButton:ControlsButton;
		private var myBackButton:BackButton;
		private var controls:Controls;
		public function MainMenu() 
		{
			introMovieclip = new intro();
			myStartButton = new StartButton();
			myControlsButton = new ControlsButton();
			myBackButton = new BackButton();
			controls = new Controls();
			
			myStartButton.x = 112;
			myStartButton.y = 150;
			myControlsButton.x = 112;
			myControlsButton.y = 200;
			myBackButton.x = 112;
			myBackButton.y = 200;
			controls.x = 112;
			controls.y = 100;
			
			addChild(myStartButton);
			addChild(myControlsButton);
			addChild(myBackButton);
			addChild(controls);
			
			myStartButton.visible = false;
			myControlsButton.visible = false;
			controls.visible = false;
			myBackButton.visible = false;
			
			addChild(introMovieclip);
			introMovieclip.y = 50;
			introMovieclip.x = -125;
			
			var buttonsHolder:MovieClip = new MovieClip();
			buttonsHolder.addChild(myStartButton);
			buttonsHolder.addChild(myControlsButton);
			buttonsHolder.addChild(myBackButton);
			addChild(buttonsHolder);
			buttonsHolder.addEventListener(MouseEvent.CLICK, onClick);
			setTimeout(stopIntro,3500);
		}
		private function stopIntro():void
		{
			myStartButton.visible = true;
			myControlsButton.visible = true;
			introMovieclip.stop();
		}
		private function onClick(e:MouseEvent):void
		{
			if (e.target == myStartButton)
			{
				this.visible = false;
				dispatchEvent(new Event("startgame"));
			}
			else if (e.target == myControlsButton)
			{
				myControlsButton.visible = false;
				myStartButton.visible = false;
				controls.visible = true;
				myBackButton.visible = true;
				
			} 
			else if (e.target == myBackButton)
			{
				myControlsButton.visible = true;
				myStartButton.visible = true;
				controls.visible = false;
				myBackButton.visible = false;
			}
		}
		
	}

}