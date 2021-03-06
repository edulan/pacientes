package org.pacientes.controller
{
	import org.pacientes.model.SettingsProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CheckDbCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var settingsProxy:SettingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
			
			settingsProxy.checkDatabase();
		}
		
	}
}