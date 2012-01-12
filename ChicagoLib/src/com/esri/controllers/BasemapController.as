package com.esri.controllers
{

import com.esri.model.Model;

public final class BasemapController
{

    [Signal]
    public function basemapTopo():void
    {
        Model.instance.basemapURL = Model.instance.configXML.topoURL;
    }

    [Signal]
    public function basemapAerial():void
    {
        Model.instance.basemapURL = Model.instance.configXML.aerialURL;

    }

    [Signal]
    public function basemapStreet():void
    {
        Model.instance.basemapURL = Model.instance.configXML.streetURL;
    }

	[Signal]
	public function changeBasemap(url:String):void
	{
		Model.instance.basemapURL = url;
	}

}
}
