package com.waffble.gcs;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.SimpleActuator;
import com.eclecticdesignstudio.motion.easing.Quad;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.MouseEvent;
import nme.events.TimerEvent;
import nme.filters.BlurFilter;
import nme.Lib;
import nme.utils.Timer;

/**
 * qwerpoiu
 * 
 * Horse Game for Game Creation Society
 * "I own a horse" competition at
 * Carnegie Mellon University
 * 
 * Feb 10 2012
 * @author Ben Lanier
 */
class Horse extends Sprite {
	
	// globalish vars
	private static var playerName:String;
	private static var inputButton:Int;
	
	public function new() {
		
		super();		
		initialize();
		
	}
	
	private var h:HorseSprite;
	private var t:Timer;
	private var bg:Bitmap;
	private static var _cstate:Sprite; // current state
	private static var _instance:Horse;
	public static var _data:Hash<String>;
	
	private static var _color:Int;
	
	private function initialize():Void {
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		_data = new Hash();
		_color = 0xff00ff;
		playerName = "Connosieur";
		
		_cstate = new TitleScene();
		addChild(_cstate);
		
	}
	
	// Entry point
	
	public function setState(s:Class<Sprite>) {
		removeChild(_cstate);
		_cstate = null;
		_cstate = Type.createInstance(s, []);
		addChild(_cstate);
	}
	
	// This feels a bit gross for managing data that persists
	// across states; there's probably a better way.
	
	public static function setPlayerName(s:String):Void {
		playerName = s.charAt(0).toUpperCase() + s.substr(1);
	}
	
	public static function getPlayerName():String {
		return playerName;
	}
	
	public static function setInputButton(i:Int):Void {
		inputButton = i;
	}
	
	public static function getInputButton():Int {
		return inputButton;
	}
	
	public static function setPlayerColor(c:Int):Void {
		_color = c;
	}
	
	public static function getPlayerColor():Int {
		return _color;
	}
	
	public static function Game():Horse {
		return _instance;
	}
	
	public static function main () {
		
		_instance = new Horse();
		Lib.current.addChild (_instance);
		
	}
	
	
}