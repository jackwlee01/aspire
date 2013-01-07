//
// aspire

package aspire.geom {

import flash.geom.Point;

import aspire.util.Equalable;
import aspire.util.Preconditions;
import aspire.util.StringUtil;
import aspire.util.XmlUtil;

/**
 * Basic 2D vector implementation.
 */
public class Vector2
    implements Equalable
{
    public var x :Number = 0;
    public var y :Number = 0;

    /**
     * Infinite vector - often the result of normalizing a zero vector.
     */
    public static const INFINITE :Vector2 = new Vector2(Infinity, Infinity);

    /**
     * Converts Point p to a Vector2.
     */
    public static function fromPoint (p :Point) :Vector2
    {
        return new Vector2(p.x, p.y);
    }

    /**
     * Creates a new Vector2 pointing from s to t.
     */
    public static function fromPoints (s :Point, t :Point) :Vector2
    {
        return new Vector2(t.x - s.x, t.y - s.y);
    }

    /**
     * Creates a Vector2 of magnitude 'len' that has been rotated about the origin by 'radians'.
     */
    public static function fromAngle (radians :Number, len :Number = 1) :Vector2
    {
       // we use the unit vector (1, 0)

        return new Vector2(
            Math.cos(radians) * len,   // == len * (cos(theta)*x - sin(theta)*y)
            Math.sin(radians) * len);  // == len * (sin(theta)*x + cos(theta)*y)
    }

    /**
     * Creates a Vector2 from attributes on <code>xml</code>.
     */
    public static function fromXml (xml :XML, xAttrName :String="x", yAttrName :String="y",
        defaultValue :Vector2 = null) :Vector2
    {
        var x :Number = XmlUtil.getNumberAttr(xml, xAttrName,
            (defaultValue != null ? defaultValue.x : undefined));
        var y :Number = XmlUtil.getNumberAttr(xml, yAttrName,
            (defaultValue != null ? defaultValue.y : undefined));
        return new Vector2(x, y);
    }

    /**
     * Parses a string in the form "x,y" into a Vector2
     */
    public static function fromString (str :String) :Vector2
    {
        var parts :Array = str.split(",");
        Preconditions.checkState(parts.length == 2, "Bad format (should look like \"x,y\")");
        return new Vector2(StringUtil.parseNumber(parts[0]), StringUtil.parseNumber(parts[1]));
    }

    /**
     * Returns a new vector that is the linear interpolation of vectors a and b
     * at proportion p, where p is in [0, 1], p = 0 means the result is equal to a,
     * and p = 1 means the result is equal to b.
     */
    public static function interpolate (a :Vector2, b :Vector2, p :Number) :Vector2
    {
        // todo: maybe convert this into a non-static function, to fit the rest of the class?
        var q :Number = 1 - p;
        return new Vector2(q * a.x + p * b.x,
            q * a.y + p * b.y);
    }

    /**
     * Returns the smaller of the two angles between v1 and v2, in radians.
     * Result will be in range [0, pi].
     */
    public static function smallerAngleBetween (v1 :Vector2, v2 :Vector2) :Number
    {
        // v1 dot v2 == |v1||v2|cos(theta)
        // theta = acos ((v1 dot v2) / (|v1||v2|))

        var dot :Number = v1.dot(v2);
        var len1 :Number = v1.length;
        var len2 :Number = v2.length;

        return Math.acos(dot / (len1 * len2));
    }

    /**
     * Constructs a Vector2 from the given values.
     */
    public function Vector2 (x :Number = 0, y :Number = 0)
    {
        this.x = x;
        this.y = y;
    }

    /**
     * Sets the vector's components to the given values.
     */
    public function set (x :Number, y :Number) :void
    {
        this.x = x;
        this.y = y;
    }

    /**
     * Returns the dot product of this vector with vector v.
     */
    public function dot (v :Vector2) :Number
    {
        return x * v.x + y * v.y;
    }

    /**
     * Converts the Vector2 to a Point.
     */
    public function toPoint () :Point
    {
        return new Point(x, y);
    }

    /** Converts the Vector2 to a PointI. */
    public function toPointI () :PointI
    {
        return new PointI(x, y);
    }

    /**
     * Returns a copy of this Vector2.
     */
    public function clone () :Vector2
    {
        return new Vector2(x, y);
    }

    /**
     * Returns the angle represented by this Vector2, in radians.
     */
    public function get angle () :Number
    {
        var angle :Number = Math.atan2(y, x);
        return (angle >= 0 ? angle : angle + (2 * Math.PI));
    }

    /**
     * Returns this vector's length.
     */
    public function get length () :Number
    {
        return Math.sqrt(x * x + y * y);
    }

    /**
     * Sets this vector's length.
     */
    public function set length (newLen :Number) :void
    {
        var scale :Number = newLen / this.length;

        x *= scale;
        y *= scale;
    }

    /**
     * Returns the square of this vector's length.
     */
    public function get lengthSquared () :Number
    {
        return (x * x + y * y);
    }

    /**
     * Rotates the vector in place by 'radians'.
     * Returns a reference to 'this', for chaining.
     */
    public function rotateLocal (radians :Number) :Vector2
    {
        var cosTheta :Number = Math.cos(radians);
        var sinTheta :Number = Math.sin(radians);

        var oldX :Number = x;
        x = (cosTheta * oldX) - (sinTheta * y);
        y = (sinTheta * oldX) + (cosTheta * y);

        return this;
    }

    /**
     * Returns a rotated copy of this vector.
     */
    public function rotate (radians :Number) :Vector2
    {
        return clone().rotateLocal(radians);
    }

    /**
     * Normalizes the vector in place and returns its original length.
     */
    public function normalizeLocalAndGetLength () :Number
    {
        var length :Number = this.length;

        x /= length;
        y /= length;

        return length;
    }

    /**
     * Normalizes this vector in place.
     * Returns a reference to 'this', for chaining.
     */
    public function normalizeLocal () :Vector2
    {
        var lengthInverse :Number = 1 / this.length;

        x *= lengthInverse;
        y *= lengthInverse;

        return this;
    }

    /**
     * Returns a normalized copy of the vector.
     */
    public function normalize () :Vector2
    {
        return clone().normalizeLocal();
    }

    /**
     * Adds another Vector2 to this, in place.
     * Returns a reference to 'this', for chaining.
     */
    public function addLocal (v :Vector2) :Vector2
    {
        x += v.x;
        y += v.y;

        return this;
    }

    /**
     * Returns a copy of this vector added to 'v'.
     */
    public function add (v :Vector2) :Vector2
    {
        return clone().addLocal(v);
    }

    /**
     * Subtracts another vector from this one, in place.
     * Returns a reference to 'this', for chaining.
     */
    public function subtractLocal (v :Vector2) :Vector2
    {
        x -= v.x;
        y -= v.y;

        return this;
    }

    /**
     * Returns (this - v).
     */
    public function subtract (v :Vector2) :Vector2
    {
       return clone().subtractLocal(v);
    }

    /**
     * Offsets this Vector2's values by the specified amounts.
     * Returns a reference to 'this', for chaining.
     */
    public function offsetLocal (xOffset :Number, yOffset :Number) :Vector2
    {
        x += xOffset;
        y += yOffset;
        return this;
    }

    /**
     * Returns a copy of this Vector2, offset by the specified amount.
     */
    public function offset (xOffset :Number, yOffset :Number) :Vector2
    {
        return clone().offsetLocal(xOffset, yOffset);
    }

    /**
     * Returns a vector that is perpendicular to this one.
     * If ccw = true, the perpendicular vector is rotated 90 degrees counter-clockwise from this
     * vector, otherwise it's rotated 90 degrees clockwise.
     */
    public function getPerp (ccw :Boolean = true) :Vector2
    {
        if (ccw) {
            return new Vector2(-y, x);
        } else {
            return new Vector2(y, -x);
        }
    }

    /**
     * Scales this vector by value.
     */
    public function scaleLocal (value :Number) :Vector2
    {
        x *= value;
        y *= value;

        return this;
    }

    /** Returns (this * value). */
    public function scale (value :Number) :Vector2
    {
        return clone().scaleLocal(value);
    }

    /**
     * Multiplies this vector's components by the given vector's components.
     */
    public function multLocal (v :Vector2) :Vector2
    {
        x *= v.x;
        y *= v.y;
        return this;
    }

    /**
     * Returns a copy of this vector, multiplied by the given vector's components.
     */
    public function mult (v :Vector2) :Vector2
    {
        return clone().multLocal(v);
    }

    /**
     * Inverts the vector.
     */
    public function invertLocal () :Vector2
    {
        x = -x;
        y = -y;

        return this;
    }

    /**
     * Returns a copy of the vector, inverted.
     */
    public function invert () :Vector2
    {
       return clone().invertLocal();
    }

    /**
     * Returns true if this vector is equal to v.
     */
    public function equals (obj :Object) :Boolean
    {
        var v :Vector2 = obj as Vector2;
        return (v != null && x == v.x && y == v.y);
    }

    /**
     * Returns true if the components of v are equal to the components of this Vector2,
     * within the given epsilon.
     */
    public function similar (v :Vector2, epsilon :Number) :Boolean
    {
        return ((Math.abs(x - v.x) <= epsilon) && (Math.abs(y - v.y) <= epsilon));
    }

    /** Returns a string representation of the Vector2. */
    public function toString () :String
    {
        return "" + x + "," + y;
    }
}

}
