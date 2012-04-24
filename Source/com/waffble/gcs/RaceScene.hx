package com.waffble.gcs;

import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import com.eclecticdesignstudio.motion.easing.Linear;
import nme.display.Sprite;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.Lib;
import nme.media.Sound;
import nme.text.TextField;
import nme.display.Bitmap;
import nme.text.TextFormat;
import nme.Assets;
import com.eclecticdesignstudio.motion.Actuate;
import nme.utils.Timer;

/**
 * The main game state.
 * @author Ben Lanier
 */

class RaceScene extends Sprite
{
	
	private var bg:Bitmap;
	private var rail:Bitmap;
	
	// hud
	private var hud:Sprite;
	private var pNameText:TextField;
	private var timerText:TextField;
	private var countdownText:TextField;
	private var distanceText:TextField;
	private var speedText:TextField;
	
	private var cText:String;
	private var t:TextField;
	
	// black overlay
	private var overlay:Sprite;
	
	private var janitor:Bitmap;
	private var reginald:Bitmap;
	
	// where we are in the scene
	private var sIndex:Int;
	
	// are we listening for events?
	private var listening:Bool;
	
	// horse
	private var h:HorseSprite;
	
	private var v:Float; // velocity
	private var drag:Float;
	private var horsex:Float; //displacement
	
	private var controls:String;
	// array of keycodes in order of correct press
	private var buttonOrder:Array<Int>;
	private var prevStep:Int; // the index of the previous step (to determine sequentialness)
	private var fromFirst:Bool; // did this gallop cycle begin with the first step?

	private var clock:IGenericActuator; // clock
	private var timePassed:Float;
	
	private var started:Bool;
	private var stopped:Bool;
	private var victory:Bool;
	private var defeat:Bool;
	private var endgame:Bool;
	
	// enemy horses
	private var horses:Array<HorseSprite>;
	
	// physics
	private var TIMESTEP:Float;
	private var MAXGAIN:Float;
	private var MEDGAIN:Float;
	private var MINGAIN:Float;
	
	private var RACELENGTH:Int;
	
	private var debugText:TextField;
	
	private var finishLine:Sprite;
	
	
	public function new() 
	{
		super();
		
		TIMESTEP = 0.033;
		drag = 0.9;
		
		MAXGAIN = 400;
		MEDGAIN = 80;
		MINGAIN = 40;
		
		RACELENGTH = 500;
		
		bg = new Bitmap(Assets.getBitmapData("assets/track.png"));
		//bg.scaleX = 800 / bg.width;
		//bg.scaleY = 400 / bg.height;
		addChild(bg);
		
		rail = new Bitmap(Assets.getBitmapData("assets/railing.png"));
		rail.y = 218;
		addChild(rail);
		
		finishLine = new Sprite();
		finishLine.graphics.beginFill(0xeeeeee);
		finishLine.graphics.drawRect(0, 0, 10, 150);
		finishLine.y = 262;
		finishLine.x = 25000 + 228;
		addChild(finishLine);
		
		h = new HorseSprite(Horse.getPlayerColor());
		h.y = 200;
		addChild(h);
		h.setFrame(1);
		
		horses = new Array<HorseSprite>();
		horses = [ new HorseSprite(Std.int(Math.random() * 0xffffff)),
				   new HorseSprite(Std.int(Math.random() * 0xffffff)) ];
		
		for (i in 0...horses.length) {
			addChild(horses[i]);
			horses[i].y = 230 + (30 * i);
			horses[i].setFrame(Std.int(Math.random() * 4) + 1);
		}
		
		hud = new Sprite();
		
		var textf:TextFormat = new TextFormat();
		textf.size = 36;
		pNameText = new TextField();
		pNameText.setTextFormat(textf);
		pNameText.text = Horse.getPlayerName();
		pNameText.x = 10;
		hud.addChild(pNameText);
		
		timerText = new TextField();
		textf.size = 28;
		timerText.setTextFormat(textf);
		timerText.x = pNameText.textWidth + 30;
		timerText.y = 8;
		hud.addChild(timerText);
		
		distanceText = new TextField();
		distanceText.setTextFormat(textf);
		distanceText.x = 650;
		distanceText.y = 8;
		distanceText.text = "left " + RACELENGTH + ".m";
		hud.addChild(distanceText);
		
		speedText = new TextField();
		speedText.setTextFormat(textf);
		speedText.x = pNameText.textWidth - 30;
		speedText.y = 40;
		speedText.text = "0 m/s";
		hud.addChild(speedText);
		
		debugText = new TextField();
		debugText.setTextFormat(textf);
		debugText.y = 100;
		hud.addChild(debugText);
		
		countdownText = new TextField();
		textf.size = 72;
		countdownText.setTextFormat(textf);
		countdownText.text = "3";
		countdownText.x = 380;
		countdownText.y = 100;
		hud.addChild(countdownText);
		
		overlay = new Sprite();
		overlay.graphics.beginFill(0xffffff);
		overlay.graphics.drawRect(0, 0, 800, 400);
		
		horsex = 0;
		
		addChild(hud);
		
		buttonOrder = new Array<Int>();
		controls = Horse._data.get("control");
		switch (controls) {
			case "QWER": buttonOrder = [81, 87, 69, 82];
			case "REWQ": buttonOrder = [82, 69, 87, 81];
			case "UIOP": buttonOrder = [85, 73, 79, 80];
			case "POIU": buttonOrder = [80, 79, 73, 85];
		}
		
		clock = Actuate.timer(TIMESTEP);
		
		started = false;
		Actuate.timer(1).onComplete(function() {
			countdownText.text = "2";
			Actuate.timer(1).onComplete(function() {
				countdownText.text = "1";
				Actuate.timer(1).onComplete(function() {
					countdownText.text = "GO!";
					Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKey);
					Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, upKey);
					started = true;
					
					for (i in 0...horses.length) {
						horses[i].play();
					}
					
					Actuate.timer(1).onComplete(function() {
						hud.removeChild(countdownText);
					});
				});
			});
		});
		
		clock.repeat();
		clock.onUpdate(tick);
		stopped = false;
		victory = false;
		endgame = false;
	}
	
	private function tick():Void {
		if (!started) return;
		// graphical update
		var dx:Float = (TIMESTEP * v);
		rail.x -= dx;
		finishLine.x -= dx;
		horsex += dx / 50;
		if (dx < 1)
			h.setFrame(1);
		while (rail.x <= -120) {
			rail.x += 120;
		}
		
		for (i in 0...horses.length) {
			if (horses[i].dx >= 25000) {
				if (!victory) defeat = true;
			}
			if (horses[i].dx >= 25228) {
				horses[i].stop();
			} else {
				horses[i].dx += horses[i].v / 2;
			}
				horses[i].x = horses[i].dx - (horsex * 50); // displacement on screen
		}
		//debugText.text = horses[0].dx;
		
		// logical update
		v *= drag;
		if (!stopped) {
			timePassed += TIMESTEP;
			timerText.text = formatTime(timePassed + "");
			distanceText.text = "left " + (RACELENGTH - horsex) + ".";
			distanceText.text = distanceText.text.substr(0, distanceText.text.indexOf(".")) + "m";
		} else {
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKey);
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, upKey);
		}
		
		speedText.text = Std.int(dx / 2) + " m/s";
		
		if (!endgame && horsex >= RACELENGTH) {
			endgame = true;
			if (!defeat) victory = true;
			addChild(overlay);
			Actuate.tween(overlay, 1, { alpha:0 } );
			stopped = true;
			
			var egText:TextField = new TextField();
			var egtf:TextFormat = new TextFormat();
			egtf.size = 72;
			egText.setTextFormat(egtf);
			egText.x = 200;
			egText.y = 110;
			egText.text = (victory ? "Victory!" : "Defeat!");
			addChild(egText);
			
			var rText:TextField = new TextField();
			rText.text = "Restart";
			rText.x = 500;
			rText.y = 200;
			egtf.size = 36;
			var restart:TextButton = new TextButton(rText, egtf, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				Horse.Game().setState(RaceScene);
			});
			addChild(restart);
			
			var mText:TextField = new TextField();
			mText.text = "Main Menu";
			mText.x = 200;
			mText.y = 200;
			egtf.size = 36;
			var mainmenu:TextButton = new TextButton(mText, egtf, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				Horse.Game().setState(TitleScene);
			});
			addChild(mainmenu);
			
		}
	}
	
	private function formatTime(s:String):String {
		var res:String = "";
		var seconds:String = s.substr(0, s.indexOf("."));
		var sec:Int = Std.parseInt(seconds);
		var deci:String = s.substr(s.indexOf(".") + 1, 1);
		var minutes:String = Std.int(sec / 60) + "";
		var secs:String = (sec % 60) + "";
		return (minutes.length < 2 ? "0" + minutes : minutes) + ":" + (secs.length < 2 ? "0" + secs : secs) + ":" + deci;
	}
	
	private function upKey(e:KeyboardEvent):Void {
		if (prevStep == 3 && e.keyCode == buttonOrder[3]) {
			h.setFrame(0); // airborne
		}
	}
	
	private function handleKey(e:KeyboardEvent):Void {
		
		switch (e.keyCode) {
			case buttonOrder[0]:
				if (prevStep == 0) return;
				h.setFrame(1);
				fromFirst = true;
				//h.x += (prevStep == 3 ? 2 : 1);
				v += (prevStep == 3 ? MEDGAIN : MINGAIN);
				prevStep = 0;
			case buttonOrder[1]:
				if (prevStep == 1) return;
				h.setFrame(2);
				if (prevStep == 0) {
					//h.x += 2;
					v += MEDGAIN;
				} else {
					//h.x += 1;
					v += MINGAIN;
					fromFirst = false;
				}
				prevStep = 1;
			case buttonOrder[2]:
				if (prevStep == 2) return;
				h.setFrame(3);
				if (prevStep == 1) {
					//h.x += 2;
					v += MEDGAIN;
				} else {
					//h.x += 1;
					v += MINGAIN;
					fromFirst = false;
				}
				prevStep = 2;
			case buttonOrder[3]:
				if (prevStep == 3) return;
				h.setFrame(4);
				if (prevStep == 2 && fromFirst) {
					// MEGA BOOST BRO
					//h.x += 10;
					v += MAXGAIN;
				} else if (prevStep == 2) {
					//h.x += 2;
					v += MEDGAIN;
				} else {
					//h.x += 1;
					v += MINGAIN;
				}
				prevStep = 3;
				fromFirst = false;
		}
		
	}
	
}