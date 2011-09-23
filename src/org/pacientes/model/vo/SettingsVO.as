package org.pacientes.model.vo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	
	public class SettingsVO extends EventDispatcher
	{
		private var _login:LoginVO;

		[Bindable(event="loginChange")]
		public function get login():LoginVO {
			return _login;
		}

		public function set login(value:LoginVO):void {
			if( _login !== value) {
				_login = value;
				dispatchEvent(new Event("loginChange"));
			}
		}
	}
}