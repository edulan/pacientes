package org.pacientes.controller
{
	import org.pacientes.model.PatientProxy;
	import org.pacientes.model.vo.PatientVO;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SavePatientCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var patientProxy:PatientProxy = facade.retrieveProxy(PatientProxy.NAME) as PatientProxy;
			var patient:PatientVO = notification.getBody() as PatientVO;

			if (!patient.isSaved()) {
				patientProxy.create(patient);
			} else {
				patientProxy.update(patient);
			}
		}
	}
}