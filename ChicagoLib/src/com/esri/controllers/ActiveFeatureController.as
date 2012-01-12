package com.esri.controllers
{

import com.esri.ags.Graphic;
import com.esri.model.Model;

import spark.filters.GlowFilter;

public final class ActiveFeatureController
{
    private var m_filters:Array;

    [Signal]
    public function activeFeature(feature:Graphic):void
    {
        if (Model.instance.activeFeature)
        {
            Model.instance.activeFeature.filters = null;
        }
        if (m_filters === null)
        {
            m_filters = [ new GlowFilter(0xFFFF00, 1.0, 5, 5, 4)];
        }
        if (feature)
        {
            feature.filters = m_filters;
        }
        Model.instance.activeFeature = feature;
    }

    [Signal]
    public function clearAll():void
    {
        if (Model.instance.activeFeature)
        {
            Model.instance.activeFeature.filters = null;
            Model.instance.activeFeature = null;
        }
    }
}
}
