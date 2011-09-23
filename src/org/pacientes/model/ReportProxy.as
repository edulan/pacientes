package org.pacientes.model
{
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.ReportVO;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ReportProxy extends Proxy
	{
		public static const NAME:String = "ReportProxy";
		
		private var _loginProxy:LoginProxy;
		
		public function ReportProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		override public function onRegister():void {
			_loginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
		}

		public function findAll(patientId:int):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.itemClass = ReportVO;
			sqlStatement.parameters[":patientId"] = patientId;
			sqlStatement.text = "SELECT * FROM reports " +
				"WHERE patientId = :patientId";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				data = new ArrayCollection(sqlStatement.getResult().data);
				sendNotification(ApplicationFacade.GET_ALL_PATIENT_REPORTS_SUCCEED, reports);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				data = null;
				sendNotification(ApplicationFacade.GET_ALL_PATIENT_REPORTS_FAILED);
			});
			sqlStatement.execute();
		}
		
		public function create(report:ReportVO):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.parameters[":patientId"] = report.patientId;
			sqlStatement.parameters[":exploration"] = report.exploration;
			sqlStatement.parameters[":body"] = report.body;
			sqlStatement.text = "INSERT INTO reports " +
				"(patientId, exploration, body, dateCreated, lastUpdated) " +
				"VALUES(:patientId, :exploration, :body, (DATETIME('NOW')), (DATETIME('NOW')))";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				var lastInsertRowID:int = sqlStatement.getResult().lastInsertRowID;
				
				report.reportId = lastInsertRowID;
				sendNotification(ApplicationFacade.SAVE_REPORT_SUCCEED);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				sendNotification(ApplicationFacade.SAVE_REPORT_FAILED);
			});
			sqlStatement.execute();
		}
		
		public function update(report:ReportVO):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.parameters[":reportId"] = report.reportId;
			sqlStatement.parameters[":exploration"] = report.exploration;
			sqlStatement.parameters[":body"] = report.body;
			sqlStatement.parameters[":dateCreated"] = report.dateCreated;
			sqlStatement.text = "UPDATE reports SET " +
				"exploration = :exploration, " +
				"body = :body, " +
				"dateCreated = :dateCreated, " +
				"lastUpdated = (DATETIME('NOW')) " +
				"WHERE reportId = :reportId";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				// TODO: Reload object from database
				reports.itemUpdated(report);
				sendNotification(ApplicationFacade.SAVE_REPORT_SUCCEED);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				sendNotification(ApplicationFacade.SAVE_REPORT_FAILED);
			});
			sqlStatement.execute();
		}
		
		public function destroy(report:ReportVO):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.parameters[":reportId"] = report.reportId;
			sqlStatement.text = "DELETE FROM reports " +
				"WHERE reportId = :reportId";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				var reportIndex:int = reports.getItemIndex(report);
				
				if (reportIndex != -1) {
					reports.removeItemAt(reportIndex);
				}
				sendNotification(ApplicationFacade.DELETE_REPORT_SUCCEED, reports);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				sendNotification(ApplicationFacade.DELETE_REPORT_FAILED);
			});
			sqlStatement.execute();
		}
		
		protected function get reports():ArrayCollection {
			return data as ArrayCollection;
		}
	}
}