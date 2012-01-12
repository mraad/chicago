package com.esri.model
{

import com.esri.ags.layers.supportClasses.AllDetails;
import com.esri.views.AppDynamicMapServiceLayer;

import flash.utils.Timer;

public class AppMapServer extends AppNameLabel
{
    public var dynamicMapServiceLayer:AppDynamicMapServiceLayer;

    public var refreshSeconds:Number;

    public var restURL:String;

    public var wsdlURL:String;

    public var visible:Boolean;

    public var layersIncluded:Boolean;

    public var getAllDetails:Boolean;

    public var allDetails:AllDetails;

    public var timer:Timer;

    public var layerList:Array;

    public var layerDict:Object;

    public function AppMapServer()
    {
    }
}
}
