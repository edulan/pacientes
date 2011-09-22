package org.pacientes.model
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.ReportVO;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ReportProxy extends Proxy
	{
		public static const NAME:String = "ReportProxy";
		
		private static const DB_FILE:String = "pacientes.db";
		private static const DB_NAME:String = "main";
		
		private var _sqlc:SQLConnection;
		
		public function ReportProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		override public function onRegister():void {
			var db:File = File.applicationStorageDirectory.resolvePath(DB_FILE);
			
			_sqlc = new SQLConnection();
			_sqlc.addEventListener(SQLEvent.OPEN, onDbOpen);
			_sqlc.addEventListener(SQLErrorEvent.ERROR, onDbError);
			_sqlc.openAsync(db);	// TODO: Add encryption key
		}
		
		private function onDbOpen(event:SQLEvent):void {
			var sqlStatement:SQLStatement = new SQLStatement();

			sqlStatement.sqlConnection = _sqlc;
			sqlStatement.text = "CREATE TABLE reports (" +
				"reportId INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"patientId INTEGER NOT NULL, " +
				"exploration TEXT," +
				"body TEXT," +
				"dateCreated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
				"lastUpdated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
				"FOREIGN KEY(patientId) REFERENCES patients(patientId)" +
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
			// TODO: Implement
		}
		
		public function findAll(patientId:int):void {

		}
		
		public function create(report:ReportVO):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _sqlc;
			sqlStatement.parameters[":patientId"] = report.patientId;
			sqlStatement.parameters[":exploration"] = report.exploration;
			sqlStatement.parameters[":body"] = report.body;
			sqlStatement.text = "INSERT INTO reports " +
				"(patientId, exploration, body, dateCreated, lastUpdated) " +
				"VALUES(:patientId, :exploration, :body, (DATETIME('NOW')), (DATETIME('NOW')))";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				sendNotification(ApplicationFacade.SAVE_REPORT_SUCCEED);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				sendNotification(ApplicationFacade.SAVE_REPORT_FAILED);
			});
			sqlStatement.execute();
		}
	}
}