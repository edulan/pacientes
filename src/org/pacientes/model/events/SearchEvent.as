package org.pacientes.model.events
{
	import flash.events.Event;
	
	public class SearchEvent extends Event
	{
		public static const SEARCH:String = "searchPatientEvent";
		
		private var _pattern:String;
		
		public function SearchEvent(type:String, pattern:String):void {
			super(type, true, false);
			_pattern = pattern;
		}
		
		
		public function get pattern():String {
			return _pattern;
		}
	}
}