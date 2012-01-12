package com.esri.controllers
{

import com.esri.model.FindOptions;
import com.esri.views.FindWindow;

public final class FindController
{
    [Inject]
    public var mongoService:MongoService;

    [Signal]
    public function findWindow():void
    {
        FindWindow.show();
    }

    [Signal]
    public function find(findOptions:FindOptions):void
    {
        mongoService.find(findOptions);
    }
}
}
