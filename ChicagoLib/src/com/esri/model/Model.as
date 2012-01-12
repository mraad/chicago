package com.esri.model
{

import com.esri.ags.Graphic;
import com.esri.ags.SpatialReference;
import com.esri.ags.clusterers.IClusterer;
import com.esri.ags.geometry.Extent;
import com.esri.ags.symbols.Symbol;
import com.esri.views.LabelSymbol;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;

public final class Model extends EventDispatcher
{
    public static const instance:Model = new Model;

    public var requestTimeout:int = 20;
    public var configXML:XML;

    public var spatialReference:SpatialReference;

    [Bindable]
    public var statusText:String = "";

    [Bindable]
    public var extent:Extent;

    [Bindable]
    public var basemapURL:String;

    [Bindable]
    public var polygons:ArrayCollection = new ArrayCollection();

    [Bindable]
    public var polylines:ArrayCollection = new ArrayCollection();

    [Bindable]
    public var markers:ArrayCollection = new ArrayCollection();

    [Bindable]
    public var clusterer:IClusterer;

    [Bindable]
    public var collectionList:ArrayList = new ArrayList();

    public var collectionDict:Dictionary = new Dictionary();

    [Bindable]
    public var identifyIndex:int;

    [Bindable]
    public var identifyCount:int;

    public var identifyResults:Array;

    [Bindable]
    public var identifyTolerance:Number = 3;

    [Bindable]
    public var identifyWindowWidth:Number = 245;

    [Bindable]
    public var identifyWindowHeight:Number = 250;

    [Bindable]
    public var identifyDataGridProvider:ArrayCollection = new ArrayCollection();

    [Bindable]
    public var mapServers:ArrayList = new ArrayList();

    public var selectedMapServer:AppMapServer;

    public var featureServerDict:Dictionary = new Dictionary();

    public var featureServerList:Array = [];

    public var activeFeature:Graphic;

    public function Model()
    {
    }

    public function get routeSymbol():Symbol
    {
        return null;
    }

    private var m_labelSymbol:LabelSymbol;

    public function get labelSymbol():Symbol
    {
        if (m_labelSymbol === null)
        {
            m_labelSymbol = new LabelSymbol();
        }
        return m_labelSymbol;
    }
}
}
