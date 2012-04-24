package com.waffble.gcs;

import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.MouseEvent;

/**
 * putting text on top of a button became a repeated task,
 * thus the creation of this class.
 * @author Ben Lanier
 */
class TextButton extends Sprite {
		
		public var t:TextField;
		public var tf:TextFormat;
		private var hitbox:Sprite;
		private var clickfxns:MouseEvent -> Void;
		
		public function new(_t:TextField, _tf:TextFormat, overfxn:MouseEvent -> Void,
		                                                  outfxn:MouseEvent -> Void,
														  clickfxn:MouseEvent -> Void) {
			super();
			hitbox = new Sprite();
			t = _t;
			tf = _tf;
			t.setTextFormat(tf);
			addChild(t);
			hitbox.graphics.beginFill(0x00ff00, 0);
			hitbox.graphics.drawRect( t.x-10, t.y-10, t.textWidth + 10, t.textHeight + 10);
			addChild(hitbox);
			this.addEventListener(MouseEvent.ROLL_OVER, overfxn);
			this.addEventListener(MouseEvent.ROLL_OUT, outfxn);
			clickfxns = clickfxn;
			this.addEventListener(MouseEvent.CLICK, clickfxns);
		}
		
		public function changeAction(clicfxn:MouseEvent -> Void) {
			this.removeEventListener(MouseEvent.CLICK, clickfxns);
			clickfxns = clicfxn;
			this.addEventListener(MouseEvent.CLICK, clickfxns);
		}
		
	}