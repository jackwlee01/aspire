//
// aspirin library - Taking some of the pain out of Actionscript development.
// Copyright (C) 2007-2012 Three Rings Design, Inc., All Rights Reserved
// http://github.com/threerings/aspirin
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

package aspire.util {

import flash.events.EventDispatcher;
import flash.events.NetStatusEvent;
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;

/**
 * Dispatched when this Config object has a value set on it.
 *
 * @eventType com.threerings.util.Config.CONFIG_VALUE_SET
 */
[Event(name="ConfigValSet", type="aspire.util.NamedValueEvent")]

public class Config extends EventDispatcher
{
    /** The event type dispatched when a config value changes.
     *
     * @eventType ConfigValSet
     */
    public static const CONFIG_VALUE_SET :String = "ConfigValSet";

    /**
     * Constructs a new config object which will obtain configuration
     * information from the specified path.
     */
    public function Config (path :String)
    {
        setPath(path);
    }

    /**
     * Set the path, if null then we aren't persisting settings.
     */
    public function setPath (path :String) :void
    {
        _so = (path == null) ? null : SharedObject.getLocal("config_" + path, "/");
        _data = (_so == null) ? {} : _so.data;

        // dispatch events for all settings
        for (var n :String in _data) {
            dispatchEvent(new NamedValueEvent(CONFIG_VALUE_SET, n, _data[n]));
        }
    }

    /**
     * Are we persisting settings?
     */
    public function isPersisting () :Boolean
    {
        return (_so != null);
    }

    /**
     * Fetches and returns the value for the specified configuration property.
     */
    public function getValue (name :String, defValue :Object) :Object
    {
        var val :* = _data[name];
        return (val === undefined) ? defValue : val;
    }

    /**
     * Returns the value specified.
     */
    public function setValue (name :String, value :Object, flush :Boolean = true) :void
    {
        _data[name] = value;
        if (flush && _so != null) {
            _so.flush(); // flushing is not strictly necessary
        }

        // dispatch an event corresponding
        dispatchEvent(new NamedValueEvent(CONFIG_VALUE_SET, name, value));
    }

    /**
     * Gets all the property names.
     */
    public function getPropertyNames () :Array
    {
        return Util.keys(_data);
    }

    /**
     * Remove any set value for the specified preference.
     * This does not dispatch an event because this would only be done to remove an
     * obsolete preference.
     */
    public function remove (name :String) :void
    {
        delete _data[name];
        if (_so != null) {
            _so.flush(); // flushing is not strictly necessary
        }
    }

    /**
     * Ensure that we can store preferences up to the specified size. Note that calling this method
     * may pop up a dialog to the user, asking them if it's ok to increase the capacity. The result
     * listener may never be called if the user doesn't answer the pop-up.
     *
     * @param onFailure a function that will be passed an exception on failure.
     * @param onSuccess an optional function that will be passed <code>this</code> on success.
     */
    public function ensureCapacity (
        kilobytes :int, onFailure :Function, onSuccess :Function = null) :void
    {
        if (_so == null) {
            if (onSuccess != null) {
                onSuccess(this);
            }
            return;
        }

        // flush with the size, see if we're cool
        var result :String = _so.flush(1024 * kilobytes);
        if (onSuccess == null) {
            return;
        }

        // success
        if (result == SharedObjectFlushStatus.FLUSHED) {
            onSuccess(this);
            return;
        }

        // otherwise we'll hear back in a sec
        var thisConfig :Config = this;
        var listener :Function = function (evt :NetStatusEvent) :void {
            // TODO: There is a bug where the status is always
            // "SharedObject.Flush.Failed", even on success, if the request
            // was for a large enough storage that the player calls it
            // "unlimited".
            trace("================[" + evt.info.code + "]");
            if ("SharedObject.Flush.Success" == evt.info.code) {
                onSuccess(thisConfig);
            } else {
                onFailure(new Error(String(evt.info.code)));
            }
            _so.removeEventListener(NetStatusEvent.NET_STATUS, listener);
        };
        _so.addEventListener(NetStatusEvent.NET_STATUS, listener);
    }

    /** The shared object that contains our preferences. */
    protected var _so :SharedObject;

    /** The object in which we store things, usually _so.data. */
    protected var _data :Object;
}
}
