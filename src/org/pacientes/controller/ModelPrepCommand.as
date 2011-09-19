package org.pacientes.controller
{	
	import org.pacientes.model.LoginProxy;
	import org.pacientes.model.PatientProxy;
	import org.pacientes.model.ReportProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

    public class ModelPrepCommand extends SimpleCommand
	{
        override public function execute(note:INotification):void {
			// Register proxies
			facade.registerProxy(new LoginProxy());
			facade.registerProxy(new PatientProxy());
			facade.registerProxy(new ReportProxy());
        }
    }
}