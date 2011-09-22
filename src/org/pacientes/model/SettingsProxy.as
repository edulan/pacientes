package org.pacientes.model
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SettingsProxy extends Proxy
	{
		public static const NAME:String = "SettingsProxy";
		
		private static const DB_FILE:String = "pacientes.db";
		private static const DB_NAME:String = "main";
		
		private var _sqlc:SQLConnection;
		
		public function SettingsProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		public function openDatabase():void {
			var db:File = File.applicationStorageDirectory.resolvePath(DB_FILE);
			
			_sqlc = new SQLConnection();
			_sqlc.addEventListener(SQLEvent.OPEN, onDbOpen);
			_sqlc.addEventListener(SQLErrorEvent.ERROR, onDbError);
			_sqlc.openAsync(db);
		}
		
		public function createDatabase():void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _sqlc;
			sqlStatement.text += "CREATE TABLE reports (" +
				"reportId INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"patientId INTEGER NOT NULL, " +
				"exploration TEXT," +
				"body TEXT," +
				"dateCreated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
				"lastUpdated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
				"FOREIGN KEY(patientId) REFERENCES patients(patientId)" +
				");";
			sqlStatement.text += "CREATE TABLE patients (" +
				"patientId INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"name TEXT," +
				"lastname TEXT," +
				"age INTEGER," +
				"insurance TEXT," +
				"doctor TEXT," +
				"other TEXT," +
				"lastUpdated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP" +
				");";
			
			sqlStatement.addEventListener(
				SQLEvent.RESULT,
				function (event:SQLEvent):void {
					// TODO: Send notification
				}
			);
			sqlStatement.addEventListener(
				SQLErrorEvent.ERROR,
				function (event:SQLErrorEvent):void {
					// TODO: Send notification
				}
			);
			sqlStatement.execute();
		}
		
		private function onDbOpen(event:SQLEvent):void {
			// TODO: Implement
		}
		
		private function onDbError(evt:SQLErrorEvent):void {
			// TODO: Implement
		}
	}
}