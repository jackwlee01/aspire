//
// aspire

package aspire.util {

import flash.display.DisplayObject;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

/**
 * A utility for loading parameters from an XML file when run from
 * the local filesystem.
 *
 * The file "parameters.xml" should reside in the current directory and contains:
 *  <parameters>
 *      <param name="name1" value="val1"/>
 *      <param name="name2" value="val2"/>
 *  </parameters>
 */
public class ParameterUtil
{
    /**
     * Get the parameters.
     * Note: the callback function may be called prior to this method
     * returning.
     */
    public static function getParameters (disp :DisplayObject, callback :Function) :void
    {
        return getInfoParameters(disp.root.loaderInfo, callback);
    }

    /**
     * Get the parameters.
     * Note: the callback function may be called prior to this method
     * returning.
     */
    public static function getInfoParameters (loaderInfo :LoaderInfo, callback :Function) :void
    {
        var url :String = loaderInfo.url;

        // ensure that it's initialized...
        if (url == null) {
            // Create a function to wait until the loaded object is initialized
            var initWaiter :Function = function (event :Event) :void {
                loaderInfo.removeEventListener(Event.INIT, initWaiter);
                if (loaderInfo.url != null) {
                    // re-call
                    getInfoParameters(loaderInfo, callback);

                } else {
                    // url is still null, don't infinite loop
                    logWarning("Unable to determine url, bailing");
                    callback(loaderInfo.parameters);
                }
            }; // end- initWaiter function

            // and wait.
            loaderInfo.addEventListener(Event.INIT, initWaiter);
            return;
        }

        // Simply use the parameters in the loaderInfo if we were not
        // loaded from a file.
        if (0 != url.indexOf("file:")) {
            callback(loaderInfo.parameters);
            return;
        }
        // else, let's try loading parameters.xml

        var dex :int = url.lastIndexOf("/");
        var paramUrl :String;
        if (dex == -1) {
            paramUrl = "file:";
        } else {
            paramUrl = url.substring(0, dex + 1);
        }
        paramUrl += "parameters.xml";
        Log.getLog(ParameterUtil).info("Trying to load parameters from " + paramUrl);

        var loader :URLLoader = new URLLoader();
        loader.addEventListener(IOErrorEvent.IO_ERROR,
            function (event :Event) :void {
                logWarning("Error loading params: " + event);
                callback(loaderInfo.parameters);
            }
        );
        loader.addEventListener(Event.COMPLETE,
            function (event :Event) :void  {
                var data :XML = XmlUtil.newXML(loader.data);
                var params :Object = {};
                for each (var param :XML in data..param) {
                    params[param.@name] = String(param.@value);
                }
                callback(params);
            }
        );
        loader.load(new URLRequest(paramUrl));
    }

    /**
     * Convenience function to log a warning, since we don't keep around
     * a Log instance.
     */
    protected static function logWarning (msg :String) :void
    {
        Log.getLog(ParameterUtil).warning(msg);
    }
}
}
