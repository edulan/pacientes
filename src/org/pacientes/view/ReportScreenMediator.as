package org.pacientes.view
{	
	import org.pacientes.model.vo.ReportVO;
	import org.pacientes.view.screens.ReportScreen;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class ReportScreenMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "ReportScreenMediator";
		// Notifications
		public static const SHOW:String = "showReportScreen";

        public function ReportScreenMediator(viewComponent:ReportScreen) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {

		}
		
		override public function onRemove():void {

		}

        override public function listNotificationInterests():Array {
            return [
						ReportScreenMediator.SHOW
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case ReportScreenMediator.SHOW:
					handleShowReport(note.getBody() as ReportVO);
					break;
            }
        }
		
		/* NOTIFICATION HANDLERS */
		
		private function handleShowReport(report:ReportVO):void {
			reportScreen.report = report;
		}
		
		/* VIEW LISTENERS */
		
		protected function get reportScreen():ReportScreen {
			return viewComponent as ReportScreen
		}
    }
}