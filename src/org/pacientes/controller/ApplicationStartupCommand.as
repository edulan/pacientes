package org.pacientes.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;

    public class ApplicationStartupCommand extends MacroCommand
    {
        override protected function initializeMacroCommand() :void {
            addSubCommand(ModelPrepCommand);
            addSubCommand(ViewPrepCommand);
        }
    }
}
