package org.pacientes.model
{
	import com.adobe.air.crypto.EncryptionKeyGenerator;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.utils.ByteArray;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.LoginVO;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class LoginProxy extends Proxy
	{
		public static const NAME:String = "LoginProxy";
		
		private static const NULL_PASSWORD_ERROR_STR:String = "Please specify a password.";
		private static const WEAK_PASSWORD_ERROR_STR:String = "The password must be 8-32 characters long. It must contain at least one lowercase letter, at least one uppercase letter, and at least one number or symbol.";
		private static const INVALID_PASSWORD_ERROR_STR:String = "Incorrect password!";
		private static const UNKNOWN_ERROR_STR:String = "Error opening database.";
		
		private var _settingsProxy:SettingsProxy;
		private var _sqlConnection:SQLConnection;
		
		public function LoginProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		override public function onRegister():void {
			_settingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
		}
		
		public function login(loginVO:LoginVO):void {
			openConnection(loginVO.generateKey());
		}
		
		public function logout():void {
			sendNotification(ApplicationFacade.LOGOUT_SUCCEED);
		}
		
		private function openConnection(credential:String):void {
			var keyGenerator:EncryptionKeyGenerator = new EncryptionKeyGenerator();
			var encryptionKey:ByteArray = null;
			
			if (credential == null || credential.length <= 0) {
				sendNotification(ApplicationFacade.LOGIN_FAILED, NULL_PASSWORD_ERROR_STR);
				return;
			}
			
			if (!keyGenerator.validateStrongPassword(credential)) {
				sendNotification(ApplicationFacade.LOGIN_FAILED, WEAK_PASSWORD_ERROR_STR);
				return;
			}
			
			encryptionKey = keyGenerator.getEncryptionKey(credential);
			
			_sqlConnection = new SQLConnection();
			_sqlConnection.addEventListener(SQLEvent.OPEN, onDbOpen);
			_sqlConnection.addEventListener(SQLErrorEvent.ERROR, onDbError);
			_sqlConnection.openAsync(_settingsProxy.dbFile, SQLMode.CREATE, null, false, 1024, encryptionKey); 
		}
		
		private function onDbOpen(event:SQLEvent):void {
			_sqlConnection.removeEventListener(SQLEvent.OPEN, onDbOpen);
			_sqlConnection.removeEventListener(SQLErrorEvent.ERROR, onDbError);

			sendNotification(ApplicationFacade.LOGIN_SUCCEED);
		}
		
		private function onDbError(event:SQLErrorEvent):void {
			_sqlConnection.removeEventListener(SQLEvent.OPEN, onDbOpen);
			_sqlConnection.removeEventListener(SQLErrorEvent.ERROR, onDbError);
			
			if (event.error.errorID == EncryptionKeyGenerator.ENCRYPTED_DB_PASSWORD_ERROR_ID) {
				sendNotification(ApplicationFacade.LOGIN_FAILED, INVALID_PASSWORD_ERROR_STR);
			} else {
				sendNotification(ApplicationFacade.LOGIN_FAILED, UNKNOWN_ERROR_STR);
			}
		}
		
		public function get dbConnection():SQLConnection {
			return _sqlConnection;
		}
	}
}