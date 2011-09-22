package org.pacientes.model.events
{
	import flash.events.Event;
	
	import org.pacientes.model.vo.PatientVO;
	
	public class PatientEvent extends Event
	{
		public static const SELECT:String = "selectPatientEvent";
		public static const CHANGE:String = "changePatientEvent";
		public static const SAVE:String = "savePatientEvent";
		public static const EDIT:String = "editPatientEvent";
		public static const DELETE:String = "deletePatientEvent";
		public static const CANCEL:String = "cancelPatientEvent";
		
		private var _patient:PatientVO

		public function PatientEvent(type:String, patient:PatientVO=null) {
			super(type, true, false);
			_patient = patient
		}
		
		public function get patient():PatientVO {
			return _patient;
		}
	}
}