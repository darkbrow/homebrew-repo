class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.3.0/libqalculate-5.3.0.tar.gz"
  sha256 "61dd60b1d43ad3d2944cff9b2f45c9bc646c5a849c621133ef07231e8289e35b"
  license "GPL-2.0-or-later"

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "darkbrow/repo/gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gmp"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "gmp"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?
    ENV.cxx11
    system "./configure", "--disable-silent-rules",
                          "--without-icu",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin/"qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
