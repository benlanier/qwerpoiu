package com.waffble.gcs;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.filters.BlurFilter;
import nme.filters.GlowFilter;
import nme.geom.ColorTransform;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.utils.ByteArray;

/**
 * This class manages the horses' animation.
 * @author Ben Lanier
 */

class HorseSprite extends Sprite
{
	
	private var _image:Bitmap;
	private var _imgw:Int;
	private var _imgh:Int;
	private var source:Bitmap;
	private var copy:BitmapData; // so they can have their own colors.
	private var maskRect:Rectangle;
	
	// 0.07 seconds per frame felt about right.
	public var dx:Float;
	public var v:Float;
	
	private var stopped:Bool;
	
	private var t:IGenericActuator;
	
	public function new(c:Int) 
	{
		super();
		
		_imgw = 228;
		_imgh = 119;
		
		source = new Bitmap(Assets.getBitmapData("assets/gallopcycle.png"));

		//source.bitmapData.setPixels(new Rectangle(0, 0, 1140, 120), pixels);
		copy = new BitmapData(1140, 120, true, 0x00000000);
		//copy = source.bitmapData;
		source.bitmapData.lock();
		copy.lock();
		var color:Int = c;
		if (color == null) {
			color = 0xff00ff;
		}
		for (i in 0...(1140 * 120)) {
			if (source.bitmapData.getPixel(i % 1140, Std.int(i / 1140)) == 0xff00ff) {
				copy.setPixel(i % 1140, Std.int(i / 1140), color);
			} else if (source.bitmapData.getPixel(i % 1140, Std.int(i / 1140)) == 0x000000) {
				copy.setPixel32(i % 1140, Std.int(i / 1140), 0x00000000);
			} else {
				copy.setPixel32(i % 1140, Std.int(i / 1140), 0xff000000);
			}
		}
		
		source.bitmapData.unlock();
		copy.unlock();
		
		// the frame we are looking at's dest bitmapdata
		var dest = new BitmapData(_imgw, _imgh, true);
		
		maskRect = new Rectangle(0, 0, _imgw, _imgh);
		dest.copyPixels(copy, maskRect, new Point(0, 0));
		_image = new Bitmap(dest);
		addChild(_image);
		
		// for AI
		dx = 0;
		v = Math.random() * 37;
		stopped = false;
	}
	
	public function play():Void
	{
		t = Actuate.timer(.07);
		t.onRepeat(swapImage);
		t.repeat();
	}
	
	public function stop():Void
	{
		stopped = true;
	}
	
	public function swapImage():Void
	{
		if (!stopped) {
		maskRect.x += _imgw;
		maskRect.x = maskRect.x % source.width;
		_image.bitmapData.fillRect(new Rectangle(0,0,_imgw,_imgh), 0x00ffffff);
		_image.bitmapData.copyPixels(copy, maskRect, new Point(0, 0));
		
		v += Math.random() * 4 - 2;
		}
		if (!stopped && v < 25) v = 25;
		if (v > 60) v = 60;
		if (stopped) v /= 2;
	}
	
	public function setFrame(i:Int):Void
	{
		maskRect.x = (i%5) * _imgw;
		_image.bitmapData.fillRect(new Rectangle(0,0,_imgw,_imgh), 0x00ffffff);
		_image.bitmapData.copyPixels(copy, maskRect, new Point(0, 0));
	}
	
}