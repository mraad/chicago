package com.esri.model
{

import com.esri.ags.geometry.MapPoint;
import com.esri.ags.symbols.Symbol;

public class FindOptions
{
    public var appCollection:AppCollection;
    public var queryString:String;

    public var isWithin:Boolean;

    public var withinData:int;

    public var nearData:int;
    public var mapPoint:MapPoint;
    public var distance:Number;
    public var unit:String;

    public var isAll:Boolean;
    public var fields:Array;

    public var symbol:Symbol;

    public function FindOptions()
    {
    }
}
}
