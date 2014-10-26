package game 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Menno Jongejan
	 */
	public class SoundManager 
	{
		public static const SOUND_BEGIN			: String	=	"soundBegin";
		public static const SOUND_CHOMP 		: String	=	"soundChomp";
		public static const SOUND_DEATH 		: String	=	"soundDeath";
		public static const SOUND_EATGHOST 		: String 	=	"soundEatGhost";
		public static const SOUND_INTERMISSION 	: String 	= 	"soundIntermission";
		public static const SOUND_EATFRUIT	 	: String 	= 	"soundEatFruit";
		
		public static var soundChannel:SoundChannel;
		public static var chompSoundChannel:SoundChannel;
		private var _sirenSoundChannel:SoundChannel;
		
		public function SoundManager() 
		{
			soundChannel = new SoundChannel();
			chompSoundChannel = new SoundChannel();
			_sirenSoundChannel = new SoundChannel();
			var sf:SoundTransform = new SoundTransform(0, 0);
			var soundToPlay:Sound;
			var chompReq:URLRequest = new URLRequest("sounds/pacman_chomp.mp3");
			soundToPlay = new Sound(chompReq);
			chompSoundChannel = soundToPlay.play();
			chompSoundChannel.soundTransform = sf;
			var sirenReq:URLRequest = new URLRequest("sounds/Pacman_Siren.mp3");
			var sirenSound:Sound = new Sound(sirenReq);
			_sirenSoundChannel = sirenSound.play();
			_sirenSoundChannel.soundTransform = sf;
		}
		public function update():void
		{
			var soundPos:Number = _sirenSoundChannel.position;
			if (soundPos > 1400)
			{
				_sirenSoundChannel.stop();
				var sf:SoundTransform = new SoundTransform(1, 0);
				var sirenReq:URLRequest = new URLRequest("sounds/Pacman_Siren.mp3");
				var sirenSound:Sound = new Sound(sirenReq);
				_sirenSoundChannel = sirenSound.play();
				_sirenSoundChannel.soundTransform = sf;
			}
		}
		public static function playSound(sound:String):void
		{
			var soundToPlay:Sound;
			var beginReq:URLRequest = new URLRequest("sounds/pacman_beginning.mp3"); 
			var chompReq:URLRequest = new URLRequest("sounds/pacman_chomp.mp3");
			var deathReq:URLRequest = new URLRequest("sounds/pacman_death.mp3");
			var eatghostReq:URLRequest = new URLRequest("sounds/pacman_eatghost.mp3");
			var intermissionReq:URLRequest = new URLRequest("sounds/pacman_intermission.mp3");
			var eatfruitReq:URLRequest = new URLRequest("sounds/pacman_eatfruit.mp3");
			
			if (sound == SOUND_BEGIN)
			{
				soundToPlay = new Sound(beginReq);
			} 
			else if (sound == SOUND_DEATH)
			{
				soundToPlay = new Sound(deathReq);
			}
			else if (sound == SOUND_EATFRUIT)
			{
				soundToPlay = new Sound(eatfruitReq);
			}
			else if (sound == SOUND_EATGHOST)
			{
				soundToPlay = new Sound(eatghostReq);
			}
			else if (sound == SOUND_INTERMISSION)
			{
				soundToPlay = new Sound(intermissionReq);
			}
			if (sound != SOUND_CHOMP)
			{
				soundChannel = soundToPlay.play();
			} else if (chompSoundChannel.position > 25) {
				var sf:SoundTransform = new SoundTransform(1, 0);
				chompSoundChannel.soundTransform = sf;
				soundToPlay = new Sound(chompReq);
				chompSoundChannel = soundToPlay.play();
			}
		}
	}
}