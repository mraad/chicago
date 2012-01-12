package com.esri.views
{

import com.esri.ags.Map;
import com.esri.ags.layers.GraphicsLayer;

public final class ViewLocator
{
    public static const instance:ViewLocator = new ViewLocator();

    public var map:Map;

    public var markersLayer:GraphicsLayer;

    public var polylineLayer:GraphicsLayer;

    public var polygonsLayer:GraphicsLayer;

    public function ViewLocator()
    {
    }
}
}
