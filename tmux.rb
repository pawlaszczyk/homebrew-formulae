class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.1c/tmux-3.1c.tar.gz"
  sha256 "918f7220447bef33a1902d4faff05317afd9db4ae1c9971bef5c787ac6c88386"
  license "ISC"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+[a-z]?)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d31999d036ab81506c70b2e446a4fc62457307a610e9af51538cea0e592fd4b"
    sha256 cellar: :any,                 arm64_ventura:  "b7ca49e08f08c52f9a2c7f67dbcbd1214ca97023d1173f943d8df0a4dda66c55"
    sha256 cellar: :any,                 arm64_monterey: "666c5e8c3f01854847176459ee4fc06d3248dfda68e8249b2186777c09cab373"
    sha256 cellar: :any,                 sonoma:         "98aa66f907f2e279295bb6691302388264f6fc141128703ce4bfd315531815d2"
    sha256 cellar: :any,                 ventura:        "48d595e1d25c23f2376ba436b3a89913f9babbd0d715f4029d9eff7174923215"
    sha256 cellar: :any,                 monterey:       "327dd3eac9c6a481c5f7e578f815d6b3f3d912c33e47c4e15dd5ccce85a2bd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240f267390c10b75634da1be1bf04e0878819ef79d6d79fb52a4507adb47908b"
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    uses_from_macos "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"

  # Old versions of macOS libc disagree with utf8proc character widths.
  # https://github.com/tmux/tmux/issues/2223
  depends_on "utf8proc" if MacOS.version >= :high_sierra

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/f5d53239f7658f8e8fbaf02535cc369009c436d6/completions/tmux"
    sha256 "b5f7bbd78f9790026bbff16fc6e3fe4070d067f58f943e156bd1a8c3c99f6a6f"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    args << "--enable-utf8proc" if MacOS.version >= :high_sierra

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
