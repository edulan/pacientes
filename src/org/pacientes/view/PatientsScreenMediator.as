package org.pacientes.view
{	
	import mx.collections.ArrayCollection;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.PatientEvent;
	import org.pacientes.model.events.SearchEvent;
	import org.pacientes.view.screens.PatientListScreen;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class PatientsScreenMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "PatientsScreenMediator";
		// Notifications
		public static const SHOW:String = "showPatientsScreen";

        public function PatientsScreenMediator(viewComponent:PatientListScreen) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			patientsScreen.addEventListener(PatientEvent.SELECT, onSelect);
			patientsScreen.addEventListener(SearchEvent.SEARCH, onSearch);
		}
		
		override public function onRemove():void {
			patientsScreen.removeEventListener(PatientEvent.SELECT, onSelect);
			patientsScreen.removeEventListener(SearchEvent.SEARCH, onSearch);
		}

        override public function listNotificationInterests():Array {
            return [
						PatientsScreenMediator.SHOW,
						ApplicationFacade.GET_ALL_PATIENTS_SUCCEED,
						ApplicationFacade.GET_ALL_PATIENTS_FAILED,
						ApplicationFacade.SEARCH_PATIENT_SUCCEED,
						ApplicationFacade.SEARCH_PATIENT_FAILED
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case PatientsScreenMediator.SHOW:
					handleShowPatientsScreen();
					break;
				case ApplicationFacade.GET_ALL_PATIENTS_SUCCEED:
					handleGetAllPatientsSucceed(note.getBody() as ArrayCollection);
					break;
				case ApplicationFacade.GET_ALL_PATIENTS_FAILED:
					handleGetAllPatientsFailed();
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
		
		private function handleShowPatientsScreen():void {
			// Retrieve patients list
			sendNotification(ApplicationFacade.COMMAND_GET_ALL_PATIENTS);
		}
		
		private function handleGetAllPatientsSucceed(patients:ArrayCollection):void {
			patientsScreen.patients = patients;
		}
		
		private function handleGetAllPatientsFailed():void {
			// TODO: Implement
		}
		
		private function handleSearchPatientSucceed(patients:ArrayCollection):void {
			patientsScreen.patients = patients;
		}
		
		private function handleSearchPatientFailed():void {
			// TODO: Implement
		}
		
		/* VIEW LISTENERS */
		
		private function onSelect(event:PatientEvent):void {
			event.stopPropagation();
			//sendNotification(ApplicationFacade.VIEW_REPORT_SCREEN, event.patient);
		}
		
		private function onSearch(event:SearchEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_SEARCH_PATIENT, event.pattern);
		}
		
		protected function get patientsScreen():PatientListScreen {
			return viewComponent as PatientListScreen
		}
    }
}