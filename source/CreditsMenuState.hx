package;
#if desktop
import cpp.abi.Abi;
#end
import flixel.graphics.FlxGraphic;
import flixel.FlxCamera;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUIGroup;
import flixel.ui.FlxButton;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import flixel.addons.display.FlxBackdrop;
#if desktop
import Discord.DiscordClient;
#end
using StringTools;
/*
hi cool lil committers looking at this code, 95% of this is my code and I'd appreciate if you didn't steal it without asking for my permission
-vs dave dev T5mpler 
i have to put this here just in case you think of doing so
*/
class CreditsMenuState extends MusicBeatState
{
	var bg:FlxSprite = new FlxSprite();
   var overlay:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/CoolOverlay'));
   var selectedFormat:FlxText;
   var defaultFormat:FlxText;
   var curNameSelected:Int = 0;
   var creditsTextGroup:Array<CreditsText> = new Array<CreditsText>();
   var menuItems:Array<CreditsText> = new Array<CreditsText>();
   var state:State;
   var selectedPersonGroup:FlxSpriteGroup = new FlxSpriteGroup();
   var selectPersonCam:FlxCamera = new FlxCamera();
   var mainCam:FlxCamera = new FlxCamera();
   var transitioning:Bool = false;
   var creditsTypeString:String = '';
   var translatedCreditsType:String = '';

   var StupidCameraFollow:FlxObject = new FlxObject();

   var curSocialMediaSelected:Int = 0;
   var socialButtons:Array<SocialButton> = new Array<SocialButton>();
   var hasSocialMedia:Bool = true;

   public var DoFunnyScroll:Bool = false;
   
   var peopleInCredits:Array<Person> = 
   [
      // Developers //
      new Person("MoldyGH", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCHIvkOUDfbMCv-BEIPGgpmA'), 
         new Social('twitter', 'https://twitter.com/moldy_gh'),
         new Social('soundcloud', 'https://soundcloud.com/moldygh')
      ]),
     
      new Person("MissingTextureMan101", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCCJna2KG54d1604L2lhZINQ'),
         new Social('twitter', 'https://twitter.com/OfficialMTM101'),
         new Social('twitch', 'https://www.twitch.tv/missingtextureman101'),
         new Social('gamebanana', 'https://gamebanana.com/members/1665049')
      ]),
      
      new Person("rapparep lol", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCKfdkmcdFftv4pFWr0Bh45A'),
         new Social('twitter', 'https://twitter.com/rappareplol')
      ]),

      new Person("TheBuilderXD", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/user/99percentMember'),
         new Social('twitter', 'https://twitter.com/TheBuilderXD')
      ]),

      new Person("Erizur", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCdCAaQzt9yOGfFM0gJDJ4bQ'),
         new Social('twitter', 'https://twitter.com/am_erizur')
      ]),
      
      new Person("T5mpler", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCgNoOsE_NDjH6ac4umyADrw'),
         new Social('twitter', 'https://twitter.com/RealT5mpler'),
         new Social('soundcloud', 'https://soundcloud.com/t5mpler')
      ]),
      new Person("Zmac", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCl50Xru1nLBENuLiQBt6VRg')
      ]),
      new Person("pointy", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCRKMTB-VvZlXig4gChk5jtg'),
         new Social('twitter', 'https://twitter.com/PointyyESM')
      ]),
      new Person("Billy Bobbo", CreditsType.Dev,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCWbxUPrpRb3lWFHULkmR0IQ'),
         new Social('twitter', 'https://twitter.com/BillyBobboLOL')
      ]),

      // Translators //
      
      new Person("dani", CreditsType.Translator,
      [
         new Social('youtube', 'https://youtube.com/channel/UCzCcYbUwbtSJcAQH0IZl-pA'),
         new Social('twitter', 'https://twitter.com/danicheese99')
      ]),
      
      new Person("Aizakku", CreditsType.Translator,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCmSCR85PlhbHGHm-wxiA6sA'),
         new Social('twitter', 'https://twitter.com/ItsAizakku')
      ]),
      
      new Person("Soulegal", CreditsType.Translator,
      [
            new Social('youtube', 'https://www.youtube.com/channel/UC7VSf4ITAMN83hL3zQbqt3w'),
            new Social('twitter', 'https://twitter.com/nickstwt')
      ]),
      
      // Contributors //
      new Person("Steph45", CreditsType.Contributor,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UClb4YjR8i74G-ue2nyiH2DQ')
      ]),
      new Person("evdial", CreditsType.Contributor,
      [

      ]),
      new Person("wugalex", CreditsType.Contributor,
      [
         
      ]),
      new Person("Jukebox", CreditsType.Contributor,
      [
         new Social('twitter', 'https://twitter.com/Juk3b0x_'),
         new Social('youtube', 'https://www.youtube.com/channel/UCwA3jnG5cu3toaVCOhc-Tqw'),
      ]),
      
      new Person("Oxygen", CreditsType.Contributor,
      [
         new Social('soundcloud', 'https://soundcloud.com/oxygendude2000'),
         new Social('twitter', 'https://twitter.com/oxygenboi2000'),
         new Social('youtube', 'https://youtube.com/channel/UCgTW7cQcfqduIqlu-bSZGZg')
      ]),
      new Person("Alexander Cooper 19", CreditsType.Contributor,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCNz20AHJq41rkBUsq8RmUfQ'),
         new Social('twitter', 'https://twitter.com/Zander_cooper19')
      ]),
      new Person("Aadsta", CreditsType.Contributor,
      [
         new Social('twitter', 'https://twitter.com/FullNameDeTrain')
      ]),
      new Person("Project Tea", CreditsType.Contributor,
      [
         new Social('youtube', 'https://youtube.com/c/ProjectTea'),
         new Social('discord', 'Project Tea#9139'),
      ]),
      new Person("Top 10 Awesome", CreditsType.Contributor,
      [
         new Social('youtube', 'https://www.youtube.com/c/Top10Awesome')
      ]),
      new Person("BombasticHype", CreditsType.Contributor,
      [  
         new Social ('youtube', 'https://www.youtube.com/c/BombasticHype')
      ]),
      new Person("Sky!", CreditsType.Contributor,
      [  
         new Social ('youtube', 'https://www.youtube.com/c/Grantare'),
      ]),
      new Person("Ruby", CreditsType.Contributor,
      [  
         new Social ('youtube', 'https://youtube.com/c/RubysArt_'),
         new Social ('twitter', 'https://twitter.com/RubysArt_')
      ]),
      new Person("Lancey", CreditsType.Contributor,
      [  
         new Social('youtube', 'https://youtube.com/c/Lancey170'),
         new Social('twitter', 'https://twitter.com/Lancey170')
      ]),
      new Person("Cup", CreditsType.Contributor,
      [  
         new Social('youtube', 'https://youtube.com/channel/UCEeVFDTzxe2K8dMng_7YU7A'),
      ]),
      new Person("ShiftyTM", CreditsType.Contributor,
      [  
         new Social('youtube', 'https://youtube.com/channel/UC8NHfjpy6tNWgnM7889S1Ew'),
      ]),
      
      new Person("Paraso", CreditsType.Contributor,
      [  

      ]),
      new Person("SAMMYPIGZY", CreditsType.Contributor,
      [  
         new Social('youtube', 'https://www.youtube.com/channel/UCVbNlXsQ-9WA2WcN8u2se_Q'),
         new Social('twitter', 'https://twitter.com/TH3_R34L_D34L')
      ]),
      
      new Person("R34LD34L", CreditsType.Contributor,
      [  

      ]),
      
      new Person("Devianator", CreditsType.Contributor,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCcaYOWO98UIsJ54t_aV6JHw'),
         new Social('twitter', 'https://twitter.com/devianator404')
      ]),
      
      new Person("sk0rbias", CreditsType.Contributor,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCTz8DmuC85UN_nspzp3d_VA'),
         new Social('twitter', 'https://twitter.com/sk0rbias')
      ]),
      new Person("Your mom", CreditsType.Contributor,
      [  
         new Social('youtube', 'https://www.youtube.com/channel/UCeYxPL7ClfwXOOrpbtqJ13g'),
      ]),

      new Person("sibottle", CreditsType.Contributor,
      [  
         new Social('youtube', 'https://www.youtube.com/channel/UCqFkjwmaYlnVXwLMw3_AXLA'),
      ]),

      new Person("chromasen", CreditsType.Contributor,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCgGk4oZt3We-ktkEOV9HY1Q'),
      ]),

      // Beta Testers //
      new Person("letsy", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCPsNWR6RYLRvpDZinADtJ8w'),
         new Social('twitter', 'https://twitter.com/Iesty19'),
         new Social('discord', 'ietsy#5140')
      ]),
      new Person("wildy", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCrUhQeLDv7lpZifWfPr4uGQ'),
         new Social('twitter', 'https://twitter.com/wildythomas1233')
         
      ]),

      new Person("peejeada", CreditsType.BetaTester,
      [
         new Social('twitter', 'https://twitter.com/tailsmaster1')
      ]),
      
      new Person("bendygaming_1", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCDgAtfpjDW1F2LAk6LzgavA')
      ]),
      new Person("YourAverageMental", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCDgAtfpjDW1F2LAk6LzgavA')
      ]),
      new Person("vex", CreditsType.BetaTester,
      [
         new Social('twitter', 'https://twitter.com/vex________')
      ]),
      new Person("xml", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCL5UPJDEFDZLo4D62pcmIBQ'),
         new Social('twitter', 'https://twitter.com/AstrayFile')
      ]),
      
      new Person("ztgds", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCUmuZE0RPjvUhB036T6omfQ')
      ]),
      new Person("ashtonyes", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCQkB-JEx7OGdOUxPzcgUkkQ'),
         new Social('gamebanana', 'https://gamebanana.com/members/1943292')
      ]),
      new Person("Silver Escaper", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCP9McVE9T5K3pzum48-m6Tg'),
         new Social('roblox', 'https://www.roblox.com/users/2546405173/profile'),
         new Social('discord', 'Silver Escaper#8220')
      ]),

      new Person("TrustVVorthy", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UC_lJmvYgeAwzcYaeYXlZ7vg')
      ]),
      
      new Person("Gorbini", CreditsType.BetaTester,
      [
         new Social("youtube", 'https://www.youtube.com/channel/UC1u46mYMoecfO04dm-9Djjg')
      ]),

      new Person("Log Man", CreditsType.BetaTester,
      [
         new Social('twitter', 'https://twitter.com/LogManLoggy'),
         new Social('youtube', 'https://www.youtube.com/channel/UCnGg-cLnXuQNfSzIq6xF8hw'),
      ]),

      new Person("Mooncakeez", CreditsType.BetaTester, 
      [
         new Social('youtube', 'https://www.youtube.com/channel/UC6lOrY3AkmXWFpaLHwlP-5A')
      ]),
      
      new Person("Foxnap", CreditsType.BetaTester,
      [
         new Social("youtube", 'https://www.youtube.com/channel/UCFMq8C3d6QvZlzR8vBBnITg'),
         new Social('twitter', 'https://twitter.com/Foxnap2')
      ]),
      
      new Person("lotuswaterz", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCf0Y-SfRxhrVnggHwwz1CnA'),
         new Social('twitter', 'https://twitter.com/NIHIILISTIC'),
      ]),

      new Person("mantis", CreditsType.BetaTester,
      [
         new Social('discord', 'mantis#6969')
      ]),
      
      new Person("ArturSef", CreditsType.BetaTester, 
      [  
         new Social('gamebanana', 'https://gamebanana.com/members/1766076')
      ]),
      
      new Person("normal", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UC21TRNz6llg8a6-ur4dSBtw'),
         new Social('roblox', 'https://www.roblox.com/users/1368920745')
      ]),

      new Person("Rendurse", CreditsType.BetaTester,
      [
         new Social('twitter', 'https://twitter.com/RendurseDev')
      ]),
      new Person("Lordryan1999", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UCEdSlV8RvVnEd8w_yQz-Feg'),
         new Social('twitter', 'https://twitter.com/lr1999_baldi')
      ]),
      new Person("Vanquiler", CreditsType.BetaTester,
      [
         new Social('discord', 'Vanquiler#3026'),
         new Social('twitch', 'https://www.twitch.tv/vanquiler'),
         new Social('roblox', 'https://www.roblox.com/users/1505830747')
      ]),
      new Person("Villezen", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/c/Villezen')
      ]),
      new Person("TecheVent", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/c/Villezen')
      ]),
      new Person("miko", CreditsType.BetaTester,
      [
         new Social('youtube', 'https://www.youtube.com/channel/UC3mIybwSekVs5VEJSe2yjog')
      ]),
      new Person("Cotiles", CreditsType.BetaTester,
      [
         new Social('twitter', 'https://twitter.com/Ctiles1'),
         new Social('youtube', 'https://www.youtube.com/channel/UClNnrTqtgzAQ16w4_eC7rwA'),
      ]),
	  // Special Thanks //
     new Person("You!", CreditsType.SpecialThanks, [])
   ];

	override function create()
	{
      #if desktop
      DiscordClient.changePresence("In the Credits Menu", null);
      #end

      mainCam.bgColor.alpha = 0;
      selectPersonCam.bgColor.alpha = 0;
      FlxG.cameras.reset(mainCam);
      FlxG.cameras.add(selectPersonCam);

      FlxCamera.defaultCameras = [mainCam];
      selectedPersonGroup.cameras = [selectPersonCam];

      state = State.SelectingName;
      defaultFormat = new FlxText().setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      defaultFormat.borderSize = 2;
      defaultFormat.borderQuality = 2;
      selectedFormat = new FlxText().setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      selectedFormat.borderSize = 2;
      selectedFormat.borderQuality = 2;

      if (!DoFunnyScroll)
      {
         bg.loadGraphic(MainMenuState.randomizeBG());
         bg.color = FlxColor.LIME;
         bg.scrollFactor.set();
         add(bg);


         overlay.color = FlxColor.LIME;
         overlay.scrollFactor.set();
         add(overlay);
      }
      else
      {
         FlxG.sound.playMusic(Paths.music('creditsTheme'));
         //PLACEHOLDER.
         bg.loadGraphic(MainMenuState.randomizeBG());
         bg.color = FlxColor.GRAY;
         bg.scrollFactor.set();
         add(bg);
      }
      
      var developers:Array<Person> = new Array<Person>();
      var translators:Array<Person> = new Array<Person>();
      var contributors:Array<Person> = new Array<Person>();
      var betaTesters:Array<Person> = new Array<Person>();
      var specialThanks:Array<Person> = new Array<Person>();

      for (person in peopleInCredits) 
      {
         switch (person.creditsType)
         {
            case Dev: developers.push(person);
            case Translator: translators.push(person);
            case Contributor: contributors.push(person);
            case BetaTester: betaTesters.push(person);
            case SpecialThanks: specialThanks.push(person);
         }
      }

      for (i in 0...peopleInCredits.length)
      {
         var currentPerson = peopleInCredits[i];
         if (currentPerson == developers[0] || currentPerson == translators[0] || currentPerson == contributors[0] || currentPerson == betaTesters[0] || currentPerson == specialThanks[0])
         {
            switch (currentPerson.creditsType)
            {
               case Dev:
                  creditsTypeString = 'Developers';
                  translatedCreditsType = LanguageManager.getTextString('credits_dev');
               case Translator:
                  creditsTypeString = 'Translators';
                  translatedCreditsType = LanguageManager.getTextString('credits_translator');
               case Contributor:
                  creditsTypeString = 'Contributors';
				  translatedCreditsType = LanguageManager.getTextString('credits_contributor');
               case BetaTester:
                  creditsTypeString = 'Beta Testers';
                  translatedCreditsType = LanguageManager.getTextString('credits_betaTester');
               case SpecialThanks:
                  creditsTypeString = 'Special Thanks';
                  translatedCreditsType = LanguageManager.getTextString('credits_specialThanks');
            }
            var titleText:FlxText = new FlxText(0, 0, 0, translatedCreditsType);
            titleText.setFormat("Comic Sans MS Bold", 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            titleText.borderSize = 3;
            titleText.borderQuality = 3;
            titleText.screenCenter(X);
            titleText.antialiasing = true;
            titleText.scrollFactor.set(0, 1);
            if (DoFunnyScroll)
            {
               titleText.color = FlxColor.PURPLE;
            }

            var personIcon:PersonIcon = new PersonIcon(titleText);
            personIcon.loadGraphic(Paths.image('credits/titles/' + creditsTypeString));
            personIcon.visible = !DoFunnyScroll;
            add(personIcon);
            
            var creditsTextTitleText = new CreditsText(titleText, false, personIcon);
            creditsTextGroup.push(creditsTextTitleText);
            add(titleText);
         }

         var textItem:FlxText = new FlxText(0, i * 50, 0, currentPerson.name, 32);
         textItem.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color, defaultFormat.alignment, defaultFormat.borderStyle, defaultFormat.borderColor);
         textItem.screenCenter(X);
		   textItem.antialiasing = true;
         textItem.scrollFactor.set(0, 1);

         var personIcon:PersonIcon = new PersonIcon(textItem);
         personIcon.loadGraphic(Paths.image('credits/icons/' + creditsTypeString + '/' + currentPerson.name));
         add(personIcon);

         personIcon.visible = !DoFunnyScroll;
         personIcon.antialiasing = true;

         var creditsTextItem:CreditsText = new CreditsText(textItem, true, personIcon);

         add(textItem);
         creditsTextGroup.push(creditsTextItem);
         menuItems.push(creditsTextItem);
      }
      
      var selection = 0;
      
      changeSelection();
      
      for (creditsText in creditsTextGroup)
      {
         creditsText.selectionId = selection - curNameSelected;
         selection++;  
      }
      for (creditsText in creditsTextGroup)
      {
         var scaledY = FlxMath.remapToRange(creditsText.selectionId, 0, 1, 0, 1.5);
         creditsText.text.y = scaledY * 75 + (FlxG.height * 0.5);
      }

      StupidCameraFollow.x = menuItems[0].text.x;
      StupidCameraFollow.y = menuItems[0].text.y - 460; //so close yet so far from having the offset be 420 :(
      if (DoFunnyScroll)
      {
         //(FlxG.sound.music.length / 1000) - 15
         FlxTween.tween(StupidCameraFollow, {y : (menuItems[menuItems.length - 1].text.y + 440)}, (FlxG.sound.music.length / 1000) - 10.5, {ease: FlxEase.linear, onComplete: function(tween:FlxTween)
         {
            var logoBl:FlxSprite = new FlxSprite(StupidCameraFollow.x, StupidCameraFollow.y);
            logoBl.frames = Paths.getSparrowAtlas('ui/logoBumpin');
            logoBl.antialiasing = true;
            logoBl.alpha = 0;
            logoBl.x -= logoBl.width / 2;
            logoBl.y -= logoBl.height / 2;
            add(logoBl);
            FlxTween.tween(logoBl, {alpha: 1}, 5.6, {ease: FlxEase.quadIn, onComplete: function(tween:FlxTween)
            {
               new FlxTimer().start((FlxG.sound.music.length / 1000) - (FlxG.sound.music.time / 1000), function(timer:FlxTimer)
               {
			      if (!FlxG.save.data.hasSeenCreditsMenu)
				  {
				     FlxG.save.data.hasSeenCreditsMenu = true;
					 FlxG.save.flush();
				  }
                  FlxG.sound.playMusic(Paths.music('theend'));
                  FlxG.switchState(new StoryMenuState());
               });
            }});
         }});
      }
		super.create();
	}
   
   override function update(elapsed:Float)
   {

      var fadeTimer:Float = 0.08;
      var upPressed = controls.UP_P;
		var downPressed = controls.DOWN_P;
		var back = controls.BACK;
		var accept = controls.ACCEPT;
      if (DoFunnyScroll)
      {
         FlxG.camera.follow(StupidCameraFollow, 0.1);
         super.update(elapsed);
         if (back && FlxG.save.data.hasSeenCreditsMenu)
         {
            //make sure they get the epic song no matter what
            FlxG.sound.playMusic(Paths.music('theend'));
            FlxG.switchState(new StoryMenuState());
         }
         return;
      }
      switch (state)
      {
         case State.SelectingName:
			   if (upPressed)
				{
               changeSelection(-1);
				}
				if (downPressed)
				{
               changeSelection(1);
            }
				if (back)
				{
					FlxG.switchState(new MainMenuState());
				}
				if (accept && !transitioning)
				{
               transitioning = true;
               for (creditsText in creditsTextGroup)
               {
                  FlxTween.tween(creditsText.text, {alpha: 0}, fadeTimer);
                  FlxTween.tween(creditsText.icon, {alpha: 0}, fadeTimer);
                  if (creditsText == creditsTextGroup[creditsTextGroup.length - 1])
                  {
                     FlxTween.tween(creditsText.text, {alpha: 0}, fadeTimer, 
                     {
                        onComplete: function(tween:FlxTween)
                        {
                           FlxCamera.defaultCameras = [selectPersonCam];
                           selectPerson(peopleInCredits[curNameSelected]);
                        }
                     });
                  }
               }
				}
         case State.OnName:
            if (back && !transitioning)
            {
               transitioning = true; 
               for (item in selectedPersonGroup)
               {
                  FlxTween.tween(item, {alpha: 0}, fadeTimer);
                  if (item == selectedPersonGroup.members[selectedPersonGroup.members.length - 1])
                  {
                     FlxTween.tween(item, {alpha: 0}, fadeTimer,
                     { 
                        onComplete: function (tween:FlxTween) 
                        {
                           selectedPersonGroup.forEach(function(spr:FlxSprite)
                           {
                              remove(selectedPersonGroup.remove(spr, true));
                           });
                           for (i in 0...socialButtons.length) 
                           {
                              socialButtons.remove(socialButtons[i]);
                           }
                           FlxCamera.defaultCameras = [mainCam];
                           for (creditsText in creditsTextGroup)
                           {
                              FlxTween.tween(creditsText.text, {alpha: 1}, fadeTimer);
                              FlxTween.tween(creditsText.icon, {alpha: 1}, fadeTimer);
                              if (creditsText == creditsTextGroup[creditsTextGroup.length - 1])
                              {
                                 FlxTween.tween(creditsText.text, {alpha: 1}, fadeTimer, 
                                 {
                                    onComplete: function(tween:FlxTween)
                                    {
                                       selectedPersonGroup = new FlxSpriteGroup();
                                       socialButtons = new Array<SocialButton>();
                                       FlxG.mouse.visible = false;
                                       transitioning = false;
                                       state = State.SelectingName;
                                    }
                                 });
                              }
                           }
                        }
                     });
                  }
               }
            }
            if (hasSocialMedia)
            {
               if (upPressed)
               {
                    changeSocialMediaSelection(-1);
               }
               if (downPressed)
               {
                  changeSocialMediaSelection(1);
               }
               if (accept)
               {
                  var socialButton = socialButtons[curSocialMediaSelected];
                  if (socialButton != null && socialButton.socialMedia.socialMediaName != 'discord')
                  {
                     FlxG.openURL(socialButton.socialMedia.socialLink);
                  }
               }
            }
      }
      
      super.update(elapsed);
   }

   function changeSelection(amount:Int = 0)
   {
      if (amount != 0)
      {
         FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
         curNameSelected += amount;
      }
      if (curNameSelected > peopleInCredits.length - 1)
      {
         curNameSelected = 0;
      }
      if (curNameSelected < 0)
      {
         curNameSelected = peopleInCredits.length - 1;
      }
      FlxG.camera.follow(menuItems[curNameSelected].text, 0.1);
      updateText(curNameSelected);
   }
   function changeSocialMediaSelection(amount:Int = 0)
   {
      if (amount != 0)
      {
         FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
         curSocialMediaSelected += amount;
      }
      if (curSocialMediaSelected > socialButtons.length - 1)
      {
         curSocialMediaSelected = 0;
      }
      if (curSocialMediaSelected < 0)
      {
         curSocialMediaSelected = socialButtons.length - 1;
      }
      updateSocialMediaUI();
   }

   function updateText(index:Int)
   {
      if (DoFunnyScroll)
      {
         return;
      }
      var currentText:FlxText = menuItems[index].text;
      if (menuItems[index].menuItem)
      {
		   currentText.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, 
            selectedFormat.borderColor);
         currentText.color = FlxColor.YELLOW;
         currentText.borderSize = selectedFormat.borderSize;
         currentText.borderQuality = selectedFormat.borderQuality;
      }
		for (i in 0...menuItems.length)
		{
         if (menuItems[i] == menuItems[curNameSelected])
         {
            continue;
         }
			var currentText:FlxText = menuItems[i].text;
         currentText.color = FlxColor.WHITE;
			currentText.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color, defaultFormat.alignment, defaultFormat.borderStyle,
				defaultFormat.borderColor);
			currentText.screenCenter(X);
		}
   }
   function updateSocialMediaUI()
   {
      if (hasSocialMedia)
      {
         for (socialButton in socialButtons)
         {
            var isCurrentSelected = socialButton == socialButtons[curSocialMediaSelected];
            if (isCurrentSelected)
            {
               fadeSocialMedia(socialButton, 1);
            }
            else
            {
               fadeSocialMedia(socialButton, 0.3);
            }
         }
      }
   }
   function fadeSocialMedia(socialButton:SocialButton, amount:Float)
   {
      for (i in 0...socialButton.graphics.length) 
      {
         var graphic:FlxSprite = socialButton.graphics[i];
         graphic.alpha = amount;
      }
   }

   function selectPerson(selectedPerson:Person)
   {
      curSocialMediaSelected = 0;
      var fadeTime:Float = 0.4;
      var blackBg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
      blackBg.screenCenter(X);
      blackBg.updateHitbox();
      blackBg.scrollFactor.set();
      blackBg.active = false;

      var personName:FlxText = new FlxText(0, 100, 0, selectedPerson.name, 50);
      personName.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
      personName.screenCenter(X);
      personName.updateHitbox();
	   personName.antialiasing = true;
      personName.scrollFactor.set();
      personName.active = false;
      
      var credits:FlxText = new FlxText(0, personName.y + 50, FlxG.width / 1.25, LanguageManager.getTextString('credit_${selectedPerson.name}'), 25);
      credits.setFormat(selectedFormat.font, selectedFormat.size, selectedFormat.color, selectedFormat.alignment, selectedFormat.borderStyle, selectedFormat.borderColor);
      credits.screenCenter(X);
      credits.updateHitbox();
	  credits.antialiasing = true;
      credits.scrollFactor.set();
      credits.active = false;

      blackBg.alpha = 0;
      personName.alpha = 0;
      credits.alpha = 0;
      
      selectedPersonGroup.add(blackBg);
      selectedPersonGroup.add(personName);
      selectedPersonGroup.add(credits);

      add(blackBg);
      add(personName);
      add(credits);

      FlxTween.tween(blackBg, { alpha: 0.7 }, fadeTime);
      FlxTween.tween(personName, { alpha: 1 }, fadeTime);
      FlxTween.tween(credits, { alpha: 1 }, fadeTime, { onComplete: function(tween:FlxTween)
      {
         if (selectedPerson.socialMedia.length == 0)
         {
            transitioning = false;
            state = State.OnName;
         }
      }});
      
      for (i in 0...selectedPerson.socialMedia.length)
      {
         var social:Social = selectedPerson.socialMedia[i];
         var socialGraphic:FlxSprite = new FlxSprite(0, credits.y + 100 + (i * 100)).loadGraphic(Paths.image('credits/socialMedia/' + social.socialMediaName));
         var discordText:FlxText = null;
         socialGraphic.updateHitbox();
         socialGraphic.screenCenter(X);
         socialGraphic.scrollFactor.set();
         socialGraphic.active = false;
         socialGraphic.alpha = 0;
         add(socialGraphic);

         if (social.socialMediaName == 'discord')
         {
            var offsetY:Float = 20;
            discordText = new FlxText(socialGraphic.x + 100, socialGraphic.y + (i * 100) + offsetY, 0, social.socialLink, 40);
            discordText.setFormat(defaultFormat.font, defaultFormat.size, defaultFormat.color, defaultFormat.alignment, defaultFormat.borderStyle, defaultFormat.borderColor);
            discordText.alpha = 0;
            discordText.updateHitbox();
            discordText.scrollFactor.set();
			discordText.antialiasing = true;
            discordText.active = false;
            add(discordText);
            FlxTween.tween(discordText, { alpha: 1 }, fadeTime);
            selectedPersonGroup.add(discordText);
         }

         var socialButton:SocialButton;
         
         if (discordText != null)
         {
            socialButton = new SocialButton([socialGraphic, discordText], social);
         }
         else
         {
            socialButton = new SocialButton([socialGraphic], social);
         }
         socialButtons.push(socialButton);
         selectedPersonGroup.add(socialGraphic);
         
         var isCurrentSelectedButton = socialButton == socialButtons[curSocialMediaSelected];
         var targetAlpha = isCurrentSelectedButton ? 1 : 0.3;

         if (i == selectedPerson.socialMedia.length - 1)
         {
            FlxTween.tween(socialGraphic, { alpha: targetAlpha }, fadeTime, { onComplete: function(tween:FlxTween)
            {
               transitioning = false;
               state = State.OnName;
            }});
         }
         else
         {
            FlxTween.tween(socialGraphic, { alpha: targetAlpha }, fadeTime);
         }
      }
      hasSocialMedia = socialButtons.length != 0;
   }
}

class Person
{
   public var name:String;
   public var creditsType:CreditsType;
	public var socialMedia:Array<Social>;

	public function new(name:String, creditsType:CreditsType, socialMedia:Array<Social>)
	{
      this.name = name;
      this.creditsType = creditsType;
      this.socialMedia = socialMedia;
	}
}
class Social
{
   public var socialMediaName:String;
   public var socialLink:String;

   public function new(socialMedia:String, socialLink:String)
   {
      this.socialMediaName = socialMedia;
      this.socialLink = socialLink;
   }
}
class CreditsText
{
   public var text:FlxText;
   public var menuItem:Bool;
   public var selectionId:Int;
   public var icon:PersonIcon;

   public function new(text:FlxText, menuItem:Bool, icon:PersonIcon)
   {
      this.text = text;
      this.menuItem = menuItem;
      this.icon = icon;
   }
}
class PersonIcon extends FlxSprite
{
   public var tracker:FlxObject;

   public function new(tracker:FlxObject)
   {
      this.tracker = tracker;
      super();
   }
   public override function update(elapsed:Float)
   {
      super.update(elapsed);
      if (tracker != null) 
      {
         var biggerValue = Math.max(tracker.height, height);
         var smallerValue = Math.min(tracker.height, height);

         setPosition(tracker.x + tracker.width + 20, tracker.y + (smallerValue - biggerValue) / 2);
      }
   }
}
class SocialButton
{
   public var graphics:Array<FlxSprite>;
   public var socialMedia:Social;

   public function new(graphics:Array<FlxSprite>, socialMedia:Social)
   {
      this.graphics = graphics;
      this.socialMedia = socialMedia;
   }
}
enum CreditsType
{
   Dev; Translator; Contributor; BetaTester; SpecialThanks;
}
enum State
{
   SelectingName; OnName;
}