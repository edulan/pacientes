package org.pacientes.model.events
{
	import flash.events.Event;
	
	import org.pacientes.model.vo.LoginVO;
	
	public class LoginEvent extends Event
	{
		public static const SUBMIT:String = "submitEvent";
		
		private var _login:LoginVO;
		
		public function LoginEvent(type:String, login:LoginVO=null) {
			super(type, true, false);
			_login = login;
		}

		public function get login():LoginVO {
			return _login;
		}
	}
}