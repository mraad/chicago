package com.esri.controllers
{

import com.esri.ags.Graphic;
import com.esri.ags.tasks.Locator;
import com.esri.ags.tasks.supportClasses.AddressCandidate;
import com.esri.model.Model;
import com.esri.signal.Signal;
import com.esri.views.ViewLocator;

import mx.controls.Alert;
import mx.rpc.AsyncResponder;
import mx.rpc.Fault;

public final class LocatorService
{
    private var m_locator:Locator;
    private var m_locatorKey:String;
    private var m_locatorField:String;

    public function locate(text:String):void
    {
        if (m_locator === null)
        {
            m_locatorKey = Model.instance.configXML.locatorKey;
            m_locatorField = Model.instance.configXML.locatorField;
            m_locator = new Locator(Model.instance.configXML.locatorURL);
            m_locator.showBusyCursor = true;
            m_locator.requestTimeout = Model.instance.requestTimeout;
            m_locator.outSpatialReference = Model.instance.spatialReference;
        }
        const param:Object = {};
        param[m_locatorKey] = text;
        m_locator.addressToLocations(param, [ m_locatorField ],
                                     new AsyncResponder(addressToLocations_resultHandler, faultHandler, text));
    }

    private function addressToLocations_resultHandler(result:Array, text:String):void
    {
        if (result.length)
        {
            const addrCand:AddressCandidate = result[0];

            const graphic:Graphic = new Graphic(addrCand.location, Model.instance.labelSymbol, { label: addrCand.address });
            Model.instance.markers.addItem(graphic);

            const scale:Number = Model.instance.configXML.zoomScale;
            ViewLocator.instance.map.centerAt(addrCand.location);
            ViewLocator.instance.map.scale = scale;
        }
        else
        {
            Alert.show('Cannot Locate Addres', 'Warning');
        }
    }

    private function faultHandler(fault:Fault, token:Object = null):void
    {
        Signal.sendFault(fault);
    }

}
}
