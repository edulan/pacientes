package org.pacientes.model.events
{
	import flash.events.Event;
	
	import org.pacientes.model.vo.SettingsVO;
	
	public class WizardEvent extends Event
	{
		private var _settings:SettingsVO;
		
		public static const SAVE:String = "saveWizardEvent";
		public static const CANCEL:String = "cancelWizardEvent";
		
		public function WizardEvent(type:String, settings:SettingsVO=null) {
			super(type, true, false);
			_settings = settings;
		}

		public function get settings():SettingsVO {
			return _settings;
		}
	}
}