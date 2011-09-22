package org.pacientes.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ReportVO extends EventDispatcher
	{
		private var _reportId:int;
		private var _patientId:int;
		private var _exploration:String;
		private var _body:String;
		private var _dateCreated:Date;
		private var _lastUpdated:Date;

		[Bindable(event="reportIdChange")]
		public function get reportId():int {
			return _reportId;
		}

		public function set reportId(value:int):void {
			if( _reportId !== value) {
				_reportId = value;
				dispatchEvent(new Event("reportIdChange"));
			}
		}
		
		[Bindable(event="patientIdChange")]
		public function get patientId():int {
			return _patientId;
		}
		
		public function set patientId(value:int):void {
			if( _patientId !== value) {
				_patientId = value;
				dispatchEvent(new Event("patientIdChange"));
			}
		}
		
		[Bindable(event="explorationChange")]
		public function get exploration():String {
			return _exploration;
		}
		
		public function set exploration(value:String):void {
			if( _exploration !== value) {
				_exploration = value;
				dispatchEvent(new Event("explorationChange"));
			}
		}
		
		[Bindable(event="bodyChange")]
		public function get body():String {
			return _body;
		}
		
		public function set body(value:String):void {
			if( _body !== value) {
				_body = value;
				dispatchEvent(new Event("bodyChange"));
			}
		}

		[Bindable(event="dateCreatedChange")]
		public function get dateCreated():Date {
			return _dateCreated;
		}

		public function set dateCreated(value:Date):void {
			if( _dateCreated !== value) {
				_dateCreated = value;
				dispatchEvent(new Event("dateCreatedChange"));
			}
		}

		[Bindable(event="lastUpdatedChange")]
		public function get lastUpdated():Date {
			return _lastUpdated;
		}

		public function set lastUpdated(value:Date):void {
			if( _lastUpdated !== value) {
				_lastUpdated = value;
				dispatchEvent(new Event("lastUpdatedChange"));
			}
		}
		
		public function isSaved():Boolean {
			return _reportId > 0;
		}
	}
}