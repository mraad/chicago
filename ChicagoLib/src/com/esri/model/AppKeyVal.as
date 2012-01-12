package com.esri.model
{

public class AppKeyVal
{
    public var field:AppField;

    [Bindable]
    public var key:String;

    [Bindable]
    public var val:Object;

    public function AppKeyVal(key:String, val:Object, field:AppField = null)
    {
        this.key = key;
        this.val = val;
        this.field = field;
    }
}
}
