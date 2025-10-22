package;

//import polymod.fs.SysFileSystem;
import Section.SwagSection;
#if desktop
import sys.FileSystem;
import Discord.DiscordClient;
#end
import Song.SwagSong;
//import WiggleEffect.WiggleEffectType;
//import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
//import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
//import flixel.FlxState;
import flixel.FlxSubState;
//import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
//import flixel.addons.effects.FlxTrailArea;
//import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
//import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
//import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
//import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
//import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
//import haxe.Json;
//import lime.utils.Assets;
import openfl.display.BlendMode;
//import openfl.display.StageQuality;
//import openfl.filters.ShaderFilter;
import Lyric.SwagLyricSection;
import haxe.Json;
import lime.utils.Assets;
import openfl.Assets;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	
	public static var returnLocation:String = "main";
	public static var returnSong:Int = 0;
	
	private var canHit:Bool = false;
	private var noMissCount:Int = 0;

	public static var stageSongs:Array<String>;
	public static var spookySongs:Array<String>;
	public static var stationSongs:Array<String>;
	public static var limoSongs:Array<String>;
	public static var miaSongs:Array<String>;
	public static var mallSongs:Array<String>;
	public static var evilMallSongs:Array<String>;
	public static var schoolSongs:Array<String>;
	public static var schoolScared:Array<String>;
	public static var evilSchoolSongs:Array<String>;
	
	public static var botplay:Bool = true;
	
	private var errorLog:FlxText;
private var showErrors:Bool = true; // Ativa/desativa o log na tela
private static var lastError:String = "Nenhum erro detectado";
	
	var gayStation:FlxSprite;

	var camFocus:String = "";
	var camTween:FlxTween;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var invulnCount:Int = 0;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	//Wacky input stuff=========================

	private var skipListener:Bool = false;

	private var upTime:Int = 0;
	private var downTime:Int = 0;
	private var leftTime:Int = 0;
	private var rightTime:Int = 0;

	private var upPress:Bool = false;
	private var downPress:Bool = false;
	private var leftPress:Bool = false;
	private var rightPress:Bool = false;
	
	private var upRelease:Bool = false;
	private var downRelease:Bool = false;
	private var leftRelease:Bool = false;
	private var rightRelease:Bool = false;

	private var upHold:Bool = false;
	private var downHold:Bool = false;
	private var leftHold:Bool = false;
	private var rightHold:Bool = false;

	//End of wacky input stuff===================

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var enemyStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	private var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	
	private var startingSong:Bool = false;
	
	
	
	private var gayPico:Bool = false;

	
	
	
	
	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	// (tsg - 7/30/21) small things lyric system port
	private var lyricSpeakerIcon:HealthIcon;
	var lyrics:Array<SwagLyricSection>;
	var hasLyrics:Bool = false;
	var hasDialogue:Bool = false;
	var lyricTxt:FlxText;

	var gayBoppers:Array <FlxSprite> = [];
	
	
	
	var dialogue:Array<String> = ['strange code', '>:]'];

	/*var bfPos:Array<Array<Float>> = [
									[975.5, 862],
									[975.5, 862],
									[975.5, 862],
									[1235.5, 642],
									[1175.5, 866],
									[1295.5, 866],
									[1189, 1108],
									[1189, 1108]
									];

	var dadPos:Array<Array<Float>> = [
									 [314.5, 867],
									 [346, 849],
									 [326.5, 875],
									 [339.5, 914],
									 [42, 882],
									 [342, 861],
									 [625, 1446],
									 [334, 968]
									 ];*/

	var halloweenSky:FlxSprite;
	var halloweenForeground:FlxSprite;
	var halloweenGround:FlxSprite;
	var halloweenTrees:FlxSprite;

	var isHalloween:Bool = false;

	var stationLights:FlxSprite;
	var stationGlow:FlxSprite;
	var pcameos:FlxSprite;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var frontBoppers:FlxSprite;
	var backBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var dcameos:FlxSprite;

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	
	//ANTI STACK SHIT
	var allNotes:Array<Array<Float>> = [[],[],[],[]];

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	
	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end


	var dadBeats:Array<Int> = [0, 2];
	var bfBeats:Array<Int> = [1, 3];
	
	override public function create()
	{
		FlxG.mouse.visible = false;

		FlxG.sound.cache("assets/music/" + SONG.song + "_Inst" + TitleState.soundExt);
		FlxG.sound.cache("assets/music/" + SONG.song + "_Voices" + TitleState.soundExt);
		
		if(Config.noFpsCap)
			openfl.Lib.current.stage.frameRate = 999;
		else
			openfl.Lib.current.stage.frameRate = 144;

		Conductor.setSafeZone();
		camTween = FlxTween.tween(this, {}, 0);
	
		stageSongs = ["tutorial", "bopeebo", "fresh", "dadbattle"];
		spookySongs = ["spookeez", "south", "not a monster"];
		stationSongs = ["pico", "philly", "blammed", "school"];
		limoSongs = ["satin-panties", "high", "milf", "milkies"];
		miaSongs = ["mi-opera", "mia battle", "diva", "revolution", "mania"];
		mallSongs = ["cocoa", "eggnog"];
		evilMallSongs = ["winter-horrorland"];
		schoolSongs = ["senpai", "roses"];
		schoolScared = ["roses"];
		evilSchoolSongs = ["thorns"];
		
		canHit = !Config.noRandomTap;
		noMissCount = 0;
		invulnCount = 0;
	
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		
		if (showErrors) {
    errorLog = new FlxText(10, 10, 0, "Erro: " + lastError, 16);
    errorLog.setFormat(null, 16, FlxColor.RED, FlxTextAlign.LEFT, FlxColor.BLACK, true);
    errorLog.scrollFactor.set();
    errorLog.cameras = [camHUD]; // Aparece na HUD
    add(errorLog);
}

		try {
		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.changeBPM(SONG.bpm);

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "Getreal";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		try {
            if (Assets.exists("data/" + SONG.song.toLowerCase() + "/" + SONG.song.toLowerCase() + "Dialogue.txt")) {
                hasDialogue = true;
                var text = Assets.getText("data/" + SONG.song.toLowerCase() + "/" + SONG.song.toLowerCase() + "Dialogue.txt");
                dialogue = text != null ? text.split("\n") : [];
                trace("Dialogue loaded: " + dialogue);
            } else {
                hasDialogue = false;
                dialogue = [];
                trace("Dialogue file not found");
            }
        } catch(e) {
            hasDialogue = false;
            dialogue = [];
            trace("Error loading dialogue: " + e);
        }

		// (tsg - 7/30/21) small things lyric system port
		// check for lyrics
		try {
            if (Assets.exists("data/" + SONG.song.toLowerCase() + "/lyrics.json")) {
                var text = Assets.getText("data/" + SONG.song.toLowerCase() + "/lyrics.json");
                if (text != null) {
                    lyrics = cast Json.parse(text);
                    hasLyrics = true;
                    trace("Lyrics loaded: " + lyrics);
                    trace("Found lyrics for " + SONG.song.toLowerCase());
                } else {
                    hasLyrics = false;
                    lyrics = [];
                    trace("Lyrics file is empty for " + SONG.song.toLowerCase());
                }
            } else {
                hasLyrics = false;
                lyrics = [];
                trace("Lyrics file not found for " + SONG.song.toLowerCase());
            }
        } catch(e) {
            hasLyrics = false;
            lyrics = [];
            trace("Error loading lyrics: " + e);
        }

		if (spookySongs.contains(SONG.song.toLowerCase()))
		{
			curStage = "spooky";
			halloweenLevel = true;
			defaultCamZoom = 0.35;
			var halloweenSky:FlxSprite = new FlxSprite(-1400, -1000).loadGraphic('assets/images/week2bg/Forest.png');
			halloweenSky.scrollFactor.set(0.3, 0.3);
			halloweenSky.setGraphicSize(Std.int(halloweenSky.width * 0.8));
			halloweenSky.updateHitbox();

			var halloweenTrees:FlxSprite = new FlxSprite(-1400, -800).loadGraphic('assets/images/week2bg/bg_trees.png');
			halloweenTrees.scrollFactor.set(0.6, 0.6);
			halloweenTrees.setGraphicSize(Std.int(halloweenTrees.width * 0.8));
			halloweenTrees.updateHitbox();

			var halloweenGround:FlxSprite = new FlxSprite(-1400, -900).loadGraphic('assets/images/week2bg/house.png');
			halloweenGround.scrollFactor.set(0.9, 0.9);
			halloweenGround.setGraphicSize(Std.int(halloweenGround.width * 0.8));
			halloweenGround.updateHitbox();

			add(halloweenSky);
			add(halloweenTrees);
			add(halloweenGround);
			isHalloween = true;


		}
		else if (stationSongs.contains(SONG.song.toLowerCase()))
		{
			curStage = 'station';
			defaultCamZoom = 0.6;
			var cachingSprites1:FlxSprite = new FlxSprite(0, 0);
			cachingSprites1.frames = FlxAtlasFrames.fromSparrow('assets/images/picobutgay.png', 'assets/images/picobutgay.xml');
			var cachingSprites2:FlxSprite = new FlxSprite(0, 0);
			cachingSprites2.frames = FlxAtlasFrames.fromSparrow('assets/images/bfbutgay.png', 'assets/images/bfbutgay.xml');
			add(cachingSprites1);
			add(cachingSprites2);
			var subway:FlxSprite = new FlxSprite(-350,-500).loadGraphic('assets/images/station/subway.png');
			subway.scrollFactor.set(0.9, 0.9);
			subway.setGraphicSize(Std.int(subway.width * 1));
			subway.updateHitbox();
			add(subway);
			
			
			
			gayStation = new FlxSprite(-350,-500).loadGraphic('assets/images/station/subway but gay.png');
			gayStation.scrollFactor.set(0.9, 0.9);
			gayStation.setGraphicSize(Std.int(subway.width * 1));
			gayStation.updateHitbox();
			add(gayStation);
			gayStation.visible = false;

			pcameos = new FlxSprite(-335,-551);
			pcameos.frames = FlxAtlasFrames.fromSparrow('assets/images/station/pcameos.png','assets/images/station/pcameos.xml');
			pcameos.animation.addByPrefix('bop', "bop", 24, true);
			pcameos.antialiasing = true;
			pcameos.scrollFactor.set(0.9, 0.9);
			pcameos.setGraphicSize(Std.int(pcameos.width * 1.65));
			pcameos.setGraphicSize(Std.int(pcameos.height * 1.65));
			pcameos.updateHitbox();
			add(pcameos);
gayBoppers.push(pcameos);
			pcameos.animation.play('bop', false);

			var stationLights:FlxSprite = new FlxSprite(-350,-500);
			stationLights.frames = FlxAtlasFrames.fromSparrow('assets/images/station/lightsSheet.png','assets/images/station/lightsSheet.xml');
			stationLights.animation.addByPrefix('bop', "Lights", 24);
			stationLights.animation.play('bop');
			stationLights.scrollFactor.set(0.9, 0.9);
			stationLights.setGraphicSize(Std.int(subway.width * 1));
			stationLights.updateHitbox();
			add(stationLights);

			

			/*for (i in 0...2)
			{
				var stationGlow:FlxSprite = new FlxSprite(-70, 0).loadGraphic('assets/images/station/glow' + i + '.png');
				stationGlow.scrollFactor.set(0.3, 0.3);
				stationGlow.setGraphicSize(Std.int(stationGlow.width * 0.55));
				stationGlow.updateHitbox();
			}

			stationLights = new FlxTypedGroup<FlxSprite>();
			add(stationLights);

			for (i in 0...2)
			{
				var stationLight:FlxSprite = new FlxSprite(-70, 0).loadGraphic('assets/images/station/light' + i + '.png');
				stationLight.scrollFactor.set(0.3, 0.3);
				stationLight.setGraphicSize(Std.int(stationLight.width * 0.55));
				stationLight.updateHitbox();
				stationLights.add(stationLight);
			}

			phillyTrain = new FlxSprite(2000, 360).loadGraphic('assets/images/station/train.png');
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded('assets/sounds/train_passes' + TitleState.soundExt);
			FlxG.sound.list.add(trainSound);*/

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
		}
		else if (limoSongs.contains(SONG.song.toLowerCase()))
		{
			curStage = 'limo';
			defaultCamZoom = 0.90;

			var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic('assets/images/limo/limoSunset.png');
			skyBG.scrollFactor.set(0.1, 0.1);
			add(skyBG);

			var bgLimo:FlxSprite = new FlxSprite(-200, 480);
			bgLimo.frames = FlxAtlasFrames.fromSparrow('assets/images/limo/bgLimo.png', 'assets/images/limo/bgLimo.xml');
			bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
			bgLimo.animation.play('drive');
			bgLimo.scrollFactor.set(0.4, 0.4);
			add(bgLimo);

			grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
			add(grpLimoDancers);

			for (i in 0...5)
			{
				var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
				dancer.scrollFactor.set(0.4, 0.4);
				grpLimoDancers.add(dancer);
			}

			var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic('assets/images/limo/limoOverlay.png');
			overlayShit.alpha = 0.5;
			// add(overlayShit);

			// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

			// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

			// overlayShit.shader = shaderBullshit;

			var limoTex = FlxAtlasFrames.fromSparrow('assets/images/limo/limoDrive.png', 'assets/images/limo/limoDrive.xml');

			limo = new FlxSprite(-120, 550);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = true;

			fastCar = new FlxSprite(-300, 160).loadGraphic('assets/images/limo/fastCarLol.png');
			// add(limo);
		}

		else if (miaSongs.contains(SONG.song.toLowerCase()))
			{
				curStage = 'miaStadium';
				defaultCamZoom = 0.575;
	
				var stadiumBG:FlxSprite = new FlxSprite(-550, -270).loadGraphic('assets/images/stadium/stadium.png');
				stadiumBG.setGraphicSize(Std.int(stadiumBG.width * 1));
				stadiumBG.scrollFactor.set(0.9, 0.9);
				add(stadiumBG);

				backBoppers = new FlxSprite(-550, -327);
				backBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/stadium/mia_boppers.png', 'assets/images/stadium/mia_boppers.xml');
				backBoppers.animation.addByPrefix('bop', "Back Crowd Bop", 24, true);
				backBoppers.antialiasing = true;
				backBoppers.scrollFactor.set(0.9, 0.9);
				backBoppers.setGraphicSize(Std.int(backBoppers.width * 1));
				backBoppers.updateHitbox();
				add(backBoppers);

				frontBoppers = new FlxSprite(-550, -335);
				frontBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/stadium/mia_boppers.png', 'assets/images/stadium/mia_boppers.xml');
				frontBoppers.animation.addByPrefix('bop', "Front Crowd Bop", 24, true);
				frontBoppers.antialiasing = true;
				frontBoppers.scrollFactor.set(0.9, 0.9);
				frontBoppers.setGraphicSize(Std.int(frontBoppers.width * 1));
				frontBoppers.updateHitbox();
				add(frontBoppers);

				frontBoppers.animation.play('bop', true);
				backBoppers.animation.play('bop', true);

			}
		else if (mallSongs.contains(SONG.song.toLowerCase()))
		{
			curStage = 'mall';

			defaultCamZoom = 0.80;

			var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic('assets/images/christmas/bgWalls.png');
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			upperBoppers = new FlxSprite(-240, -90);
			upperBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/upperBop.png', 'assets/images/christmas/upperBop.xml');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = true;
			upperBoppers.scrollFactor.set(0.33, 0.33);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic('assets/images/christmas/bgEscalator.png');
			bgEscalator.antialiasing = true;
			bgEscalator.scrollFactor.set(0.3, 0.3);
			bgEscalator.active = false;
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
			bgEscalator.updateHitbox();
			add(bgEscalator);

			var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic('assets/images/christmas/christmasTree.png');
			tree.antialiasing = true;
			tree.scrollFactor.set(0.40, 0.40);
			add(tree);

			bottomBoppers = new FlxSprite(-300, 140);
			bottomBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/bottomBop.png', 'assets/images/christmas/bottomBop.xml');
			bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			bottomBoppers.antialiasing = true;
			bottomBoppers.scrollFactor.set(0.9, 0.9);
			bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			bottomBoppers.updateHitbox();
			add(bottomBoppers);

			var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic('assets/images/christmas/fgSnow.png');
			fgSnow.active = false;
			fgSnow.antialiasing = true;
			add(fgSnow);

			santa = new FlxSprite(-840, 150);
			santa.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/santa.png', 'assets/images/christmas/santa.xml');
			santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
			santa.antialiasing = true;
			add(santa);
		}
		else if (evilMallSongs.contains(SONG.song.toLowerCase()))
		{
			curStage = 'mallEvil';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic('assets/images/christmas/evilBG.png');
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic('assets/images/christmas/evilTree.png');
			evilTree.antialiasing = true;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic("assets/images/christmas/evilSnow.png");
			evilSnow.antialiasing = true;
			add(evilSnow);
		}
		else if (schoolSongs.contains(SONG.song.toLowerCase()))
		{
			curStage = 'school';

			// defaultCamZoom = 0.9;

			var bgSky = new FlxSprite().loadGraphic('assets/images/weeb/weebSky.png');
			bgSky.scrollFactor.set(0.1, 0.1);
			add(bgSky);

			var repositionShit = -200;

			var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic('assets/images/weeb/weebSchool.png');
			bgSchool.scrollFactor.set(0.6, 0.90);
			add(bgSchool);

			var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic('assets/images/weeb/weebStreet.png');
			bgStreet.scrollFactor.set(0.95, 0.95);
			add(bgStreet);

			var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic('assets/images/weeb/weebTreesBack.png');
			fgTrees.scrollFactor.set(0.9, 0.9);
			add(fgTrees);

			var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
			var treetex = FlxAtlasFrames.fromSpriteSheetPacker('assets/images/weeb/weebTrees.png', 'assets/images/weeb/weebTrees.txt');
			bgTrees.frames = treetex;
			bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
			bgTrees.animation.play('treeLoop');
			bgTrees.scrollFactor.set(0.85, 0.85);
			add(bgTrees);

			var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
			treeLeaves.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/petals.png', 'assets/images/weeb/petals.xml');
			treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
			treeLeaves.animation.play('leaves');
			treeLeaves.scrollFactor.set(0.85, 0.85);
			add(treeLeaves);

			var widShit = Std.int(bgSky.width * 6);

			bgSky.setGraphicSize(widShit);
			bgSchool.setGraphicSize(widShit);
			bgStreet.setGraphicSize(widShit);
			bgTrees.setGraphicSize(Std.int(widShit * 1.4));
			fgTrees.setGraphicSize(Std.int(widShit * 0.8));
			treeLeaves.setGraphicSize(widShit);

			fgTrees.updateHitbox();
			bgSky.updateHitbox();
			bgSchool.updateHitbox();
			bgStreet.updateHitbox();
			bgTrees.updateHitbox();
			treeLeaves.updateHitbox();

			bgGirls = new BackgroundGirls(-100, 190);
			bgGirls.scrollFactor.set(0.9, 0.9);

			if (schoolScared.contains(SONG.song.toLowerCase()))
			{
				bgGirls.getScared();
			}

			bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
			bgGirls.updateHitbox();
			add(bgGirls);
		}
		else if (evilSchoolSongs.contains(SONG.song.toLowerCase()))
		{
			curStage = 'schoolEvil';

			var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
			var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

			var posX = 400;
			var posY = 200;

			var bg:FlxSprite = new FlxSprite(posX, posY);
			bg.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/animatedEvilSchool.png', 'assets/images/weeb/animatedEvilSchool.xml');
			bg.animation.addByPrefix('idle', 'background 2', 24);
			bg.animation.play('idle');
			bg.scrollFactor.set(0.8, 0.9);
			bg.scale.set(6, 6);
			add(bg);

			/* 
				var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic('assets/images/weeb/evilSchoolBG.png');
				bg.scale.set(6, 6);
				// bg.setGraphicSize(Std.int(bg.width * 6));
				// bg.updateHitbox();
				add(bg);
				var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic('assets/images/weeb/evilSchoolFG.png');
				fg.scale.set(6, 6);
				// fg.setGraphicSize(Std.int(fg.width * 6));
				// fg.updateHitbox();
				add(fg);
				wiggleShit.effectType = WiggleEffectType.DREAMY;
				wiggleShit.waveAmplitude = 0.01;
				wiggleShit.waveFrequency = 60;
				wiggleShit.waveSpeed = 0.8;
			 */

			// bg.shader = wiggleShit.shader;
			// fg.shader = wiggleShit.shader;

			/* 
				var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
				var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
				// Using scale since setGraphicSize() doesnt work???
				waveSprite.scale.set(6, 6);
				waveSpriteFG.scale.set(6, 6);
				waveSprite.setPosition(posX, posY);
				waveSpriteFG.setPosition(posX, posY);
				waveSprite.scrollFactor.set(0.7, 0.8);
				waveSpriteFG.scrollFactor.set(0.9, 0.8);
				// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
				// waveSprite.updateHitbox();
				// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
				// waveSpriteFG.updateHitbox();
				add(waveSprite);
				add(waveSpriteFG);
			 */
		}
		else
		{
			curStage = 'stage';
			defaultCamZoom = 0.515;

			var stageBG:FlxSprite = new FlxSprite(-700, -300).loadGraphic('assets/images/stage/Stadium.png');
			stageBG.setGraphicSize(Std.int(stageBG.width * 1));
			stageBG.scrollFactor.set(0.9, 0.9);
			add(stageBG);

			dcameos = new FlxSprite(-700, -580);
			dcameos.frames = FlxAtlasFrames.fromSparrow('assets/images/stage/dcameos.png', 'assets/images/stage/dcameos.xml');
			dcameos.animation.addByPrefix('bop', "bop", 24, true);
			dcameos.antialiasing = true;
			dcameos.scrollFactor.set(0.9, 0.9);
			dcameos.setGraphicSize(Std.int(dcameos.width * 1));
			dcameos.updateHitbox();
			add(dcameos);
gayBoppers.push(dcameos);
			dcameos.animation.play('bop');
		}

		switch(SONG.song.toLowerCase()){
			case "tutorial":
				dadBeats = [0, 1, 2, 3];
			case "bopeebo":
				dadBeats = [0, 1, 2, 3];
				bfBeats = [0, 1, 2, 3];
			case "fresh":
				dadBeats = [0, 1, 2, 3];
				bfBeats = [0, 1, 2, 3];
			case "spookeez":
				dadBeats = [0, 1, 2, 3];
			case "south":
				dadBeats = [0, 1, 2, 3];
			case "monster":
				dadBeats = [0, 1, 2, 3];
				bfBeats = [0, 1, 2, 3];
			case "cocoa":
				dadBeats = [0, 1, 2, 3];
				bfBeats = [0, 1, 2, 3];
			case "thorns":
				dadBeats = [0, 1, 2, 3];
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'spooky':
				gfVersion = 'gf-night';
			case 'station':
				gfVersion = 'gf-train';
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall':
				gfVersion = 'gf-christmas';
			case 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += -100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
				dad.y -= 140;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case "mia":
				dad.x -= -113;
				dad.y += 164;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		add(gf);
		add(dad);
		add(boyfriend);
		
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;
			case 'stage':
				dad.x += 100;
			case 'station':
				boyfriend.x += 300;
				gf.x += 100;
				var stationGlow:FlxSprite = new FlxSprite(-275,-400);
				stationGlow.frames = FlxAtlasFrames.fromSparrow('assets/images/station/glowsSheet.png','assets/images/station/glowsSheet.xml');
				stationGlow.animation.addByPrefix('bop', "Glows", 24);
				stationGlow.animation.play('bop');
				stationGlow.scrollFactor.set(0.9, 0.9);
				stationGlow.setGraphicSize(Std.int(stationGlow.width * 1));
				stationGlow.updateHitbox();
				add(stationGlow);
			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'spooky':
				boyfriend.y += 600;
				boyfriend.x += 450;
				gf.y += 600;
				gf.x += 300;
				dad.y += 600;
				var halloweenForeground:FlxSprite = new FlxSprite(-900, -800).loadGraphic('assets/images/week2bg/foreground_trees.png');
				halloweenForeground.scrollFactor.set(1.3, 1.3);//this closer to the eye move faster
				halloweenForeground.setGraphicSize(Std.int(halloweenForeground.width * 0.8));
				halloweenForeground.updateHitbox();

				add(halloweenForeground);
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'miaStadium':
				boyfriend.y += 250;
				boyfriend.x += 200;
				gf.y += 160;
				dad.y += 220;
				var lights:FlxSprite = new FlxSprite(-550, -280).loadGraphic('assets/images/stadium/lights.png');
				lights.setGraphicSize(Std.int(lights.width * 1));
				lights.scrollFactor.set(0.9, 0.9);
				add(lights);
		}

		if (curStage == 'limo')
			add(limo);


		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		if(Config.downscroll){
			strumLine = new FlxSprite(0, 570).makeGraphic(FlxG.width, 10);
		}
		else {
			strumLine = new FlxSprite(0, 30).makeGraphic(FlxG.width, 10);
		}
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		enemyStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON);
		
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, Config.downscroll ? FlxG.height * 0.1 : FlxG.height * 0.875).loadGraphic('assets/images/healthBar.png');
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		
		scoreTxt = new FlxText(healthBarBG.x - 105, (FlxG.height * 0.9) + 36, 800, "", 22);
		scoreTxt.setFormat("assets/fonts/vcr.ttf", 22, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);

		// (tsg - 7/30/21) small things lyric system port
		lyricTxt = new FlxText(healthBar.x, healthBar.y, 320, "[PLACEHOLDER]", 28);
		lyricTxt.setFormat("assets/fonts/vcr.ttf", 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		lyricTxt.scrollFactor.set();

		lyricSpeakerIcon = new HealthIcon();
		lyricSpeakerIcon.iconScale = 0.65;
		lyricSpeakerIcon.visible = false;
		
		add(healthBar);
		add(iconP2);
		add(iconP1);
		add(scoreTxt);
		add(lyricTxt);			// (tsg - 7/30/21) small things lyric system port
		add(lyricSpeakerIcon);	// (tsg - 7/30/21) small things lyric system port

		// (tsg - 7/30/21) small things lyric system port
		// by default make this off
		lyricTxt.text = "";

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		
		// (tsg - 7/30/21) small things lyric system port
		lyricTxt.cameras = [camHUD];
		lyricSpeakerIcon.cameras = [camHUD];

		healthBar.visible = false;
		healthBarBG.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;
		scoreTxt.visible = false;

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		#if mobile
		addMControls();
		#end
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play('assets/sounds/Lights_Turn_On' + TitleState.soundExt);
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play('assets/sounds/ANGRY' + TitleState.soundExt);
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				default:
					if (hasDialogue){
						schoolIntro(doof);
					}else{
						startCountdown();
						
					}
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}

	function updateAccuracy()
		{

			totalPlayed += 1;
			accuracy = totalNotesHit / totalPlayed * 100;
			//trace(totalNotesHit + '/' + totalPlayed + '* 100 = ' + accuracy);
			if (accuracy >= 100.00)
			{
					accuracy = 100;
			}
		
		}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpaiCrazy.png', 'assets/images/weeb/senpaiCrazy.xml');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 5.5));
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		//senpaiEvil.x -= 120;
		senpaiEvil.y -= 115;

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play('assets/sounds/Senpai_Dies' + TitleState.soundExt, 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		healthBar.visible = true;
		healthBarBG.visible = true;
		iconP1.visible = true;
		iconP2.visible = true;
		scoreTxt.visible = true;

		generateStaticArrows(0);
		generateStaticArrows(1);
		
		#if mobile
	    mcontrols.visible = true;
	    #end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if(dadBeats.contains((swagCounter % 4)))
				dad.dance();

			gf.dance();

			if(bfBeats.contains((swagCounter % 4)))
				boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready.png', "set.png", "go.png"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel.png',
				'weeb/pixelUI/set-pixel.png',
				'weeb/pixelUI/date-pixel.png'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel.png',
				'weeb/pixelUI/set-pixel.png',
				'weeb/pixelUI/date-pixel.png'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play('assets/sounds/intro3' + altSuffix + TitleState.soundExt, 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[0]);
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro2' + altSuffix + TitleState.soundExt, 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[1]);
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro1' + altSuffix + TitleState.soundExt, 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[2]);
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/introGo' + altSuffix + TitleState.soundExt, 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic("assets/music/" + SONG.song + "_Inst" + TitleState.soundExt, 1, false);

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			if(!paused)
			resyncVocals();
		});

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end

	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
		{
			vocals = new FlxSound().loadEmbedded("assets/music/" + curSong + "_Voices" + TitleState.soundExt);
		}
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, false, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);
				
				if(songNotes[3])swagNote.noteStyle = songNotes[3];

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				
				//FIXING THE STACKED NOTES
				
				var stacked = false;
				
				if(gottaHitNote){
				if (allNotes[swagNote.noteData].contains(swagNote.strumTime)){
					stacked = true;
					trace("STACKED");
				}else{
					
				unspawnNotes.push(swagNote);
				}
				if(!stacked)allNotes[swagNote.noteData].push(swagNote.strumTime);
				}else{
					unspawnNotes.push(swagNote);
				}
				///
				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, false, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(50, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
					}

				default:
					babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				enemyStrums.add(babyArrow);
				babyArrow.animation.finishCallback = function(name:String){
					if(name == "confirm"){
						babyArrow.animation.play('static', true);
						babyArrow.centerOffsets();
					}
				}
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
		} catch (e:Dynamic) {
    logError("Erro no create: " + Std.string(e));
}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
		{
			#if desktop
			if (health > 0 && !paused)
			{
				if (Conductor.songPosition > 0.0)
				{
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
				}
				else
				{
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
				}
			}
			#end
	
			super.onFocus();
		}
		
		override public function onFocusLost():Void
		{
			#if desktop
			if (health > 0 && !paused)
			{
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
	
			super.onFocusLost();
		}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}


	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		keyCheck(); 

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'station':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);
		try {

		switch(Config.accuracy){
			case "none":
				scoreTxt.text = "Score:" + songScore;
			default:
				scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "%";
		}
		if (FlxG.keys.justPressed.ENTER #if android || FlxG.android.justReleased.BACK #end && startedCountdown && canPause)
			{
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
	
                
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				
				
				
				
				#if desktop
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
				#end
			}
	
			
			/*
			 
				if(FlxG.keys.justPressed.SIX){
					var sexScene:FlxVideo = new FlxVideo(Paths.video("sexScene"));
					add(sexScene);
					sexScene.play();
				
				}
			
			
			
			
			
			
			*/
			
			
			
			if (FlxG.keys.justPressed.SEVEN)
			{
				FlxG.switchState(new ChartingState());
	
				#if desktop
				if (FlxG.random.bool(40))
				DiscordClient.changePresence("Shart Editor", null, null, true);
			
				else
				DiscordClient.changePresence("Chart Editor", null, null, true);	
				#end
			}
	

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		lyricTxt.x = (healthBar.getMidpoint().x - 100) - 70;
		lyricTxt.y = (FlxG.save.data.downscroll ? healthBar.getMidpoint().y + 175 : healthBar.getMidpoint().y - 175);

		lyricSpeakerIcon.x = (lyricTxt.x + (lyricTxt.width / 2) - 64) + 24;
		lyricSpeakerIcon.y = (lyricTxt.y - 112) + 28;
		
		var lyricFailMargin:Int = 120;
		
		// (tsg - 7/30/21) small things lyric system port
		if (hasLyrics == true) {
			for (i in lyrics) {
				if (FlxMath.inBounds(Conductor.songPosition, i.start, i.start + lyricFailMargin)) {
					lyricTxt.text = i.lyric;
					lyricSpeakerIcon.animation.play(i.speaker);
					lyricSpeakerIcon.visible = true;
				}

				if (FlxMath.inBounds(Conductor.songPosition, i.end, i.end + lyricFailMargin))
				{
					lyricTxt.text = "";
					lyricSpeakerIcon.visible = false;
				}
			}
		}


		if (health > 2)
			health = 2;

		//Heath Icons
		if (healthBar.percent < 20){
			iconP1.animation.curAnim.curFrame = 1;
			if(Config.betterIcons){ //Better Icons Win Anim
				iconP2.animation.curAnim.curFrame = 2;
			}
		}
		else if (healthBar.percent > 80){
			iconP2.animation.curAnim.curFrame = 1;
			if(Config.betterIcons){ //Better Icons Win Anim
				iconP1.animation.curAnim.curFrame = 2;
			}
		}
		else{
			iconP2.animation.curAnim.curFrame = 0;
			iconP1.animation.curAnim.curFrame = 0;
		}
			
		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		if (FlxG.keys.justPressed.EIGHT){
			if(FlxG.keys.pressed.SHIFT){
				FlxG.switchState(new AnimationDebug(SONG.player1));
			}
			else if(FlxG.keys.pressed.CONTROL){
				FlxG.switchState(new AnimationDebug(gf.curCharacter));
			}
			else{
				FlxG.switchState(new AnimationDebug(SONG.player2));
			}
		}
			

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFocus != "dad" && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{

				camTween.cancel();
				
				camFocus = "dad";

				var followX = dad.getMidpoint().x + 150;
				var followY = dad.getMidpoint().y - 100;
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case "mom" | "mom-car":
						followY = dad.getMidpoint().y;
					case 'senpai' | 'senpai-angry':
						followY = dad.getMidpoint().y - 430;
						followX = dad.getMidpoint().x - 100;
					case 'mia':
						followY = dad.getMidpoint().y - 235;
					case 'monster':
						followY = dad.getMidpoint().y - 450;
					case 'spooky':
						followY = dad.getMidpoint().y - 450;
						followX = dad.getMidpoint().x + 15;
					case 'pico': 
						followY = dad.getMidpoint().y - 275;
						followX = dad.getMidpoint().x + 400;
					
					case 'picoGAY':
						followY = dad.getMidpoint().y - 275;
						followX = dad.getMidpoint().x + 400;
				}

				
				
				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}

				camTween = FlxTween.tween(camFollow, {x: followX, y: followY}, 1.9, {ease: FlxEase.quintOut});

			}

			if (camFocus != "bf" && PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{

				camTween.cancel();

				camFocus = "bf";

				var followX = boyfriend.getMidpoint().x - 100;
				var followY = boyfriend.getMidpoint().y - 100;

				switch (curStage)
				{
					case 'limo':
						followX = boyfriend.getMidpoint().x - 300;
					case 'mall':
						followY = boyfriend.getMidpoint().y - 200;
					case 'school':
						followX = boyfriend.getMidpoint().x - 200;
						followY = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						followX = boyfriend.getMidpoint().x - 200;
						followY = boyfriend.getMidpoint().y - 200;
					case 'miaStadium':
						followX = boyfriend.getMidpoint().x - 260;
						followY = dad.getMidpoint().y - 235;
					case 'spooky':
						followX = boyfriend.getMidpoint().x - 250;
						followY = dad.getMidpoint().y - 450;
					case 'station':
						followX = boyfriend.getMidpoint().x - 375;
						followY = dad.getMidpoint().y - 275;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}

				camTween = FlxTween.tween(camFollow, {x: followX, y: followY}, 1.95, {ease: FlxEase.quintOut});
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.05);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.05);
		}
		FlxG.watch.addQuick("totalBeats: ", totalBeats);
		FlxG.watch.addQuick("conductorPos: ", Conductor.songPosition);	// (tsg - 7/30/21) small things lyric system port

		if (curSong == 'Fresh')
		{
			switch (totalBeats)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
					dadBeats = [0, 2];
					bfBeats = [1, 3];
				case 48:
					gfSpeed = 1;
					dadBeats = [0, 1, 2, 3];
					bfBeats = [0, 1, 2, 3];
				case 80:
					gfSpeed = 2;
					dadBeats = [0, 2];
					bfBeats = [1, 3];
				case 112:
					gfSpeed = 1;
					dadBeats = [0, 1, 2, 3];
					bfBeats = [0, 1, 2, 3];
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		/*if (curSong == 'Bopeebo')
		{
			switch (totalBeats)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}*/
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET && !startingSong)
		{
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, camFollow.getScreenPosition().x, camFollow.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				/*if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}*/

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;
					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					//trace("DA ALT THO?: " + SONG.notes[Math.floor(curStep / 16)].altAnim);

					if(dad.canAutoAnim){
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
					}
					
					
					if(daNote.noteStyle == 1){
						dad.playAnim('cock', true);
					}

					if(daNote.noteStyle == 2){
						dad.playAnim('shoot', true);
						camGame.shake(0.02,0.5);
						camHUD.shake(0.02,0.2);
					}

					enemyStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(daNote.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						}
					});

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.destroy();
				}
				if (daNote.mustPress && daNote.wasGoodHit && botplay)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;
					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					//trace("DA ALT THO?: " + SONG.notes[Math.floor(curStep / 16)].altAnim);

					if(dad.canAutoAnim){
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								boyfriend.playAnim('singUP' + altAnim, true);
							case 3:
								boyfriend.playAnim('singRIGHT' + altAnim, true);
							case 1:
								boyfriend.playAnim('singDOWN' + altAnim, true);
							case 0:
								boyfriend.playAnim('singLEFT' + altAnim, true);
						}
					}

					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(daNote.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						}
					});

					boyfriend.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.destroy();
				}

				if(Config.downscroll){
					daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
				else {
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));


				//MOVE NOTE TRANSPARENCY CODE BECAUSE REASONS 
				if(daNote.tooLate){

					if (daNote.alpha > 0.3){

						if(Config.newInput){
							noteMiss(daNote.noteData, 0.055, false, true);
							vocals.volume = 0;
						}

						daNote.alpha = 0.3;
		
					}

				}

				//Guitar Hero Type Held Notes
				if(Config.newInput && daNote.isSustainNote && daNote.mustPress){

					if(daNote.prevNote.tooLate){
						daNote.tooLate = true;
						daNote.destroy();
					}
	
					if(daNote.prevNote.wasGoodHit){
						
						var upP = controls.UP;
						var rightP = controls.RIGHT;
						var downP = controls.DOWN;
						var leftP = controls.LEFT;
	
						switch(daNote.noteData){
							case 0:
								if(!leftP){
									noteMiss(0, 0.03, true, true);
									vocals.volume = 0;
									daNote.tooLate = true;
									daNote.destroy();
								}
							case 1:
								if(!downP){
									noteMiss(1, 0.03, true, true);
									vocals.volume = 0;
									daNote.tooLate = true;
									daNote.destroy();
								}
							case 2:
								if(!upP){
									noteMiss(2, 0.03, true, true);
									vocals.volume = 0;
									daNote.tooLate = true;
									daNote.destroy();
								}
							case 3:
								if(!rightP){
									noteMiss(3, 0.03, true, true);
									vocals.volume = 0;
									daNote.tooLate = true;
									daNote.destroy();
								}
						}
					}
				}

				if (Config.downscroll ? (daNote.y > strumLine.y + daNote.height + 50) : (daNote.y < strumLine.y - daNote.height - 50))
				{
					if(Config.newInput){

						if (daNote.tooLate && !daNote.isEnd){
								
							daNote.active = false;
							daNote.visible = false;
			
							daNote.destroy();
		
						}

					}
					else{

						if (daNote.tooLate || !daNote.wasGoodHit){
							
							health -= 0.0475;
							misses += 1;
							updateAccuracy();
							vocals.volume = 0;
						}
		
						daNote.active = false;
						daNote.visible = false;
		
						daNote.destroy();

					}
					
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		//FlxG.camera.followLerp = 0.04 * (6 / Main.fpsDisplay.currentFPS); 
	} catch (e:Dynamic) {
    logError("Erro no update: " + Std.string(e));
}
	}
	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		#if mobile
	    mcontrols.visible = false;
	    #end
		FlxG.sound.music.stop();
		vocals.stop();
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}
		
		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{

				

		var hasD = false;
		try {
            if (Assets.exists("data/" + SONG.song.toLowerCase() + "/post" + SONG.song.toLowerCase() + ".txt")) {
                hasD = true;
                var text = Assets.getText("data/" + SONG.song.toLowerCase() + "/post" + SONG.song.toLowerCase() + ".txt");
                dialogue = text != null ? text.split("\n") : [];
                trace("End dialogue loaded: " + dialogue);
            } else {
                hasD = false;
                dialogue = [];
                trace("End dialogue file not found");
            }
        } catch(e) {
            hasD = false;
            dialogue = [];
            trace("Error loading end dialogue: " + e);
        }
				
				
				if (hasD){//if it does, do end dialogue
					var doof2:DialogueBox = new DialogueBox(false, dialogue);
					doof2.scrollFactor.set();
					startingSong = true;
					startedCountdown = false;
					Conductor.songPosition = 0;
						
						
					doof2.finishThing = function(){
						FlxG.sound.playMusic("assets/music/klaskiiLoop.ogg", 0.75);
						FlxG.switchState(new StoryMenuState());
					};
					
					
					add(doof2);
					doof2.cameras = [camHUD];
				}else{//if not just leave : /
				FlxG.sound.playMusic("assets/music/klaskiiLoop.ogg", 0.75);
					FlxG.switchState(new StoryMenuState());
				}

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = '';

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				if (storyDifficulty == 3)
					difficulty = '-getreal';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play('assets/sounds/Lights_Shut_off' + TitleState.soundExt);
				}

				if (SONG.song.toLowerCase() == 'senpai')
				{
					transIn = null;
					transOut = null;
					prevCamFollow = camFollow;
				}

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				FlxG.switchState(new PlayState());

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * Conductor.shitZone)
			{
				daRating = 'shit';
				if(Config.accuracy == "complex") {
					totalNotesHit += 1 - Conductor.shitZone;
				}
				else {
					totalNotesHit += 1;
				}
				score = 50;
			}
		else if (noteDiff > Conductor.safeZoneOffset * Conductor.badZone)
			{
				daRating = 'bad';
				score = 100;
				if(Config.accuracy == "complex") {
					totalNotesHit += 1 - Conductor.badZone;
				}
				else {
					totalNotesHit += 1;
				}
			}
		else if (noteDiff > Conductor.safeZoneOffset * Conductor.goodZone)
			{
				daRating = 'good';
				if(Config.accuracy == "complex") {
					totalNotesHit += 1 - Conductor.goodZone;
				}
				else {
					totalNotesHit += 1;
				}
				score = 200;
			}
		if (daRating == 'sick')
			totalNotesHit += 1;
	
		//trace('hit ' + daRating);

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic('assets/images/' + pixelShitPart1 + daRating + pixelShitPart2 + ".png");
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + pixelShitPart1 + 'combo' + pixelShitPart2 + '.png');
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2 + '.png');
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyCheck():Void{

		upTime = controls.UP ? upTime + 1 : 0;
		downTime = controls.DOWN ? downTime + 1 : 0;
		leftTime = controls.LEFT ? leftTime + 1 : 0;
		rightTime = controls.RIGHT ? rightTime + 1 : 0;

		upPress = upTime == 1;
		downPress = downTime == 1;
		leftPress = leftTime == 1;
		rightPress = rightTime == 1;

		upRelease = upHold && upTime == 0;
		downRelease = downHold && downTime == 0;
		leftRelease = leftHold && leftTime == 0;
		rightRelease = rightHold && rightTime == 0;

		upHold = upTime > 0;
		downHold = downTime > 0;
		leftHold = leftTime > 0;
		rightHold = rightTime > 0;

		/*THE FUNNY 4AM CODE!
		trace((leftHold?(leftPress?"^":"|"):(leftRelease?"^":" "))+(downHold?(downPress?"^":"|"):(downRelease?"^":" "))+(upHold?(upPress?"^":"|"):(upRelease?"^":" "))+(rightHold?(rightPress?"^":"|"):(rightRelease?"^":" ")));
		I should probably remove this from the code because it literally serves no purpose, but I'm gonna keep it in because I think it's funny.
		It just sorta prints 4 lines in the console that look like the arrows being pressed. Looks something like this:
		====
		^  | 
		| ^|
		| |^
		^ |
		====*/

	}


	private function keyShit():Void
	{

		var controlArray:Array<Bool> = [leftPress, downPress, upPress, rightPress];

		if ((upPress || rightPress || downPress || leftPress) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);

					if(Config.noRandomTap)
						setCanMiss();
				}

			});

			var directionsAccounted = [false,false,false,false];

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (inRange(possibleNotes[0].strumTime, possibleNotes[1].strumTime, 4))
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData] && !directionsAccounted[coolNote.noteData])
							{
								goodNoteHit(coolNote);
								directionsAccounted[coolNote.noteData] = true;
							}
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList){
									badNoteCheck();
								}
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						if (controlArray[daNote.noteData] && !directionsAccounted[daNote.noteData])
						{
							goodNoteHit(daNote);
							directionsAccounted[daNote.noteData] = true;
						}
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData] && !directionsAccounted[coolNote.noteData] && !coolNote.isSustainNote)
							{
								goodNoteHit(coolNote);
								directionsAccounted[coolNote.noteData] = true;
							}
						}
					}
				}
				else // regular notes?
				{
					if (controlArray[daNote.noteData] && !directionsAccounted[daNote.noteData])
					{
						goodNoteHit(daNote);
						directionsAccounted[daNote.noteData] = true;
					}
				}
				/* 
					if (controlArray[daNote.noteData])
						goodNoteHit(daNote);
				 */
				// trace(daNote.noteData);
				/* 
					switch (daNote.noteData)
					{
						case 2: // NOTES YOU JUST PRESSED
							if (upP || rightP || downP || leftP)
								noteCheck(upP, daNote);
						case 3:
							if (upP || rightP || downP || leftP)
								noteCheck(rightP, daNote);
						case 1:
							if (upP || rightP || downP || leftP)
								noteCheck(downP, daNote);
						case 0:
							if (upP || rightP || downP || leftP)
								noteCheck(leftP, daNote);
					}
				 */
				/*if (daNote.wasGoodHit && !daNote.isSustainNote)
				{
					daNote.destroy();
				}*/
			}
			else
			{
				badNoteCheck();
			}
		}
		
		notes.forEachAlive(function(daNote:Note)
		{
			if ((upHold || rightHold || downHold || leftHold) && !boyfriend.stunned && generatedMusic){
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{

					boyfriend.holdTimer = 0;

					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 2:
							if (upHold)
								goodNoteHit(daNote);
						case 3:
							if (rightHold)
								goodNoteHit(daNote);
						case 1:
							if (downHold)
								goodNoteHit(daNote);
						case 0:
							if (leftHold)
								goodNoteHit(daNote);
					}
				}
			}

			//Guitar Hero Type Held Notes
			if(daNote.isSustainNote && daNote.mustPress){

				if(daNote.prevNote.tooLate && !daNote.prevNote.wasGoodHit){
					daNote.tooLate = true;
					daNote.destroy();
				}

				if(daNote.prevNote.wasGoodHit && !daNote.wasGoodHit){

					switch(daNote.noteData){
						case 0:
							if(leftRelease){
								noteMissWrongPress(daNote.noteData, 0.0475);
								vocals.volume = 0;
								daNote.tooLate = true;
								daNote.destroy();
								boyfriend.holdTimer = 0;
							}
						case 1:
							if(downRelease){
								noteMissWrongPress(daNote.noteData, 0.0475);
								vocals.volume = 0;
								daNote.tooLate = true;
								daNote.destroy();
								boyfriend.holdTimer = 0;
							}
						case 2:
							if(upRelease){
								noteMissWrongPress(daNote.noteData, 0.0475);
								vocals.volume = 0;
								daNote.tooLate = true;
								daNote.destroy();
								boyfriend.holdTimer = 0;
							}
						case 3:
							if(rightRelease){
								noteMissWrongPress(daNote.noteData, 0.0475);
								vocals.volume = 0;
								daNote.tooLate = true;
								daNote.destroy();
								boyfriend.holdTimer = 0;
							}
					}
				}
			}
		});

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !upHold && !downHold && !rightHold && !leftHold)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing'))
				boyfriend.idleEnd();
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 2:
					if (upPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!upHold)
						spr.animation.play('static');
				case 3:
					if (rightPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!rightHold)
						spr.animation.play('static');
				case 1:
					if (downPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!downHold)
						spr.animation.play('static');
				case 0:
					if (leftPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!leftHold)
						spr.animation.play('static');
			}

			switch(spr.animation.curAnim.name){

				case "confirm":

					//spr.alpha = 1;
					spr.centerOffsets();

					if(!curStage.startsWith('school')){
						spr.offset.x -= 14;
						spr.offset.y -= 14;
					}

				/*case "static":
					spr.alpha = 0.5; //Might mess around with strum transparency in the future or something.
					spr.centerOffsets();*/

				default:
					//spr.alpha = 1;
					spr.centerOffsets();

			}

		});
	}

	function noteMiss(direction:Int = 1, ?healthLoss:Float = 0.1, ?playAudio:Bool = true, ?skipInvCheck:Bool = false):Void
	{
		if (!boyfriend.stunned && !startingSong && (!boyfriend.invuln || skipInvCheck) )
		{
			health -= healthLoss;
			if (combo > 5)
			{
				gf.playAnim('sad');
			}
			misses += 1;
			combo = 0;

			songScore -= 100;
			
			if(playAudio){
				FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));
			}
			// FlxG.sound.play('assets/sounds/missnote1' + TitleState.soundExt, 1, false);
			// FlxG.log.add('played imss note');

			if(Config.newInput)
				setBoyfriendInvuln(0.08);
			else
				setBoyfriendStunned();

			if(boyfriend.canAutoAnim){
				switch (direction)
				{
					case 2:
						boyfriend.playAnim('singUPmiss', true);
					case 3:
						boyfriend.playAnim('singRIGHTmiss', true);
					case 1:
						boyfriend.playAnim('singDOWNmiss', true);
					case 0:
						boyfriend.playAnim('singLEFTmiss', true);
				}
			}

			updateAccuracy();
		}
	}

	function noteMissWrongPress(direction:Int = 1, ?healthLoss:Float = 0.1):Void
		{
			if (!startingSong && !boyfriend.invuln)
			{
				health -= healthLoss;
				if (combo > 5)
				{
					gf.playAnim('sad');
				}
				combo = 0;
	
				songScore -= 25;
				
				FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));
				
				// FlxG.sound.play('assets/sounds/missnote1' + TitleState.soundExt, 1, false);
				// FlxG.log.add('played imss note');
	
				setBoyfriendInvuln(0.04);
	
				if(boyfriend.canAutoAnim){
					switch (direction)
					{
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
					}
				}
			}
		}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if(Config.noRandomTap && !canHit){}
		else{

			switch(Config.newInput){
				case true:
					/* // avoid Unmatched patterns: true
					if (leftP)
						noteMissWrongPress(0);
					if (upP)
						noteMissWrongPress(2);
					if (rightP)
						noteMissWrongPress(3);
					if (downP)
						noteMissWrongPress(1);
					misses++; // this is rozebud being a fuckhead and not making it so an anti-mash miss doesn't actually count as a miss, which is STUPID. 
					*/
					// also this anti-mash thing should go away lol!


				// we have an early hit window, no need for anti-mash on this.

				case false:
					if (leftP)
						noteMiss(0);
					if (upP)
						noteMiss(2);
					if (rightP)
						noteMiss(3);
					if (downP)
						noteMiss(1);

			}
		}
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			{
			goodNoteHit(note);
			}
		else
		{
			badNoteCheck();
		}
	}

	function setBoyfriendInvuln(time:Float = 5 / 60){

		invulnCount++;
		var invulnCheck = invulnCount;

		boyfriend.invuln = true;

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			if(invulnCount == invulnCheck){

				boyfriend.invuln = false;

			}
			
		});

	}

	function setCanMiss(time:Float = 0.185){

		noMissCount++;
		var noMissCheck = noMissCount;

		canHit = true;

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			if(noMissCheck == noMissCount){

				canHit = false;

			}
			
		});

	}

	function setBoyfriendStunned(time:Float = 5 / 60){

		boyfriend.stunned = true;

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			boyfriend.stunned = false;
		});

	}

	function goodNoteHit(note:Note):Void
	{

		//Guitar Hero Styled Hold Notes
		if(Config.newInput && note.isSustainNote && !note.prevNote.wasGoodHit){
			noteMiss(note.noteData, 0.05, true, true);
			note.prevNote.tooLate = true;
			note.prevNote.destroy();
			vocals.volume = 0;
		}

		else if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
			}
			else
				totalNotesHit += 1;

			if (note.noteData >= 0){
				switch(Config.newInput){
					case true:
						health += 0.015 * Config.healthMultiplier;
					case false:
						health += 0.023 * Config.healthMultiplier;
				}
			}
			else{
				switch(Config.newInput){
					case true:
						health += 0.0015 * Config.healthMultiplier;
					case false:
						health += 0.004 * Config.healthMultiplier;
				}
			}
				
			if(boyfriend.canAutoAnim){
				switch (note.noteData)
				{
					case 2:
						boyfriend.playAnim('singUP', true);
					case 3:
						boyfriend.playAnim('singRIGHT', true);
					case 1:
						boyfriend.playAnim('singDOWN', true);
					case 0:
						boyfriend.playAnim('singLEFT', true);
				}
			}

			if(Config.newInput && !note.isSustainNote){
				setBoyfriendInvuln(0.02);
			}
			

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.destroy();
			
			updateAccuracy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play('assets/sounds/carPass' + FlxG.random.int(0, 1) + TitleState.soundExt, 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		if (SONG.needsVoices)
		{
			if (vocals.time > Conductor.songPosition + 20 || vocals.time < Conductor.songPosition - 20)
			{
				resyncVocals();
			}
		}

		/*if (dad.curCharacter == 'spooky' && totalSteps % 4 == 2)
		{
			// dad.dance();
		}*/

		super.stepHit();
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		wiggleShit.update(Conductor.crochet);
		super.beatHit();
		try {

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		for (i in gayBoppers){
			i.animation.play("bop",true);
		}
		
		
		
		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			else
				Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				if(dadBeats.contains(curBeat % 4) && dad.canAutoAnim)
					dad.dance();
			
		}
		else{
			if(dadBeats.contains(curBeat % 4))
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		
		if (SONG.song.toLowerCase() == "school"){
			if (curBeat == 112){
				gay(true);
			}
			if (curBeat == 176){
				gay(false);
			}
		}
		
		
		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat <= 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'milf' && curBeat == 168)
		{
			dadBeats = [0, 1, 2, 3];
			bfBeats = [0, 1, 2, 3];
		}

		if (curSong.toLowerCase() == 'milf' && curBeat == 200)
		{
			dadBeats = [0, 2];
			bfBeats = [1, 3];
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && totalBeats % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curBeat % 1 == 0){
			iconP1.iconScale = iconP1.defualtIconScale * 1.25;
			iconP2.iconScale = iconP2.defualtIconScale * 1.25;

			FlxTween.tween(iconP1, {iconScale: iconP1.defualtIconScale}, 0.2, {ease: FlxEase.quintOut});
			FlxTween.tween(iconP2, {iconScale: iconP2.defualtIconScale}, 0.2, {ease: FlxEase.quintOut});
		}

		if (totalBeats % gfSpeed == 0)
		{
			gf.dance();
		}

		if(bfBeats.contains(curBeat % 4) && boyfriend.canAutoAnim)
			boyfriend.dance();

		if (totalBeats % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);

		}
		
		// if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf')
		// {
			// dad.playAnim('cheer', true);
		// }

		switch (curStage)
		{
			case "school":
				bgGirls.dance();
			case "mall":
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			case "miaStadium":
				frontBoppers.animation.play('bop', true);
				backBoppers.animation.play('bop', true);
			case "limo":
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "station":
				//stationLights.animation.play('bop', true);
				//stationGlow.animation.play('bop', true);
				/*if (!trainMoving)
					trainCooldown += 1;

				if (totalBeats % 4 == 0)
				{
					{
					stationLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, stationLights.length - 1);

					stationLights.members[curLight].visible = true;
					}

					{
					// phillyCityLights.members[curLight].alpha = 1;
					
						stationGlow.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, stationGlow.length - 1);
	
						stationGlow.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
					}
				}

				if (totalBeats % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}*/
		}

		/*if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}*/
		
		} catch (e:Dynamic) {
    logError("Erro no beatHit: " + Std.string(e));
}
	}

	function inRange(a:Float, b:Float, tolerance:Float){
		return (a <= b + tolerance && a >= b - tolerance);
	}

	
	function gay(lgbtqaiPlusRep:Bool = false){
		gayPico = lgbtqaiPlusRep; // :D
		gf.visible = !lgbtqaiPlusRep;
		gayStation.visible = lgbtqaiPlusRep;
		
		for (i in gayBoppers){
			i.visible = !lgbtqaiPlusRep;
		}
		if (gayPico){
				var olddadx = dad.x;
					var olddady = dad.y;
					remove(dad);
					dad = new Character(olddadx, olddady, "picoGAY");
					add(dad);
					
				var oldbfx = boyfriend.x;
					var oldbfy = boyfriend.y;
					remove(boyfriend);
					boyfriend = new Boyfriend(oldbfx, oldbfy, "bfBisexual");
					add(boyfriend);
					
		}else{
				var olddadx = dad.x;
					var olddady = dad.y;
					remove(dad);
					dad = new Character(olddadx, olddady, "pico");
					add(dad);
					
				var oldbfx = boyfriend.x;
					var oldbfy = boyfriend.y;
					remove(boyfriend);
					boyfriend = new Boyfriend(oldbfx, oldbfy, "week3bf");
					add(boyfriend);
					
		}
	}
	
	private static function logError(message:String):Void {
    lastError = message;
    if (FlxG.state is PlayState) {
        var playState:PlayState = cast FlxG.state;
        if (playState.errorLog != null && playState.showErrors) {
            playState.errorLog.text = "Erro: " + message;
        }
    }
    trace("Erro no PlayState: " + message); // Loga no console também, se debug
}
	
	
	var curLight:Int = 0;
}