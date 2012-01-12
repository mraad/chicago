package com.esri.controllers
{

import com.esri.ags.clusterers.WeightedClusterer;
import com.esri.ags.clusterers.supportClasses.SimpleClusterSymbol;
import com.esri.model.Model;

public final class ClusterPointsController
{
    private var m_clusterer:WeightedClusterer;

    [Signal]
    public function clusterPoints(selected:Boolean):void
    {
        if (selected)
        {
            if (m_clusterer === null)
            {
                m_clusterer = new WeightedClusterer();
                m_clusterer.symbol = new SimpleClusterSymbol();
            }
            Model.instance.clusterer = m_clusterer;
        }
        else
        {
            Model.instance.clusterer = null;
        }
    }
}
}
