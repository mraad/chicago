package com.esri.controllers
{

import com.esri.ags.events.IdentifyEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.layers.supportClasses.LayerDetails;
import com.esri.ags.tasks.IdentifyTask;
import com.esri.ags.tasks.supportClasses.IdentifyParameters;
import com.esri.model.Model;
import com.esri.signal.Signal;
import com.esri.views.ViewLocator;

import mx.controls.Alert;
import mx.rpc.events.FaultEvent;

public final class IdentifyDelegate
{
    private var m_mapPoint:MapPoint;

    public function identify(mapPoint:MapPoint):void
    {
        m_mapPoint = mapPoint;
        if (Model.instance.selectedMapServer)
        {
            const visibleLayers:Array = Model.instance.selectedMapServer.dynamicMapServiceLayer.visibleLayers.source;
            const mapScale:Number = ViewLocator.instance.map.scale;
            const layerIds:Array = [];
            for each (var layerDetails:LayerDetails in Model.instance.selectedMapServer.allDetails.layersDetails)
            {
                const isVisible:Boolean = visibleLayers.indexOf(layerDetails.id) > -1;

                if (isVisible && layerDetails.maxScale === 0.0 && layerDetails.minScale === 0.0)
                {
                    layerIds.push(layerDetails.id);
                }
                else if (isVisible && layerDetails.maxScale <= mapScale && mapScale <= layerDetails.minScale)
                {
                    layerIds.push(layerDetails.id);
                }
            }

            const identifyParameters:IdentifyParameters = new IdentifyParameters();
            identifyParameters.geometry = new MapPoint(mapPoint.x, mapPoint.y);
            identifyParameters.mapExtent = new Extent(
                ViewLocator.instance.map.extent.xmin,
                ViewLocator.instance.map.extent.ymin,
                ViewLocator.instance.map.extent.xmax,
                ViewLocator.instance.map.extent.ymax);
            identifyParameters.width = ViewLocator.instance.map.width;
            identifyParameters.height = ViewLocator.instance.map.height;
            identifyParameters.layerOption = IdentifyParameters.LAYER_OPTION_ALL; // Could have been changed to VISIBLE !!
            identifyParameters.layerIds = layerIds; // Model.instance.selectedMapServer.dynamicMapServiceLayer.visibleLayers.source;
            identifyParameters.returnGeometry = false;
            identifyParameters.tolerance = Model.instance.identifyTolerance;
            identifyParameters.spatialReference = Model.instance.spatialReference;

            const identifyTask:IdentifyTask = new IdentifyTask(Model.instance.selectedMapServer.restURL);
            identifyTask.showBusyCursor = true;
            identifyTask.autoNormalize = false;
            identifyTask.requestTimeout = Model.instance.requestTimeout;
            identifyTask.addEventListener(IdentifyEvent.EXECUTE_COMPLETE, executeCompleteHandler);
            identifyTask.addEventListener(FaultEvent.FAULT, faultHandler);
            identifyTask.execute(identifyParameters);
        }
        else
        {
            Alert.show("Please enable an active map service from 'Layers TOC' !", 'Warning');
        }
    }

    private function faultHandler(event:FaultEvent):void
    {
        // AppEvent.dispatchFault(event.fault);
        Signal.sendFault(event.fault);
    }

    private function executeCompleteHandler(event:IdentifyEvent):void
    {
        if (event.identifyResults && event.identifyResults.length)
        {
            Model.instance.identifyIndex = 0;
            Model.instance.identifyCount = event.identifyResults.length;
            Model.instance.identifyResults = event.identifyResults;

            // AppEvent.dispatch(AppEvent.IDENTIFY_SHOW);
            Signal.send('identifyShow');

            ViewLocator.instance.map.infoWindow.show(m_mapPoint);
        }
        else
        {
            Alert.show('No visible features found !', 'Identify');
        }
    }
}
}
