//
// $Id$
//
// aspirin library - Taking some of the pain out of Actionscript development.
// Copyright (C) 2007-2010 Three Rings Design, Inc., All Rights Reserved
// http://code.google.com/p/ooo-aspirin/
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

package com.threerings.media {

import flash.events.IEventDispatcher;

import com.threerings.util.ValueEvent;

/**
 * Dispatched when the state of the mediaplayer changes, usually in response to commands
 * such as play/pause, etc.
 * <b>value</b>: an int state. @see MediaPlayerCodes
 *
 * @eventType com.threerings.flash.media.MediaPlayerCodes.STATE
 */
[Event(name="state", type="com.threerings.util.ValueEvent")]

/**
 * Dispatched when the total duration of the media is known.
 * <b>value</b>: a Number expressing the duration in seconds.
 *
 * @eventType com.threerings.flash.media.MediaPlayerCodes.DURATION
 */
[Event(name="duration", type="com.threerings.util.ValueEvent")]

/**
 * Dispatched periodically as the position is updated, during playback.
 * <b>value</b>: a Number expressing the position in seconds.
 *
 * @eventType com.threerings.flash.media.MediaPlayerCodes.POSITION
 */
[Event(name="position", type="com.threerings.util.ValueEvent")]

/**
 * Dispatched when media metadata is available, if ever.
 * <b>value</b>: metadata object. @see getMetadata() for more info.
 *
 * @eventType com.threerings.flash.media.MediaPlayerCodes.METADATA
 */
[Event(name="metadata", type="com.threerings.util.ValueEvent")]

/**
 * Dispatched when there's a problem.
 * <b>value</b>: a String error code/message.
 *
 * @eventType com.threerings.flash.media.MediaPlayerCodes.ERROR
 */
[Event(name="error", type="com.threerings.util.ValueEvent")]

/**
 * Implemented by media-playing backends.
 */
public interface MediaPlayer extends IEventDispatcher
{
    /**
     * @return a MediaPlayerCodes state constant.
     */
    function getState () :int;

    /**
     * Play the media, if not already.
     */
    function play () :void;

    /**
     * Pause the media, if not already.
     */
    function pause () :void;

    /**
     * Get the duration of the media, in seconds, or NaN if not yet known.
     */
    function getDuration () :Number;

    /**
     * Get the position of the media, in seconds, or NaN if not yet ready.
     */
    function getPosition () :Number;

    /**
     * Seek to the specified position.
     */
    function seek (position :Number) :void;

    /**
     * Set the volume, between 0-1.
     */
    function setVolume (volume :Number) :void;

    /**
     * Get the volume, from 0 to 1.
     */
    function getVolume () :Number;

    /**
     * Get metadata, or null if none or not yet available. The exact format of this data
     * object varies by MediaPlayer implementation, see the documentation for each.
     */
    function getMetadata () :Object;

    /**
     * Unload the media.
     */
    function unload () :void;
}
}
