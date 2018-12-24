(
var x_position = Bus.control(s, 16);
var y_position = Bus.control(s, 16);
var note_amp = Bus.control(s, 16);
var notes = Array.newClear(16);
var output = Bus.audio(s, 1);

var out = SynthDef.new(\out, {
  |input, outBus|
  var sig;
  sig = In.ar(input, 1);
  sig = FreeVerb.ar(sig, 0.2, 0.5);
  Out.ar(outBus, sig!2);
});

var synthdef = SynthDef.new(\sinez, {
  |index, gate|
  var sig, env, amp, freq;
  freq = x_position.kr(1, index).linexp(0, 230, 35, 2000).varlag(0.005);
  amp = note_amp.kr(1, index).lincurve(0, 2000, 0, 1, 1.5).varlag(0.005);
  env = EnvGen.kr(Env.adsr(0.05, 0.5, 0.5, 0.05, 1), gate: gate, doneAction: 2);
  sig = Saw.ar(freq) * amp * env * 1.5;
  sig = RLPF.ar(sig, freq * y_position.kr(1, index).linlin(0, 130, 1, 10).varlag(0.005), 0.75);
  Out.ar(output, sig);
});

var startStopSynths = { |id, command|
  switch (command,
    'start', { notes[id] = Synth.new(\sinez, [\index, id, \gate, 1]) },
    'end', { notes[id].set(\gate, 0) },
    {}
  )
};

var setSynthFreq = { |id, value|
  x_position.setAt(id, value);
};

var setSynthFilter = { |id, value|
  y_position.setAt(id, value);
};

var setSynthPressure = { |id, value|
  note_amp.setAt(id, value);
};

var oscSetup = {
  var address;
  thisProcess.openUDPPort(5005);
  OSCFunc.new({ |msg| startStopSynths.value(msg[1], msg[2]) }, '/lifecycle');
  OSCFunc.new({ |msg| setSynthFreq.value(msg[1], msg[2]) }, '/x_position');
  OSCFunc.new({ |msg| setSynthFilter.value(msg[1], msg[2]) }, '/y_position');
  OSCFunc.new({ |msg| setSynthPressure.value(msg[1], msg[2]) }, '/pressure');
};

var start = Routine({
  out.add;
  synthdef.add;
  s.sync;
  Synth.new(\out, [\input, output, \outBus, 0]);
  oscSetup.value;
});

s.waitForBoot({start.play});
)
