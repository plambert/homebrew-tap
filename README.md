# Paul's Homebrew tap

Formulae for my own tools, with bottles for Apple Silicon and Intel macOS and
for x86_64 and arm64 Linux.

## Installing

```bash
brew tap plambert/tap
brew install crystal-roguelike
```

Or in one step, without tapping first:

```bash
brew install plambert/tap/crystal-roguelike
```

Or in a `Brewfile`:

```ruby
tap "plambert/tap"
brew "crystal-roguelike"
```

Homebrew asks you to trust a third-party tap before it will load anything from
it. Answer the prompt, or settle it ahead of time:

```bash
brew trust plambert/tap
```

## What is here

| Formula            | Command     | Source                                              |
| ------------------ | ----------- | --------------------------------------------------- |
| `crystal-roguelike` | `roguelike` | [crystal-roguelike.cr](https://github.com/plambert/crystal-roguelike.cr) |

## How bottles get built

`bottle.yml` runs when a formula changes on `main`. It works out which
formulae have no bottle for the current version, builds one on a runner per
platform, uploads them to a release on this repository, and commits the
resulting `bottle do` block back to `main`. That commit triggers the workflow
once more, which finds nothing to do and stops.

Bottles live as release assets here, one release per formula version, tagged
`<formula>-<version>`. The `root_url` in each formula's bottle block points at
that release.

`autobump.yml` runs daily and opens a pull request when a formula's upstream
has a newer tag. Merging it is what starts the build above.

## Documentation

`brew help`, `man brew` or [Homebrew's documentation](https://docs.brew.sh).
