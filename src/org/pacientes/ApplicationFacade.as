package org.pacientes
{	
	import org.pacientes.controller.*;
	import org.puremvc.as3.patterns.facade.Facade;

    public class ApplicationFacade extends Facade
    {
		// application
        public static const STARTUP:String = "startup";
        public static const SHUTDOWN:String = "shutdown";
		// notifications
		public static const CHECK_DB_SUCCEED:String = "checkDbSucceed";
		public static const CHECK_DB_FAILED:String = "checkDbFailed";
		public static const SETUP_SETTINGS_SUCCEED:String = "setupSettingsSucceed";
		public static const SETUP_SETTINGS_FAILED:String = "setupSettingsFailed";
		public static const LOGIN_SUCCEED:String = "loginSucceed";
		public static const LOGIN_FAILED:String = "loginFailed";
		public static const LOGOUT_SUCCEED:String = "logoutSucceed";
		public static const GET_ALL_PATIENTS_SUCCEED:String = "getAllPatientsSucceed";
		public static const GET_ALL_PATIENTS_FAILED:String = "getAllPatientsFailed";
		public static const GET_ALL_PATIENT_REPORTS_SUCCEED:String = "getAllPatientReportsSucceed";
		public static const GET_ALL_PATIENT_REPORTS_FAILED:String = "getAllPatientReportsFailed";
		public static const GET_ALL_REPORT_IMAGES_SUCCEED:String = "getAllReportImagesSucceed";
		public static const GET_ALL_REPORT_IMAGES_FAILED:String = "getAllReportImagesFailed";
		public static const SEARCH_PATIENT_SUCCEED:String = "searchPatientSucceed";
		public static const SEARCH_PATIENT_FAILED:String = "searchPatientFailed";
		public static const SAVE_PATIENT_SUCCEED:String = "savePatientSucceed";
		public static const SAVE_PATIENT_FAILED:String = "savePatientFailed";
		public static const SAVE_REPORT_SUCCEED:String = "saveReportSucceed";
		public static const SAVE_REPORT_FAILED:String = "saveReportFailed";
		public static const SAVE_IMAGE_SUCCEED:String = "saveImageSucceed";
		public static const SAVE_IMAGE_FAILED:String = "saveImageFailed";
		public static const DELETE_PATIENT_SUCCEED:String = "deletePatientSucceed";
		public static const DELETE_PATIENT_FAILED:String = "deletePatientFailed";
		public static const DELETE_REPORT_SUCCEED:String = "deleteReportSucceed";
		public static const DELETE_REPORT_FAILED:String = "deleteReportFailed";
		public static const DELETE_IMAGE_SUCCEED:String = "deleteImageSucceed";
		public static const DELETE_IMAGE_FAILED:String = "deleteImageFailed";
		// command
		public static const COMMAND_CHECK_DB:String = "commandCheckDb";
		public static const COMMAND_SETUP_SETTINGS:String = "commandSetupSettings";
		public static const COMMAND_LOGIN:String = "commandLogin";
		public static const COMMAND_LOGOUT:String = "commandLogout";
		public static const COMMAND_GET_ALL_PATIENTS:String = "commandGetAllPatients";
		public static const COMMAND_GET_ALL_PATIENT_REPORTS:String = "commandGetAllPatientReports";
		public static const COMMAND_GET_ALL_REPORT_IMAGES:String = "commandGetAllReportImages";
		public static const COMMAND_SEARCH_PATIENT:String = "commandSearchPatient";
		public static const COMMAND_SAVE_PATIENT:String = "commandSavePatient";
		public static const COMMAND_SAVE_REPORT:String = "commandSaveReport";
		public static const COMMAND_SAVE_IMAGE:String = "commandSaveImage";
		public static const COMMAND_DELETE_PATIENT:String = "commandDeletePatient";
		public static const COMMAND_DELETE_REPORT:String = "commandDeleteReport";
		public static const COMMAND_DELETE_IMAGE:String = "commandDeleteImage";
		// views
		public static const VIEW_WIZARD_SCREEN:String = "viewWizardScreen";
		public static const VIEW_LOGIN_SCREEN:String = "viewLoginScreen";
		public static const VIEW_MAIN_SCREEN:String = "viewMainScreen";
		public static const VIEW_PATIENT_DIALOG:String = "viewPatientDialog";
		public static const VIEW_PATIENT_SCREEN:String = "viewPatientScreen";

        public static function getInstance():ApplicationFacade {
            if (!instance) { 
				instance = new ApplicationFacade();
			}
            return instance as ApplicationFacade;
        }

        override protected function initializeController():void {
            super.initializeController();
            registerCommand(STARTUP, ApplicationStartupCommand);
			registerCommand(COMMAND_CHECK_DB, CheckDbCommand);
			registerCommand(COMMAND_SETUP_SETTINGS, SetupSettingsCommand);
			registerCommand(COMMAND_LOGIN, LoginCommand);
			registerCommand(COMMAND_LOGOUT, LogoutCommand);
			registerCommand(COMMAND_GET_ALL_PATIENTS, GetAllPatientsCommand);
			registerCommand(COMMAND_GET_ALL_PATIENT_REPORTS, GetAllPatientReportsCommand);
			registerCommand(COMMAND_GET_ALL_REPORT_IMAGES, GetAllReportImagesCommand);
			registerCommand(COMMAND_SEARCH_PATIENT, SearchPatientCommand);
			registerCommand(COMMAND_SAVE_PATIENT, SavePatientCommand);
			registerCommand(COMMAND_SAVE_REPORT, SaveReportCommand);
			registerCommand(COMMAND_SAVE_IMAGE, SaveImageCommand);
			registerCommand(COMMAND_DELETE_PATIENT, DeletePatientCommand);
			registerCommand(COMMAND_DELETE_REPORT, DeleteReportCommand);
			registerCommand(COMMAND_DELETE_IMAGE, DeleteImageCommand);
        }
		
		override public function sendNotification(notificationName:String, body:Object=null, type:String=null):void {
			trace("sendNotification (" + notificationName + ")");
			super.sendNotification(notificationName, body, type);
		}

		public function startup(app:Pacientes):void {
			sendNotification(STARTUP, app);
		}
    }
}