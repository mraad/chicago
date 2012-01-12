package com.esri.controllers
{

import com.esri.ags.Graphic;
import com.esri.ags.clusterers.supportClasses.ClusterGraphic;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.geometry.Polygon;
import com.esri.ags.geometry.Polyline;
import com.esri.model.Model;
import com.esri.signal.Signal;
import com.esri.views.LabelSymbol;

import flash.events.ContextMenuEvent;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.core.IMXMLObject;

public class ContextMenuController implements IMXMLObject
{
    private var m_contextMenuMapPoint:ContextMenu = new ContextMenu();

    private var m_contextMenuPolygon:ContextMenu = new ContextMenu();

    private var m_contextMenuPolyline:ContextMenu = new ContextMenu();

    private var m_contextMenuRoute:ContextMenu = new ContextMenu();

    private var m_menuItemProperties:ContextMenuItem = new ContextMenuItem("Properties");

    private var m_menuItemFind:ContextMenuItem = new ContextMenuItem("Find...");

    private var m_menuItemAddress:ContextMenuItem = new ContextMenuItem("Address");

    private var m_menuItemArea:ContextMenuItem = new ContextMenuItem("Area");

    private var m_menuItemCoords:ContextMenuItem = new ContextMenuItem("Coordinates");

    private var m_menuItemLength:ContextMenuItem = new ContextMenuItem("Length");

    private var m_menuItemRemove:ContextMenuItem = new ContextMenuItem("Remove", true);

    private var m_menuItemRouteBarrier:ContextMenuItem = new ContextMenuItem("Barrier");

    private var m_menuItemRouteStop:ContextMenuItem = new ContextMenuItem("Stop", true);

    // private var m_menuItemSendBack:ContextMenuItem = new ContextMenuItem("Send Back");

    private var m_menuItemBuffer:ContextMenuItem = new ContextMenuItem("Buffer...");

    // private var m_menuItemServiceArea:ContextMenuItem = new ContextMenuItem("Service Area");

    // private var m_menuItemSymbol:ContextMenuItem = new ContextMenuItem("Symbol...");

    /*
    [Inject]
    public var selectedFeatureDelegate:SelectedFeatureDelegate;
    */

    /*
    [Inject]
    public var addStopAttributesDelegate:AddStopAttributesDelegate;
    */

    [Inject]
    public var graphicPropertiesController:GraphicPropertiesController;

    public function initialized(document:Object, id:String):void
    {
        m_menuItemProperties.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, properties_menuItemSelectHandler);
        m_menuItemFind.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, find_menuItemSelectHandler);
        // m_menuItemSymbol.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, symbol_menuItemSelectHandler);
        m_menuItemRemove.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, remove_menuItemSelectHandler);
        m_menuItemAddress.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, address_menuItemSelectHandler);
        m_menuItemCoords.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, coords_menuItemSelectHandler);
        m_menuItemRouteStop.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, routeStop_menuItemSelectHandler);
        m_menuItemRouteBarrier.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, routeBarrier_menuItemSelectHandler);
        m_menuItemArea.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, area_menuItemSelectHandler);
        m_menuItemLength.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, length_menuItemSelectHandler);
        m_menuItemBuffer.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, buffer_menuItemSelectHandler);
        // m_menuItemServiceArea.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, m_menuItemServiceArea_menuItemSelectHandler);

        m_contextMenuMapPoint.hideBuiltInItems();
        m_contextMenuMapPoint.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
        m_contextMenuMapPoint.customItems.push(m_menuItemProperties);
        m_contextMenuMapPoint.customItems.push(m_menuItemRemove);
        m_contextMenuMapPoint.customItems.push(m_menuItemFind);
        m_contextMenuMapPoint.customItems.push(m_menuItemBuffer);
        m_contextMenuMapPoint.customItems.push(m_menuItemAddress);
        m_contextMenuMapPoint.customItems.push(m_menuItemCoords);
        m_contextMenuMapPoint.customItems.push(m_menuItemRouteStop);
        m_contextMenuMapPoint.customItems.push(m_menuItemRouteBarrier);

        m_contextMenuPolyline.hideBuiltInItems();
        m_contextMenuPolyline.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
        m_contextMenuPolyline.customItems.push(m_menuItemProperties);
        m_contextMenuPolyline.customItems.push(m_menuItemRemove);
        m_contextMenuPolyline.customItems.push(m_menuItemFind);
        m_contextMenuPolyline.customItems.push(m_menuItemBuffer);
        m_contextMenuPolyline.customItems.push(m_menuItemLength);
        m_contextMenuPolyline.customItems.push(m_menuItemRouteBarrier);

        m_contextMenuRoute.hideBuiltInItems();
        m_contextMenuRoute.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
        m_contextMenuRoute.customItems.push(m_menuItemProperties);
        m_contextMenuRoute.customItems.push(m_menuItemRemove);
        m_contextMenuRoute.customItems.push(m_menuItemFind);
        m_contextMenuRoute.customItems.push(m_menuItemBuffer);
        m_contextMenuRoute.customItems.push(m_menuItemLength);

        m_contextMenuPolygon.hideBuiltInItems();
        m_contextMenuPolygon.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
        m_contextMenuPolygon.customItems.push(m_menuItemProperties);
        m_contextMenuPolygon.customItems.push(m_menuItemRemove);
        m_contextMenuPolygon.customItems.push(m_menuItemFind);
        m_contextMenuPolygon.customItems.push(m_menuItemBuffer);
        m_contextMenuPolygon.customItems.push(m_menuItemArea);
        m_contextMenuPolygon.customItems.push(m_menuItemLength);
        m_contextMenuPolygon.customItems.push(m_menuItemRouteBarrier);
    }

    [Signal]
    public function addContextMenu(graphic:Graphic):void
    {
        graphic.autoMoveToTop = false; // TODO - make configurable.
        if (graphic.geometry is MapPoint)
        {
            graphic.contextMenu = m_contextMenuMapPoint;
        }
        else if (graphic.geometry is Polyline)
        {
            /*
            if (graphic.symbol === Model.instance.routeSymbol)
            {
                graphic.contextMenu = m_contextMenuRoute;
            }
            else
            {
                graphic.contextMenu = m_contextMenuPolyline;
            }
            */
        }
        else if (graphic.geometry is Polygon)
        {
            graphic.contextMenu = m_contextMenuPolygon;
        }
        else if (graphic.geometry is Extent)
        {
            graphic.contextMenu = m_contextMenuPolygon;
        }
    }

    private function find_menuItemSelectHandler(contextMenuEvent:ContextMenuEvent):void
    {
        const graphic:Graphic = contextMenuEvent.contextMenuOwner as Graphic;
        Signal.send('findWindow', graphic);
    /*
    const appEvent:AppEvent = new AppEvent(AppEvent.SELECT_WINDOW);
    appEvent.graphic = graphic;
    appEvent.dispatch();
    */
    }

    private function symbol_menuItemSelectHandler(contextMenuEvent:ContextMenuEvent):void
    {
        const graphic:Graphic = contextMenuEvent.contextMenuOwner as Graphic;
    /*
    const symbol:ISymbol = graphic.symbol as ISymbol;
    if (symbol)
    {
        const event:AppEvent = new AppEvent(AppEvent.SYMBOL);
        event.symbol = symbol;
        event.dispatch();
    }
    */
    }

    /*
    private function m_menuItemServiceArea_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        const appEvent:AppEvent = new AppEvent(AppEvent.SERVICE_AREA_WINDOW);
        appEvent.graphic = graphic;
        appEvent.dispatch();
    }
    */

    private function buffer_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
    /*
    const appEvent:AppEvent = new AppEvent(AppEvent.BUFFER_WINDOW);
    appEvent.graphic = graphic;
    appEvent.dispatch();
    */
    }

    /*
    private function selectFeature_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        if (selectedFeatureDelegate.isFeatureSelected(graphic))
        {
            selectedFeatureDelegate.clearSelectedFeature(graphic);
        }
        else
        {
            selectedFeatureDelegate.addSelectedFeature(graphic);
        }
    }
    */

    private function addAreaExtent(extent:Extent):void
    {
    /*
    const area:Number = extent.width * extent.height;
    Model.instance.markers.addItem(new Graphic(extent.center, Model.instance.areaSymbol, { label: 'Area', area: area }));
    */
    }

    private function addAreaPolygon(polygon:Polygon):void
    {
        const mapPoints:Array = polygon.rings[0];
        const signedArea:Number = calcSignedArea(mapPoints);
        if (signedArea !== 0.0)
        {
            const mapPoint:MapPoint = new MapPoint();
            var factor:Number = 0.0;
            for (var i:int = 0; i < mapPoints.length; i++)
            {
                const j:int = (i + 1) % mapPoints.length;
                const p:MapPoint = mapPoints[i];
                const q:MapPoint = mapPoints[j];
                factor = p.x * q.y - q.x * p.y;
                mapPoint.x += (p.x + q.x) * factor;
                mapPoint.y += (p.y + q.y) * factor;
            }
            factor = 1.0 / (6.0 * signedArea);
            mapPoint.x *= factor;
            mapPoint.y *= factor;
            const area:Number = Math.abs(signedArea);
                // Model.instance.markers.addItem(new Graphic(mapPoint, Model.instance.areaSymbol, { label: 'Area', area: area }));
        }
    }

    private function addLengthExtent(extent:Extent):void
    {
        const length:Number = 2.0 * (extent.width + extent.height);
        const mapPoint:MapPoint = new MapPoint(extent.xmax, extent.ymax);
        // Model.instance.markers.addItem(new Graphic(mapPoint, Model.instance.lengthSymbol, { label: 'Length', length: length }));
    }

    private function addLengthGraphic(mapPoints:Array, addAtEnd:Boolean):void
    {
        if (mapPoints && mapPoints.length > 1)
        {
            var mapPoint:MapPoint = mapPoints[0];
            var length:Number = 0;
            for (var i:int = 0, j:int = 1; j < mapPoints.length; i++, j++)
            {
                const p1:MapPoint = mapPoints[i];
                const p2:MapPoint = mapPoints[j];
                const dx:Number = p2.x - p1.x;
                const dy:Number = p2.y - p1.y;
                const dd:Number = Math.sqrt(dx * dx + dy * dy);
                length += dd;

                if (p1.y > mapPoint.y)
                {
                    mapPoint = p1;
                }
            }
            if (addAtEnd)
            {
                mapPoint = mapPoints[mapPoints.length - 1];
            }
                // Model.instance.markers.addItem(new Graphic(mapPoint, Model.instance.lengthSymbol, { label: 'Length', length: length }));
        }
    }

    private function address_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
    /*
    const appEvent:AppEvent = new AppEvent(AppEvent.LOCATION_TO_ADDRESS);
    appEvent.graphic = graphic;
    appEvent.dispatch();
    */
    }

    private function area_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        const polygon:Polygon = graphic.geometry as Polygon;
        if (polygon)
        {
            addAreaPolygon(polygon);
        }
        else
        {
            const extent:Extent = graphic.geometry as Extent;
            if (extent)
            {
                addAreaExtent(extent);
            }
        }
    }

    private function calcSignedArea(mapPoints:Array):Number
    {
        var area:Number = 0;
        for (var i:int = 0; i < mapPoints.length; i++)
        {
            const j:int = (i + 1) % mapPoints.length;
            const p:MapPoint = mapPoints[i];
            const q:MapPoint = mapPoints[j];
            area += p.x * q.y;
            area -= p.y * q.x;
        }
        return area * 0.5;
    }

    private function coords_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const oldFeature:Graphic = event.contextMenuOwner as Graphic;

        const mapPoint:MapPoint = oldFeature.geometry as MapPoint;

        // const newFeature:Graphic = new Graphic(mapPoint, Model.instance.coordSymbol, {});

        const lonNume:Number = WebMercator.xToLongitude(mapPoint.x);
        const latNume:Number = WebMercator.yToLatitude(mapPoint.y);

        trace(lonNume, latNume);

        const lonText:String = DegToDMS.format(lonNume, DegToDMS.LON);
        const latText:String = DegToDMS.format(latNume, DegToDMS.LAT);

        // newFeature.attributes.lon = lonText;
        // newFeature.attributes.lat = latText;
        // newFeature.attributes.label = latText + " " + lonText;

        // Model.instance.markers.addItem(newFeature);
    }

    private function length_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        const polyline:Polyline = graphic.geometry as Polyline;
        if (polyline)
        {
            addLengthGraphic(polyline.paths[0], true);
        }
        else
        {
            const polygon:Polygon = graphic.geometry as Polygon;
            if (polygon)
            {
                addLengthGraphic(polygon.rings[0], false);
            }
            else
            {
                const extent:Extent = graphic.geometry as Extent;
                if (extent)
                {
                    addLengthExtent(extent);
                }
            }
        }
    }

    private function removeFromArrCol(graphic:Graphic, arrcol:ArrayCollection):void
    {
        const index:int = arrcol.source.indexOf(graphic);
        if (index > -1)
        {
            arrcol.source.splice(index, 1);
            arrcol.refresh();
        }
    }

    private function remove_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        if (graphic.geometry is MapPoint)
        {
            removeFromArrCol(graphic, Model.instance.markers);
        }
        else if (graphic.geometry is Polyline)
        {
            removeFromArrCol(graphic, Model.instance.polylines);
        }
        else
        {
            removeFromArrCol(graphic, Model.instance.polygons);
        }

    /*
    removeFromArrCol(graphic, Model.instance.routeBarriers);

    for (var i:int = 0, len:int = ViewLocator.instance.viewStack.length; i < len; i++)
    {
        const arrColRef:IArrColRef = ViewLocator.instance.viewStack.getElementAt(i) as IArrColRef;
        if (arrColRef)
        {
            removeFromArrCol(graphic, arrColRef.arrcol);
        }
    }
    */
        // selectedFeatureDelegate.clearSelectedFeature(graphic);
    }

    private function routeBarrier_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        /*
        if (graphic.attributes)
        {
            if (graphic.attributes.label === undefined)
            {
                graphic.attributes.label = "Barrier " + Model.instance.barrierCounter++;
            }
        }
        else
        {
            graphic.attributes = { label: "Barrier " + Model.instance.barrierCounter++ };
        }
        if (graphic.geometry is MapPoint)
        {
            graphic.symbol = Model.instance.barrierPointSymbol;
        }
        else if (graphic.geometry is Polygon)
        {
            graphic.symbol = Model.instance.barrierPolygonSymbol;
        }
        const barrierIndex:int = Model.instance.routeBarriers.getItemIndex(graphic);
        if (barrierIndex === -1)
        {
            Model.instance.routeBarriers.addItem(graphic);
        }
        */
        /* TODO
           for each (var dataGridProvider:BaseDataGridProvider in Model.instance.dataGridProviders)
           {
           const index:int = dataGridProvider.arrcol.getItemIndex(graphic);
           if (index > -1)
           {
           dataGridProvider.arrcol.removeItemAt(index);
           }
           }
         */
        setToolTip(graphic);
    }

    private function routeStop_menuItemSelectHandler(event:ContextMenuEvent):void
    {
    /*
    const arrColRef:IArrColRef = ViewLocator.instance.viewStack.selectedChild as IArrColRef;
    if (arrColRef)
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        const index:int = arrColRef.arrcol.getItemIndex(graphic);
        if (index === -1)
        {
            if (graphic.symbol !== Model.instance.carSymbol)
            {
                graphic.symbol = Model.instance.stopSymbol;
            }
            addStopAttributesDelegate.addStopAttributes(graphic);
            setToolTip(graphic);
            arrColRef.arrcol.addItem(graphic);
        }
    }
    else
    {
        Alert.show('Create a route before adding this feature as a stop!', 'Warning');
    }
    */
    }

    /*
    private function sendBack_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        const graphicsLayer:GraphicsLayer = graphic.parent as GraphicsLayer;
        graphicsLayer.setChildIndex(graphic, 0);
    }
    */

    private function setToolTip(graphic:Graphic):void
    {
        if (graphic.attributes)
        {
            if (graphic.attributes.label)
            {
                graphic.toolTip = graphic.attributes.label;
            }
            else
            {
                graphic.toolTip = null;
            }
        }
        else
        {
            graphic.toolTip = null;
        }
    }

    private function menuSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        const isClusterGraphic:Boolean = graphic is ClusterGraphic;
        const isLabelSymbol:Boolean = graphic.symbol is LabelSymbol;
        m_menuItemProperties.enabled = graphic.attributes !== null && !isLabelSymbol;
        //m_menuItemSymbol.enabled = graphic.symbol is ISymbol;
        m_menuItemRemove.enabled = !isClusterGraphic;
        m_menuItemAddress.enabled = !isClusterGraphic;
        m_menuItemCoords.enabled = !isClusterGraphic;
        m_menuItemRouteStop.enabled = !isClusterGraphic;
        m_menuItemRouteBarrier.enabled = !isClusterGraphic;
    }

    private function properties_menuItemSelectHandler(event:ContextMenuEvent):void
    {
        const graphic:Graphic = event.contextMenuOwner as Graphic;
        graphicPropertiesController.graphicProperties(graphic, FlexGlobals.topLevelApplication.mouseX, FlexGlobals.topLevelApplication.mouseY);
    /*
    const appEvent:AppEvent = new AppEvent(AppEvent.GRAPHIC_PROPERTIES);
    appEvent.graphic = graphic;
    appEvent.stageX = FlexGlobals.topLevelApplication.mouseX;
    appEvent.stageY = FlexGlobals.topLevelApplication.mouseY;
    appEvent.dispatch();
    */
    }

}
}
