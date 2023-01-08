# 🎥 Flutter WebRTC Wrapper

## ⚡ Best and easy way to INTEGRATE WebRTC with Flutter ⚡

Main features of `flutter_webrtc_wrapper` : 

1. `Simple and easy to Connect Flutter with WebRTC`
2. `Plug and Play🚀`
3. `Event Handlers🚀`
4. `In built Methods for Meeting App🚀`

Tutorial based on `flutter_webrtc_wrapper` plugin: 

`Flutter WebRTC Video Calling Meeting App - Part1` : https://youtu.be/FZDCRza5UDQ

`Flutter WebRTC Video Calling Meeting App - Part2` : https://youtu.be/Jr2-pN7UPsg

## 🎖 Installing

```yaml
dependencies:
  flutter_webrtc_wrapper: ^<latest_version>
```

## Usage

## ⚡ Create instance of WebRTCMeetingHelper

```
WebRTCMeetingHelper webRTCMeetingHelper = WebRTCMeetingHelper(
    url: "SOCKET_API_URL",
    meetingId: meetingId,
    userId: userId,
    name: userName,
);

```

## ⚡ Set local Stream

```
MediaStream _localstream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

_localRenderer.srcObject = _localstream;

webRTCMeetingHelper!.stream = _localstream;

```
    
## ⚡ Events

```
webRTCMeetingHelper!.on('open', null, (ev, context) {
   
});

webRTCMeetingHelper!.on('connection', null, (ev, context) {

});

webRTCMeetingHelper!.on('user-left', null, (ev, ctx) {

});

webRTCMeetingHelper!.on('video-toggle', null, (ev, ctx) {
   
});

webRTCMeetingHelper!.on('audio-toggle', null, (ev, ctx) {
  
});

webRTCMeetingHelper!.on('meeting-ended', null, (ev, ctx) {
  
});

webRTCMeetingHelper!.on('connection-setting-changed', null, (ev, ctx) {
  
});

webRTCMeetingHelper!.on('stream-changed', null, (ev, ctx) {

});

```

## ⚡ Methods

1. `toggleAudio` Used for toggeling Audio on/off.

```
webRTCMeetingHelper!.toggleAudio();

```
 
2. `toggleVideo` Used for toggeling Video on/off.

```
webRTCMeetingHelper!.toggleVideo();

```

3. `endMeeting` Used for Ending Meeting.

```
webRTCMeetingHelper!.endMeeting();

```

4. `reconnect` Used for Reconnecting Meeting.

```
WebRTCMeetingHelper!.reconnect();

```

5. `destroy` Used for End/Destory Meeting Helper object.

```
webRTCMeetingHelper!.destroy();

```
-----------------------------------------------------------------------------
## ⚡ Donate

> If you like my work, you can support me buying a cup of :coffee:
>
> - [PayPal](https://www.paypal.me/iSharpeners/)
> - [Patreon](https://www.patreon.com/SnippetCoder)

## Copyright & License

Code and documentation Copyright 2022 [SnippetCoder](https://www.youtube.com/SnippetCoder). Code released under the [Apache License](./LICENSE). Docs released under [Creative Commons](https://creativecommons.org/licenses/by/3.0/).