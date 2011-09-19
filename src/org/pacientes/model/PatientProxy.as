package org.pacientes.model
{
	import flash.data.SQLConnection;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	
	import mx.collections.ArrayCollection;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.PatientVO;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class PatientProxy extends Proxy
	{
		public static const NAME:String = "PatientProxy";
		
		private static const DB_FILE:String = "pacientes.db";
		private static const DB_NAME:String = "main";
		
		private var _sqlc:SQLConnection;
		
		public function PatientProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		override public function onRegister():void {
			var db:File = File.applicationStorageDirectory.resolvePath(DB_FILE);
			
			_sqlc = new SQLConnection();
			_sqlc.addEventListener(SQLEvent.OPEN, onDbOpen);
			_sqlc.addEventListener(SQLErrorEvent.ERROR, onDbError);
			_sqlc.openAsync(db);	// TODO: Add encryption key
		}
		
		public function findAll():void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _sqlc;
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
			
			sqlStatement.sqlConnection = _sqlc;
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
			
			sqlStatement.sqlConnection = _sqlc;
			sqlStatement.parameters[":id"] = patient.id;
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
				"WHERE id = :id";
			
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
			
			sqlStatement.sqlConnection = _sqlc;
			sqlStatement.parameters[":id"] = patient.id;
			sqlStatement.text = "DELETE FROM patients " +
				"WHERE id = :id";
			
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
			
			sqlStatement.sqlConnection = _sqlc;
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
		
		private function onDbOpen(event:SQLEvent):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			loadSchema();

			sqlStatement.sqlConnection = _sqlc;
			sqlStatement.text = "CREATE TABLE patients (" +
				"id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"name TEXT," +
				"lastname TEXT," +
				"age INTEGER," +
				"insurance TEXT," +
				"doctor TEXT," +
				"other TEXT," +
				"lastUpdated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP" +
				")";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (event:SQLEvent):void {
				trace(event);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (event:SQLErrorEvent):void {
				trace(event);
			});
			sqlStatement.execute();
		}
		
		private function onDbError(evt:SQLErrorEvent):void {
			
		}
		
		private function loadSchema():void {
			_sqlc.loadSchema(SQLTableSchema, null, DB_NAME, false, new Responder(
				function (event:SQLSchemaResult):void {
					for each (var table:SQLTableSchema in event.tables) {
						trace(table.name);
					}
				},
				function (event:SQLError):void {
					trace(event);
				}
			));
		}
		
		protected function get patients():ArrayCollection {
			return data as ArrayCollection;
		}
	}
}