
import("stdfaust.lib");
autopan(amount, rate, phase, shape) = _*gainLeft, _*gainRight
with {
    // A saturator
    // asumiendo que x es una senal con un valor entre -1 y 1. Esta funcion
    // empuja el output hacia -1 y 1. Mientras el shape
    // parameter vaya de 0 a 1, un input sinusoide se va a volver mas
    // cercano a una onda cuadrada. Si 'shape' es cero, entonces la
    // funcion no cambia su senal de entrada.
    saturator(shape, x) = result
    with {
        // esta bien reemplazar tanh con otro saturador
        result = x, ma.tanh(x*10.) : it.interpolate_linear(shape);
    };

    phase2Gain(phase) = os.oscp(rate, phase)
        : saturator(shape) // comentar esta linea para volar el saturador 
        : it.remap(-1., 1., 1.-amount, 1.);

    gainLeft = 0. : phase2Gain;
    gainRight = phase : ma.deg2rad : phase2Gain;
};

amount = hslider("[0]Amount[style:knob]", 0., 0., 1., .001);
rate = hslider("[1]Rate[style:knob][unit:Hz][scale:log]", 1., .05, 90., .001);
phase = hslider("[2]Phase[style:knob][unit:°]", 180., 0., 360., 15) : si.smoo;
shape = hslider("[3]Shape[style:knob]", 0., 0., 1., 0.001) : si.smoo;
process = hgroup("Pan-adero", autopan(amount, rate, phase, shape));