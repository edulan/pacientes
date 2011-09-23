package org.pacientes.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class LoginVO extends EventDispatcher
	{
		private var _username:String;
		private var _password:String;

		[Bindable(event="usernameChange")]
		public function get username():String {
			return _username;
		}

		public function set username(value:String):void {
			if( _username !== value) {
				_username = value;
				dispatchEvent(new Event("usernameChange"));
			}
		}		

		[Bindable(event="passwordChange")]
		public function get password():String {
			return _password;
		}

		public function set password(value:String):void {
			if( _password !== value) {
				_password = value;
				dispatchEvent(new Event("passwordChange"));
			}
		}
		
		public function generateKey():String {
			return username + ":" + password;
		}
	}
}