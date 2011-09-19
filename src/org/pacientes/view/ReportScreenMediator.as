package org.pacientes.view
{	
	import mx.collections.ArrayCollection;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.PatientVO;
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
						ReportScreenMediator.SHOW,
						ApplicationFacade.GET_ALL_PATIENT_REPORTS_SUCCEED,
						ApplicationFacade.GET_ALL_PATIENT_REPORTS_FAILED
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case ReportScreenMediator.SHOW:
					reportScreen.patient = note.getBody() as PatientVO;
					sendNotification(ApplicationFacade.COMMAND_GET_ALL_PATIENT_REPORTS);
					break;
				case ApplicationFacade.GET_ALL_PATIENT_REPORTS_SUCCEED:
					reportScreen.reports = new ArrayCollection(note.getBody() as Array);
					break;
				case ApplicationFacade.GET_ALL_PATIENT_REPORTS_FAILED:
					break;
            }
        }
		
		/* VIEW LISTENERS */
		
		protected function get reportScreen():ReportScreen {
			return viewComponent as ReportScreen
		}
    }
}