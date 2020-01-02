# Kakaia

Kakaia strives to be a personal assistant supporting voice commands without sending any data to third-parties.

## Kakaia watchOS Client

This client is still just a proof of concept. It currently makes hard-coded assumptions based on my personal development environments.

The client requires that you are also running the [Kakaia engine](https://github.com/jeremyandrews/kakaia) on your local network. It provides a simple UI for recording your voice from an Apple Watch, sending the audio file to the Kakaia engine to convert to text.

The app currently has two modes:

### Standby

The app is not recording audio, but is standing by to record audio as soon as you press the big green button.

![Kakaia watchOS app: Standby](/images/standby.png?raw=true "Standby: Kakaia client")

### Listening

The app is recording audio:

![Kakaia watchOS app: Listening](/images/listening.png?raw=true "Listening: Kakaia client")

Currently the app records continuously until you press the big red button. In the background it will then encode the audio file and push it to your local Kakaia engine.

### Notes

This is my first watchOS app. I greatly appreciate contributions!

## Roadmap

### Phase 1: Proof of Concept

Kakaia watchOS app:

- provide a simplistic UI for recording voice (done)
- send audio recording to API (done)
- wait for conversion (done)
- display text version on app screen (done)
- add configuration (currently it's hard-coded to my environment)

### Phase 2: Basic functionality

Add support for setting timers.

Kakaia watchOS app:

- parse returned JSON, set timer when the command is received
- display errors if no command was matched
- add complication for recording audio from watch-face
- submit to App Store

### Phase n: Future plans

See [Kakaia engine Readme](https://github.com/jeremyandrews/kakaia).

Contributions welcome!
