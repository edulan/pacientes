package org.pacientes.model.vo
{
	import com.adobe.images.JPGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.JPEGLoaderContext;
	import flash.utils.ByteArray;
	
	public class ImageVO extends EventDispatcher
	{
		private var _imageId:int;
		private var _reportId:int;
		private var _bitmapData:BitmapData;
		private var _dateCreated:Date;
		private var _lastUpdated:Date;
		private var _rawData:ByteArray;

		[Bindable(event="imageIdChange")]
		public function get imageId():int {
			return _imageId;
		}

		public function set imageId(value:int):void {
			if( _imageId !== value) {
				_imageId = value;
				dispatchEvent(new Event("imageIdChange"));
			}
		}
		
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

		[Bindable(event="bitmapDataChange")]
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void {
			if( _bitmapData !== value) {
				_bitmapData = value;
				dispatchEvent(new Event("bitmapDataChange"));
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

		public function get rawData():ByteArray {
			var encoder:JPGEncoder = new JPGEncoder(100);

			// TODO: Check whether bitmap data has changed
			if (_rawData !== null) {
				return _rawData;
			}
			
			if (_bitmapData !== null) {
				return encoder.encode(_bitmapData);
			}
			return null;
		}
		
		public function set rawData(value:ByteArray):void {
			var loader:Loader = new Loader();
			var jpegContext:JPEGLoaderContext = new JPEGLoaderContext();
			
			_rawData = value;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.loadBytes(value, jpegContext);
		}

		private function onLoadComplete(event:Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var loaderBitmapData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
			
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			loaderBitmapData.draw(loaderInfo.loader);
			
			if (_bitmapData !== null) {
				_bitmapData.dispose();
			}
			bitmapData = loaderBitmapData;
		}
		
		private function onIOError(event:IOErrorEvent):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;

			loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			// TODO: Implement
		}
		
		public function isSaved():Boolean {
			return _imageId > 0;
		}
	}
}