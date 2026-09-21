# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

When preparing a release, write the notes for the new version under a
`## [x.y.z]` heading that matches the version in `pubspec.yaml`, then tag the
commit `vx.y.z` and paste that section in the GitHub release.

Releases prior to 1.2.0 are listed on the
[GitHub releases page](https://github.com/nogringo/couleur/releases).

## [1.2.1]

### Added

- Chat without an account. A key is created on arrival, so rooms can be read
  and written to right away, and logging in with your own key takes over from
  it.
- Show the NIP-05 address of a profile under its name, with a verified mark
  next to the name.
- Open the login and the profile screens from their own address, `/login` and
  `/profile`, which makes them reachable as links on the web.

### Changed

- Group the settings of the profile screen into segmented lists: the theme
  mode, the proof of work filter, the client tag, and the links to the source
  code and to support.
- Give the name of each author its own color, derived from their public key,
  instead of the same accent color for everyone.
- Show the name of an account without a profile as its `Anon#uid` handle on the
  profile screen, as it already reads in the chat, instead of an npub.
- Verify the signature of every event the app receives, which it used to skip.
- Keep the cache of relay data in a local database instead of memory, on every
  platform including the web.

### Fixed

- Show a message as soon as it arrives, instead of waiting for the profile of
  its author to load. The name appears on its own once the profile is there.
- Send a message without waiting for your own profile. The name carried in the
  `n` tag is dropped if the profile takes longer than 300 ms to load.

## [1.2.0]

### Added

- List the rooms of the sidebar under Starred and Popular. Popular holds the
  rooms carrying at least two messages from two people in the last five
  minutes, the busiest first.
- Filter messages by proof of work, with a difficulty slider in the profile.
  Messages below the chosen difficulty are hidden, and your own messages are
  mined to meet it before they are sent.
- Tell others which app you write from with the "Let others know I use Couleur"
  switch, and read where a message comes from under it when its author does the
  same.
- Send a message with the button next to the message field, in place of the
  Enter key alone.
- Translate the new screens and settings into English, Spanish, French,
  Japanese, Russian and Chinese.

### Changed

- Carry your display name in the `n` tag of each message, so the apps that read
  that tag show your name instead of an anonymous handle.

### Fixed

- Join a room by pressing Enter in the add room dialog, instead of only through
  its button.
- Show the name of an author from their profile when they have one, and fall
  back to the name carried in the message only without a profile.
