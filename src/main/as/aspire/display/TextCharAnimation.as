//
// aspire

package aspire.display {

import flash.display.Sprite;
import flash.text.TextField;

import aspire.text.TextFieldUtil;

public class TextCharAnimation extends Sprite
    implements Animation
{
    public function TextCharAnimation (text :String, fn :Function, textArgs :Object)
    {
        _fn = fn;

        var alignment :Sprite = new Sprite();

        var w :Number = 0;
        var h :Number = 0;
        var tf :TextField;
        for (var ii :int = 0; ii < text.length; ii++) {
            tf = TextFieldUtil.createField(text.charAt(ii), textArgs);

            tf.x = w;
            w += tf.width;
            h = Math.max(h, tf.height);

            alignment.addChild(tf);
            _texts.push(tf);
        }

        alignment.x = -(w/2);
        alignment.y = -(h/2);
        addChild(alignment);

        AnimationManager.addDisplayAnimation(this);
    }

    // from Animation
    public function updateAnimation (elapsed :Number) :void
    {
        for (var ii :int = 0; ii < _texts.length; ii++) {
            _texts[ii].y = _fn(elapsed, ii);
        }
    }

    protected var _texts :Array = [];

    protected var _fn :Function;
}
}
