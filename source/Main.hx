package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import hxcodec.VideoHandler;

class Main extends Sprite
{
    public static var fpsDisplay:FPS;
    public static var preload:Bool = !Sys.args().contains("-nopreload");
    public static var video:Bool = true; // Nova variável para controlar vídeos

    public function new()
    {
        super();

        #if CORY
        if(preload)
            addChild(new FlxGame(0, 0, CoryState, 144, 144, true, true));
        else
            addChild(new FlxGame(0, 0, CoryState, 144, 144, true, true));
        #else
        if(preload)
            addChild(new FlxGame(0, 0, Startup, 144, 144, true, true));
        else
            addChild(new FlxGame(0, 0, TitleVidState, 144, 144, true, true));
        #end
            
        fpsDisplay = new FPS(10, 3, 0xFFFFFF);
        fpsDisplay.visible = false;
        addChild(fpsDisplay);
    }
}