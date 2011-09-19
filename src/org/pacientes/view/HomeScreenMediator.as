package org.pacientes.view
{	
	import mx.managers.PopUpManager;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.MenuEvent;
	import org.pacientes.model.vo.PatientVO;
	import org.pacientes.view.screens.HomeScreen;
	import org.pacientes.view.screens.PatientDialog;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class HomeScreenMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "HomeScreenMediator";

        public function HomeScreenMediator(viewComponent:HomeScreen) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			// Setup listeners
			homeScreen.addEventListener(MenuEvent.ADD, onAdd);
			homeScreen.addEventListener(MenuEvent.EXIT, onExit);
			// Register mediators
			facade.registerMediator(new PatientsScreenMediator(homeScreen.patientListScreen));
		}
		
		override public function onRemove():void {
			// Remove listeners
			homeScreen.removeEventListener(MenuEvent.ADD, onAdd);
			homeScreen.removeEventListener(MenuEvent.EXIT, onExit);
			// Remove mediators
			facade.removeMediator(PatientsScreenMediator.NAME);
		}

        override public function listNotificationInterests():Array {
            return [
						ApplicationFacade.LOGOUT_SUCCEED,
						PatientDialogMediator.CLOSE
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case ApplicationFacade.LOGOUT_SUCCEED:
					sendNotification(ApplicationFacade.VIEW_LOGIN_SCREEN);
					break;
				case PatientDialogMediator.CLOSE:
					handleClosePatientDialog(note.getBody() as PatientDialog);
					break;
            }
        }

		/* NOTIFICATION HANDLERS */
		
		private function handleClosePatientDialog(patientDialog:PatientDialog):void {
			PopUpManager.removePopUp(patientDialog);
			// Remove mediator
			facade.removeMediator(PatientDialogMediator.NAME);
		}
		
		/* VIEW LISTENERS */
		
		private function onAdd(event:MenuEvent):void {
			event.stopPropagation();
			
			var patientDialog:PatientDialog =
				PopUpManager.createPopUp(homeScreen, PatientDialog,  true) as PatientDialog;
			
			PopUpManager.centerPopUp(patientDialog);
			// Register mediator
			facade.registerMediator(new PatientDialogMediator(patientDialog));
			sendNotification(PatientDialogMediator.SHOW, new PatientVO());
		}

		private function onExit(event:MenuEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_LOGOUT);
		}
		
		protected function get homeScreen():HomeScreen {
			return viewComponent as HomeScreen
		}
    }
}