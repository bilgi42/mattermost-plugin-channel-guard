# Channel Guard Plugin

Use this plugin to make channels read-only to some and writeable to other users. Channel Admins, Team Admins, bots, and system messages are all allowed to post.

## Installation

1. Download or build the plugin `.tar.gz` bundle (see [Building](#building) below).
2. Go to **System Console > Plugins > Management** and upload the bundle.
3. Click **Enable** to enable the Channel Guard plugin.

## Configuration

1. Go to **System Console > Plugins > Channel-Guard**.
2. In the **Guards Configuration (JSON)** field, enter a JSON array of guards:

```json
[
  {
    "TeamName": "my-team",
    "ChannelName": "announcements",
    "Allowed": ["user1", "user2"]
  },
  {
    "TeamName": "my-team",
    "ChannelName": "releases",
    "Allowed": ["releasebot"]
  }
]
```

3. Click **Save**.

### Guard Fields

- **TeamName**: The team's URL slug (lowercase). For example, in `https://example.com/my-team/channels/my-channel` the TeamName is `my-team`.
- **ChannelName**: The channel's URL slug (lowercase). For example, in `https://example.com/my-team/channels/my-channel` the ChannelName is `my-channel`.
- **Allowed**: List of Mattermost usernames that are allowed to post in the guarded channel.

### Who Can Always Post

The following users bypass guards and can always post:

- System Admins
- Team Admins
- Channel Admins
- Bots
- System messages

## Building

Requires Go and Make.

```bash
make dist
```

The plugin bundle will be output to `dist/com.mattermost.channel-guard-<version>.tar.gz`.

### NixOS / Nix Flake

```bash
nix build
```

The bundle will be at `result/com.mattermost.channel-guard-<version>.tar.gz`.

A dev shell with Go and Make is also available:

```bash
nix develop
```

## License

Apache License 2.0. See [LICENSE](LICENSE) for details.
