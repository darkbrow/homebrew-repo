class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.10.0.tar.gz"
  sha256 "ff40068574810a7de3990f4f69c9c47ef49e37bd31d298d372e8bcdafb973fff"
  license "GPL-2.0-or-later"
  head "https://github.com/cmus/cmus.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "darkbrow/repo/ffmpeg"
  depends_on "flac"
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "opusfile"

  on_linux do
    depends_on "alsa-lib"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}",
                          "CONFIG_WAVPACK=n", "CONFIG_MPC=n"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
