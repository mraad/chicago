package com.esri.controllers
{

import com.esri.ags.events.DrawEvent;
import com.esri.ags.tools.DrawTool;
import com.esri.views.ViewLocator;

public final class DrawController
{
    private var m_drawTool:DrawTool = new DrawTool();

    [Signal]
    public function drawRect():void
    {
        m_drawTool.map = ViewLocator.instance.map;
        m_drawTool.showDrawTips = false;
        m_drawTool.graphicsLayer = ViewLocator.instance.polygonsLayer;
        m_drawTool.removeEventListener(DrawEvent.DRAW_END, drawTool_drawEndHandler);
        m_drawTool.addEventListener(DrawEvent.DRAW_END, drawTool_drawEndHandler);
        m_drawTool.activate(DrawTool.EXTENT);
    }

    private function drawTool_drawEndHandler(event:DrawEvent):void
    {
        m_drawTool.deactivate();
        // ViewLocator.instance.polygonsLayer.remove(event.graphic);
        // Model.instance.polygons.addItem(event.graphic);
    }
}
}
