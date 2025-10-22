package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import hxcodec.VideoHandler;

class Main extends Sprite
{
    public static var fpsDisplay:FPS;
    public static var video:Bool = true;

    public function new()
    {
        super();

        addChild(new FlxGame(0, 0, TitleVidState, 144, 144, true, true));
        
        fpsDisplay = new FPS(10, 3, 0xFFFFFF);
        fpsDisplay.visible = false;
        addChild(fpsDisplay);
    }
}