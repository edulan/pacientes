package org.pacientes.model.events
{
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		public static const ADD:String = "addPatientEvent";
		
		public function MenuEvent(type:String) {
			super(type, true, false);
		}
	}
}