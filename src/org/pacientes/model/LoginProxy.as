package org.pacientes.model
{
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.vo.LoginVO;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class LoginProxy extends Proxy
	{
		public static const NAME:String = "LoginProxy";
		
		public function LoginProxy(proxyName:String=null, data:Object=null) {
			super(NAME, data);
		}
		
		public function login(loginVO:LoginVO):void {
			sendNotification(ApplicationFacade.LOGIN_SUCCEED);
		}
		
		public function logout():void {
			sendNotification(ApplicationFacade.LOGOUT_SUCCEED);
		}
	}
}