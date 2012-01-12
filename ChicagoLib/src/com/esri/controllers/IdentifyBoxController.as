package com.esri.controllers
{

import com.esri.ags.layers.supportClasses.Field;
import com.esri.ags.layers.supportClasses.LayerDetails;
import com.esri.ags.tasks.supportClasses.IdentifyResult;
import com.esri.model.AppFeatureServer;
import com.esri.model.AppField;
import com.esri.model.AppKeyVal;
import com.esri.model.Model;
import com.esri.views.ViewLocator;

public final class IdentifyBoxController
{

    [Signal]
    public function identifyNext():void
    {
        if (Model.instance.identifyIndex < Model.instance.identifyCount - 1)
        {
            Model.instance.identifyIndex++;
            identifyShow();
        }
    }

    [Signal]
    public function identifyPrev():void
    {
        if (Model.instance.identifyIndex > 0)
        {
            Model.instance.identifyIndex--;
            identifyShow();
        }
    }

    [Signal]
    public function identifyShow():void
    {
        /**TRACEDISABLE:trace('identifyShow'); TRACEDISABLE*/
        const identifyResult:IdentifyResult = Model.instance.identifyResults[Model.instance.identifyIndex];
        const layerDetails:LayerDetails = identifyResult.layerId === -1 ? null : (Model.instance.selectedMapServer ? Model.instance.selectedMapServer.allDetails.layersDetails[identifyResult.layerId] : null);
        const featureServer:AppFeatureServer = findAppFeatureServer(identifyResult.layerId);
        const attributes:Object = identifyResult.feature.attributes;
        const arr:Array = [];
        if (featureServer && featureServer.fields && featureServer.fields.length)
        {
            setFieldsBasedOnFeatureServerConfig(arr, layerDetails, featureServer, attributes);
        }
        else
        {
            for (var attrName:String in attributes)
            {
                if (attrName === "OBJECTID")
                {
                    continue;
                }
                if (attrName === "GLOBALID")
                {
                    continue;
                }
                if (attrName === "Shape")
                {
                    continue;
                }
                if (attrName === "SHAPE")
                {
                    continue;
                }
                if (attrName === "SHAPE_Area")
                {
                    continue;
                }
                if (attrName === "SHAPE_Length")
                {
                    continue;
                }
                if (attrName === "label")
                {
                    continue;
                }
                if (attrName === "_id")
                {
                    continue;
                }
                const field:Field = layerDetails ? findField(attrName, layerDetails.fields) : null;
                const key:String = field ? field.alias : attrName;
                arr.push(new AppKeyVal(key, attributes[attrName]));
            }
        }
        arr.sortOn("key");
        Model.instance.identifyDataGridProvider.removeAll();
        for each (var item:Object in arr)
        {
            Model.instance.identifyDataGridProvider.addItem(item);
        }
        ViewLocator.instance.map.infoWindow.label = identifyResult.layerName;
    }

    private function setFieldsBasedOnFeatureServerConfig(arr:Array, layerDetails:LayerDetails, featureServer:AppFeatureServer, attributes:Object):void
    {
        for each (var field:AppField in featureServer.fields)
        {
            arr.push(new AppKeyVal(field.label, attributes[field.name]));
        }
    }

    private function findAppFeatureServer(layerId:int):AppFeatureServer
    {
        if (Model.instance.selectedMapServer)
        {
            const url:String = Model.instance.selectedMapServer.restURL + "/" + layerId;
            for each (var featureServer:AppFeatureServer in Model.instance.featureServerArr)
            {
                if (featureServer.url === url)
                {
                    return featureServer;
                }
            }
        }
        return null;
    }

    private function findField(name:String, fields:Array):Field
    {
        for each (var field:Field in fields)
        {
            if (field.name === name)
            {
                return field;
            }
        }
        return null;
    }

}
}
