class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/libsixel/libsixel/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "b6654928bd423f92e6da39eb1f40f10000ae2cc6247247fc1882dcff6acbdfc8"
  license "MIT"
  head "https://github.com/libsixel/libsixel.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "gd"

  def install
    system "meson", "setup", "build", "-Dgdk-pixbuf2=disabled", "-Dtests=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    fixture = test_fixtures("test.png")
    system bin/"img2sixel", fixture
  end
end
