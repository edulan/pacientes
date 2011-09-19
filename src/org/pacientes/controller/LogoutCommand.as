package org.pacientes.controller
{	
	import org.pacientes.model.LoginProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LogoutCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var loginProxy:LoginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
			
			loginProxy.logout();
		}
	}
}