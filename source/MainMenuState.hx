package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import openfl.Lib;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	

	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if windows 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg1:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu1'));
		bg1.setGraphicSize(Std.int(FlxG.width, FlxG.height));
		bg1.updateHitbox();
		bg1.screenCenter();
		bg1.antialiasing = ClientPrefs.globalAntialiasing;
		bg1.visible = true;
		add(bg1);

		var bg2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu2'));
		bg2.setGraphicSize(Std.int(FlxG.width, FlxG.height));
		bg2.updateHitbox();
		bg2.screenCenter();
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		bg2.visible = false;
		add(bg2);

		var bg3:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu3'));
		bg3.setGraphicSize(Std.int(FlxG.width, FlxG.height));
		bg3.updateHitbox();
		bg3.screenCenter();
		bg3.antialiasing = ClientPrefs.globalAntialiasing;
		bg3.visible = false;
		add(bg3);

		var bg4:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu4'));
		bg4.setGraphicSize(Std.int(FlxG.width, FlxG.height));
		bg4.updateHitbox();
		bg4.screenCenter();
		bg4.antialiasing = ClientPrefs.globalAntialiasing;
		bg4.visible = false;
		add(bg4);

		var bg5:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu4anim'));
		bg5.setGraphicSize(Std.int(FlxG.width, FlxG.height));
		bg5.updateHitbox();
		bg5.screenCenter();
		bg5.antialiasing = ClientPrefs.globalAntialiasing;
		bg5.visible = false;
		add(bg5);

		// Isso é da demo do Haxe K
		var text = new FlxText(0, 0, 0, "NO ROM FOUND", 64);
		text.screenCenter();
		add(text);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
	
		FlxG.camera.follow(camFollowPos, null, 1);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

                #if android
                addVirtualPad(UP_DOWN, A_B);
                #end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);

			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				var amongus:String = curSelected;
				switch (amongus) {

				case '0':
					//FlxG.log.add('NAO TEM ROM VAGABUNDO');
					bg1.visible = true;
					bg2.visible = false;
					bg3.visible = false;
					bg4.visible = false;
					bg5.visible = false;
					norom.visible = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					//omega kek
					new FlxTimer().start(0.5, ()->{
					 norom.visible = false;
					});
				case '1':
						//FlxG.log.add('NAO TEM ROM VAGABUNDO');
						bg2.visible = true;
						bg1.visible = false;
						bg3.visible = false;
						bg4.visible = false;
						bg5.visible = false;
						norom.visible = true;
						
						FlxG.sound.play(Paths.sound('confirmMenu'));
						//omega kek
						new FlxTimer().start(0.5, ()->{
						 norom.visible = false;
						});
						case '2':
							//FlxG.log.add('NAO TEM ROM VAGABUNDO');
							bg3.visible = true;
							bg1.visible = false;
							bg2.visible = false;
							bg4.visible = false;
							bg5.visible = false;
							norom.visible = true;
							
							FlxG.sound.play(Paths.sound('confirmMenu'));
							//omega kek
							new FlxTimer().start(0.5, ()->{
							 norom.visible = false;
							});
							case '3':
								
								PlayState.SONG = Song.loadFromJson('nomoreinnocence-RUN', 'nomoreinnocence');
								Lib.application.window.alert('M.R INNOCENCE\nGOOD LUCK');
								new FlxTimer().start(0.5, ()->{
								LoadingState.loadAndSwitchState(new PlayState());
								});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
