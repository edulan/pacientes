package org.pacientes.view
{	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.PatientEvent;
	import org.pacientes.model.vo.PatientVO;
	import org.pacientes.view.screens.PatientDialog;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class PatientDialogMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "PatientDialogMediator";
		// Notifications
		public static const SHOW:String = "showPatientDialog";
		public static const CLOSE:String = "closePatientDialog";

        public function PatientDialogMediator(viewComponent:PatientDialog) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			patientDialog.addEventListener(PatientEvent.CREATE, onCreate);
			patientDialog.addEventListener(PatientEvent.CANCEL, onCancel);
		}
		
		override public function onRemove():void {
			patientDialog.removeEventListener(PatientEvent.CREATE, onCreate);
			patientDialog.addEventListener(PatientEvent.CANCEL, onCancel);
		}

        override public function listNotificationInterests():Array {
            return [
						PatientDialogMediator.SHOW,
						ApplicationFacade.CREATE_PATIENT_SUCCEED,
						ApplicationFacade.CREATE_PATIENT_FAILED
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case PatientDialogMediator.SHOW:
					handleShowPatientDialog(note.getBody() as PatientVO);
					break;
				case ApplicationFacade.CREATE_PATIENT_SUCCEED:
					handleCreatePatientSucceed();
					break;
				case ApplicationFacade.CREATE_PATIENT_FAILED:
					handleCreatePatientFailed();
					break;
            }
        }
		
		/* NOTIFICATION HANDLERS */
		
		private function handleShowPatientDialog(patient:PatientVO):void {
			patientDialog.patient = patient;
		}
		
		private function handleCreatePatientSucceed():void {
			sendNotification(PatientDialogMediator.CLOSE, patientDialog);
		}
		
		private function handleCreatePatientFailed():void {
			sendNotification(PatientDialogMediator.CLOSE, patientDialog);
		}
		
		/* VIEW LISTENERS */
		
		private function onCreate(event:PatientEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_CREATE_PATIENT, event.patient);
		}
		
		private function onCancel(event:PatientEvent):void {
			event.stopPropagation();
			sendNotification(PatientDialogMediator.CLOSE, patientDialog);
		}
		
		protected function get patientDialog():PatientDialog {
			return viewComponent as PatientDialog
		}
    }
}