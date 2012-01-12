package com.esri.model
{

import com.esri.ags.layers.supportClasses.LayerDetails;

public final class AppLayerDetails
{
    public var label:String;
    public var layerDetails:LayerDetails;
    public var mapServer:AppMapServer;

    public function AppLayerDetails(label:String, layerDetails:LayerDetails, mapServer:AppMapServer)
    {
        this.label = label;
        this.layerDetails = layerDetails;
        this.mapServer = mapServer;
    }
}
}