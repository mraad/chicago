package com.esri.controllers
{

import com.esri.ags.Graphic;

import spark.filters.GlowFilter;

public final class ActiveFeatureController
{
    private var m_lastFeature:Graphic;
    private var m_filters:Array;

    [Signal]
    public function activeFeature(feature:Graphic):void
    {
        if (m_lastFeature)
        {
            m_lastFeature.filters = null;
        }
        if (m_filters === null)
        {
            m_filters = [ new GlowFilter(0xFFFF00, 1.0, 5, 5, 4)];
        }
        m_lastFeature = feature;
        m_lastFeature.filters = m_filters;
    }

    [Signal]
    public function clearAll():void
    {
        if (m_lastFeature)
        {
            m_lastFeature.filters = null;
            m_lastFeature = null;
        }
    }
}
}
