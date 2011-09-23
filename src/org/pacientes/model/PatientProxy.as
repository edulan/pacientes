package org.pacientes.model
{
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.PatientVO;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class PatientProxy extends Proxy
	{
		public static const NAME:String = "PatientProxy";

		private var _loginProxy:LoginProxy;
		
		public function PatientProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		override public function onRegister():void {
			_loginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
		}

		public function findAll():void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.itemClass = PatientVO;
			sqlStatement.text = "SELECT * FROM patients";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				data = new ArrayCollection(sqlStatement.getResult().data);
				sendNotification(ApplicationFacade.GET_ALL_PATIENTS_SUCCEED, patients);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				data = null;
				sendNotification(ApplicationFacade.GET_ALL_PATIENTS_FAILED);
			});
			sqlStatement.execute();
		}
		
		public function create(patient:PatientVO):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.parameters[":name"] = patient.name;
			sqlStatement.parameters[":lastname"] = patient.lastname;
			sqlStatement.parameters[":age"] = patient.age;
			sqlStatement.parameters[":insurance"] = patient.insurance;
			sqlStatement.parameters[":doctor"] = patient.doctor;
			sqlStatement.parameters[":other"] = patient.other;
			sqlStatement.text = "INSERT INTO patients " +
				"(name, lastname, age, insurance, doctor, other, lastUpdated) " +
				"VALUES(:name, :lastname, :age, :insurance, :doctor, :other, (DATETIME('NOW')))";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				sendNotification(ApplicationFacade.SAVE_PATIENT_SUCCEED);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				sendNotification(ApplicationFacade.SAVE_PATIENT_FAILED);
			});
			sqlStatement.execute();
		}
		
		public function update(patient:PatientVO):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.parameters[":patientId"] = patient.patientId;
			sqlStatement.parameters[":name"] = patient.name;
			sqlStatement.parameters[":lastname"] = patient.lastname;
			sqlStatement.parameters[":age"] = patient.age;
			sqlStatement.parameters[":insurance"] = patient.insurance;
			sqlStatement.parameters[":doctor"] = patient.doctor;
			sqlStatement.parameters[":other"] = patient.other;
			sqlStatement.text = "UPDATE patients SET " +
				"name = :name, " +
				"lastname = :lastname, " +
				"age = :age, " +
				"insurance = :insurance, " +
				"doctor = :doctor, " +
				"other = :other, " +
				"lastUpdated = (DATETIME('NOW')) " +
				"WHERE patientId = :patientId";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				// TODO: Reload object from database
				patients.itemUpdated(patient);
				sendNotification(ApplicationFacade.SAVE_PATIENT_SUCCEED);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				sendNotification(ApplicationFacade.SAVE_PATIENT_FAILED);
			});
			sqlStatement.execute();
		}
		
		public function destroy(patient:PatientVO):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.parameters[":patientId"] = patient.patientId;
			sqlStatement.text = "DELETE FROM patients " +
				"WHERE patientId = :patientId";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				var patientIndex:int = patients.getItemIndex(patient);
				
				if (patientIndex != -1) {
					patients.removeItemAt(patientIndex);
				}
				sendNotification(ApplicationFacade.DELETE_PATIENT_SUCCEED, patients);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				sendNotification(ApplicationFacade.DELETE_PATIENT_FAILED);
			});
			sqlStatement.execute();
		}
		
		public function search(pattern:String):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.itemClass = PatientVO;
			//sqlStatement.parameters[":name"] = pattern;
			// TODO: Find how to escape parameters when using '%' symbol
			if (pattern != "") {
				sqlStatement.text = "SELECT * " +
					"FROM patients " +
					"WHERE name LIKE '%" + pattern + "%' "
					"OR lastname LIKE '%" + pattern + "%'";
			} else {
				sqlStatement.text = "SELECT * FROM patients";
			}
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				data = new ArrayCollection(sqlStatement.getResult().data);
				sendNotification(ApplicationFacade.SEARCH_PATIENT_SUCCEED, patients);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				data = null;
				sendNotification(ApplicationFacade.SEARCH_PATIENT_FAILED);
			});
			sqlStatement.execute();
		}

		protected function get patients():ArrayCollection {
			return data as ArrayCollection;
		}
	}
}