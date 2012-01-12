package com.esri.model
{
	import com.esri.ags.geometry.Extent;
	import com.esri.model.ConfigModel;
	
	import mx.collections.ArrayCollection;
	
	public class ConfigModel
	{
		public static const configInfo:ConfigModel = new ConfigModel(); 
		
		//Application UI configuration items
		[Bindable] public var _appTitle:String;
		[Bindable] public var _appSubTitle:String;
		[Bindable] public var _appLogo:String;
		[Bindable] public var _appBackgroundImage:String;
		[Bindable] public var _taskSwitcherNamesAC:ArrayCollection;
		[Bindable] public var _downloadEnabled:Boolean;
		
		//Map configuration items
		[Bindable] public var _basemapActiveID:Number;
		[Bindable] public var _mapInitExtent:Extent = new Extent();
		[Bindable] public var _mapSwitcherButtonLabelsAC:ArrayCollection;
		[Bindable] public var _basemapsAC:ArrayCollection;
		
		//Online Sharing Info
		[Bindable] public var _shareEnabled:Boolean;
		[Bindable] public var _dynamicSvcURL:String; 
		[Bindable] public var _portalName:String;
		[Bindable] public var _portalURL:String;
		[Bindable] public var _portalTokenURL:String;
		[Bindable] public var _itemThumbnailURL:String;
		[Bindable] public var _itemGroupID:String;
		[Bindable] public var _groupOwner:String;
		[Bindable] public var _sharingKey:String;
		
		//Image Services Info
		[Bindable] public var _sensorTypesItemsAC:ArrayCollection;
		[Bindable] public var _browseSensorTypesAC:ArrayCollection;
		[Bindable] public var _searchChartAC:ArrayCollection;
		[Bindable] public var _spatialReference:String;
		
		//ImageCatalog Map Service Info
		[Bindable] public var _queryImagePointsURL:String;
		[Bindable] public var _queryImageServiceCatalogURL:String;
		[Bindable] public var _imageServiceFootprintURL:String;
		[Bindable] public var _layerFileURL:String;
		//[Bindable] public var _dynamicSvcURL:String; 
		[Bindable] public var _dataConfigValue:Number;
		
		//Utility GIS Services
		[Bindable] public var _locatorSvcURL:String;
		
		public function ConfigModel()
		{
		}
	}
}