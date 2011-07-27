//
// aspirin library - Taking some of the pain out of Actionscript development.
// Copyright (C) 2007-2011 Three Rings Design, Inc., All Rights Reserved
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

package com.threerings.util {

import flash.system.Capabilities;
import flash.system.System;

/**
 * Simple implementation of assertion checks for debug environments.
 * When running in a debug player, each function will test the assert expression,
 * and if it fails, log an error message with a stack trace. When running in a
 * release player, these functions do not run any tests, and exit immediately.
 *
 * Note: stack dumping is controlled via the Assert.dumpStack parameter.
 *
 * Usage example:
 * <pre>
 *   Assert.isNotNull(mystack.top());
 *   Assert.isTrue(mystack.length == 1, "Unexpected number of items on stack!");
 * </pre>
 *
 * Deprecation notes:
 * What we really want is a way to turn off assertions at compile time. We don't
 * want folks who happen to be running a debug player to have their player exit.
 * And why wouldn't you always want an exception if something's going to go wrong?
 */
public class Assert
{
    /** Controls whether stack dumps should be included in the error log (default value is true).*/
    public static var dumpStack :Boolean = true;

    /** Asserts that the value is equal to null. */
    public static function isNull (value :Object, message :String = null) :void
    {
        if (_debug && (value != null)) {
            fail(message);
        }
    }

    /** Asserts that the value is not equal to null. */
    public static function isNotNull (value :Object, message :String = null) :void
    {
        if (_debug && (value == null)) {
            fail(message);
        }
    }

    /** Asserts that the value is false. */
    public static function isFalse (value :Boolean, message :String = null) :void
    {
        if (_debug && value) {
            fail(message);
        }
    }

    /** Asserts that the value is true. */
    public static function isTrue (value :Boolean, message :String = null) :void
    {
        if (_debug && ! value) {
            fail(message);
        }
    }

    /** Displays an error message, with an optional stack trace. */
    public static function fail (message :String) :void
    {
        _log.warning("Failure" + ((message != null) ? (": " + message) : ""));
        if (dumpStack) {
            _log.warning(new Error("dumpStack").getStackTrace());
        }

        // try to exit, but don't booch if we're running in an older player
        var o :Object = System;
        try {
            o["exit"](1); // call System.exit(1);
        } catch (err :SecurityError) {
            // probably not allowed
        }
    }

    protected static var _log :Log = Log.getLog(Assert);
    protected static var _debug :Boolean = flash.system.Capabilities.isDebugger;
}
}
