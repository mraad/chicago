package com.esri.controllers
{

import com.esri.ags.Graphic;
import com.esri.ags.esri_internal;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.model.AppField;
import com.esri.model.FieldOptions;
import com.esri.model.FindOptions;
import com.esri.model.Model;
import com.esri.views.ViewLocator;

import flash.system.Security;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.managers.CursorManager;

import org.db.mongo.Collection;
import org.db.mongo.Cursor;
import org.db.mongo.DB;
import org.db.mongo.Mongo;
import org.db.mongo.mwp.OpReply;

use namespace esri_internal;

public final class MongoService
{
    private var m_loadedPolicyFile:Boolean = false;
    private var m_mongo:Mongo;
    private var m_db:DB;
    private var m_cursor:Cursor;

    private var m_findOptions:FindOptions;

    public function find(findOptions:FindOptions):void
    {
        m_findOptions = findOptions;
        if (m_loadedPolicyFile === false)
        {
            m_loadedPolicyFile = true;

            const policyFileURL:String = Model.instance.configXML.policyFileURL;
            Security.loadPolicyFile(policyFileURL);

            const mongoHost:String = Model.instance.configXML.mongoHost;
            const mongoPort:uint = Model.instance.configXML.mongoPort;
            m_mongo = new Mongo(mongoHost, mongoPort);

            const mongoDB:String = Model.instance.configXML.mongoDB;
            m_db = m_mongo.getDB(mongoDB);
        }
        const queryObject:Object = toQueryObject(findOptions);
        trace(JSON.stringify(queryObject));
        const collection:Collection = m_db.getCollection(findOptions.appCollection.name);
        m_cursor = collection.find(queryObject, null, findHandler);
        CursorManager.setBusyCursor();
    }

    private function toDict(findOptions:FindOptions):Dictionary
    {
        const dict:Dictionary = new Dictionary();
        for each (var fieldOptions:FieldOptions in findOptions.fields)
        {
            if (fieldOptions.value !== "")
            {
                const arr:Array = dict[fieldOptions.field.name];
                if (arr === null)
                {
                    dict[fieldOptions.field.name] = [ fieldOptions ];
                }
                else
                {
                    arr.push(fieldOptions);
                }
            }
        }
        return dict;
    }

    private function toQueryObject(findOptions:FindOptions):Object
    {
        if (findOptions.queryString)
        {
            return JSON.parse(findOptions.queryString);
        }
        const dict:Dictionary = toDict(findOptions);
        const obj:Object = {};
        addSpatial(obj, findOptions);
        for (var fieldName:String in dict)
        {
            const arr:Array = dict[fieldName];
            if (arr.length === 1)
            {
                const fieldOptions:FieldOptions = arr[0];
                switch (fieldOptions.operator)
                {
                    case "$eq":
                    {
                        obj[fieldName] = toValue(fieldOptions);
                        break;
                    }
                    default:
                    {
                        const val:Object = {};
                        val[fieldOptions.operator] = toValue(fieldOptions);
                        obj[fieldName] = val;
                    }
                }
            }
            else if (arr.length === 2)
            {
                const opt1:FieldOptions = arr[0];
                const opt2:FieldOptions = arr[1];
                const val2:Object = {};
                val2[opt1.operator] = toValue(opt1);
                val2[opt2.operator] = toValue(opt2);
                obj[fieldName] = val2;
            }
        }
        return obj;
    }

    private function addSpatial(obj:Object, findOptions:FindOptions):void
    {
        if (findOptions.isWithin)
        {
            if (findOptions.withinData === -1)
            {
                addWithin(obj, ViewLocator.instance.map.extent);
            }
            else if (findOptions.withinData > -1)
            {
                const withinFeature:Graphic = Model.instance.polygons.getItemAt(findOptions.withinData) as Graphic;
                addWithin(obj, withinFeature.geometry.extent);
            }
        }
        else
        {
            if (findOptions.nearData > -1)
            {
                const nearFeature:Graphic = Model.instance.markers.getItemAt(findOptions.nearData) as Graphic;
                addNear(obj, nearFeature.geometry, findOptions);
            }
            else
            {
                addNear(obj, findOptions.mapPoint, findOptions);
            }
        }
    }

    private function addNear(obj:Object, geometry:Geometry, findOptions:FindOptions):void
    {
        const mapPoint:MapPoint = geometry as MapPoint;
        // Very very rough distabce calculation.
        var meters:Number;
        if (findOptions.unit === "feet")
        {
            meters = findOptions.distance * 3.281;
        }
        else
        {
            meters = findOptions.distance * 1609.3; // Miles
        }
        const lon1:Number = WebMercator.xToLongitude(mapPoint.x);
        const lat1:Number = WebMercator.yToLatitude(mapPoint.y);
        const lon2:Number = WebMercator.xToLongitude(mapPoint.x + meters);
        const maxDistance:Number = (lon2 - lon1) * Math.PI / 180.0;
        const within:Object = { "$within": { "$centerSphere": [[ lon1, lat1 ], maxDistance ]}};
        obj.loc = within;
    }

    private function addWithin(obj:Object, extent:Extent):void
    {
        const xmin:Number = WebMercator.xToLongitude(extent.xmin);
        const ymin:Number = WebMercator.yToLatitude(extent.ymin);
        const xmax:Number = WebMercator.xToLongitude(extent.xmax);
        const ymax:Number = WebMercator.yToLatitude(extent.ymax);
        const lower:Array = [ xmin, ymin ];
        const upper:Array = [ xmax, ymax ];
        const within:Object = { "$within": { "$box": [ lower, upper ]}};
        obj.loc = within; // TODO - make loc configurable
    }

    private function toValue(fieldOptions:FieldOptions):Object
    {
        if (fieldOptions.field.type === "nume")
        {
            return Number(fieldOptions.value);
        }
        return fieldOptions.value;
    }

    private function findHandler():void
    {
        CursorManager.removeBusyCursor();
        const count:int = 0;
        const arrcol:ArrayCollection = Model.instance.markers;
        const extent:Extent = Extent.createEmptyExtent(Model.instance.spatialReference);
        for each (var reply:OpReply in m_cursor.replies)
        {
            for each (var doc:Object in reply.documents)
            {
                const mapPoint:MapPoint = new MapPoint();
                const attr:Object = {};
                for (var key:String in doc)
                {
                    const value:* = doc[key];
                    if (key === "loc") // TODO - make configurable
                    {
                        const loc:Array = value;
                        mapPoint.x = WebMercator.longitudeToX(loc[0]);
                        mapPoint.y = WebMercator.latitudeToY(loc[1]);
                        extent.unionXY(mapPoint.x, mapPoint.y);
                    }
                    else
                    {
                        attr[key] = value;
                    }
                }

                const feature:Graphic = new Graphic(mapPoint, m_findOptions.symbol, attr);
                addTooltipAndTitle(feature);
                arrcol.addItem(feature);
                count++;
            }
        }
        if (count > 1)
        {
            Model.instance.extent = extent.expand(2.0);
        }
        else if (count === 1)
        {
            const scale:Number = Model.instance.configXML.zoomScale;
            ViewLocator.instance.map.centerAt(mapPoint);
            ViewLocator.instance.map.scale = scale;
        }
        Model.instance.statusText = "Found " + count + " Feature(s)";
    }

    private function addTooltipAndTitle(feature:Graphic):void
    {
        const arr:Array = [];
        for each (var field:AppField in m_findOptions.appCollection.fields)
        {
            if (field.isTooltip)
            {
                const value:Object = feature.attributes[field.name];
                if (value)
                {
                    arr.push(value.toString());
                }
            }
            if (field.isTitle)
            {
                feature.attributes.label = feature.attributes[field.name];
            }
        }
        feature.toolTip = arr.length ? arr.join("\n") : null;
    }

}
}
