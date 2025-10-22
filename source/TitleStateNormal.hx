package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

using StringTools;

class TitleStateNormal extends MusicBeatState
{
	static var initialized:Bool = false;
	static public var soundExt:String = ".ogg";
	public var camOffset:FlxPoint = new FlxPoint();

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	
	var xtween:FlxTween;
	var ytween:FlxTween;

	override public function create():Void
	{
		
		
		#if android FlxG.android.preventDefaultKeys = [BACK]; #end
		
		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		
		super.create();

		
		xtween = FlxTween.tween(FlxG.camera.scroll,{x:0},1);
		ytween = FlxTween.tween(FlxG.camera.scroll,{y:0},1);
		
		FlxG.save.bind('data');

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		KeyBinds.keyCheck();
		PlayerSettings.init();

		if (!initialized){
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;
		}

		startIntro();
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		Conductor.changeBPM(102);
		persistentUpdate = true;

		/*var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);*/

		//logoBl = new FlxSprite(-150, -100);
		//logoBl.frames = FlxAtlasFrames.fromSparrow('assets/images/logoBumpin.png', 'assets/images/logoBumpin.xml');
		//logoBl.antialiasing = true;
		//logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		//logoBl.animation.play('bump');
		//logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		var bgGrad:FlxSprite = new FlxSprite().loadGraphic('assets/images/titleBG.png');
		bgGrad.antialiasing = true;
		bgGrad.updateHitbox();

		gfDance = new FlxSprite(-50, -30);
		gfDance.frames = FlxAtlasFrames.fromSparrow('assets/images/Start_Screen_Assets.png', 'assets/images/Start_Screen_Assets.xml');
		gfDance.animation.addByIndices('danceLeft', 'Start Screen BG art', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'Start Screen BG art', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		//add(bgGrad);
		add(gfDance);
		//add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = FlxAtlasFrames.fromSparrow('assets/images/titleEnter.png', 'assets/images/titleEnter.xml');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.scrollFactor.set(1.3, 1.3);
		// titleText.screenCenter(X);
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic('assets/images/newgrounds_logo.png');
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else{
			initialized = true;
			var ttt = "";
			#if CORY
			ttt = "Cory";
			#end
			
			
			FlxG.sound.playMusic('assets/music/freakyMenu'+ttt + TitleState.soundExt, 0.8);
		}
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText('assets/data/introText.txt');

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (initialized){
			//if (controls.LEFT) camOffset.x = -80;//FlxTween.tween(FlxG.camera.scroll, {x:-80}, 0.4,{ease:FlxEase.sineInOut});
			//if (controls.RIGHT) camOffset.x = 80;//FlxTween.tween(FlxG.camera.scroll, {x:80}, 0.4,{ease:FlxEase.sineInOut});
			//if (controls.UP) camOffset.y = -80;//FlxTween.tween(FlxG.camera.scroll, {y:-80}, 0.4,{ease:FlxEase.sineInOut});
			//if (controls.DOWN) camOffset.y = 80; //FlxTween.tween(FlxG.camera.scroll, {y:80}, 0.4, {ease:FlxEase.sineInOut});
			
			if (controls.LEFT_P){
				xtween.cancel();
				xtween = FlxTween.tween(FlxG.camera.scroll, {x:-80}, 0.4,{ease:FlxEase.sineInOut});
			}
			if (controls.RIGHT_P){
				xtween.cancel();
				xtween = FlxTween.tween(FlxG.camera.scroll, {x:80}, 0.4,{ease:FlxEase.sineInOut});
			}
			if (controls.UP_P){
				ytween.cancel();
				ytween = FlxTween.tween(FlxG.camera.scroll, {y:-80}, 0.4,{ease:FlxEase.sineInOut});
			}
			if (controls.DOWN_P){
				ytween.cancel();
				ytween = FlxTween.tween(FlxG.camera.scroll, {y:80}, 0.4, {ease:FlxEase.sineInOut});
			}
			
			if (controls.LEFT_R){
				xtween.cancel();
				xtween = FlxTween.tween(FlxG.camera.scroll, {x:0}, 0.4,{ease:FlxEase.sineInOut});
			}
			if (controls.RIGHT_R){
				xtween.cancel();
				xtween = FlxTween.tween(FlxG.camera.scroll, {x:0}, 0.4,{ease:FlxEase.sineInOut});
			}
			if (controls.UP_R){
				ytween.cancel();
				ytween = FlxTween.tween(FlxG.camera.scroll, {y:0}, 0.4,{ease:FlxEase.sineInOut});
			}
			if (controls.DOWN_R){
				ytween.cancel();
				ytween = FlxTween.tween(FlxG.camera.scroll, {y:0}, 0.4,{ease:FlxEase.sineInOut});
			}
			
			//if (controls.LEFT_R)camOffset.x = 0;//FlxTween.tween(FlxG.camera.scroll, {x:0}, 0.4,{ease:FlxEase.sineInOut});
			//if (controls.RIGHT_R)camOffset.x = 0;//FlxTween.tween(FlxG.camera.scroll, {x:0}, 0.4,{ease:FlxEase.sineInOut});
			//if (controls.UP_R)camOffset.y = 0;//FlxTween.tween(FlxG.camera.scroll, {y:0}, 0.4,{ease:FlxEase.sineInOut});
			//if (controls.DOWN_R)camOffset.y = 0;//FlxTween.tween(FlxG.camera.scroll, {y:0}, 0.4,{ease:FlxEase.sineInOut});
			
			//FlxG.camera.scroll.x += camOffset.x - FlxG.camera.scroll.x / 20;
			//FlxG.camera.scroll.y += camOffset.y - FlxG.camera.scroll.y / 20;
			
			Conductor.songPosition = FlxG.sound.music.time;
			// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

			if (FlxG.keys.justPressed.F)
			{
				FlxG.fullscreen = !FlxG.fullscreen;
			}

			var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.START)
					pressedEnter = true;
					
				

				#if switch
				if (gamepad.justPressed.B)
					pressedEnter = true;
				#end
			}
			
			#if mobile
	        var jusTouched:Bool = false;
	
	        for (touch in FlxG.touches.list)
	          if (touch.justPressed)
	            jusTouched = true;
	        #end

			
			
			
			if (pressedEnter #if mobile || jusTouched #end && !transitioning && skippedIntro)
			{
				titleText.animation.play('press');

				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt, 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					// Check if version is outdated
					FlxG.switchState(new MainMenuState());
				});
				// FlxG.sound.play('assets/music/titleShoot' + TitleState.soundExt, 0.7);
			}

			if (pressedEnter #if mobile || jusTouched #end && !skippedIntro)
			{
				skipIntro();
			}
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	

	override function beatHit()
	{
		super.beatHit();
		FlxG.camera.zoom = 1.05;
		titleText.scale.x = titleText.scale.y = 1.06;
		FlxTween.tween(FlxG.camera, {zoom:1}, 0.4);
		FlxTween.tween(titleText.scale, {x:1,y:1}, 0.4);

		//logoBl.animation.play('bump', true);
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight', true);
		else
			gfDance.animation.play('danceLeft', true);

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['STUDIO BREAKBEAT']);
			case 3:
				deleteCoolText();
				addMoreText('present');
			case 5:
				deleteCoolText();
				addMoreText('Created');
			case 6:
				addMoreText('by');
			case 7:
				addMoreText('BiddleZ');
				ngSpr.visible = true;
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			case 9:
				createCoolText([curWacky[0]]);
			case 11:
				addMoreText(curWacky[1]);
			case 12:
				deleteCoolText();
				addMoreText('Friday');
			case 13:
				addMoreText('Night');
			case 14:
				addMoreText('Funkin');
			case 15:
				addMoreText('BZ REMIXED');
			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			PlayerSettings.player1.controls.loadKeyBinds();
			Config.configCheck();
			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
