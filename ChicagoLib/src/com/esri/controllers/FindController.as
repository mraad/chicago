package com.esri.controllers
{

import com.esri.ags.Graphic;
import com.esri.ags.events.MapMouseEvent;
import com.esri.model.FindOptions;
import com.esri.model.Model;
import com.esri.views.FindWindow;
import com.esri.views.ViewLocator;

public final class FindController
{
    [Inject]
    public var mongoService:MongoService;

    [Inject]
    public var activeFeature:ActiveFeatureController;

    [Signal]
    public function findWindow(feature:Graphic = null):void
    {
        activeFeature.activeFeature(feature);
        FindWindow.show();
    }

    [Signal]
    public function findExecute(findOptions:FindOptions):void
    {
        if (findOptions.isWithin === false && findOptions.nearData === -1) // Map Click
        {
            Model.instance.statusText = 'Click on the map to start the search...';
            ViewLocator.instance.map.addEventListener(MapMouseEvent.MAP_CLICK, mapClickHandler);
            function mapClickHandler(event:MapMouseEvent):void
            {
                ViewLocator.instance.map.removeEventListener(MapMouseEvent.MAP_CLICK, mapClickHandler);
                Model.instance.markers.addItem(new Graphic(event.mapPoint, null, { label: "Map click location" }));
                findOptions.mapPoint = event.mapPoint;
                mongoService.find(findOptions);
            }
        }
        else
        {
            mongoService.find(findOptions);
        }
    }

}
}
