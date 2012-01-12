package com.esri.model
{

import com.esri.views.AppDataGridColumn;

import flash.utils.Dictionary;

import mx.controls.dataGridClasses.DataGridColumn;

import org.as3commons.lang.ClassUtils;

public class AppNameLabelFields extends AppNameLabel
{
    public var fields:Array = [];
    public var fieldDict:Dictionary = new Dictionary();

    public function AppNameLabelFields()
    {
    }

    public function addField(field:AppField):void
    {
        fields.push(field);
        fieldDict[field.name] = field;
    }

    public function get outFields():Array
    {
        const arr:Array = [];
        for each (var field:AppField in fields)
        {
            arr.push(field.name);
        }
        return arr;
    }

    public function get columns():Array
    {
        const columns:Array = [];
        for each (var field:AppField in fields)
        {
            if (field.isVisible)
            {
                var dataGridColumn:DataGridColumn;
                if (field.dataGridColumnClassName)
                {
                    const clazz:Class = ClassUtils.forName(field.dataGridColumnClassName);
                    dataGridColumn = new clazz();
                }
                else
                {
                    dataGridColumn = new AppDataGridColumn();
                }
                dataGridColumn.dataField = field.name;
                dataGridColumn.headerText = field.label;
                if (field.align)
                {
                    dataGridColumn.setStyle('textAlign', field.align);
                }
                columns.push(dataGridColumn);
            }
        }
        return columns;
    }
	
	public function get titleField():AppField
	{
		for each (var field:AppField in fields)
		{
			if(field.isTitle) {
				return field;
			}
		}
		
		return null;
	}
}
}
