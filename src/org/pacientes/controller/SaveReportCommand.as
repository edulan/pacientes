package org.pacientes.controller
{
	import org.pacientes.model.ReportProxy;
	import org.pacientes.model.vo.ReportVO;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SaveReportCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var reportProxy:ReportProxy = facade.retrieveProxy(ReportProxy.NAME) as ReportProxy;
			var report:ReportVO = notification.getBody() as ReportVO;

			if (!report.isSaved()) {
				reportProxy.create(report);
			} else {
				reportProxy.update(report);
			}
		}
	}
}