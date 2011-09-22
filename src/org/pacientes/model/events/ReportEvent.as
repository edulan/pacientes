package org.pacientes.model.events
{
	import flash.events.Event;
	
	import org.pacientes.model.vo.ReportVO;
	
	public class ReportEvent extends Event
	{
		public static const ADD:String = "addReportEvent";
		public static const SELECT:String = "selectReportEvent";
		
		private var _report:ReportVO;
		
		public function ReportEvent(type:String, report:ReportVO=null) {
			super(type, true, false);
			_report = report;
		}

		public function get report():ReportVO {
			return _report;
		}
	}
}