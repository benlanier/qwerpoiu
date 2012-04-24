package com.waffble.gcs;

import com.eclecticdesignstudio.motion.Actuate;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * Widget showing how to play.
 * @author Ben Lanier
 */

class HowToPlay extends Sprite
{
	
	private var buttons:Array<Sprite>;
	private var text:TextField;
	private var curbut:Int;
	private var forward:Bool;

	public function new() 
	{
		super();
		
		curbut = 0;
		buttons = new Array<Sprite>();
		for (i in 0...4) {
			var temp:Sprite = new Sprite();
			temp.x = i * 50;
			temp.y = 60;
			temp.graphics.beginFill(0x333333);
			temp.graphics.drawRect(0, 0, 40, 40);
			addChild(temp);
			buttons.push(temp);
		}
		
		text = new TextField();
		var tf:TextFormat = new TextFormat();
		tf.size = 30;
		tf.color = 0x666666;
		text.setTextFormat(tf);
		text.x = 5;
		text.y = 65;
		text.text = "Q   W   E   R";
		addChild(text);
		forward = true;
		Actuate.timer(.2).onRepeat(altercurbut).repeat();
		
		var htr = new TextField();
		tf.size = 30;
		tf.color = 0xffffff;
		htr.text = "How to run:";
		htr.setTextFormat(tf);
		addChild(htr);
	}
	
	public function changeText(s:String) {
		text.text = s;
	}
	
	public function setDir(foward:Bool) {
		forward = foward;
	}
	
	private function altercurbut():Void {
		
		for (i in 0...buttons.length) {
			buttons[i].graphics.clear();
			buttons[i].x = i * 50;
			buttons[i].graphics.beginFill(0x333333);
			if (curbut == i) {
				buttons[i].graphics.drawRect(5, 5, 35, 35);
			} else {
				buttons[i].graphics.drawRect(0, 0, 40, 40);
			}
		}
		
		curbut += (forward ? 1 : -1);
		if (curbut < -1) curbut = 3;
		if (curbut > 3) curbut = -1;
	}
	
}