package com.esri.controllers
{

import com.esri.ags.SpatialReference;
import com.esri.ags.geometry.Extent;
import com.esri.ags.symbols.SimpleMarkerSymbol;
import com.esri.ags.symbols.Symbol;
import com.esri.model.AppField;
import com.esri.model.AppNameLabelFields;
import com.esri.model.Model;
import com.esri.model.AppCollection;
import com.esri.signal.Signal;

import mx.controls.LinkBar;
import mx.core.FlexGlobals;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

public final class LoadConfigController
{

    [Inject]
    public var basemapController:BasemapController;

    [Signal]
    public function loadConfig():void
    {
        Model.instance.statusText = "Loading config...";
        const hs:HTTPService = new HTTPService();
        hs.useProxy = false;
        hs.requestTimeout = Model.instance.requestTimeout;
        hs.resultFormat = HTTPService.RESULT_FORMAT_E4X;
        hs.addEventListener(ResultEvent.RESULT, hs_resultHandler);
        hs.addEventListener(FaultEvent.FAULT, hs_faultHandler);
        hs.url = "config.xml"
        hs.send();
    }

    private function hs_faultHandler(event:FaultEvent):void
    {
        Signal.sendFault(event.fault);
    }

    private function hs_resultHandler(event:ResultEvent):void
    {
        const configXML:XML = event.result as XML;
        if (configXML)
        {
            const model:Model = Model.instance;
            model.configXML = configXML;

            model.requestTimeout = configXML.requestTimeout;
            const wkid:Number = configXML.wkid;
            model.spatialReference = new SpatialReference(wkid);
            const xmin:Number = configXML.xmin;
            const ymin:Number = configXML.ymin;
            const xmax:Number = configXML.xmax;
            const ymax:Number = configXML.ymax;
            model.extent = new Extent(xmin, ymin, xmax, ymax, model.spatialReference);

            basemapController.basemapTopo();

            parseCollections(configXML.collection);
        }
        Model.instance.statusText = "Ready.";
    }

    private function parseCollections(collections:XMLList):void
    {
        for each (var collectionXML:XML in collections)
        {
            const mongoCollection:AppCollection = new AppCollection();
            mongoCollection.name = collectionXML.@name;
            mongoCollection.label = collectionXML.@label;
            mongoCollection.symbol = parseSymbol(collectionXML.symbol[0]);
            parseFields(mongoCollection, collectionXML.field);
            Model.instance.collectionDict[mongoCollection.name] = mongoCollection;
            Model.instance.collectionList.addItem(mongoCollection);
        }
    }

    private function parseFields(dest:AppNameLabelFields, fields:XMLList):void
    {
        for each (var fieldXML:XML in fields)
        {
            const field:AppField = new AppField();

            field.name = fieldXML.@name;

            field.label = fieldXML.@label;

            field.link = fieldXML.@link;

            const type:String = fieldXML.@type;
            field.type = type === null ? "string" : type;

            const align:String = fieldXML.@align;
            field.align = align === null ? "left" : align;

            const visible:String = fieldXML.@visible;
            field.isVisible = visible !== "false";

            const tooltip:String = fieldXML.@tooltip;
            field.isTooltip = tooltip === "true";

            const title:String = fieldXML.@title;
            field.isTitle = title === "true";

            trace(field.name, field.isTooltip, field.isTitle);

            const className:String = fieldXML.@className;

            dest.addField(field);
        }
    }

    private function parseSymbol(symbolXML:XML):Symbol
    {
        var children:XMLList = symbolXML.child("SimpleMarkerSymbol");
        if (children.length() === 1)
        {
            return parseSimpleMarkerSymbol(children[0])
        }
        return null;
    }

    private function parseSimpleMarkerSymbol(symbolXML:XML):Symbol
    {
        const colorText:String = symbolXML.@color;
        const color:Number = FlexGlobals.topLevelApplication.styleManager.getColorName(colorText);
        const size:Number = symbolXML.@size;
        const alpha:Number = symbolXML.@alpha;
        return new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_CIRCLE, size, color, alpha);
    }
}
}
