class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.io/"
  revision 7
  head "https://github.com/tats/w3m.git", branch: "master"

  stable do
    url "https://deb.debian.org/debian/pool/main/w/w3m/w3m_0.5.3.orig.tar.gz"
    sha256 "e994d263f2fd2c22febfbe45103526e00145a7674a0fda79c822b97c2770a9e3"

    # Upstream is effectively Debian https://github.com/tats/w3m at this point.
    # The patches fix a pile of CVEs
    patch do
      url "https://salsa.debian.org/debian/w3m/-/raw/debian/0.5.3-38/debian/patches/010_upstream.patch"
      sha256 "39e80b36bc5213d15a3ef015ce8df87f7fab5f157e784c7f06dc3936f28d11bc"
    end

    patch do
      url "https://salsa.debian.org/debian/w3m/-/raw/debian/0.5.3-38/debian/patches/020_debian.patch"
      sha256 "08bd013064dc544dc2e70599ea1c9e90f18998bc207dd8053188417fbdaeefb2"
    end
  end

  livecheck do
    url "https://deb.debian.org/debian/pool/main/w/w3m/"
    regex(/href=.*?w3m[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "darkbrow/repo/libsixel"
  depends_on "openssl@3"
  depends_on "gdk-pixbuf"
  depends_on "imlib2"
  depends_on "darkbrow/repo/libsixel"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gettext"
    depends_on "libbsd"
  end

  def install
    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-image",
                          "--with-imagelib=gdk-pixbuf imlib2",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
