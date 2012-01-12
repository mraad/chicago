package com.esri.controllers
{

import com.esri.ags.Graphic;
import com.esri.ags.clusterers.supportClasses.ClusterGraphic;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.tasks.supportClasses.IdentifyResult;
import com.esri.model.Model;
import com.esri.views.ViewLocator;

public final class GraphicPropertiesController
{

    [Inject]
    public var identifyBoxController:IdentifyBoxController;

    [Signal]
    public function graphicProperties(feature:Graphic, stageX:Number, stageY:Number):void
    {
        trace('graphicProperties::begin');
        if (feature.symbol === Model.instance.routeSymbol)
        {
            /*
            const appEvent:AppEvent = new AppEvent(AppEvent.ROUTE_DIRECTIONS);
            appEvent.routeResult = feature.attributes.routeResult;
            appEvent.title = feature.attributes.label;
            appEvent.dispatch();
            */
        }
        else
        {
            if (feature is ClusterGraphic)
            {
                const clusterGraphic:ClusterGraphic = feature as ClusterGraphic;
                const identifyResults:Array = [];
                for each (var graphic:Graphic in clusterGraphic.cluster.graphics)
                {
                    identifyResults.push(toIdentifyResult(graphic));
                }
                Model.instance.identifyResults = identifyResults;
            }
            else
            {
                Model.instance.identifyResults = [ toIdentifyResult(feature)];
            }

            Model.instance.identifyIndex = 0;
            Model.instance.identifyCount = Model.instance.identifyResults.length;

            identifyBoxController.identifyShow();
            // AppEvent.dispatch(AppEvent.IDENTIFY_SHOW);

            const mapPoint:MapPoint = feature.geometry as MapPoint;
            if (mapPoint)
            {
                ViewLocator.instance.map.infoWindow.show(mapPoint);
            }
            else
            {
                ViewLocator.instance.map.infoWindow.show(ViewLocator.instance.map.toMapFromStage(stageX, stageY));
            }
        }
        trace('graphicProperties::end');
    }

    private function toIdentifyResult(feature:Graphic):IdentifyResult
    {
        const identifyResult:IdentifyResult = new IdentifyResult();
        identifyResult.feature = feature;
        identifyResult.layerId = -1;
        identifyResult.layerName = feature.attributes ? feature.attributes.label : '';
        return identifyResult;
    }
}
}
