package org.pacientes.model.events
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		public static const SUBMIT:String = "submitEvent";
		
		public function LoginEvent(type:String) {
			super(type, true, false);
		}
	}
}