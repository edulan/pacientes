package org.pacientes.view
{	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.PatientEvent;
	import org.pacientes.model.vo.PatientVO;
	import org.pacientes.view.screens.PatientTab;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class PatientTabMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "PatientTabMediator";

        public function PatientTabMediator(viewComponent:PatientTab) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			// Setup listeners
			patientTab.addEventListener(PatientEvent.CHANGE, onChange);
		}
		
		override public function onRemove():void {
			// Remove listeners
			patientTab.removeEventListener(PatientEvent.CHANGE, onChange);
		}

        override public function listNotificationInterests():Array {
            return [
						ApplicationFacade.VIEW_PATIENT_SCREEN
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case ApplicationFacade.VIEW_PATIENT_SCREEN:
					handleViewPatient(note.getBody() as PatientVO);
					break;
            }
        }
		
		/* NOTIFICATION HANDLERS */
		
		private function handleViewPatient(patient:PatientVO):void {
			patientTab.patients.addItem(patient);
			
			facade.registerMediator(new PatientScreenMediator(patientTab.patientScreen));
			sendNotification(PatientScreenMediator.SHOW, patient);
		}
		
		/* VIEW LISTENERS */
		
		private function onChange(event:PatientEvent):void {
			sendNotification(PatientScreenMediator.SHOW, event.patient);
		}
		
		protected function get patientTab():PatientTab {
			return viewComponent as PatientTab
		}
    }
}