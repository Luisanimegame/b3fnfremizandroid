package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import hxcodec.VideoHandler;

class Main extends Sprite
{
	public static var fpsDisplay:FPS;
	public static var preload:Bool = !Sys.args().contains("-nopreload");

	public function new()
	{
		super();

		#if CORY
		if(preload)
			addChild(new FlxGame(0, 0, CoryState, 1, 144, 144, true));
		else
			addChild(new FlxGame(0, 0, CoryState, 1, 144, 144, true));
		#else
		if(preload)
			addChild(new FlxGame(0, 0, Startup, 1, 144, 144, true));
		else
			addChild(new FlxGame(0, 0, TitleVidState, 1, 144, 144, true));
		#end
			
		fpsDisplay = new FPS(10, 3, 0xFFFFFF);
		fpsDisplay.visible = false;
		addChild(fpsDisplay);
		}

	}
}
