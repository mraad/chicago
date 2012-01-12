package com.esri.controllers
{

import com.esri.ags.Graphic;
import com.esri.model.FindOptions;
import com.esri.model.Model;
import com.esri.views.FindWindow;

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
    public function find(findOptions:FindOptions):void
    {
        mongoService.find(findOptions);
    }
}
}
