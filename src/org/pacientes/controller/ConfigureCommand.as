package org.pacientes.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class ConfigureCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void {
			addSubCommand(SetupDbCommand);
		}
	}
}