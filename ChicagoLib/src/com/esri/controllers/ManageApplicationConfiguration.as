package com.esri.controllers
{
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.layers.supportClasses.MosaicRule;
	import com.esri.model.ConfigModel;
	import com.esri.model.Model;
	import flash.events.DataEvent;
	import flash.events.UncaughtErrorEvent;
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.core.FlexGlobals;
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ManageApplicationConfiguration implements IMXMLObject
	{
		public function initialized(document:Object, id:String):void
		{
			FlexGlobals.topLevelApplication.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			getConfigInfo();
		}
		
		protected function onCreationComplete(e:FlexEvent):void
		{
			trace('creation complete fired -- pop up login panel');
			FlexGlobals.topLevelApplication.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		}
		
		protected function getConfigInfo():void
		{
			var configSvc:HTTPService = new HTTPService();
			configSvc.url = 'config.xml';
			configSvc.resultFormat = 'e4x';
			configSvc.addEventListener(ResultEvent.RESULT, onConfigComplete);
			configSvc.addEventListener(FaultEvent.FAULT, onConfigFault);
			configSvc.send();
		}
		
		protected function onConfigComplete(e:ResultEvent):void
		{
			//Configures Application Header Information
//			ConfigModel.configInfo._appTitle = e.result.UserInterface.ApplicationTitle;
//			ConfigModel.configInfo._appSubTitle = e.result.UserInterface.ApplicationSubTitle;
//			ConfigModel.configInfo._appLogo = 'assets/images/'+e.result.UserInterface.ApplicationLogo;
//			ConfigModel.configInfo._appBackgroundImage = 'assets/images/'+e.result.UserInterface.ApplicationBackgroundImage;
//			ConfigModel.configInfo._downloadEnabled = e.result.UserInterface.DownloadEnabled;
			
			//Configures sharing settings
//			ConfigModel.configInfo._shareEnabled = e.result.ShareEnabled;
			
			//Configures Map Container
//			ConfigModel.configInfo._mapInitExtent = 
//				new Extent(new Number(e.result.MapExtent.xmin), new Number(e.result.MapExtent.ymin),
//				new Number(e.result.MapExtent.xmax), new Number(e.result.MapExtent.ymax));
//			ConfigModel.configInfo._basemapActiveID = e.result.Basemaps.SetActiveBasemapID;
//			ConfigModel.configInfo._spatialReference = e.result.MapExtent.sr;
			
			//Configures GIS Services
//			ConfigModel.configInfo._queryImagePointsURL = e.result.CatalogServices.CatalogImagePointsURL;
//			ConfigModel.configInfo._queryImageServiceCatalogURL = e.result.CatalogServices.CatalogImageServiceURL;
//			ConfigModel.configInfo._imageServiceFootprintURL = e.result.CatalogServices.CatalogImageServiceFootprintURL;
//			ConfigModel.configInfo._locatorSvcURL = e.result.CatalogServices.LocatorServiceURL;
//			ConfigModel.configInfo._layerFileURL = e.result.LayerFileURL;
				
//			createTaskSwitcherButtonLabels(e.result.UserInterface.TaskSwitcherNames);
			createBasemapsAC(e.result.Basemaps.TiledMap);
//			createSensorTypesAC(e.result.SensorInfo.sensor);
//			createBrowseSensorTypesAC(e.result.SensorInfo.sensor);
//			createSearchChartAC(e.result.SensorInfo.sensor);
//			createOldestImageDate(e.result.OldestImageDate);
//			createInitialMosaicRule();
//			createDatabaseConfig(e.result.DataConfig);
//			getShareStatus(e.result.ShareEnabled);
		}
		
		protected function createBasemapsAC(items:XMLList):void
		{
			ConfigModel.configInfo._basemapsAC = new ArrayCollection();
			for each (var item:Object in items) {
				ConfigModel.configInfo._basemapsAC.addItem(
					{id:item.Id, name:item.Name, url:item.URL, thumbnail:item.Thumbnail});
			}
		}
		
		protected function createTaskSwitcherButtonLabels(values:String):void
		{
			var a:Array = values.split(',');
			ConfigModel.configInfo._taskSwitcherNamesAC = new ArrayCollection(a);
		}
		
		protected function createSensorTypesAC(items:XMLList):void
		{
			ConfigModel.configInfo._sensorTypesItemsAC = new ArrayCollection();
			for each (var item:Object in items) {
				ConfigModel.configInfo._sensorTypesItemsAC.addItem(
					{sCode:item.sCode, sName:item.sName});
			}
		}
		
		protected function createBrowseSensorTypesAC(items:XMLList):void
		{
			ConfigModel.configInfo._browseSensorTypesAC = new ArrayCollection();
			for each (var item:Object in items) {
				if(item.sCode != 99) {
					ConfigModel.configInfo._browseSensorTypesAC.addItem(
						{sCode:item.sCode, sName:item.sName, sLayerName:item.sLayerName, sURL:item.sURL});
				}
			}
		}
		
		protected function createSearchChartAC(items:XMLList):void
		{
			ConfigModel.configInfo._searchChartAC = new ArrayCollection();
			for each (var item:Object in items) {
				if(item.sCode != 99) {
					ConfigModel.configInfo._searchChartAC.addItem(
						{sCode:item.sCode, sName:item.sName, sCount:0});
				}
			}
		}
		
		protected function createOldestImageDate(date:String):void
		{
//			Model.instance._searchDateSliderOldestDate = DateField.stringToDate(date, 'MM/DD/YYYY');
//			Model.instance._searchFromDate = DateField.stringToDate(date, 'MM/DD/YYYY');
		}
		
		protected function createInitialMosaicRule():void
		{
//			var mosaicRule:MosaicRule = new MosaicRule();
//			mosaicRule.method = MosaicRule.METHOD_NONE;
//			Model.instance._browseSelectedServiceMosaicRule = mosaicRule; 
		}
		
		protected function createDatabaseConfig(items:XMLList):void
		{
			//trace(items);
			var dataItems:Object = items;
			var mapFGDB:Boolean = true;
			var imagesFGDB:Boolean = true;
			
			if(dataItems.MapCatalog == 'EGDB') {
				mapFGDB = false;
			}
			
			if(dataItems.ImageCatalog == 'EGDB') {
				imagesFGDB = false;
			}
			
			var dataConfig:Number = 0;
			
			if(mapFGDB == true && imagesFGDB == true){
				dataConfig = 1;
			} else if(mapFGDB == true && imagesFGDB == false){
				dataConfig = 2;
			} else if(mapFGDB == false && imagesFGDB == true){
				dataConfig = 3;
			} else {
				dataConfig = 4;
			}
			
			ConfigModel.configInfo._dataConfigValue = dataConfig;
		}
		
		protected function getShareStatus(status:String):void
		{
			if (status == 'true') {
				ConfigModel.configInfo._shareEnabled = true;
				var configsharingSvc:HTTPService = new HTTPService();
				configsharingSvc.url = 'configsharing.xml';
				configsharingSvc.resultFormat = 'e4x';
				configsharingSvc.addEventListener(ResultEvent.RESULT, onShareConfigComplete);
				configsharingSvc.addEventListener(FaultEvent.FAULT, onShareConfigFault);
				configsharingSvc.send();
			} else {
				ConfigModel.configInfo._shareEnabled = false;
			}		
		}
		
		protected function onShareConfigComplete(e:ResultEvent):void
		{
			ConfigModel.configInfo._portalName = e.result.ShareSettings.PortalName;
			ConfigModel.configInfo._portalURL = e.result.ShareSettings.PortalURL;
			ConfigModel.configInfo._portalTokenURL = e.result.ShareSettings.PortalTokenURL;
			ConfigModel.configInfo._itemThumbnailURL = e.result.ShareSettings.ItemThumbnailURL;
			ConfigModel.configInfo._itemGroupID = e.result.ShareSettings.ItemGroupID;
			ConfigModel.configInfo._dynamicSvcURL = e.result.ShareSettings.DynamicServiceURL;
			ConfigModel.configInfo._groupOwner = e.result.ShareSettings.GroupOwner;
			ConfigModel.configInfo._sharingKey = e.result.ShareSettings.Key;
		}
		
		protected function onShareConfigFault(e:FaultEvent):void
		{
			ConfigModel.configInfo._shareEnabled = false;
			var errorMsg:String = "Problem reading your sharing configuration file. " + 
			"Configuration File Error.";
			sendErrorMsg(errorMsg);
		}
		
		protected function onConfigFault(e:FaultEvent):void
		{
			ConfigModel.configInfo._shareEnabled = false;
			var errorMsg:String = "Problem reading your sharing configuration file. " + 
				"Configuration File Error.";
			sendErrorMsg(errorMsg);
		}
		
		protected function onUncaughtError(e:UncaughtErrorEvent):void
		{
			var errorMsg:String = "An application error has occurred; please refresh application and try again.";
			sendErrorMsg(errorMsg);
		}
		
		protected function sendErrorMsg(msg:String):void
		{
			const ErrorMsgEvent:DataEvent = new DataEvent('errorMsgEvent$', true, false, msg);
			FlexGlobals.topLevelApplication.dispatchEvent(ErrorMsgEvent);
		}
		
		public function ManageApplicationConfiguration()
		{
		}
	}
}