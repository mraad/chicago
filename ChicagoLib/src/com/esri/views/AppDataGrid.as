package com.esri.views
{

import com.esri.ags.Graphic;

import mx.controls.DataGrid;
import mx.core.ClassFactory;
import mx.events.DataGridEvent;
import mx.events.ListEvent;

public final class AppDataGrid extends DataGrid
{
    public function AppDataGrid()
    {
        init();
    }

    private function init():void
    {
        percentWidth = 100;
        percentHeight = 100;
        allowMultipleSelection = true;
        doubleClickEnabled = true;
        itemRenderer = new ClassFactory(AppDataGridItemRenderer);
        addEventListener(DataGridEvent.HEADER_RELEASE, headerReleaseHandler);
        addEventListener(ListEvent.ITEM_CLICK, itemClickHandler);
        addEventListener(ListEvent.ITEM_DOUBLE_CLICK, itemDoubleClickHandler);
    }

    private function headerReleaseHandler(event:DataGridEvent):void
    {
        this.selectedIndices = [];
    }

    private function itemDoubleClickHandler(event:ListEvent):void
    {
        if (selectedItem is Graphic)
        {
            /*
            const appEvent:AppEvent = new AppEvent(AppEvent.DATA_GRID_DOUBLE_CLICK);
            appEvent.selectedGraphic = selectedItem;
            appEvent.dispatch();
            */
        }
    }

    private function itemClickHandler(event:ListEvent):void
    {
        if (selectedItem is Graphic)
        {
            /*
            const appEvent:AppEvent = new AppEvent(AppEvent.DATA_GRID_CLICK);
            appEvent.selectedGraphic = selectedItem;
            appEvent.selectedGraphics = selectedItems;
            appEvent.dispatch();
            */
        }
    }

}
}
