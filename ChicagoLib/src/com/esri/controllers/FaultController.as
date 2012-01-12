package com.esri.controllers
{

import com.esri.model.Model;

import mx.controls.Alert;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.rpc.Fault;

public final class FaultController
{
    private const LOGGER:ILogger = Log.getLogger("FaultController");

    [Signal]
    public function faultHandler(fault:Fault):void
    {
        const faultText:String = fault.faultDetail ? fault.faultDetail : (fault.faultString ? fault.faultString : "Unkown Fault");
        if (faultText.length > 128)
        {
            Model.instance.statusText = "Fault-" + faultText.substr(0, 128) + "...";
        }
        else
        {
            Model.instance.statusText = "Fault-" + faultText;
        }
        if (Log.isError())
        {
            LOGGER.error(fault.toString());
        }
        Alert.show(faultText, 'Fault');
    }
}
}
