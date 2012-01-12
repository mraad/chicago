package com.esri.model
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

import mx.events.PropertyChangeEvent;

use namespace flash_proxy;

[Bindable(event=PropertyChangeEvent.PROPERTY_CHANGE)]
public dynamic class Attributes extends Proxy implements IEventDispatcher
{
    private var m_eventDispatcher:EventDispatcher;

    private var m_object:Object = {};

    public function Attributes()
    {
        m_eventDispatcher = new EventDispatcher(this);
    }

    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        m_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public function dispatchEvent(evt:Event):Boolean
    {
        return m_eventDispatcher.dispatchEvent(evt);
    }

    public function hasEventListener(type:String):Boolean
    {
        return m_eventDispatcher.hasEventListener(type);
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {

        m_eventDispatcher.removeEventListener(type, listener, useCapture);
    }

    public function willTrigger(type:String):Boolean
    {
        return m_eventDispatcher.willTrigger(type);
    }

    flash_proxy override function callProperty(name:*, ... rest):*
    {
        return m_object[name].apply(m_object, rest)
    }

    flash_proxy override function getProperty(name:*):*
    {
        return m_object[name];
    }

    flash_proxy override function setProperty(name:*, newVal:*):void
    {
        var oldVal:* = m_object[name];
        if (oldVal !== newVal)
        {
            m_object[name] = newVal;

            if (m_eventDispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
                if (name is QName)
                {
                    name = QName(name).localName;
                }
                const event:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, name.toString(), oldVal, newVal);
                m_eventDispatcher.dispatchEvent(event);
            }
        }
    }
}
}
