package org.pacientes.model
{
	import com.adobe.air.crypto.EncryptionKeyGenerator;
	import com.adobe.utils.StringUtil;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	import flash.utils.ByteArray;
	
	import mx.core.ByteArrayAsset;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.SettingsVO;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SettingsProxy extends Proxy
	{
		public static const NAME:String = "SettingsProxy";
		
		private static const DB_FILE:String = "pacientes.db";
		private static const DB_NAME:String = "main";
		
		[Embed(source="assets/schema.sql", mimeType="application/octet-stream")]
		private var schemaClass:Class;

		private var _dbFile:File;
		private var _sqlConnection:SQLConnection;
		private var _createNewDb:Boolean = true;
		
		public function SettingsProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		public function checkDatabase():void {
			_dbFile = File.applicationStorageDirectory.resolvePath(DB_FILE);
			
			if (_dbFile.exists) {
				_createNewDb = false;
				sendNotification(ApplicationFacade.CHECK_DB_SUCCEED);
			} else {
				_createNewDb = true;
				sendNotification(ApplicationFacade.CHECK_DB_FAILED);
			}
		}

		public function setupSettings(settings:SettingsVO):void {
			var keyGenerator:EncryptionKeyGenerator = new EncryptionKeyGenerator();
			var encryptionKey:ByteArray = null;
			var credential:String = settings.login.generateKey();

			if (credential == null || credential.length <= 0) {
				sendNotification(ApplicationFacade.SETUP_SETTINGS_FAILED);
				return;
			}

			if (!keyGenerator.validateStrongPassword(credential)) {
				sendNotification(ApplicationFacade.SETUP_SETTINGS_FAILED);
				return;
			}

			encryptionKey = keyGenerator.getEncryptionKey(credential);

			_sqlConnection = new SQLConnection();
			_sqlConnection.addEventListener(SQLEvent.OPEN, onDbOpen);
			_sqlConnection.addEventListener(SQLErrorEvent.ERROR, onDbError);
			_sqlConnection.openAsync(_dbFile, SQLMode.CREATE, null, false, 1024, encryptionKey); 
		}

		private function onDbOpen(event:SQLEvent):void {
			_sqlConnection.removeEventListener(SQLEvent.OPEN, onDbOpen);
			_sqlConnection.removeEventListener(SQLErrorEvent.ERROR, onDbError);
 
			if (_createNewDb) {
				loadSchema();
			}
		}
		
		private function onDbError(event:SQLErrorEvent):void {
			_sqlConnection.removeEventListener(SQLEvent.OPEN, onDbOpen);
			_sqlConnection.removeEventListener(SQLErrorEvent.ERROR, onDbError);
			
			sendNotification(ApplicationFacade.SETUP_SETTINGS_FAILED);
		}
		
		private function loadSchema():void {
			var schemaByteArray:ByteArrayAsset = ByteArrayAsset(new schemaClass());
			var schema:String = schemaByteArray.readUTFBytes(schemaByteArray.length);
			
			createSchema(schema);
		}
		
		private function createSchema(schema:String):void {
			_sqlConnection.begin();

			var queries:Array = schema.match(/([\w\s\r\n\(\),]+);/g);
			queries.forEach(function (query:String, index:int, array:Array):void {
				var sqlStatement:SQLStatement = new SQLStatement();

				sqlStatement.sqlConnection = _sqlConnection;
				sqlStatement.text = StringUtil.trim(query);
				sqlStatement.execute();
			});
			
			_sqlConnection.commit(new Responder(
				function (event:SQLEvent):void {
					sendNotification(ApplicationFacade.SETUP_SETTINGS_SUCCEED);
				},
				function (event:SQLErrorEvent):void {
					sendNotification(ApplicationFacade.SETUP_SETTINGS_FAILED);
				}
			));
		}

		public function get dbFile():File {
			return _dbFile;
		}
	}
}