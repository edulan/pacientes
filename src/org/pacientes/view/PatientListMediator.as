package org.pacientes.view
{	
	import mx.collections.ArrayCollection;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.PatientEvent;
	import org.pacientes.view.screens.PatientList;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class PatientListMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "PatientListMediator";

        public function PatientListMediator(viewComponent:PatientList) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			// Setup listeners
			patientList.addEventListener(PatientEvent.SELECT, onSelect);
			patientList.addEventListener(PatientEvent.EDIT, onEdit);
			patientList.addEventListener(PatientEvent.DELETE, onDelete);
		}
		
		override public function onRemove():void {
			// Remove listeners
			patientList.removeEventListener(PatientEvent.SELECT, onSelect);
			patientList.removeEventListener(PatientEvent.EDIT, onEdit);
			patientList.removeEventListener(PatientEvent.DELETE, onDelete);
		}

        override public function listNotificationInterests():Array {
            return [
						ApplicationFacade.GET_ALL_PATIENTS_SUCCEED,
						ApplicationFacade.GET_ALL_PATIENTS_FAILED,
						ApplicationFacade.SEARCH_PATIENT_SUCCEED,
						ApplicationFacade.SEARCH_PATIENT_FAILED
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case ApplicationFacade.GET_ALL_PATIENTS_SUCCEED:
					handleGetAllPatientsSucceed(note.getBody() as ArrayCollection);
					break;
				case ApplicationFacade.GET_ALL_PATIENTS_FAILED:
					handleGetAllPatientsFailed();
					break;
				case ApplicationFacade.DELETE_PATIENT_SUCCEED:
					handleDeletePatientSucceed();
					break;
				case ApplicationFacade.DELETE_PATIENT_FAILED:
					handleDeletePatientFailed();
					break;
				case ApplicationFacade.SEARCH_PATIENT_SUCCEED:
					handleSearchPatientSucceed(note.getBody() as ArrayCollection);
					break;
				case ApplicationFacade.SEARCH_PATIENT_FAILED:
					handleSearchPatientFailed();
					break;
            }
        }
		
		/* NOTIFICATION HANDLERS */
		
		private function handleGetAllPatientsSucceed(patients:ArrayCollection):void {
			patientList.patients = patients;
		}
		
		private function handleGetAllPatientsFailed():void {
			// TODO: Implement
		}
		
		private function handleDeletePatientSucceed():void {
			// TODO: Implement
		}
		
		private function handleDeletePatientFailed():void {
			// TODO: Implement
		}
		
		private function handleSearchPatientSucceed(patients:ArrayCollection):void {
			patientList.patients = patients;
		}
		
		private function handleSearchPatientFailed():void {
			// TODO: Implement
		}
		
		/* VIEW LISTENERS */
		
		private function onSelect(event:PatientEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.VIEW_PATIENT_SCREEN, event.patient);
		}
		
		private function onEdit(event:PatientEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.VIEW_PATIENT_DIALOG, event.patient);
		}
		
		private function onDelete(event:PatientEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_DELETE_PATIENT, event.patient);
		}
		
		protected function get patientList():PatientList {
			return viewComponent as PatientList
		}
    }
}