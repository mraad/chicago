package com.esri.views
{

import com.esri.ags.Graphic;
import com.esri.model.Model;

import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridItemRenderer;
import mx.controls.dataGridClasses.DataGridListData;

public class AppDataGridItemRenderer extends DataGridItemRenderer
{
    public function AppDataGridItemRenderer()
    {
    }

    override public function validateNow():void
    {
        super.validateNow();

        if (!listData)
        {
            background = false;
            return;
        }

        var dgListData:DataGridListData = listData as DataGridListData;
        var dataGrid:DataGrid = dgListData.owner as DataGrid;

        if (dataGrid.isItemSelected(data) || dataGrid.isItemHighlighted(data))
        {
            background = false;
            return;
        }

    /*
    const feature:Graphic = data as Graphic;
    if (feature && !feature.geometry)
    {
        background = true;
        backgroundColor = Model.instance.featureWithNoGeometryGridColor;
    }
    else
    {
        background = false;
    }
    */
    }
}
}
