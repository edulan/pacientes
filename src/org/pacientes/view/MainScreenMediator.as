package org.pacientes.view
{	
	import mx.managers.PopUpManager;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.MenuEvent;
	import org.pacientes.model.events.SearchEvent;
	import org.pacientes.model.vo.PatientVO;
	import org.pacientes.view.screens.MainScreen;
	import org.pacientes.view.screens.PatientDialog;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class MainScreenMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "MainScreenMediator";
		// Notifications
		public static const SHOW:String = "showMainScreen";

        public function MainScreenMediator(viewComponent:MainScreen) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			// Setup listeners
			mainScreen.addEventListener(MenuEvent.ADD, onAdd);
			mainScreen.addEventListener(SearchEvent.SEARCH, onSearch);
			// Register mediators
			facade.registerMediator(new PatientListMediator(mainScreen.patientList));
			facade.registerMediator(new PatientTabMediator(mainScreen.patientTab));
		}
		
		override public function onRemove():void {
			// Remove listeners
			mainScreen.removeEventListener(MenuEvent.ADD, onAdd);
			mainScreen.removeEventListener(SearchEvent.SEARCH, onSearch);
			// Remove mediators
			facade.removeMediator(PatientListMediator.NAME);
			facade.removeMediator(PatientTabMediator.NAME);
		}

        override public function listNotificationInterests():Array {
            return [
						ApplicationFacade.VIEW_PATIENT_DIALOG,
						PatientDialogMediator.CLOSE
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case ApplicationFacade.VIEW_PATIENT_DIALOG:
					handleViewPatientDialog(note.getBody() as PatientVO);
					break;
				case PatientDialogMediator.CLOSE:
					handleClosePatientDialog(note.getBody() as PatientDialog);
					break;
            }
        }

		/* NOTIFICATION HANDLERS */

		private function handleViewPatientDialog(patient:PatientVO):void {
			var patientDialog:PatientDialog =
				PopUpManager.createPopUp(mainScreen, PatientDialog,  true) as PatientDialog;
			
			PopUpManager.centerPopUp(patientDialog);
			// Register mediator
			facade.registerMediator(new PatientDialogMediator(patientDialog));
			sendNotification(PatientDialogMediator.SHOW, patient);
		}
		
		private function handleClosePatientDialog(patientDialog:PatientDialog):void {
			PopUpManager.removePopUp(patientDialog);
			// Remove mediator
			facade.removeMediator(PatientDialogMediator.NAME);
		}
		
		/* VIEW LISTENERS */
		
		private function onAdd(event:MenuEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.VIEW_PATIENT_DIALOG, new PatientVO());
		}
		
		private function onSearch(event:SearchEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_SEARCH_PATIENT, event.pattern);
		}
		
		protected function get mainScreen():MainScreen {
			return viewComponent as MainScreen
		}
    }
}