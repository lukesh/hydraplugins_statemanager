package com.hydraframework.plugins.stateManager.events {
	import flash.events.Event;

	public class StateEvent extends Event {
		public static const STATE_CHANGE:String = "stateChange";

		public var state:Object;

		public function StateEvent(type:String, state:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.state = state;
		}

		override public function clone():Event {
			return new StateEvent(type, state, bubbles, cancelable);
		}

	}
}