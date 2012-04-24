package com.waffble.gcs;

import nme.display.BitmapData;
import nme.display.Sprite;
import nme.display.Bitmap;
import nme.events.MouseEvent;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * Slider for selecting the hue of the player horse.
 * @author Ben Lanier
 */

class ColorSelector extends Sprite
{

	private var colors:BitmapData;
	private var cBitmap:Bitmap;
	private var slider:Sprite;
	private var dragginslider:Bool;
	
	public function new() 
	{
		super();
		graphics.beginFill(HSVtoRGB(0,1,1.0));
		graphics.drawRect(0, 0, 150, 150);
		
		graphics.beginFill(0x333333);
		graphics.drawRect(0, 157, 150, 5);
		
		slider = new Sprite();
		slider.graphics.beginFill(0xffffff);
		slider.graphics.drawRect(0, 0, 5, 10);
		slider.x = 0;
		slider.y = 155;
		addChild(slider);
		
		dragginslider = false;
		
		addEventListener(MouseEvent.MOUSE_DOWN, startSliderDrag);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent) {
			if (!dragginslider) return;
			graphics.beginFill(HSVtoRGB(slider.x / 150 * 360, 1, 1));
			graphics.drawRect(0, 0, 150, 150);
		});
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, stopSliderDrag);
	}
	
	private function startSliderDrag(e:MouseEvent):Void {
		slider.startDrag(false, new Rectangle(0, 154, 150, 0));
		dragginslider = true;
	}
	
	private function stopSliderDrag(e:MouseEvent):Void {
		slider.stopDrag();
		dragginslider = false;
		Horse.setPlayerColor(getRGB());
	}
	
	public function getRGB():Int {
		return HSVtoRGB(slider.x / 150 * 360, 1, 1);
	}
	
	public static function HSVtoRGB (h: Float, s: Float, v: Float): Int
		{
			var r: Float = 0, g: Float = 0, b: Float = 0;
			var i: Int, x: Float, y: Float, z: Float;
			if (s <0) s = 0; if (s> 1) s = 1; if (v <0) v = 0; if (v> 1) v = 1;
			h = h% 360; if (h <0) h += 360; h /= 60;
			i = Std.int(h);
			x = v * (1 - s); y = v * (1 - s * (h - i)); z = v * (1 - s * (1 - h + i));
			switch (i) {
				case 0: r = v; g = z; b = x;
				case 1: r = y; g = v; b = x;
				case 2: r = x; g = v; b = z;
				case 3: r = x; g = y; b = v;
				case 4: r = z; g = x; b = v;
				case 5: r = v; g = x; b = y;
			}
			return (Std.int(r * 255) << 16) | (Std.int(g * 255) << 8) | (Std.int(b * 255));
		}
	
}