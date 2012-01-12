package com.esri.views
{

import com.esri.ags.Graphic;

import flash.utils.getQualifiedClassName;

import mx.controls.dataGridClasses.DataGridColumn;
import mx.utils.StringUtil;

import org.as3commons.lang.StringUtils;

public class AppDataGridColumn extends DataGridColumn
{
    public function AppDataGridColumn(columnName:String = null)
    {
        super(columnName);
        labelFunction = featureToLabel;
        sortCompareFunction = compareFeatures;
    }

    private function compareFeatures(lhsFeature:Graphic, rhsFeature:Graphic):int
    {
        const lhsValue:Object = lhsFeature.attributes[dataField];
        if (lhsValue === null)
        {
            return -1;
        }
        const rhsValue:Object = rhsFeature.attributes[dataField];
        if (rhsValue === null)
        {
            return 1;
        }
        const lhsText:String = lhsValue as String;
        const rhsText:String = rhsValue as String;
        if (lhsText && rhsText)
        {
            return StringUtils.compareTo(lhsText, rhsText);
        }
        const lhsNume:Number = lhsValue as Number;
        const rhsNume:Number = rhsValue as Number;
        if (!isNaN(lhsNume) && !isNaN(rhsNume))
        {
            if (lhsNume < rhsNume)
            {
                return -1;
            }
            if (lhsNume > rhsNume)
            {
                return 1;
            }
            return 0;
        }
        return 0;
    }

    private function featureToLabel(feature:Graphic, dataGridColumn:DataGridColumn):String
    {
        const value:Object = feature.attributes[dataField];
        return value === null ? ' ' : value.toString();
    }
}
}