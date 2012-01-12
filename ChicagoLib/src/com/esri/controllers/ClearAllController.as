package com.esri.controllers
{

import com.esri.model.Model;

public final class ClearAllController
{

    [Signal]
    public function clearAll():void
    {
        Model.instance.markers.removeAll();
        Model.instance.polylines.removeAll();
        Model.instance.polygons.removeAll();
    }
}
}
