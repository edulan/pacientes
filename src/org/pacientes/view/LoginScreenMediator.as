package org.pacientes.view
{	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.LoginEvent;
	import org.pacientes.model.vo.LoginVO;
	import org.pacientes.view.screens.LoginScreen;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class LoginScreenMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "LoginScreenMediator";
		// Notifications
		public static const SHOW:String = "showLoginScreen";

        public function LoginScreenMediator(viewComponent:LoginScreen) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			loginScreen.addEventListener(LoginEvent.SUBMIT, onSubmit);
		}
		
		override public function onRemove():void {
			loginScreen.removeEventListener(LoginEvent.SUBMIT, onSubmit);
		}

        override public function listNotificationInterests():Array {
            return [
						LoginScreenMediator.SHOW,
						ApplicationFacade.LOGIN_SUCCEED,
						ApplicationFacade.LOGIN_FAILED
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case LoginScreenMediator.SHOW:
					handleShowLoginScreen();
					break;
				case ApplicationFacade.LOGIN_SUCCEED:
					handleLoginSucceed();
					break;
				case ApplicationFacade.LOGIN_FAILED:
					handleLoginFailed();
					break;
            }
        }
		
		/* NOTIFICATION HANDLERS */
		
		private function handleShowLoginScreen():void {
			loginScreen.login = new LoginVO();
		}
		
		private function handleLoginSucceed():void {
			sendNotification(ApplicationFacade.VIEW_MAIN_SCREEN);
		}
		
		private function handleLoginFailed():void {
			// TODO: Implement
		}
		
		/* VIEW LISTENERS */
		
		private function onSubmit(event:LoginEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_LOGIN, event.login);
		}
		
		protected function get loginScreen():LoginScreen {
			return viewComponent as LoginScreen
		}
    }
}