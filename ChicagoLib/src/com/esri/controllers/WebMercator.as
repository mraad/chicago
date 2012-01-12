package com.esri.controllers
{

import com.esri.ags.Graphic;
import com.esri.ags.SpatialReference;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.geometry.Polygon;

public class WebMercator
{

    private static const DEGREES_PER_RADIANS:Number = 57.295779513082320;

    private static const PI_OVER_2:Number = Math.PI / 2.0;

    private static const RADIANS_PER_DEGREES:Number = 0.017453292519943;

    private static const RADIUS:Number = 6378137; // Using Equatorial radius: http://en.wikipedia.org/wiki/Earth_radius

    private static const SR:SpatialReference = new SpatialReference(102100);

    public static function latitudeToY(latitude:Number):Number
    {
        const rad:Number = latitude * RADIANS_PER_DEGREES;
        const sin:Number = Math.sin(rad);
        return RADIUS / 2.0 * Math.log((1.0 + sin) / (1.0 - sin));
    }

    public static function longitudeToX(longitude:Number):Number
    {
        return longitude * RADIANS_PER_DEGREES * RADIUS;
    }

    public static function projectFromGeographic(graphic:Graphic, extent:Extent):void
    {
        const polygon:Polygon = graphic.geometry as Polygon;
        if (polygon)
        {
            polygon.spatialReference = SR;
            for each (var ring:Array in polygon.rings)
            {
                for each (var mapPoint:MapPoint in ring)
                {
                    mapPoint.x = longitudeToX(mapPoint.x);
                    mapPoint.y = latitudeToY(mapPoint.y);

                    if (mapPoint.x < extent.xmin)
                    {
                        extent.xmin = mapPoint.x;
                    }
                    if (mapPoint.x > extent.xmax)
                    {
                        extent.xmax = mapPoint.x;
                    }
                    if (mapPoint.y < extent.ymin)
                    {
                        extent.ymin = mapPoint.y;
                    }
                    if (mapPoint.y > extent.ymax)
                    {
                        extent.ymax = mapPoint.y;
                    }
                }
            }
        }
    }

    public static function xToLongitude(x:Number):Number
    {
        const rad:Number = x / RADIUS;
        const deg:Number = rad * DEGREES_PER_RADIANS;
        const rot:Number = Math.floor((deg + 180) / 360);
        return deg - (rot * 360);
    }

    public static function yToLatitude(y:Number):Number
    {
        const rad:Number = PI_OVER_2 - (2.0 * Math.atan(Math.exp(-1.0 * y / RADIUS)));
        return rad * DEGREES_PER_RADIANS;
    }

    public function WebMercator()
    {
    }
}
}
