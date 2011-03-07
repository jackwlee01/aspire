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

package com.threerings.text {

import flash.events.Event;

import flash.text.TextField;

import flash.utils.getTimer; // function import

public class FPSDisplay extends TextField
{
    public function FPSDisplay (framesToTrack :int = 150)
    {
        background = true;
        text = "fps: 000.00";
        width = textWidth + 5;
        height = textHeight + 4;

        _framesToTrack = framesToTrack;

        addEventListener(Event.ENTER_FRAME, handleEnterFrame);
    }

    protected function handleEnterFrame (event :Event) :void
    {
        var curStamp :Number = getTimer();
        _frameStamps.push(curStamp);
        if (_frameStamps.length > _framesToTrack) {
            _frameStamps.shift(); // forget the oldest timestamps
        }

        var firstStamp :Number = Number(_frameStamps[0]);
        var seconds :Number = (curStamp - firstStamp) / 1000;
        // subtract one from the frames, since we're measuring the time
        // elapsed over the frames (when there are two timestamps, that's
        // the difference between 1 frame)
        var frames :Number = _frameStamps.length - 1;

        this.text = "fps: " + (frames / seconds).toFixed(2);
    }

    /** Timestamps of past ENTER_FRAME events. */
    protected var _frameStamps :Array = [];

    /** The number of running frames we track. */
    protected var _framesToTrack :int;
}
}
