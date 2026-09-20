# The formula keeps the project's own name. The binary it installs is
# `roguelike`, which is what the game is called once it is on your PATH.
class CrystalRoguelike < Formula
  desc "Terminal roguelike in the spirit of Nethack"
  homepage "https://github.com/plambert/crystal-roguelike.cr"
  url "https://github.com/plambert/crystal-roguelike.cr/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "af146475b72c383a38e35b1da822880c373a6d2c710778db86b943febc52950d"
  license "MIT"
  head "https://github.com/plambert/crystal-roguelike.cr.git", branch: "main"

  # The upstream releases are tagged vX.Y.Z, so `brew bump` reads the tags
  # rather than guessing from the release assets.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/plambert/homebrew-tap/releases/download/crystal-roguelike-0.1.0"
    sha256 cellar: :any, arm64_sequoia: "1fb059ed102e4f5793db692ee0ddf5cc9304dcb56955393e8f19124a3495fa5c"
    sha256 cellar: :any, arm64_linux:   "832aea348405a3e1bfba28667bb4c0f434836ef0633625fd91ec5377b5be4359"
    sha256 cellar: :any, x86_64_linux:  "483db043f0517a853929d8d3f131bc49fe9d4338e17a1420b0b1279485314b36"
  end

  # The compiler and shards both come from the crystal formula, and are gone
  # once the build finishes. The collector and pcre2 stay: a Crystal binary
  # links both by path.
  depends_on "crystal" => :build
  depends_on "bdw-gc"
  depends_on "pcre2"

  def install
    # termbuf.cr keeps its terminal measurements in git-lfs, and shards
    # checks its dependencies out with git. git-lfs is not on the PATH
    # Homebrew builds with, so the checkout dies trying to start the filter.
    # Hiding the system and user git config takes the filter out of the
    # picture: nothing declares it, so git writes the pointer files through
    # untouched. The compiler never reads the images.
    ENV["GIT_CONFIG_SYSTEM"] = File::NULL
    ENV["GIT_CONFIG_GLOBAL"] = File::NULL

    # shard.lock pins every dependency. --frozen refuses to move off it, so
    # the bottle is built from the versions the release was tested with.
    system "shards", "install", "--production", "--frozen"

    # The version the binary reports comes from shard.yml, read at compile
    # time by a macro that shells out to shards.
    system "crystal", "build", "--release", "--no-debug", "-o", "roguelike", "src/main.cr"

    bin.install "roguelike"
  end

  test do
    assert_match "crystal-roguelike #{version}", shell_output("#{bin}/roguelike --version")
  end
end
