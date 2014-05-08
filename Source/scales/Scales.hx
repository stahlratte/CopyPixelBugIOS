package scales;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import openfl.Assets;

/**
 * ...
 * @author tentakl
 */
class Scales extends Sprite {
	
	private static var SCRUBBERHEIGHT:Float = 260;
	
	private var _scaleContainer:Sprite;
	

	private var _scaleCombined:Bitmap;
	private var _scaleCombinedBitmapData:BitmapData;
	private var _scaleSmall:BitmapData;
	private var _scaleBig:BitmapData;
	
	
	private var _scaleSourceRect:Rectangle;
	private var _scaleDestPoint:Point;
	private static var _canvasRect:Rectangle;

	private var _scrubberPixelValue:Float;
	private var _scrubberValue:Float;
	public static var STARTY:Int = 41;
	public static var RANGEY:Int = 1141;
	
	private var _scrubber:Shape;
	
		
	private var _minY:Float;
	private var _maxY:Float;
	
	private var _displayedValue:Int;
	
	public function new() {
		super();
		_scaleContainer = new Sprite();
		_scaleContainer.x = 1024 - 140;
		_scaleContainer.y = 170;
		addChild(_scaleContainer);
		
		

		_scaleSmall = Assets.getBitmapData ("assets/img/small.png");
		_scaleBig = Assets.getBitmapData ("assets/img/big.png");
		_canvasRect = new Rectangle(0,0,_scaleSmall.width,_scaleSmall.height);
		_scaleCombined = new Bitmap();
		_scaleCombinedBitmapData = new BitmapData(Std.int(_canvasRect.width), Std.int(_canvasRect.height), true, 0x00000000);
		_scaleCombined.bitmapData = _scaleCombinedBitmapData;
		_scaleContainer.addChild(_scaleCombined);
		
		
		_scrubber = new Shape();
		_scrubber.x = _canvasRect.width * 0.5;
		_scrubber.graphics.beginFill(0xff00ff, 0.5);
		_scrubber.graphics.drawRoundRect( -SCRUBBERHEIGHT*0.5, -SCRUBBERHEIGHT*0.5, SCRUBBERHEIGHT, SCRUBBERHEIGHT, 40, 40);
		_scaleContainer.addChild(_scrubber);
		
		_scaleSourceRect = new Rectangle(0, 0, 280, 0);
		_scaleDestPoint = new Point();
		
		_scrubberPixelValue = 0;
		
		_minY = _scaleContainer.y + STARTY;
		_maxY = _scaleContainer.y + STARTY + RANGEY;
		setScrubberPosition(0.5);

	}
	
	private function redraw():Void {
		if (_scaleContainer.alpha > 0) {
			if (_scaleCombined.alpha > 0) {
				updateScaleBMD(_scaleCombinedBitmapData, _scaleSmall, _scaleBig, _scrubberPixelValue);
			}
		}
	}
	
	
	
	private function updateScaleBMD(target:BitmapData, srcSmall:BitmapData, srcBig:BitmapData, pxValue:Float):Void {
		// clear
		target.fillRect(target.rect, 0x00000000);
		// copy top
		_scaleSourceRect.y = 0; _scaleSourceRect.height = Math.max(1, Math.round(pxValue-(SCRUBBERHEIGHT * 0.5)));
		_scaleDestPoint.y = _scaleSourceRect.y;
		target.copyPixels(srcSmall, _scaleSourceRect, _scaleDestPoint, null, null, true);
		// copy bottom
		_scaleSourceRect.y = Math.min(_canvasRect.height, Math.round(pxValue+(SCRUBBERHEIGHT * 0.5))); _scaleSourceRect.height = _canvasRect.height-pxValue+SCRUBBERHEIGHT*0.5;
		_scaleDestPoint.y = _scaleSourceRect.y;
		target.copyPixels(srcSmall, _scaleSourceRect, _scaleDestPoint, null, null, true);
		
		// copy scrubber region
		_scaleSourceRect.y = Math.round(pxValue-(SCRUBBERHEIGHT * 0.5)); _scaleSourceRect.height = SCRUBBERHEIGHT;
		if (_scaleSourceRect.y < 0) {
			_scaleSourceRect.height = SCRUBBERHEIGHT + _scaleSourceRect.y;
			_scaleSourceRect.y = 0;
		}
		_scaleDestPoint.y = _scaleSourceRect.y;
		target.copyPixels(srcBig, _scaleSourceRect, _scaleDestPoint, null, null, true);
	}
	
	
	public function setFromFingerPos(X:Float,Y:Float):Void {
		Y = Math.max(Y, _minY);
		Y = Math.min(Y, _maxY);
		Y = Y - STARTY - _scaleContainer.y;
		setScrubberPosition(Y / RANGEY);

	}
	
	
	public function setScrubberPosition(value:Float):Void {
		
		_scrubberValue = value;
		
		_scrubberPixelValue = (_scrubberValue * RANGEY) + STARTY;
		_scrubber.y = _scrubberPixelValue;
		redraw();

	}
	
}