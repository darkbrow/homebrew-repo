class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.net/"
  url "https://git.sr.ht/~rkta/w3m/archive/v0.5.6.tar.gz"
  sha256 "8dd652cd3f31817d68c7263c34eeffb50118c80be19e1159bf8cbf763037095e"
  license "w3m"
  head "https://git.sr.ht/~rkta/w3m", branch: "master"

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  depends_on "libsixel"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--enable-image",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
