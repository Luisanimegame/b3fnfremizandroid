package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import lime.utils.Assets;
import flixel.math.FlxMath;
import flixel.text.FlxText;

using StringTools;

class ConfigMenu extends MusicBeatState
{

	public static var startSong = true;

	var configText:FlxText;
	var descText:FlxText;
	var configSelected:Int = 0;
	
	var offsetValue:Float;
	var accuracyType:String;
	var accuracyTypeInt:Int;
	var accuracyTypes:Array<String> = ["none", "simple", "complex"];
	var healthValue:Int;
	var healthDrainValue:Int;
	var iconValue:Bool;
	var downValue:Bool;
	var inputValue:Bool;
	var glowValue:Bool;
	var randomTapValue:Bool;
	var noCapValue:Bool;
	var introVal:Bool;
	
	var canChangeItems:Bool = true;

	var leftRightCount:Int = 0;
	
	var settingText:Array<String> = [
									"NOTE OFFSET", 
									"ACCURACY DISPLAY", 
									"UNCAP FRAMERATE",
									"NEW INPUT",
									"ALLOW GHOST TAPPING",
									"DOWNSCROLL",
									"NOTE GLOW",
									"IMPROVED HEALTH HEADS",
									"[EDIT KEY BINDS]",
									];
								
	var settingDesc:Array<String> = [
									"Adjust note timings.\nPress \"ENTER\" to start the offset calibration." + (FlxG.save.data.ee1?"\nHold \"SHIFT\" to force the pixel calibration.\nHold \"CTRL\" to force the normal calibration.":""), 
									"What type of accuracy calculation you want to use. Simple is just notes hit / total notes. Complex also factors in how early or late a note was.", 
									"Uncaps the framerate during gameplay.",
									"Use the FPS Plus input system.",
									"Prevents you from missing when you don't need to play.",
									"Makes notes appear from the top instead the bottom.",
									"Makes note arrows glow if they are able to be hit.\n[This disables modded note arrows unless there is a version of the files included in the mod.]",
									"Adds low health icons for characters missing them and adds winning icons.\n[This disables modded health icons unless there is a version of the files included in the mod.]",
									"Change key binds.",
									];


	override function create()
	{	
	
		if(startSong)
			FlxG.sound.playMusic('assets/music/configurator' + TitleState.soundExt);
		else
			startSong = true;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuDesat.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.18));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xFF5C6CA5;
		add(bg);
	
		// var magenta = new FlxSprite(-80).loadGraphic('assets/images/menuBGMagenta.png');
		// magenta.scrollFactor.x = 0;
		// magenta.scrollFactor.y = 0;
		// magenta.setGraphicSize(Std.int(magenta.width * 1.18));
		// magenta.updateHitbox();
		// magenta.screenCenter();
		// magenta.visible = false;
		// magenta.antialiasing = true;
		// add(magenta);
		// magenta.scrollFactor.set();
		
		Config.reload();
		
		offsetValue = Config.offset;
		accuracyType = Config.accuracy;
		accuracyTypeInt = accuracyTypes.indexOf(Config.accuracy);
		healthValue = Std.int(Config.healthMultiplier * 10);
		healthDrainValue = Std.int(Config.healthDrainMultiplier * 10);
		iconValue = Config.betterIcons;
		downValue = Config.downscroll;
		inputValue = Config.newInput;
		glowValue = Config.noteGlow;
		randomTapValue = Config.noRandomTap;
		noCapValue = Config.noFpsCap;
		introVal = Config.introVal;
		
		var tex = FlxAtlasFrames.fromSparrow('assets/images/FNF_main_menu_assets.png', 'assets/images/FNF_main_menu_assets.xml');
		var optionTitle:FlxSprite = new FlxSprite(0, 55);
		optionTitle.frames = tex;
		optionTitle.animation.addByPrefix('selected', "options white", 24);
		optionTitle.animation.play('selected');
		optionTitle.scrollFactor.set();
		optionTitle.antialiasing = true;
		optionTitle.updateHitbox();
		optionTitle.screenCenter(X);
			
		add(optionTitle);
			
		
		configText = new FlxText(0, 215, 1280, "", 48);
		configText.scrollFactor.set(0, 0);
		configText.setFormat("assets/fonts/Funkin-Bold.otf", 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		configText.borderSize = 3;
		configText.borderQuality = 1;
		
		descText = new FlxText(320, 635, 640, "", 20);
		descText.scrollFactor.set(0, 0);
		descText.setFormat("assets/fonts/vcr.ttf", 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//descText.borderSize = 3;
		descText.borderQuality = 1;

		add(configText);
		add(descText);

		textUpdate();
		
		#if mobile addVPad(FULL, A_B_C); #end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{

		
	
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(canChangeItems){
			if (controls.UP_P)
				{
					FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
					changeItem(-1);
				}

				if (controls.DOWN_P)
				{
					FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
					changeItem(1);
				}
				
				#if mobile
				if (vPad.buttonC.justPressed)
				    FlxG.switchState(new mobile.CustomControlsState());
				#end
				
				switch(configSelected){
					case 0: //Offset
						if (controls.RIGHT_P)
						{
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							offsetValue += 1;
						}
						
						if (controls.LEFT_P)
						{
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							offsetValue -= 1;
						}
						
						if (controls.RIGHT)
						{
							leftRightCount++;
							
							if(leftRightCount > 64) {
								offsetValue += 1;
								textUpdate();
							}
						}
						
						if (controls.LEFT)
						{
							leftRightCount++;
							
							if(leftRightCount > 64) {
								offsetValue -= 1;
								textUpdate();
							}
						}
						
						if(!controls.RIGHT && !controls.LEFT)
						{
							leftRightCount = 0;
						}

						if(FlxG.keys.justPressed.ENTER){
							canChangeItems = false;
							FlxG.sound.music.fadeOut(0.3);
							Config.write(offsetValue, accuracyType, healthValue / 10.0, healthDrainValue / 10.0, iconValue, downValue, inputValue, glowValue, randomTapValue, noCapValue,introVal);
							AutoOffsetState.forceEasterEgg = FlxG.keys.pressed.SHIFT ? 1 : (FlxG.keys.pressed.CONTROL ? -1 : 0);
							FlxG.switchState(new AutoOffsetState());
						}
						
					case 1: //Accuracy
						if (controls.RIGHT_P)
							{
								FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
								accuracyTypeInt += 1;
							}
							
							if (controls.LEFT_P)
							{
								FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
								accuracyTypeInt -= 1;
							}
							
							if (accuracyTypeInt > 2)
								accuracyTypeInt = 0;
							if (accuracyTypeInt < 0)
								accuracyTypeInt = 2;
								
							accuracyType = accuracyTypes[accuracyTypeInt];
					case 2: //FPS Cap
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							noCapValue = !noCapValue;
						}
					case 3: //Miss Stun
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							inputValue = !inputValue;
						}
					case 4: //Random Tap 
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							randomTapValue = !randomTapValue;
						}
					case 5: //Downscroll
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							downValue = !downValue;
						}
					case 6: //Note Glow
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							glowValue = !glowValue;
						}
					case 7: //Heads
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							iconValue = !iconValue;
						}
					case 8: //Binds
						if (controls.ACCEPT) {
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							canChangeItems = false;
							Config.write(offsetValue, accuracyType, healthValue / 10.0, healthDrainValue / 10.0, iconValue, downValue, inputValue, glowValue, randomTapValue, noCapValue,introVal);
							FlxG.switchState(new KeyBindMenu());
						}
					case 9: //Binds
						
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
							introVal = !introVal;
						}
					
			}
		}

		if (controls.BACK)
		{
			Config.write(offsetValue, accuracyType, healthValue / 10.0, healthDrainValue / 10.0, iconValue, downValue, inputValue, glowValue, randomTapValue, noCapValue,introVal);
			canChangeItems = false;
			FlxG.sound.music.stop();
			FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.BACKSPACE)
		{
			Config.resetSettings();
			FlxG.save.data.ee1 = false;

			canChangeItems = false;

			FlxG.sound.music.stop();
			FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);

			FlxG.switchState(new MainMenuState());
		}

		#if debug
		if (FlxG.keys.justPressed.Q)
		{
			canChangeItems = false;
			Config.write(offsetValue, accuracyType, healthValue / 10.0, healthDrainValue / 10.0, iconValue, downValue, inputValue, glowValue, randomTapValue, noCapValue,introVal);
			FlxG.switchState(new KeyBindQuick());
		}
		#end

		super.update(elapsed);
		
		if(FlxG.keys.justPressed.ANY)
			textUpdate();
		
	}

	function changeItem(huh:Int = 0)
	{
		configSelected += huh;
			
		if (configSelected < 0)
			configSelected = settingText.length - 1;
		if (configSelected >= settingText.length)
			configSelected = 0;
	}

	function textUpdate(){

        configText.text = "";

        for(i in 0...settingText.length - 1){

            var textStart = (i == configSelected) ? ">" : "  ";
            configText.text += textStart + settingText[i] + ": " + getSetting(i) + "\n";

        }

		var textStart = (configSelected == settingText.length - 1) ? ">" : "  ";
		configText.text += textStart + settingText[settingText.length - 1] +  "\n";

		descText.text = settingDesc[configSelected];

    }

	function getSetting(r:Int):Dynamic{

		switch(r){

			case 0: return offsetValue;
			case 1: return accuracyType;
			case 2: return noCapValue;
			case 3: return inputValue;
			case 4: return randomTapValue;
			case 5: return downValue;
			case 6: return glowValue;
			case 7: return iconValue;

		}

		return -1;

	}

}
