class Libcaca < Formula
  desc "Convert pixel information into colored ASCII art"
  homepage "http://caca.zoy.org/wiki/libcaca"
  url "https://github.com/cacalabs/libcaca/releases/download/v0.99.beta20/libcaca-0.99.beta20.tar.bz2"
  mirror "https://fossies.org/linux/privat/libcaca-0.99.beta20.tar.bz2"
  version "0.99b20"
  sha256 "ff9aa641af180a59acedc7fc9e663543fb397ff758b5122093158fd628125ac1"
  license "WTFPL"

  livecheck do
    url :stable
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub(/\.?beta/, "b") }
    end
  end

  head do
    url "https://github.com/cacalabs/libcaca.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "imlib2"
  depends_on "ncurses"
  depends_on "slang"

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --disable-cocoa
      --disable-csharp
      --disable-doc
      --disable-java
      --disable-python
      --disable-ruby
      --disable-x11
      --enable-ncurses
      --enable-slang
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or install can fail making the same folder at the same time
    system "make", "install"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    assert_match "\e[0;5;34;44m", shell_output("#{bin}/img2txt test.png")
  end
end
