package org.pacientes.controller
{
	import org.pacientes.model.PatientProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GetAllPatientsCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var patientProxy:PatientProxy = facade.retrieveProxy(PatientProxy.NAME) as PatientProxy;
			
			patientProxy.findAll();
		}
	}
}