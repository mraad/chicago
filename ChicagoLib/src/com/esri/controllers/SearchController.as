package com.esri.controllers
{

import com.esri.ags.esri_internal;
import com.esri.model.AppCollection;
import com.esri.model.FindOptions;
import com.esri.model.Model;

import mx.controls.Alert;

use namespace esri_internal;

public final class SearchController
{
    [Inject]
    public var locateService:LocatorService;

    [Inject]
    public var mongoService:MongoService;

    [Signal]
    public function search(text:String):void
    {
        const index:int = text.indexOf("|");
        if (index > 0)
        {
            const collectionName:String = text.substr(0, index);
            const appCollection:AppCollection = Model.instance.collectionDict[collectionName];
            if (appCollection)
            {
                const queryString:String = text.substr(index + 1);
                const findOptions:FindOptions = new FindOptions();
                findOptions.appCollection = appCollection;
                findOptions.queryString = queryString;
                findOptions.symbol = appCollection.symbol;
                mongoService.find(findOptions);
            }
            else
            {
                Alert.show("Collection was not defined in config file !", "Error");
            }
        }
        else
        {
            locateService.locate(text);
        }
    }

}
}
