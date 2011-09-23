package org.pacientes.controller
{
	import org.pacientes.model.ImageProxy;
	import org.pacientes.model.vo.ImageVO;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class DeleteImageCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void {
			var imageProxy:ImageProxy = facade.retrieveProxy(ImageProxy.NAME) as ImageProxy;
			
			imageProxy.destroy(notification.getBody() as ImageVO);
		}
	}
}