package com.esri.controllers
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.esri_internal;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.tasks.GeometryService;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	import com.esri.ags.utils.GeometryUtil;
	import com.esri.model.AppFeatureServer;
	import com.esri.model.AppField;
	import com.esri.model.Model;
	import com.esri.views.FindWindow;
	import com.esri.views.QueryWindow;
	import com.esri.views.ViewLocator;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	use namespace esri_internal;

	public final class QueryController
	{
		[Inject]
		public var activeFeature:ActiveFeatureController;

		private var m_queryTask:QueryTask;

		public function QueryController()
		{
			m_queryTask = new QueryTask();
			m_queryTask.showBusyCursor = true;
		}

		[Signal]
		public function queryWindow():void
		{
			QueryWindow.show();
		}

		[Signal]
		public function queryExecute(featureServer:AppFeatureServer, whereClause:String):void
		{
			m_queryTask.url = featureServer.url;
			m_queryTask.useAMF = true; //featureServer.useAMF;

			var query:Query = new Query();
			query.returnGeometry = true;
			query.outFields = ["OBJECTID", featureServer.titleField.name];
			query.where = whereClause;

			m_queryTask.execute(query, new AsyncResponder(onResult, onFault));

			function onResult(featureSet:FeatureSet, token:Object = null):void
			{			
				
				if (featureSet.features.length > 0)
				{
					var aField:AppField = featureServer.titleField;									
					var extent:Extent = Extent.createEmptyExtent(ViewLocator.instance.map.spatialReference);					
					
					for each (var aFeature:Graphic in featureSet.features)
					{
						aFeature.attributes.label = aFeature.attributes[aField.name];
						Model.instance.polygons.addItem(aFeature);
						trace(aFeature.attributes.label);
						extent.unionExtent(aFeature.geometry.extent);
					}					
					
					Model.instance.extent = extent.expand(2.0);
					var firstFeature:Graphic = featureSet.features[0] as Graphic;
					activeFeature.activeFeature(firstFeature);
					FindWindow.show();
				}
				else
				{
					Alert.show("QueryTask returned no result.", "Query Result");
				}
			}

			function onFault(info:Object, token:Object = null):void
			{
				Alert.show(info.toString(), "Query Problem");
			}
		}

	}
}
