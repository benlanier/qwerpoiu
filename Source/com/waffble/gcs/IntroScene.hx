package com.waffble.gcs;

import com.eclecticdesignstudio.motion.Actuate;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * The story scene - this was originally going to
 * be a very different kind of game.
 * @author Ben Lanier
 */

class IntroScene extends Sprite
{

	private var cText:String;
	private var t:TextField;
	private var bg:Bitmap;
	
	// dialog box
	private var hud:Sprite;
	
	// black overlay
	private var overlay:Sprite;
	
	private var janitor:Bitmap;
	private var reginald:Bitmap;
	
	// where we are in the scene
	private var sIndex:Int;
	
	// are we listening for events?
	private var listening:Bool;
	
	private var words:Array<String>;
	
	public function new() 
	{
		super();
		
		words = ["Adult",
				"Aeroplane",
				"Air",
				"Aircraft Carrier",
				"Airforce",
				"Airport",
				"Album",
				"Alphabet",
				"Apple",
				"Arm",
				"Army",
				"Baby",
				"Baby",
				"Backpack",
				"Balloon",
				"Banana",
				"Bank",
				"Barbecue",
				"Bathroom",
				"Bathtub",
				"Bed",
				"Bed",
				"Bee",
				"Bible",
				"Bible",
				"Bird",
				"Bomb",
				"Book",
				"Boss",
				"Bottle",
				"Bowl",
				"Box",
				"Boy",
				"Brain",
				"Bridge",
				"Butterfly",
				"Button",
				"Cappuccino",
				"Car",
				"Car-race",
				"Carpet",
				"Carrot",
				"Cave",
				"Chair",
				"Chess Board",
				"Chief",
				"Child",
				"Chisel",
				"Chocolates",
				"Church",
				"Church",
				"Circle",
				"Circus",
				"Circus",
				"Clock",
				"Clown",
				"Coffee",
				"Coffee-shop",
				"Comet",
				"Compact Disc",
				"Compass",
				"Computer",
				"Crystal",
				"Cup",
				"Cycle",
				"Data Base",
				"Desk",
				"Diamond",
				"Dress",
				"Drill",
				"Drink",
				"Drum",
				"Dung",
				"Ears",
				"Earth",
				"Egg",
				"Electricity",
				"Elephant",
				"Eraser",
				"Explosive",
				"Eyes",
				"Family",
				"Fan",
				"Feather",
				"Festival",
				"Film",
				"Finger",
				"Fire",
				"Floodlight",
				"Flower",
				"Foot",
				"Fork",
				"Freeway",
				"Fruit",
				"Fungus",
				"Game",
				"Garden",
				"Gas",
				"Gate",
				"Gemstone",
				"Girl",
				"Gloves",
				"God",
				"Grapes",
				"Guitar",
				"Hammer",
				"Hat",
				"Hieroglyph",
				"Highway",
				"Horoscope",
				"Horse",
				"Hose",
				"Ice",
				"Ice-cream",
				"Insect",
				"Jet fighter",
				"Junk",
				"Kaleidoscope",
				"Kitchen",
				"Knife",
				"Leather jacket",
				"Leg",
				"Library",
				"Liquid",
				"Magnet",
				"Man",
				"Map",
				"Maze",
				"Meat",
				"Meteor",
				"Microscope",
				"Milk",
				"Milkshake",
				"Mist",
				"Money $$$$",
				"Monster",
				"Mosquito",
				"Mouth",
				"Nail",
				"Navy",
				"Necklace",
				"Needle",
				"Onion",
				"PaintBrush",
				"Pants",
				"Parachute",
				"Passport",
				"Pebble",
				"Pendulum",
				"Pepper",
				"Perfume",
				"Pillow",
				"Plane",
				"Planet",
				"Pocket",
				"Post-office",
				"Potato",
				"Printer",
				"Prison",
				"Pyramid",
				"Radar",
				"Rainbow",
				"Record",
				"Restaurant",
				"Rifle",
				"Ring",
				"Robot",
				"Rock",
				"Rocket",
				"Roof",
				"Room",
				"Rope",
				"Saddle",
				"Salt",
				"Sandpaper",
				"Sandwich",
				"Satellite",
				"School",
				"Sex",
				"Ship",
				"Shoes",
				"Shop",
				"Shower",
				"Signature",
				"Skeleton",
				"Slave",
				"Snail",
				"Software",
				"Solid",
				"Space Shuttle",
				"Spectrum",
				"Sphere",
				"Spice",
				"Spiral",
				"Spoon",
				"Sports-car",
				"Spot Light",
				"Square",
				"Staircase",
				"Star",
				"Stomach",
				"Sun",
				"Sunglasses",
				"Surveyor",
				"Swimming Pool",
				"Sword",
				"Table",
				"Tapestry",
				"Teeth",
				"Telescope",
				"Television",
				"Tennis racquet",
				"Thermometer",
				"Tiger",
				"Toilet",
				"Tongue",
				"Torch",
				"Torpedo",
				"Train",
				"Treadmill",
				"Triangle",
				"Tunnel",
				"Typewriter",
				"Umbrella",
				"Vacuum",
				"Vampire",
				"Videotape",
				"Vulture",
				"Water",
				"Weapon",
				"Web",
				"Wheelchair",
				"Window",
				"Woman",
				"Worm",
				"X-ray"];
		
		bg = new Bitmap(Assets.getBitmapData("assets/stands.png"));
		bg.scaleX = 800 / bg.width;
		bg.scaleY = 400 / bg.height;
		addChild(bg);
		
		janitor = new Bitmap(Assets.getBitmapData("assets/janitor.png"));
		janitor.x = 400 - (janitor.width / 2);
		janitor.y = 50;
		addChild(janitor);
		
		reginald = new Bitmap(Assets.getBitmapData("assets/reginald.png"));
		reginald.x = 400 - (reginald.width / 2);
		reginald.alpha = 0;
		addChild(reginald);
		
		hud = new Sprite();
		overlay = new Sprite();
		overlay.graphics.beginFill(0x000000);
		overlay.graphics.drawRect(0, 0, 800, 400);
		hud.graphics.beginFill(0x220022);
		hud.graphics.lineStyle(3.0, 0xffffff);
		hud.graphics.drawRect(50, 300, 702, 92);
		hud.graphics.drawRect(50, 300, 700, 90);
		
		addChild(overlay);
		addChild(hud);
		
		t = new TextField();
		var tf:TextFormat = new TextFormat();
		tf.size = 20;
		tf.color = 0xffffff;
		t.setTextFormat(tf);
		cText = "";
		t.text = cText;
		t.x = 60;
		t.y = 310;
		addChild(t);
		
		sIndex = 0;
		
		
		writeText("Wow!__________ What a crazy horse!");
		addEventListener(MouseEvent.CLICK, advance);
		listening = false;
	}
	
	/**
	 * This was a rather quick and hacky way to get sequential messages.
	 * In the future it might be nice to just have some kind of script file
	 * that is parsed sequentially.
	 * @param	e the stage of the conversation
	 */
	private function advance(e:Event) {
		if (!listening) return;
		listening = false;
		switch (sIndex++) {
			case 0:
				Actuate.tween(overlay, 2, { alpha: 0 } ).onComplete(writeText, ["That crazy Reginald...."]);
			case 1:
				writeText("He's the only one who would go to the trouble of coloring\nhis horses.");
			case 2:
				removeEventListener(MouseEvent.CLICK, advance);
				writeText("What's your name?\n>");
				cText = "";
				Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, getName);
			case 3:
				addEventListener(MouseEvent.CLICK, advance);
				writeText(Horse.getPlayerName() + ", eh?");
				Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, getName);
			case 4:
				writeText("You must like " + getRandomNoun() + "!" );
			case 5:
				writeText("Well, I should get back to cleaning the grandstand....\n________Have fun!");
			case 6:
				removeEventListener(MouseEvent.CLICK, advance);
				Actuate.tween(overlay, 2, { alpha: 1 } ).onComplete(function() {
					writeText("_____L_____O_____A_____D_____I_____N_____G_____");
				});
				Horse.Game().setState(RaceScene);
		}
	}
	
	/**
	 * Keyboard input in nme/html5 didn't seem reliable as of this writing,
	 * so that's why I implemented it in this nonsense way.
	 * @param	e the KeyboardEvent
	 */
	private function getName(e:KeyboardEvent) {
		if (listening) { cText = ""; listening = false; }
		switch (e.keyCode) {
			case 13:
				Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, getName);
				t.text = cText;
				if (sIndex == 3) {
					Horse.setPlayerName(cText);
				} else if (sIndex == 5) {
					Horse.setInputButton(cText.charCodeAt(0));
				}
				listening = true;
				advance(new Event("bluh"));
			case 65:
				cText += "a";
				t.text = cText;
			case 66:
				cText += "b";
				t.text = cText;
			case 67:
				cText += "c";
				t.text = cText;
			case 68:
				cText += "d";
				t.text = cText;
			case 69:
				cText += "e";
				t.text = cText;
			case 70:
				cText += "f";
				t.text = cText;
			case 71:
				cText += "g";
				t.text = cText;
			case 72:
				cText += "h";
				t.text = cText;
			case 73:
				cText += "i";
				t.text = cText;
			case 74:
				cText += "j";
				t.text = cText;
			case 75:
				cText += "k";
				t.text = cText;
			case 76:
				cText += "l";
				t.text = cText;
			case 77:
				cText += "m";
				t.text = cText;
			case 78:
				cText += "n";
				t.text = cText;
			case 79:
				cText += "o";
				t.text = cText;
			case 80:
				cText += "p";
				t.text = cText;
			case 81:
				cText += "q";
				t.text = cText;
			case 82:
				cText += "r";
				t.text = cText;
			case 83:
				cText += "s";
				t.text = cText;
			case 84:
				cText += "t";
				t.text = cText;
			case 85:
				cText += "u";
				t.text = cText;
			case 86:
				cText += "v";
				t.text = cText;
			case 87:
				cText += "w";
				t.text = cText;
			case 88:
				cText += "x";
				t.text = cText;
			case 89:
				cText += "y";
				t.text = cText;
			case 90:
				cText += "z";
				t.text = cText;
		}
	}
	
	/**
	 * Writes text to the textbox on the screen.
	 * @param	s the string to write
	 */
	private function writeText(s:String) {
		cText = "";
		addLetter(-1, "", s);
	}
	
	/**
	 * helper function, adds a letter to the textbox
	 * for "typing effect"
	 * @param	i the index of the letter in the string
	 * @param	c the character to write (_ results in a pause/delay)
	 * @param	s the rest of the string to write
	 */
	private function addLetter(i:Int, c:String, s:String ) {
		if (i++ < s.length) {
			if (c != "_") cText += c;
			t.text = cText;
			Actuate.timer(.001).onComplete(addLetter, [i, s.charAt(i), s]);
		} else {
			listening = true;
		}
	}
	
	private function getRandomNoun():String {
		var i:Int = Std.int(Math.random() * words.length);
		return words[i];
	}
	
	
}