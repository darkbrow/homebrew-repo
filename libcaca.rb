class Libcaca < Formula
  desc "Convert pixel information into colored ASCII art"
  homepage "http://caca.zoy.org/wiki/libcaca"
  url "http://caca.zoy.org/raw-attachment/wiki/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/libcaca/libcaca-0.99.beta19.tar.gz"
  mirror "https://fossies.org/linux/privat/libcaca-0.99.beta19.tar.gz"
  version "0.99b19"
  sha256 "128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4"
  license "WTFPL"
  revision 3
  
  # The regex here is looser than usual because it has to match unstable
  # versions for now. If this software is updated in the future to a stable
  # version, this regex should be modified to not match unstable versions.
  livecheck do
    url :homepage
    regex(/href=.*?libcaca[._-]v?(\d+(?:\.\d+)+.*?)\.t/i)
  end

  head do
    url "https://github.com/cacalabs/libcaca.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"
  depends_on "slang"
  depends_on "imlib2"

  def install
    system "./bootstrap" if build.head?

    # Fix --destdir issue.
    #   ../.auto/py-compile: Missing argument to --destdir.
    inreplace "python/Makefile.in",
              '$(am__py_compile) --destdir "$(DESTDIR)"',
              "$(am__py_compile) --destdir \"$(cacadir)\""

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-doc
      --disable-java
      --disable-csharp
      --disable-ruby
      --disable-x11
      --enable-ncurses
      --enable-slang
    ]

    args << "--disable-cocoa" if build.head?

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or install can fail making the same folder at the same time
    system "make", "install"
  end

  test do
    system "#{bin}/img2txt", "--version"
  end
end
