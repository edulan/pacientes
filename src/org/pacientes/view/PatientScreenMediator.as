package org.pacientes.view
{	
	import org.pacientes.model.events.ReportEvent;
	import org.pacientes.model.vo.PatientVO;
	import org.pacientes.model.vo.ReportVO;
	import org.pacientes.view.screens.PatientScreen;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class PatientScreenMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "PatientScreenMediator";
		// Notifications
		public static const SHOW:String = "showPatientScreen";

        public function PatientScreenMediator(viewComponent:PatientScreen) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			// Setup listeners
			patientScreen.addEventListener(ReportEvent.ADD, onAdd);
			patientScreen.addEventListener(ReportEvent.SELECT, onSelect);
		}
		
		override public function onRemove():void {
			// Remove listeners
			patientScreen.removeEventListener(ReportEvent.ADD, onAdd);
			patientScreen.removeEventListener(ReportEvent.SELECT, onSelect);
		}

        override public function listNotificationInterests():Array {
            return [
						PatientScreenMediator.SHOW
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case PatientScreenMediator.SHOW:
					handleShowPatient(note.getBody() as PatientVO);
					break;
            }
        }
		
		/* NOTIFICATION HANDLERS */
		
		private function handleShowPatient(patient:PatientVO):void {
			patientScreen.patient = patient;
		}
		
		/* VIEW LISTENERS */
		
		private function onAdd(event:ReportEvent):void {
			patientScreen.patient.reports.addItem(new ReportVO());
		}
		
		private function onSelect(event:ReportEvent):void {
			facade.registerMediator(new ReportScreenMediator(patientScreen.reportScreen));
			sendNotification(ReportScreenMediator.SHOW, event.report);
		}
		
		protected function get patientScreen():PatientScreen {
			return viewComponent as PatientScreen
		}
    }
}