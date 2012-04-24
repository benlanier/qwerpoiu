package com.waffble.gcs;
import com.eclecticdesignstudio.motion.Actuate;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.FocusEvent;
import nme.events.MouseEvent;
import nme.external.ExternalInterface;
import nme.geom.Rectangle;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * This is the screen players first see.
 * @author Ben Lanier
 */

class TitleScene extends Sprite
{

	private var start:TextButton;
	private var option:TextButton;
	private var help:TextButton;
	
	private var helpBody:TextField;
	
	private var smallerFormat:TextFormat;

	private var gallopText:TextField;
	private var QWER:TextButton;
	private var REWQ:TextButton;
	private var UIOP:TextButton;
	private var POIU:TextButton;
	
	private var colorText:TextField;
	
	private var bg:Bitmap;
	
	private var title:TextField;
	private var subtitle:flash.text.TextField;
	
	private var cs:ColorSelector;
	
	public function new() 
	{
		super();
		
		bg = new Bitmap(Assets.getBitmapData("assets/cool.png"));
		bg.x = 390;
		bg.y = 150;
		addChild(bg);
		
		title = new TextField();
		var titleFormat:TextFormat = new TextFormat();
		titleFormat.size = 72;
		titleFormat.color = 0xffffff;
		title.setTextFormat(titleFormat);
		title.text = "qwerpoiu";
		title.x = title.y = 25;
		addChild(title);
		
		subtitle = new TextField();
		titleFormat.size = 16;
		subtitle.setTextFormat(titleFormat);
		subtitle.text = "by ben lanier";
		subtitle.x = title.textWidth + 40;
		subtitle.y = title.textHeight - 6;
		addChild(subtitle);
		
		cs = new ColorSelector();
		cs.x = 600;
		cs.y = 120;
		
		smallerFormat = titleFormat;
		smallerFormat.size = 36;
		smallerFormat.color = 0x777777;
		
		var startText = new TextField();
		startText.text = "start";
		startText.x = 100;
		startText.y = 320;
		
		start = new TextButton(startText, smallerFormat, function(e:MouseEvent) {
			startText.textColor = 0xffffff;
		}, function(e:MouseEvent) {
			startText.textColor = 0x777777;
		}, function(e:MouseEvent) {
			//Horse.setPlayerColor(cs.getRGB());
			//Horse.Game().setState(IntroScene);
			doOptionsPage(e);
		});
		addChild(start);
		
		var helpText = new TextField();
		helpText.text = "help";
		helpText.x = 320;
		helpText.y = 320;
		
		helpBody = new TextField();
		smallerFormat.size = 18;
		helpBody.textColor = 0xffffff;
		helpBody.text = "Drum your fingers on the letters\n"
			            + "in the order you choose.\n"
						+ "Gallop gallop fingers\n"
						+ "for maximum speed get!";
		addChild(helpBody);
		helpBody.x = 280;
		helpBody.y = 250;
		helpBody.alpha = 0;
		
		smallerFormat.size = 36;
		
		help = new TextButton(helpText, smallerFormat, function(e:MouseEvent) {
			helpText.textColor = 0xffffff;
			Actuate.tween(helpBody, .5, { alpha:1 } );
		}, function(e:MouseEvent) {
			helpText.textColor = 0x777777;
			Actuate.tween(helpBody, .5, { alpha:0 } );
		}, function(e:MouseEvent) {
			
		});
		//addChild(help);
		
		var optionText = new TextField();
		optionText.setTextFormat(smallerFormat);
		optionText.x = 500;
		optionText.y = 320;
		optionText.text = "option";
		
		option = new TextButton(optionText, smallerFormat, function(e:MouseEvent) {
			optionText.textColor = 0xffffff;
		}, function(e:MouseEvent) {
			optionText.textColor = 0x777777;
		}, doOptionsPage);
		//addChild(option);
		
		Horse._data.set("control", "QWER");
	}
	
	private function doOptionsPage(e:MouseEvent) {
		if (title.text == "set options") return;
		Actuate.tween(subtitle, 0.5, { alpha: 0 } );
		//Actuate.tween(help, 0.5, { alpha:0 } ).onComplete(removeChild(help));
		Actuate.tween(title, 0.5, { alpha: 0 } ).onComplete(function() {
			title.text = "set options";
			Actuate.tween(title, 0.5, { alpha: 1 } );
			
			start.changeAction(function(e:MouseEvent) {
				Horse.setPlayerColor(cs.getRGB());
				Horse.Game().setState(IntroScene);
			});
			
			gallopText = new TextField();
			smallerFormat.size = 24;
			gallopText.setTextFormat(smallerFormat);
			gallopText.text = "Controls:";
			gallopText.textColor = 0xffffff;
			gallopText.x = 300;
			gallopText.y = 120;
			addChild(gallopText);
			
			var htp:HowToPlay = new HowToPlay();
			htp.x = 50;
			htp.y = 170;
			addChild(htp);
			
			var temp:TextField = new TextField();
			var oldY:Float;
			temp.x = gallopText.x + gallopText.textWidth + 10;
			temp.y = gallopText.y;
			oldY = temp.y;
			temp.text = "QWER";
			QWER = new TextButton(temp, smallerFormat, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				Horse._data.set("control", "QWER");
				htp.changeText("Q   W   E   R");
				htp.setDir(true);
				QWER.t.textColor = 0xffffff;
				REWQ.t.textColor = UIOP.t.textColor = POIU.t.textColor = 0x777777;
			});
			QWER.t.textColor = 0xffffff;
			
			temp = new TextField();
			temp.x = gallopText.x + gallopText.textWidth + 10;
			temp.y = oldY + temp.textHeight + 20;
			//oldY = temp.y;
			temp.text = "REWQ";
			REWQ = new TextButton(temp, smallerFormat, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				Horse._data.set("control", "REWQ");
				htp.changeText("Q   W   E   R");
				htp.setDir(false);
				REWQ.t.textColor = 0xffffff;
				QWER.t.textColor = UIOP.t.textColor = POIU.t.textColor = 0x777777;
			});
			temp = new TextField();
			temp.x = gallopText.x + gallopText.textWidth + 10;
			temp.y = oldY + temp.textHeight + 20;
			//oldY = temp.y;
			temp.text = "UIOP";
			UIOP = new TextButton(temp, smallerFormat, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				Horse._data.set("control", "UIOP");
				htp.changeText("U     I    O   P");
				htp.setDir(true);
				UIOP.t.textColor = 0xffffff;
				QWER.t.textColor = REWQ.t.textColor = POIU.t.textColor = 0x777777;
			});
			temp = new TextField();
			temp.x = gallopText.x + gallopText.textWidth + 10;
			temp.y = oldY + temp.textHeight + 20;
			oldY = temp.y;
			temp.text = "POIU";
			POIU = new TextButton(temp, smallerFormat, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				
			}, function(e:MouseEvent) {
				Horse._data.set("control", "POIU");
				htp.changeText("U     I    O   P");
				htp.setDir(false);
				POIU.t.textColor = 0xffffff;
				QWER.t.textColor = REWQ.t.textColor = UIOP.t.textColor = 0x777777;
			});
			
			addChild(QWER);
			// I'm not sure if people even use these control schemes, so commented out.
			//addChild(REWQ);
			//addChild(UIOP);
			addChild(POIU);
			
			colorText = new TextField();
			colorText.setTextFormat(smallerFormat);
			colorText.text = "Color:";
			colorText.textColor = 0xffffff;
			colorText.x = 520;
			colorText.y = 120;
			addChild(colorText);
			
			addChild(cs);
			
		});
		Actuate.tween(bg, 1, { alpha:0 } );
	}
	
}