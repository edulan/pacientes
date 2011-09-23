package org.pacientes.view
{	
	import mx.events.StateChangeEvent;
	import mx.managers.PopUpManager;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.SettingsVO;
	import org.pacientes.view.screens.WizardDialog;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class ApplicationMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "ApplicationMediator";

        public function ApplicationMediator(viewComponent:Pacientes) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			app.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);
			// Check for application database
			sendNotification(ApplicationFacade.COMMAND_CHECK_DB);
		}

        override public function listNotificationInterests():Array {
            return [
						ApplicationFacade.CHECK_DB_SUCCEED,
						ApplicationFacade.CHECK_DB_FAILED,
						ApplicationFacade.VIEW_WIZARD_SCREEN,
						WizardDialogMediator.CLOSE,
						ApplicationFacade.VIEW_LOGIN_SCREEN,
						ApplicationFacade.VIEW_MAIN_SCREEN
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case ApplicationFacade.CHECK_DB_SUCCEED:
					handleCheckDbSucceed();
					break;
				case ApplicationFacade.CHECK_DB_FAILED:
					handleCheckDbFailed();
					break;
				case ApplicationFacade.VIEW_WIZARD_SCREEN:
					handleViewWizardDialog(note.getBody() as SettingsVO);
					break;
				case WizardDialogMediator.CLOSE:
					handleCloseWizardDialog(note.getBody() as WizardDialog);
					break;
				case ApplicationFacade.VIEW_LOGIN_SCREEN:
					handleViewLoginScreen();
					break;
				case ApplicationFacade.VIEW_MAIN_SCREEN:
					handleViewMainScreen();
					break;
            }
        }
		
		/* NOTIFICATION HANDLERS */
		
		private function handleCheckDbSucceed():void {
			sendNotification(ApplicationFacade.VIEW_LOGIN_SCREEN);
		}
		
		private function handleCheckDbFailed():void {
			sendNotification(ApplicationFacade.VIEW_WIZARD_SCREEN, new SettingsVO());
		}
		
		private function handleViewWizardDialog(settings:SettingsVO):void {
			var wizardDialog:WizardDialog =
				PopUpManager.createPopUp(app, WizardDialog,  true) as WizardDialog;
			
			PopUpManager.centerPopUp(wizardDialog);
			// Register mediator
			facade.registerMediator(new WizardDialogMediator(wizardDialog));
			sendNotification(WizardDialogMediator.SHOW, settings);
		}
		
		private function handleCloseWizardDialog(wizardDialog:WizardDialog):void {
			PopUpManager.removePopUp(wizardDialog);
			// Remove mediator
			facade.removeMediator(WizardDialogMediator.NAME);
			sendNotification(ApplicationFacade.VIEW_LOGIN_SCREEN);
		}
		
		private function handleViewLoginScreen():void {
			app.currentState = app.loginState.name;
		}
		
		private function handleViewMainScreen():void {
			app.currentState = app.homeState.name;
		}
		
		/* VIEW LISTENERS */
		
		private function onStateChange(event:StateChangeEvent):void {
			event.stopPropagation();
			// Remove previous screen mediator
			switch (event.oldState) {
				case app.loginState.name:
					facade.removeMediator(LoginScreenMediator.NAME);
					break;
				case app.homeState.name:
					facade.removeMediator(MainScreenMediator.NAME);
					break;
			}
			// Register a new mediator for next screen
			switch (event.newState) {
				case app.loginState.name:
					facade.registerMediator(new LoginScreenMediator(app.loginScreen));
					sendNotification(LoginScreenMediator.SHOW);
					break;
				case app.homeState.name:
					facade.registerMediator(new MainScreenMediator(app.homeScreen));
					sendNotification(MainScreenMediator.SHOW);
					break;
			}
		}
		
		protected function get app():Pacientes {
			return viewComponent as Pacientes
		}
    }
}