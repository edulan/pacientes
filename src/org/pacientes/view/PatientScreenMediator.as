package org.pacientes.view
{	
	import mx.collections.ArrayCollection;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.ReportEvent;
	import org.pacientes.model.vo.PatientVO;
	import org.pacientes.model.vo.ReportVO;
	import org.pacientes.view.screens.PatientScreen;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class PatientScreenMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "PatientScreenMediator";
		// Notifications
		public static const SHOW:String = "showPatientScreen";

        public function PatientScreenMediator(viewComponent:PatientScreen) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			// Setup listeners
			patientScreen.addEventListener(ReportEvent.ADD, onAdd);
			patientScreen.addEventListener(ReportEvent.SELECT, onSelect);
			patientScreen.addEventListener(ReportEvent.DELETE, onDelete);
		}
		
		override public function onRemove():void {
			// Remove listeners
			patientScreen.removeEventListener(ReportEvent.ADD, onAdd);
			patientScreen.removeEventListener(ReportEvent.SELECT, onSelect);
			patientScreen.removeEventListener(ReportEvent.DELETE, onDelete);
		}

        override public function listNotificationInterests():Array {
            return [
						PatientScreenMediator.SHOW,
						ApplicationFacade.GET_ALL_PATIENT_REPORTS_SUCCEED,
						ApplicationFacade.GET_ALL_PATIENT_REPORTS_FAILED,
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case PatientScreenMediator.SHOW:
					handleShowPatient(note.getBody() as PatientVO);
					break;
				case ApplicationFacade.GET_ALL_PATIENT_REPORTS_SUCCEED:
					handleGetAllPatientReportsSucceed(note.getBody() as ArrayCollection);
					break;
				case ApplicationFacade.GET_ALL_PATIENT_REPORTS_FAILED:
					handleGetAllPatientReportsFailed();
					break;
            }
        }
		
		/* NOTIFICATION HANDLERS */
		
		private function handleShowPatient(patient:PatientVO):void {
			patientScreen.patient = patient;
			sendNotification(ApplicationFacade.COMMAND_GET_ALL_PATIENT_REPORTS, patient.patientId);
		}
		
		private function handleGetAllPatientReportsSucceed(reports:ArrayCollection):void {
			patientScreen.patient.reports = reports;
			sendNotification(ReportScreenMediator.SHOW, null);
		}
		
		private function handleGetAllPatientReportsFailed():void {
			// TODO: Implement
		}
		
		/* VIEW LISTENERS */
		
		private function onAdd(event:ReportEvent):void {
			event.stopPropagation();

			var report:ReportVO = new ReportVO();
			
			report.patientId = patientScreen.patient.patientId;
			patientScreen.patient.reports.addItem(report);
		}
		
		private function onSelect(event:ReportEvent):void {
			event.stopPropagation();
			facade.registerMediator(new ReportScreenMediator(patientScreen.reportScreen));
			sendNotification(ReportScreenMediator.SHOW, event.report);
		}
		
		private function onDelete(event:ReportEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_DELETE_REPORT, event.report);
		}
		
		protected function get patientScreen():PatientScreen {
			return viewComponent as PatientScreen
		}
    }
}