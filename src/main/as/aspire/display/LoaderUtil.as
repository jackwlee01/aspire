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

package aspire.display {

import flash.display.Loader;

/**
 * Contains a utility method for safely unloading a Loader.
 */
public class LoaderUtil
{
    /**
     * Safely unload the specified loader.
     */
    public static function unload (loader :Loader) :void
    {
        try {
            loader.close();
        } catch (e1 :Error) {
            // ignore
        }
        try {
            //loader.unloadAndStop();
            // always try calling it, so that if it's missing we can fall back
            loader["unloadAndStop"]();
        } catch (e2 :Error) {
            // hmm, maybe they are using FP9 still
            try {
                loader.unload();
            } catch (e3 :Error) {
                // ignore
            }
        }
    }
}
}
