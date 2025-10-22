package;

import flixel.FlxGame;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.display.BitmapData;
import openfl.media.Sound;
import sys.io.File;
import sys.io.Process;




using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	static inline final GF_DEFAULT = 'gf default';

	var box:FlxSprite;
	var skipText:FlxText;
	var curCharacter:String = '';

	var curAnim:String = '';
	var prevChar:String = '';
	var preText:String = '';
	
	var wasHidden:Bool = true;

	var effectQue:Array<String> = [""];
	var effectParamQue:Array<String> = [""];

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	
	var textShake:Float = 0;
	var boxShake:Float = 0;
	var bgShake:Float = 0;
	var textSpeed:Float = 0.04;
	
	var arrow:FlxSprite;

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???/
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;
	//Cutscene shit, HAS TO LOAD ON EVERY STAGE IDIOT
	var cutsceneImage:FlxSprite;
	var sound:FlxSound;
	#if CORY
	var censored = true;
	#else
	var censored = false;
	#end
	

	public var finishThing:Void->Void;
	public var portraitList:Array<String> = [];
	public var portraitNameList:Array<String> = [];
	public var portraits:Array<Portrait> = [];

	
	var portraitBF:Portrait;
	var portraitGF:Portrait;
	var portraitDAD:Portrait;
	var portraitSPOOKY:Portrait;
	var portraitMONSTER:Portrait;
	var portraitPICO:Portrait;
	var portraitDARNELL:Portrait;
	var portraitNENE:Portrait;
	var portraitMOM:Portrait;
	var portraitIMPS:Portrait;
	var portraitNOCHAR:Portrait;
	var portraitPINKIE:Portrait;
	

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	
	//var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var blackBG:FlxSprite;

	
	var canAdvance = false;
	var canSkip = true;
	var inAutoText:Bool = false;
	
	var timeBeforeSkip:FlxTimer;
	
	
	var cusswords:Array<Array<String>> = [
	["fuck","f***"],
	["Fuck","F***"],
	["FUCK", "F***"],
	
	["shit","s***"],
	["Shit","S***"],
	["SHIT","S***"],
	
	["bitch","b***"],
	["Bitch","B***"],
	["BITCH","B***"]
	
	];
	
	

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		

		timeBeforeSkip = new FlxTimer();
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
				canAdvance = true;
		});

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				//FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				//FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				//FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				//FlxG.sound.music.fadeIn(1, 0, 0.8);
		
		}
		blackBG = new FlxSprite(-256, -256).makeGraphic(FlxG.width * 2, FlxG.height * 2);
		//add(blackBG);
	
		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFF381D6B);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		bgFade.blend = "multiply";
		add(bgFade);

		cutsceneImage = new FlxSprite(0, 0);
		cutsceneImage.visible = false;
		add(cutsceneImage);	
		
		
		var bgg:FlxSprite = new FlxSprite( -175.8, -124.2).loadGraphic("assets/images/dialoguecheckerboard.png");
		FlxTween.tween(bgg, {x:0, y:0}, 2, {type:LOOPING});
		add(bgg);

		//if (PlayState.SONG.song.toLowerCase() == 'tutorial')
		//bgFade.visible = false;

		FlxTween.tween(bgFade, {alpha: 1}, 1, {ease: FlxEase.circOut});

		box = new FlxSprite(-20, 45);
		//REPOSITIONING, NEW ANIMATIONS AND MUSIC SHIT IDIOTS
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			
			default:
				hasDialog = true;
				//box.frames = FlxAtlasFrames.fromSparrow('assets/images/speech_bubble_talking.png','assets/images/speech_bubble_talking.xml');
				box.loadGraphic("assets/images/dialogueui.png", true,1280,720);
				box.animation.add('normalOpen',[0], 24, false);
				box.animation.add('normal', [0], 24);
				box.y = 0;
				box.x = 0;
				arrow = new FlxSprite(1198.85, 606.45);
				arrow.frames = FlxAtlasFrames.fromSparrow('assets/images/diawait.png', 'assets/images/diawait.xml');
				arrow.animation.addByIndices("wait", "wait", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "");
				arrow.animation.addByIndices("go", "wait", [20, 21, 22, 23], "", 24,false);
				//trace("loaded "+)
				/*
			case 'senpai':
				hasDialog = true;
				box.frames = FlxAtlasFrames.fromSparrow('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(('assets/sounds/ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);*/
		}

		
		
		
		this.dialogueList = dialogueList;

		if (censored){
			trace("censoring");
			censorTheShit();
		}
		
		if (!hasDialog)
			return;
		if (PlayState.SONG.song.toLowerCase() == 'senpai'
			|| PlayState.SONG.song.toLowerCase() == 'roses'
			|| PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpaiPortrait.png', 'assets/images/weeb/senpaiPortrait.xml');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPortrait.png', 'assets/images/weeb/bfPortrait.xml');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		}
		else
		{
			portraitList = CoolUtil.coolTextFile("assets/dialogue/portraitList.txt");
			for (i in portraitList){
				var shit:Array<String> = i.split(" ");
				trace(shit);
				var name = shit[0];
				var xx = Std.parseInt(shit[1]);
				var yy = Std.parseInt(shit[2]);
				var p:Portrait = new Portrait(xx, yy, name);
				
				portraits.push(p);
				portraitNameList.push(shit[0]);
				
				add(p);
				
			}
/*
			portraitBF = new Portrait(170, 15, "bf");
			add(portraitBF);

			portraitGF = new Portrait(170, 50, "gf");
			add(portraitGF);
			//portraitPINKIE = new Portrait(170, 50, "pinkie");
			//add(portraitPINKIE);
			
			portraitDAD = new Portrait(170, 85, "dad");
			add(portraitDAD);

			portraitSPOOKY = new Portrait(170, 190, "spooky");
			add(portraitSPOOKY);

			portraitMONSTER = new Portrait(170, 125, "monster");
			add(portraitMONSTER);

			portraitPICO = new Portrait(170, 85, "pico");
			add(portraitPICO);

			portraitDARNELL = new Portrait(170, 70, "darnell");
			add(portraitDARNELL);

			portraitNENE = new Portrait(170, 25, "nene");
			add(portraitNENE);

			portraitMOM = new Portrait(170, 25, "mom");
			add(portraitMOM);
			portraitIMPS = new Portrait(140, 205, "imps");
			add(portraitIMPS);
			portraitNOCHAR = new Portrait(0, 9999, "bf");
			add(portraitNOCHAR);*/
			
		}


		switch PlayState.SONG.song.toLowerCase(){
		case 'senpai' | 'roses' | 'thorns':
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);	
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * 0.9));
		box.updateHitbox();
		add(box);
		box.animation.play('normalOpen'); 
		box.setGraphicSize(Std.int(box.width * 0.9));
		box.updateHitbox();
		add(box);
	
		
		default:
		box.animation.play('normalOpen');
		//box.setGraphicSize(Std.int(box.width * 0.9));
		//box.updateHitbox();
		add(box);
		add(arrow);
		}
	
		box.screenCenter(X);
	

		//handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('hand_textbox', 'shared'));
		//add(handSelect);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		
		dropText = new FlxText(113.9, 474.05, Std.int(FlxG.width * 0.8), "", 64);
		dropText.font = 'assets/fonts/funkin.otf';
		dropText.color = 0xFF00FFFF;
		add(dropText);
		skipText = new FlxText(5, 695, 640, "Press SPACE to skip the dialogue.\n", 40);
		skipText.scrollFactor.set(0, 0);
		skipText.setFormat("assets/fonts/vcr.tff", 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		skipText.borderSize = 2;
		skipText.borderQuality = 1;
		//add(skipText);

		
		swagDialogue = new FlxTypeText(111.9, 472.05, Std.int(FlxG.width * 0.8), "", 64);
		swagDialogue.font = 'assets/fonts/funkin.otf';
		swagDialogue.color = 0xFFFFFF;
		swagDialogue.sounds = [FlxG.sound.load('assets/sounds/pixelText' + TitleState.soundExt, 0.6)];
		add(swagDialogue);

				swagDialogue.completeCallback = doAdvance;
		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		
	
		
		
		dropText.text = swagDialogue.text;

		dropText.offset.x = FlxG.random.float( -textShake, textShake);
		dropText.offset.y = FlxG.random.float( -textShake, textShake);

		swagDialogue.offset.x = FlxG.random.float( -textShake, textShake);
		swagDialogue.offset.y = FlxG.random.float( -textShake, textShake);

		box.offset.x = FlxG.random.float( -boxShake, boxShake);
		box.offset.y = FlxG.random.float( -boxShake, boxShake);

		cutsceneImage.offset.x = FlxG.random.float( -bgShake, bgShake);
		cutsceneImage.offset.y = FlxG.random.float( -bgShake, bgShake);
		
		
		if (bgShake > 0) bgShake-= 1;
		if (textShake > 0) textShake-= 1;
		if (boxShake > 0) boxShake-= 1;
		
		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
		//portraitIMPS.y = 205;
		//if (curAnim == "imps") portraitIMPS.y = 220;
		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if(FlxG.keys.justPressed.SPACE #if android || FlxG.android.justReleased.BACK #end && !isEnding){

			isEnding = true;
			endDialogue();

		}

		if (FlxG.keys.justPressed.SHIFT && !inAutoText && dialogueStarted == true && !canAdvance && !isEnding) //oq raios é isso
		{
			arrow.animation.play("go");
			timeBeforeSkip.cancel();
			canAdvance = true;
			swagDialogue.skip();
		}
		
		#if mobile
        var jusTouched:Bool = false;

        for (touch in FlxG.touches.list)
          if (touch.justPressed)
            jusTouched = true;
        #end
		
		if (FlxG.keys.justPressed.ENTER #if mobile || jusTouched #end && dialogueStarted == true && canAdvance && !isEnding)
		{
			if (wasHidden){
				wasHidden = false;
				box.animation.play("normalOpen");
			}
			nextShit();
			FlxG.sound.play(('assets/sounds/clickText.ogg'), 0.8);
		}

		super.update(elapsed);
	}

	function nextShit(){
				preText = "";
		remove(dialogue);
			canAdvance = false;

			//new FlxTimer().start(0.15, function(tmr:FlxTimer)
			//{
			//	canAdvance = true;
			//});


			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
					endDialogue();
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
	}
	
	
	var isEnding:Bool = false;

	function endDialogue(speed = 1.2){

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
			FlxG.sound.music.fadeOut(speed +2, 0);

		hideAll();
		if (this.sound != null) this.sound.stop();
		FlxTween.tween(box, {alpha: 0}, speed, {ease: FlxEase.linear});
		FlxTween.tween(bgFade, {alpha: 0}, speed, {ease: FlxEase.linear});
		FlxTween.tween(cutsceneImage, {alpha: 0}, speed, {ease: FlxEase.linear});
		FlxTween.tween(swagDialogue, {alpha: 0}, speed, {ease: FlxEase.linear});
		FlxTween.tween(blackBG, {alpha: 0}, speed, {ease: FlxEase.linear});
		FlxTween.tween(dropText, {alpha: 0}, speed, {ease: FlxEase.linear});
		//FlxTween.tween(skipText, {alpha: 0}, speed, {ease: FlxEase.linear});
		FlxG.sound.music.fadeOut(speed, 0);


		new FlxTimer().start(speed, function(tmr:FlxTimer)
		{
			finishThing();
			kill();
			FlxG.sound.music.stop();
		});

	}

	
	function startDialogue():Void
	{

		var setDialogue = false;
		var skipDialogue = false;
		cleanDialog();
		hideAll();
		box.visible = true;
		effectAngle(0);
		//box.flipX = true;
		swagDialogue.visible = true;
		dropText.visible = true;
		trace(curCharacter,curAnim,dialogueList[0]);
		if (portraitNameList.contains(curCharacter)){// if the first thing is a character in the list
				//changeSound('beat',0.6);
				portraits[portraitNameList.indexOf(curCharacter)].playFrame(curAnim.toLowerCase() );
		}else{//if not do special shit

			switch (curCharacter)
			{
				case "noChar":
					hideAll();
				case "hideCharacters":
					skipDialogue = true;
					hideAll();
				case "hideBox":
					wasHidden = true;
					skipDialogue = true;
					box.visible = false;
				case "text":
							skipDialogue = true;
					switch(curAnim){
						case "shake":
							textShake = Std.parseFloat(dialogueList[0]);
						case "speed":
							textSpeed = Std.parseFloat(dialogueList[0]);
						case "variation":
							swagDialogue.setTypingVariation(Std.parseFloat(dialogueList[0]));
						case "pretext":
							if (dialogueList[0] == "`current"){
							preText = swagDialogue.text;
							}else{
							preText = dialogueList[0];
							}
					}
				case "font":
					skipDialogue = true;
					switch(curAnim){
						case "style":
						swagDialogue.font = "assets/fonts/"+(dialogueList[0]);
						dropText.font = "assets/fonts/"+(dialogueList[0]);
						case "color":
						swagDialogue.color = Std.parseInt(dialogueList[0]);
						case "size":
						swagDialogue.size = Std.parseInt(dialogueList[0]);
						dropText.size = Std.parseInt(dialogueList[0]);
					}
				case "box":
					skipDialogue = true;
					switch(curAnim){
						case "shake":
							boxShake = Std.parseFloat(dialogueList[0]);
					}
				case "fastEnd":
					endDialogue(0.01);
				case "camEffect":
					skipDialogue = true;
					switch(curAnim){
						case "flash":
							FlxG.camera.flash(FlxColor.WHITE, Std.parseFloat(dialogueList[0]));
					}
				case "effect":
					switch(curAnim){
						case "hidden":
							doAdvance();
							wasHidden = true;
							swagDialogue.visible = false;
							dropText.visible = false;
							box.visible = false;
							setDialogue = true;
							swagDialogue.resetText("");
						default:
							effectQue.push(curAnim);
							effectParamQue.push(dialogueList[0]);
							skipDialogue = true;
					}
				case "bg":
					skipDialogue = true;
					switch(curAnim){
						case "shake":
							bgShake = Std.parseFloat(dialogueList[0]);
						case "hide":
							cutsceneImage.visible = false;
						default:
							cutsceneImage.visible = true;
							cutsceneImage.loadGraphic(BitmapData.fromFile("assets/dialogue/images/" + curAnim + ".png"));
					}
				case "sound":
					skipDialogue = true;
					if (this.sound != null) this.sound.stop();
					switch(curAnim){
						case "stop":
							this.sound.stop();
						default:
						sound = new FlxSound().loadEmbedded(Sound.fromFile("assets/dialogue/sounds/" + curAnim + ".ogg"));
						sound.play();
						this.sound.looped = (Std.parseInt(dialogueList[0]) == 1) ||dialogueList[0] == "true";
					}
				case "autoskip":
					skipDialogue = true;
					inAutoText = true;
					canSkip = false;
					new FlxTimer().start(0.16, function(tmr:FlxTimer)
					{
						canAdvance = false;
					});
					switch(curAnim){
						case "during":
								new FlxTimer().start(Std.parseFloat(dialogueList[0]), function(e:FlxTimer){
									inAutoText = false;
									canAdvance = true;
									canSkip = true;
									nextShit();
									
								});
						case "after":
								trace("doesn't work currently");
								new FlxTimer().start(Std.parseFloat(dialogueList[0]), function(e:FlxTimer){
									inAutoText = false;
									canAdvance = true;
									canSkip = true;
									nextShit();
								});
						default:
								new FlxTimer().start(Std.parseFloat(curAnim), function(e:FlxTimer){
									inAutoText = false;
									canAdvance = true;
									canSkip = true;
									nextShit();
								});
					}
				case "music":
					skipDialogue = true;
					switch(curAnim){
						case "stop":
							FlxG.sound.music.stop();
						case "fadeIn":
							FlxG.sound.music.fadeIn(1.5, 0, Std.parseFloat(dialogueList[0]));
						case "fadeOut":
							FlxG.sound.music.fadeOut(1.5, 0);
						case "fadeInFull":
							FlxG.sound.music.fadeIn(Std.parseFloat(dialogueList[0]), 0, 1);
						case "fadeOutFull":
							FlxG.sound.music.fadeOut(Std.parseFloat(dialogueList[0]), 0);
						default:
							FlxG.sound.playMusic(Sound.fromFile("assets/dialogue/music/" + curAnim + ".ogg"), Std.parseFloat(dialogueList[0]));
					}
					
				default:
					trace("default dialogue event");
					//portraitBF.playFrame();
			}
		}

		prevChar = curCharacter;

		if(!skipDialogue){
			if (!setDialogue){
				swagDialogue.delay = textSpeed;
				swagDialogue.prefix = preText;
				swagDialogue.resetText(dialogueList[0]);
				
					arrow.animation.play("wait");
				if(!inAutoText){
				timeBeforeSkip.start(swagDialogue.delay*dialogueList[0].length, function(tmr:FlxTimer)
					{
						arrow.animation.play("go");
						canAdvance = true;
					});
				}
					
			}

			swagDialogue.start(textSpeed, true);
			runEffectsQue();
		}
		else{

			dialogueList.remove(dialogueList[0]);
			startDialogue();
			
		}

	}
	
	public function doAdvance() 
	{
		
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
				canAdvance = true;
		});
	}

	function cleanDialog():Void
	{
		while(dialogueList[0] == ""){
			dialogueList.remove(dialogueList[0]);
		}

		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		curAnim = splitName[2];
	
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length  + 3).trim();
		
		
	}

	function runEffectsQue(){
	
		for(i in 0...effectQue.length){

			switch(effectQue[i]){

				case "addX":
					effectAddX(Std.parseFloat(effectParamQue[i]));
				case "angle":
					effectAngle(Std.parseFloat(effectParamQue[i]));
				case "toAngle":
					effectToAngle(Std.parseFloat(effectParamQue[i]));
				case "fromAngle":
					effectFromAngle(Std.parseFloat(effectParamQue[i]));
				case "addY":
					effectAddY(Std.parseFloat(effectParamQue[i]));
				case "toX":
					effectAddX(Std.parseFloat(effectParamQue[i]));
				case "toY":
					effectAddY(Std.parseFloat(effectParamQue[i]));
				case "fromX":
					effectFromX(Std.parseFloat(effectParamQue[i]));
				case "fromY":
					effectFromY(Std.parseFloat(effectParamQue[i]));
				case "fadeOut":
					effectFadeOut(Std.parseFloat(effectParamQue[i]));
				case "fadeIn":
					effectFadeIn(Std.parseFloat(effectParamQue[i]));
				case "exitStageLeft":
					effectExitStageLeft(Std.parseFloat(effectParamQue[i]));
				case "exitStageRight":
					effectExitStageRight(Std.parseFloat(effectParamQue[i]));
				case "enterStageLeft":
					effectEnterStageLeft(Std.parseFloat(effectParamQue[i]));
				case "enterStageRight":
					effectEnterStageRight(Std.parseFloat(effectParamQue[i]));
				case "rightSide":
					effectFlipRight();
				case "flip":
					effectFlipDirection();
				case "toLeft":
					effectToLeft();
				case "toRight":
					effectToRight();
				case "shake":
					effectShake(Std.parseFloat(effectParamQue[i]));
				default:

			}

		}

		effectQue = [""];
		effectParamQue = [""];

	}

	function changeSound(sound:String, volume:Float){
	//swagDialogue.sounds = [FlxG.sound.load(Paths.sound(sound, 'dialogue'), volume)];
	
	}

	function portraitArray(){
	//Why? i don't know, i was bored and hey it's easier to work with
	//var portraitArray = [portraitBF,portraitGF,portraitDAD,portraitSPOOKY,portraitMONSTER,portraitDARNELL,portraitNENE,portraitMOM,portraitPICO,portraitIMPS];
	
	return portraits;
	}
	
	


	function hideAll():Void{
		
		for(i in 0...portraitArray().length){
		portraitArray()[i].hide();
		}
	}

     function effectAddY(?Y:Float = 1){
        
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectAddY(Y);
		}
    }
     function effectAddX(?X:Float = 1){
        
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectFromX(X);
		}
    }
     function effectAngle(?X:Float = 1){
        
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectAngle(X);
		}
    }
     function effectToAngle(?X:Float = 1){
        
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectToAngle(X);
		}
    }
     function effectFromAngle(?X:Float = 1){
        
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectFromAngle(X);
		}
    }
     function effectFromY(?Y:Float = 1){
        
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectFromY(Y);
		}
    }
     function effectFromX(?X:Float = 1){
        
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectAddX(X);
		}
    }
	function effectFadeOut(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectFadeOut(time);
		}
	}

	function effectFadeIn(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
		portraitArray()[i].effectFadeIn(time);
		}
	}

	function effectExitStageLeft(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectExitStageLeft(time);
			}
	}

	function effectExitStageRight(?time:Float = 1):Void{
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectExitStageRight(time);
			}
	}

	function effectFlipRight(){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectFlipRight();
			}
			box.flipX = false;
		
	}
	
	function effectFlipDirection(){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectFlipDirection();
			}
		
	}

	function effectEnterStageLeft(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectEnterStageLeft(time);
			}
		
	}

	function effectEnterStageRight(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectEnterStageRight(time);
			}
	
	}

	function effectToRight(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectToRight(time);
			}
		
		box.flipX = false;
	}

	function effectToLeft(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectToLeft(time);
			}
		
	}
	function effectShake(?time:Float = 1){
		for(i in 0...portraitArray().length){
			portraitArray()[i].effectShake(time);
		}
		
	}

	function censorTheShit(){
		for (i in 0...dialogueList.length){
			trace(dialogueList[i]);
			for(u in cusswords){
				if (StringTools.contains(dialogueList[i], u[0])){
					dialogueList[i] = StringTools.replace(dialogueList[i], u[0],u[1]);
				}
			}	
		}
	}
	
}
