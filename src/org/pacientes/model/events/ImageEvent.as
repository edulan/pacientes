package org.pacientes.model.events
{
	import flash.events.Event;
	
	import mx.controls.Image;
	
	import org.pacientes.model.vo.ImageVO;
	
	public class ImageEvent extends Event
	{
		public static const ATTACH:String = "attachImageEvent";
		public static const DELETE:String = "deleteImageEvent";
		
		private var _image:ImageVO;
		
		public function ImageEvent(type:String, image:ImageVO=null) {
			super(type, true, false);
			_image = image;
		}

		public function get image():ImageVO {
			return _image;
		}
	}
}