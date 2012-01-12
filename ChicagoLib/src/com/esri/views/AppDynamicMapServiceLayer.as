package com.esri.views
{

import com.esri.ags.events.LayerEvent;
import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
import com.esri.ags.layers.supportClasses.AllDetails;
import com.esri.ags.tasks.DetailsTask;
import com.esri.model.AppMapServer;
import com.esri.model.Model;
import com.esri.signal.Signal;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.rpc.AsyncResponder;
import mx.rpc.Fault;

public final class AppDynamicMapServiceLayer extends ArcGISDynamicMapServiceLayer
{
    private var m_mapServer:AppMapServer;

    public function AppDynamicMapServiceLayer(mapServer:AppMapServer)
    {
        super(mapServer.restURL);
        m_mapServer = mapServer;
        init();
    }

    private function init():void
    {
        imageTransparency = true;

        addEventListener(LayerEvent.LOAD, loadHandler);
        addEventListener(LayerEvent.LOAD_ERROR, loadErrorHandler);

    /* Remove for now - there is a bug in the flex api :-(
    addEventListener(LayerEvent.UPDATE_START, updateStartHandler);
    addEventListener(LayerEvent.UPDATE_END, updateEndHandler);
    */
    }

    /*
    private function updateEndHandler(event:LayerEvent):void
    {
        FlexGlobals.topLevelApplication.cursorManager.removeBusyCursor();
    }

    private function updateStartHandler(event:LayerEvent):void
    {
        FlexGlobals.topLevelApplication.cursorManager.setBusyCursor();
    }
    */

    private function loadErrorHandler(event:LayerEvent):void
    {
        // FlexGlobals.topLevelApplication.cursorManager.removeBusyCursor();
        if (Model.instance.selectedMapServer === m_mapServer)
        {
            Model.instance.selectedMapServer = null;
        }
        Model.instance.mapServers.removeItem(m_mapServer);
        // AppEvent.dispatchFault(event.fault);
        Signal.sendFault(event.fault);
    }

    private function loadHandler(event:LayerEvent):void
    {
        removeEventListener(LayerEvent.LOAD, loadHandler);

        if (m_mapServer.getAllDetails)
        {
            getLayerDetails();
        }

        if (m_mapServer.refreshSeconds > 0)
        {
            m_mapServer.timer = new Timer(m_mapServer.refreshSeconds * 1000);
            m_mapServer.timer.addEventListener(TimerEvent.TIMER, timerHandler);
            m_mapServer.timer.start();
        }
    }

    private function getLayerDetails():void
    {
        const detailTask:DetailsTask = new DetailsTask(url);
        detailTask.showBusyCursor = true;
        detailTask.autoNormalize = false;
        detailTask.requestTimeout = Model.instance.requestTimeout;
        detailTask.getAllDetails(new AsyncResponder(resultHandler, faultHandler, this));
    }

    private function resultHandler(allDetails:AllDetails, token:Object = null):void
    {
        m_mapServer.allDetails = allDetails;
    }

    private function faultHandler(fault:Fault, token:Object = null):void
    {
        // AppEvent.dispatchFault(fault)
        Signal.sendFault(fault);
    }

    private function timerHandler(event:TimerEvent):void
    {
        this.refresh();
    }
}
}
