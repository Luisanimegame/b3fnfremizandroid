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
            addChild(new FlxGame(0, 0, CoryState, true, 144, 144, true));
        else
            addChild(new FlxGame(0, 0, CoryState, true, 144, 144, true));
        #else
        if(preload)
            addChild(new FlxGame(0, 0, Startup, true, 144, 144, true)); // Linha 24 corrigida
        else
            addChild(new FlxGame(0, 0, TitleVidState, true, 144, 144, true)); // Linha 26 corrigida
        #end
            
        fpsDisplay = new FPS(10, 3, 0xFFFFFF);
        fpsDisplay.visible = false;
        addChild(fpsDisplay);
    }
}