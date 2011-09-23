package org.pacientes.model
{
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.ImageVO;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ImageProxy extends Proxy
	{
		public static const NAME:String = "ImageProxy";
		
		private var _loginProxy:LoginProxy;
		
		public function ImageProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		override public function onRegister():void {
			_loginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
		}
		
		public function findAll(reportId:int):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.itemClass = ImageVO;
			sqlStatement.parameters[":reportId"] = reportId;
			sqlStatement.text = "SELECT * FROM images " +
				"WHERE reportId = :reportId";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				data = new ArrayCollection(sqlStatement.getResult().data);
				sendNotification(ApplicationFacade.GET_ALL_REPORT_IMAGES_SUCCEED, images);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				data = null;
				sendNotification(ApplicationFacade.GET_ALL_REPORT_IMAGES_FAILED);
			});
			sqlStatement.execute();
		}
		
		public function create(image:ImageVO):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.parameters[":reportId"] = image.reportId;
			sqlStatement.parameters[":rawData"] = image.rawData;
			sqlStatement.text = "INSERT INTO images " +
				"(reportId, rawData, lastUpdated) " +
				"VALUES(:reportId, :rawData, (DATETIME('NOW')))";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				sendNotification(ApplicationFacade.SAVE_IMAGE_SUCCEED);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				sendNotification(ApplicationFacade.SAVE_IMAGE_SUCCEED);
			});
			sqlStatement.execute();
		}
		
		public function destroy(image:ImageVO):void {
			var sqlStatement:SQLStatement = new SQLStatement();
			
			sqlStatement.sqlConnection = _loginProxy.dbConnection;
			sqlStatement.parameters[":imageId"] = image.imageId;
			sqlStatement.text = "DELETE FROM images " +
				"WHERE imageId = :imageId";
			
			sqlStatement.addEventListener(SQLEvent.RESULT, function (evt:SQLEvent):void {
				var imageIndex:int = images.getItemIndex(image);
				
				if (imageIndex != -1) {
					images.removeItemAt(imageIndex);
				}
				sendNotification(ApplicationFacade.DELETE_IMAGE_SUCCEED, images);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, function (evt:SQLErrorEvent):void {
				sendNotification(ApplicationFacade.DELETE_IMAGE_FAILED);
			});
			sqlStatement.execute();
		}
		
		protected function get images():ArrayCollection {
			return data as ArrayCollection;
		}
	}
}