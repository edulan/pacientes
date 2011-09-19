package org.pacientes.controller
{
	import org.pacientes.model.PatientProxy;
	import org.pacientes.model.vo.PatientVO;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class DeletePatientCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var patientProxy:PatientProxy = facade.retrieveProxy(PatientProxy.NAME) as PatientProxy;

			patientProxy.destroy(notification.getBody() as PatientVO);
		}
	}
}