package org.pacientes.view
{	
	import mx.events.StateChangeEvent;
	
	import org.pacientes.ApplicationFacade;
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
		}

        override public function listNotificationInterests():Array {
            return [
						ApplicationFacade.VIEW_LOGIN_SCREEN,
						ApplicationFacade.VIEW_HOME_SCREEN
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case ApplicationFacade.VIEW_LOGIN_SCREEN:
					app.currentState = app.loginState.name;
					break;
				case ApplicationFacade.VIEW_HOME_SCREEN:
					app.currentState = app.homeState.name;
					break;
            }
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
					facade.removeMediator(HomeScreenMediator.NAME);
					break;
			}
			// Register a new mediator for next screen
			switch (event.newState) {
				case app.loginState.name:
					facade.registerMediator(new LoginScreenMediator(app.loginScreen));
					break;
				case app.homeState.name:
					facade.registerMediator(new HomeScreenMediator(app.homeScreen));
					break;
			}
		}
		
		protected function get app():Pacientes {
			return viewComponent as Pacientes
		}
    }
}