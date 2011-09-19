package org.pacientes.model.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class PatientVO extends EventDispatcher
	{
		private var _id:int;
		private var _name:String;
		private var _lastname:String;
		private var _age:int;
		private var _insurance:String;
		private var _doctor:String;
		private var _other:String;
		private var _lastUpdated:Date;

		[Bindable(event="idChange")]
		public function get id():int {
			return _id;
		}

		public function set id(value:int):void {
			if ( _id !== value) {
				_id = value;
				dispatchEvent(new Event("idChange"));
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
		
		override public function toString():String {
			return name + " " + lastname;
		}
	}
}