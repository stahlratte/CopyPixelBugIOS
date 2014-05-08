package;


import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import flash.geom.Point;
import scales.Scales;


class Main extends Sprite {
	
	private var _scales:Scales;
	
	private var _position:Point;
	private var _fingers:Int;
	public static var appScale:Float;
	
	public var _touches:Array<Int>;
	
	public function new () {
		
		super ();
		_touches = new Array<Int>();
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		if (stage.stageWidth < 2048) {
			appScale = 0.5;
			this.scaleX = this.scaleY = 0.5;
		}
		
		_scales = new Scales();
		addChild(_scales);
		
		_position = new Point();
		_fingers = 0;
		
		if (Multitouch.supportsTouchEvents == true) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		} else {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		
	}
	
	public function enterFrameHandler(e:Event):Void {
		if (_fingers == 1) {
			updateFromTouches();
		}
	}
	
	private function updateFromTouches():Void {
		_scales.setFromFingerPos(_position.x, _position.y);
	}
	
	//touch
	public function onTouchBegin(event:TouchEvent):Void {
		for (i in 0..._touches.length) {
			if (_touches[i] == event.touchPointID) {
				return;
			}
		}
		_touches.push(event.touchPointID);
		_fingers = _touches.length;
		_position.x = event.stageX / appScale;
		_position.y = event.stageY / appScale;
	}
		
	public function onTouchMove(event:TouchEvent):Void {
		_position.x = event.stageX / appScale;
		_position.y = event.stageY / appScale;
	}
		
	public function onTouchEnd(event:TouchEvent):Void {
		_fingers--;
		var deleteIndex:Int = -1;
		for (i in 0..._touches.length) {
			if (_touches[i] == event.touchPointID) {
				deleteIndex = i;
			}
		}
		if (deleteIndex > -1) {
			_touches.splice(deleteIndex,1);
		}
		_fingers = _touches.length;
		_position.x = event.stageX / appScale;
		_position.y = event.stageY / appScale;
	}
	
	//mouse
	public function onMouseDown(event:MouseEvent):Void {
		_fingers = 1;	
		_position.x = event.stageX / appScale;
		_position.y = event.stageY / appScale;
	}
		
	public function onMouseMove(event:MouseEvent):Void {
		_position.x = event.stageX / appScale;
		_position.y = event.stageY / appScale;
	}
		
	public function onMouseUp(event:MouseEvent):Void {
		_fingers = 0;
		_position.x = event.stageX / appScale;
		_position.y = event.stageY / appScale;
	}
	
	
}