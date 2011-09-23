package org.pacientes.view
{	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.system.JPEGLoaderContext;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import org.pacientes.ApplicationFacade;
	import org.pacientes.model.events.ImageEvent;
	import org.pacientes.model.events.ReportEvent;
	import org.pacientes.model.vo.ImageVO;
	import org.pacientes.model.vo.ReportVO;
	import org.pacientes.view.screens.ReportScreen;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class ReportScreenMediator extends Mediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "ReportScreenMediator";
		// Notifications
		public static const SHOW:String = "showReportScreen";

        public function ReportScreenMediator(viewComponent:ReportScreen) {
            super(NAME, viewComponent);
		}
		
		override public function onRegister():void {
			reportScreen.addEventListener(ReportEvent.SAVE, onSave);
			reportScreen.addEventListener(ImageEvent.ATTACH, onAttach);
			reportScreen.addEventListener(ImageEvent.DELETE, onDelete);
		}
		
		override public function onRemove():void {
			reportScreen.removeEventListener(ReportEvent.SAVE, onSave);
			reportScreen.removeEventListener(ImageEvent.ATTACH, onAttach);
			reportScreen.removeEventListener(ImageEvent.DELETE, onDelete);
		}

        override public function listNotificationInterests():Array {
            return [
						ReportScreenMediator.SHOW,
						ApplicationFacade.SAVE_REPORT_SUCCEED,
						ApplicationFacade.SAVE_REPORT_FAILED,
						ApplicationFacade.GET_ALL_REPORT_IMAGES_SUCCEED,
						ApplicationFacade.GET_ALL_REPORT_IMAGES_FAILED,
						ApplicationFacade.SAVE_IMAGE_SUCCEED,
						ApplicationFacade.SAVE_IMAGE_FAILED
					];
        }

        override public function handleNotification(note:INotification):void {
            switch(note.getName()) {
				case ReportScreenMediator.SHOW:
					handleShowReportScreen(note.getBody() as ReportVO);
					break;
				case ApplicationFacade.SAVE_REPORT_SUCCEED:
					handleSaveReportSucceed();
					break;
				case ApplicationFacade.SAVE_REPORT_FAILED:
					handleSaveReportFailed();
					break;
				case ApplicationFacade.GET_ALL_REPORT_IMAGES_SUCCEED:
					handleGetAllReportImagesSucceed(note.getBody() as ArrayCollection);
					break;
				case ApplicationFacade.GET_ALL_REPORT_IMAGES_FAILED:
					handleGetAllReportImagesFailed();
					break;
				case ApplicationFacade.SAVE_IMAGE_SUCCEED:
					handleSaveImageSucceed();
					break;
				case ApplicationFacade.SAVE_IMAGE_FAILED:
					handleSaveImageFailed();
					break;
            }
        }
		
		/* NOTIFICATION HANDLERS */
		
		private function handleShowReportScreen(report:ReportVO):void {
			reportScreen.report = report;
			sendNotification(ApplicationFacade.COMMAND_GET_ALL_REPORT_IMAGES, report.reportId);
		}
		
		private function handleSaveReportSucceed():void {
			var reportId:int = reportScreen.report.reportId;
			
			for each (var image:ImageVO in reportScreen.report.images) {
				image.reportId = reportId;
				sendNotification(ApplicationFacade.COMMAND_SAVE_IMAGE, image);
			}
		}
		
		private function handleSaveReportFailed():void {
			// TODO: Implement
		}
		
		private function handleGetAllReportImagesSucceed(images:ArrayCollection):void {
			reportScreen.report.images = images;
		}
		
		private function handleGetAllReportImagesFailed():void {
			// TODO: Implement
		}
		
		private function handleSaveImageSucceed():void {
			// TODO: Implement
		}
		
		private function handleSaveImageFailed():void {
			// TODO: Implement
		}
		
		/* VIEW LISTENERS */
		
		private function onSave(event:ReportEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_SAVE_REPORT, event.report);
		}
		
		private function onAttach(event:ImageEvent):void {
			var file:File = new File();
			var imagesFilter:FileFilter = new FileFilter("Imágenes", "*.jpg;*.jpeg;*.bmp");
			
			file.addEventListener(Event.SELECT, function (event:Event):void {
				var stream:FileStream = new FileStream();
				
				stream.addEventListener(Event.COMPLETE, function (event:Event):void {
					var rawData:ByteArray = new ByteArray();
					var image:ImageVO = new ImageVO();

					stream.readBytes(rawData, 0, stream.bytesAvailable);

					image.rawData = rawData
					reportScreen.report.images.addItem(image);
				});
				stream.addEventListener(IOErrorEvent.IO_ERROR, function (event:IOErrorEvent):void {
					// TODO: Implement
				});
				stream.openAsync(file, FileMode.READ);
			});
			file.addEventListener(IOErrorEvent.IO_ERROR, function (event:IOErrorEvent):void {
				// TODO: Implement
			});
			file.browseForOpen("Seleccione una imagen", [imagesFilter]);
		}
		
		private function onDelete(event:ImageEvent):void {
			event.stopPropagation();
			sendNotification(ApplicationFacade.COMMAND_DELETE_IMAGE, event.image);
		}
		
		protected function get reportScreen():ReportScreen {
			return viewComponent as ReportScreen
		}
    }
}