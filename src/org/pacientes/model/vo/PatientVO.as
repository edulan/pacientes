package org.pacientes.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class PatientVO extends EventDispatcher
	{
		private var _patientId:int;
		private var _name:String;
		private var _lastname:String;
		private var _age:int;
		private var _insurance:String;
		private var _doctor:String;
		private var _other:String;
		private var _dateCreated:Date;
		private var _lastUpdated:Date;
		private var _reports:ArrayCollection;
		
		public function PatientVO() {
			_reports = new ArrayCollection();
		}

		[Bindable(event="patientIdChange")]
		public function get patientId():int {
			return _patientId;
		}

		public function set patientId(value:int):void {
			if ( _patientId !== value) {
				_patientId = value;
				dispatchEvent(new Event("patientIdChange"));
			}
		}

		[Bindable(event="nameChange")]
		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			if ( _name !== value) {
				_name = value;
				dispatchEvent(new Event("nameChange"));
			}
		}

		[Bindable(event="lastnameChange")]
		public function get lastname():String {
			return _lastname;
		}

		public function set lastname(value:String):void {
			if ( _lastname !== value) {
				_lastname = value;
				dispatchEvent(new Event("lastnameChange"));
			}
		}

		[Bindable(event="ageChange")]
		public function get age():int {
			return _age;
		}

		public function set age(value:int):void {
			if ( _age !== value) {
				_age = value;
				dispatchEvent(new Event("ageChange"));
			}
		}

		[Bindable(event="insuranceChange")]
		public function get insurance():String {
			return _insurance;
		}

		public function set insurance(value:String):void {
			if ( _insurance !== value) {
				_insurance = value;
				dispatchEvent(new Event("insuranceChange"));
			}
		}

		[Bindable(event="doctorChange")]
		public function get doctor():String {
			return _doctor;
		}

		public function set doctor(value:String):void {
			if ( _doctor !== value) {
				_doctor = value;
				dispatchEvent(new Event("doctorChange"));
			}
		}

		[Bindable(event="otherChange")]
		public function get other():String {
			return _other;
		}

		public function set other(value:String):void {
			if ( _other !== value) {
				_other = value;
				dispatchEvent(new Event("otherChange"));
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
		
		[Bindable(event="reportsChange")]
		public function get reports():ArrayCollection {
			return _reports;
		}
		
		public function set reports(value:ArrayCollection):void {
			if( _reports !== value) {
				_reports = value;
				dispatchEvent(new Event("reportsChange"));
			}
		}
		
		public function isSaved():Boolean {
			return _patientId > 0;
		}
	}
}