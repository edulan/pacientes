package org.pacientes.view
{
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.WizardEvent;
	import org.pacientes.model.vo.LoginVO;
	import org.pacientes.model.vo.SettingsVO;
	import org.pacientes.view.screens.WizardDialog;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class WizardDialogMediator extends Mediator
	{
		// Cannonical name of the Mediator
		public static const NAME:String = "WizardDialogMediator";
		// Notifications
		public static const SHOW:String = "showWizardDialog";
		public static const CLOSE:String = "closeWizardDialog";
		
		public function WizardDialogMediator(viewComponent:WizardDialog) {
			super(NAME, viewComponent);
		}

		override public function onRegister():void {
			wizardDialog.addEventListener(WizardEvent.SAVE, onSave);
			wizardDialog.addEventListener(WizardEvent.CANCEL, onCancel);
		}

		override public function onRemove():void {
			wizardDialog.removeEventListener(WizardEvent.SAVE, onSave);
			wizardDialog.removeEventListener(WizardEvent.CANCEL, onCancel);
		}

		override public function listNotificationInterests():Array {
			return [
						WizardDialogMediator.SHOW,
						ApplicationFacade.SETUP_SETTINGS_SUCCEED,
						ApplicationFacade.SETUP_SETTINGS_FAILED
					];
		}

		override public function handleNotification(note:INotification):void {
			switch(note.getName()) {
				case WizardDialogMediator.SHOW:
					handleShowWizardDialog(note.getBody() as SettingsVO);
					break;
				case ApplicationFacade.SETUP_SETTINGS_SUCCEED:
					handleSetupSettingsSucceed();
					break;
				case ApplicationFacade.SETUP_SETTINGS_FAILED:
					handleSetupSettingsFailed();
					break;
			}
		}
		
		/* NOTIFICATION HANDLERS */
		
		private function handleShowWizardDialog(settings:SettingsVO):void {
			settings.login = new LoginVO();
			wizardDialog.settings = settings;
		}
		
		private function handleSetupSettingsSucceed():void {
			sendNotification(WizardDialogMediator.CLOSE, wizardDialog);
		}
		
		private function handleSetupSettingsFailed():void {
			// TODO: Implement
		}
		
		/* VIEW LISTENERS */
		
		private function onSave(event:WizardEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_SETUP_SETTINGS, event.settings);
		}
		
		private function onCancel(event:WizardEvent):void {
			event.stopPropagation();
			sendNotification(WizardDialogMediator.CLOSE, wizardDialog);
		}
		
		protected function get wizardDialog():WizardDialog {
			return viewComponent as WizardDialog;
		}
	}
}