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

import flash.geom.Matrix;

public class MatrixUtil
{
    public static function scaleX (m :Matrix) :Number
    {
        return Math.sqrt(m.a * m.a + m.b * m.b);
    }

    public static function setScaleX (m :Matrix, scaleX :Number) :void
    {
        var cur :Number = MatrixUtil.scaleX(m);
        if (cur != 0) {
            var scale :Number = scaleX / cur;
            m.a *= scale;
            m.b *= scale;
        } else {
            var skewY :Number = skewY(m);
            m.a = Math.cos(skewY) * scaleX;
            m.b = Math.sin(skewY) * scaleX;
        }
    }

    public static function scaleY (m :Matrix) :Number
    {
        return Math.sqrt(m.c * m.c + m.d * m.d);
    }

    public static function setScaleY (m :Matrix, scaleY :Number) :void
    {
        var cur :Number = MatrixUtil.scaleY(m);
        if (cur != 0) {
            var scale :Number = scaleY / cur;
            m.c *= scale;
            m.d *= scale;
        } else {
            var skewX :Number = skewX(m);
            m.c = -Math.sin(skewX) * scaleY;
            m.d = Math.cos(skewX) * scaleY;
        }
    }

    public static function skewX (m :Matrix) :Number
    {
        return Math.atan2(-m.c, m.d);
    }

    public static function setSkewX (m :Matrix, skewX :Number) :void
    {
        var scaleY :Number = MatrixUtil.scaleY(m);
        m.c = -scaleY * Math.sin(skewX);
        m.d = scaleY * Math.cos(skewX);
    }

    public static function skewY (m :Matrix) :Number
    {
        return Math.atan2(m.b, m.a);
    }

    public static function setSkewY (m :Matrix, skewY :Number) :void
    {
        var scaleX :Number = MatrixUtil.scaleX(m);
        m.a = scaleX * Math.cos(skewY);
        m.b = scaleX * Math.sin(skewY);
    }

    public static function rotation (m :Matrix) :Number
    {
        return skewY(m);
    }

    public static function setRotation (m :Matrix, rotation :Number) :void
    {
        var curRotation :Number = MatrixUtil.rotation(m);
        var curSkewX :Number = MatrixUtil.skewX(m);
        MatrixUtil.setSkewX(m, curSkewX + rotation - curRotation);
        MatrixUtil.setSkewY(m, rotation);
    }

    public static function prepend (m :Matrix, transform :Matrix) :void
    {
        var tmp :Matrix = transform.clone();
        tmp.concat(m);
        m.copyFrom(tmp);
    }
}
}
