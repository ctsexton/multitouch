(

var x_position = Bus.control(s, 5);
var y_position = Bus.control(s, 5);
var note_amp = Bus.control(s, 5);
var notes = Array.newClear(5);

var synthdef = SynthDef.new(\sinez, {
  |index, gate|
  var sig, env, amp;
  amp = note_amp.kr(1, index).linlin(0, 2000, 0, 1).varlag(0.05);
  env = EnvGen.kr(Env.adsr(0.05, 0.5, 0.5, 0.05, 1), gate: gate, doneAction: 2);
  sig = Saw.ar(x_position.kr(1, index).linexp(0, 230, 30, 2000).varlag(0.05)) * amp * env;
  sig = RLPF.ar(sig, y_position.kr(1, index).linexp(0, 130, 60, 2000).varlag(0.05), 0.75);
  Out.ar(0, sig!2);
});

var startStopSynths = { |id, command|
  switch (command,
    'start', { notes[id] = Synth.new(\sinez, [\index, id, \gate, 1]) },
    'end', { notes[id].set(\gate, 0) },
    {}
  )
};

var setSynthArgs = { |id, value|
  x_position.setAt(id, value);
};

var setSynthFilter = { |id, value|
  y_position.setAt(id, value);
};

var setSynthPressure = { |id, value|
  note_amp.setAt(id, value);
};

var parseOSC = { |msg, time, replyaddr, recvport|
  switch (msg[0],
    '/lifecycle/0/', { startStopSynths.value(0, msg[1]) },
    '/lifecycle/1/', { startStopSynths.value(1, msg[1]) },
    '/lifecycle/2/', { startStopSynths.value(2, msg[1]) },
    '/lifecycle/3/', { startStopSynths.value(3, msg[1]) },
    '/lifecycle/4/', { startStopSynths.value(4, msg[1]) },
    '/positions/0/x/', { setSynthArgs.value(0, msg[1]) },
    '/positions/1/x/', { setSynthArgs.value(1, msg[1]) },
    '/positions/2/x/', { setSynthArgs.value(2, msg[1]) },
    '/positions/3/x/', { setSynthArgs.value(3, msg[1]) },
    '/positions/4/x/', { setSynthArgs.value(4, msg[1]) },
    '/pressure/0/', { setSynthPressure.value(0, msg[1]) },
    '/pressure/1/', { setSynthPressure.value(1, msg[1]) },
    '/pressure/2/', { setSynthPressure.value(2, msg[1]) },
    '/pressure/3/', { setSynthPressure.value(3, msg[1]) },
    '/pressure/4/', { setSynthPressure.value(4, msg[1]) },
    '/positions/0/y/', { setSynthFilter.value(0, msg[1]) },
    '/positions/1/y/', { setSynthFilter.value(1, msg[1]) },
    '/positions/2/y/', { setSynthFilter.value(2, msg[1]) },
    '/positions/3/y/', { setSynthFilter.value(3, msg[1]) },
    '/positions/4/y/', { setSynthFilter.value(4, msg[1]) },
  )
};

var oscSetup = {
  var address;
  thisProcess.openUDPPort(5005);
  thisProcess.addOSCRecvFunc(parseOSC);
};

var start = Routine({
  synthdef.add;
  s.sync;
  oscSetup.value;
});

s.waitForBoot({start.play});
)

