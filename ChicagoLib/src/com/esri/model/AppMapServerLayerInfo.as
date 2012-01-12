package com.esri.model
{

import com.esri.ags.layers.supportClasses.LayerInfo;

public class AppMapServerLayerInfo
{
    public var layerInfo:LayerInfo;

    public var mapServer:AppMapServer;

    public function AppMapServerLayerInfo(
        mapServer:AppMapServer,
        layerInfo:LayerInfo
        )
    {
        this.mapServer = mapServer;
        this.layerInfo = layerInfo;
    }
}
}
