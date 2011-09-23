package org.pacientes.controller
{
	import org.pacientes.model.ImageProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GetAllReportImagesCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var imageProxy:ImageProxy = facade.retrieveProxy(ImageProxy.NAME) as ImageProxy;
			var reportId:int = notification.getBody() as int;
			
			imageProxy.findAll(reportId);
		}
	}
}