package org.pacientes.model
{
	import org.pacientes.ApplicationFacade;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ReportProxy extends Proxy
	{
		public static const NAME:String = "ReportProxy";
		
		public function ReportProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		public function findAll(patient:Object):void {
			sendNotification(
				ApplicationFacade.GET_ALL_PATIENT_REPORTS_SUCCEED,
				[
					{label:"report1"},
					{label:"report2"},
					{label:"report3"}
				]
			);
		}
	}
}