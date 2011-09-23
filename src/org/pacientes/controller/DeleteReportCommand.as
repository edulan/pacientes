package org.pacientes.controller
{
	import org.pacientes.model.ReportProxy;
	import org.pacientes.model.vo.ReportVO;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class DeleteReportCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var reportProxy:ReportProxy =  facade.retrieveProxy(ReportProxy.NAME) as ReportProxy;
			
			reportProxy.destroy(notification.getBody() as ReportVO);
		}
		
	}
}