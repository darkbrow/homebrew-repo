class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.10.0.tar.gz"
  sha256 "ff40068574810a7de3990f4f69c9c47ef49e37bd31d298d372e8bcdafb973fff"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/cmus/cmus.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "darkbrow/repo/ffmpeg"
  depends_on "flac"
  depends_on "libao" # See https://github.com/cmus/cmus/issues/1130
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "opusfile"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    args = [
      "prefix=#{prefix}",
      "mandir=#{man}",
      "CONFIG_WAVPACK=n",
      "CONFIG_MPC=n",
      "CONFIG_AO=y",
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    plugins = shell_output("#{bin}/cmus --plugins")
    assert_match "ao", plugins
  end
end
