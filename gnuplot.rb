class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.1/gnuplot-5.4.1.tar.gz"
  sha256 "6b690485567eaeb938c26936e5e0681cf70c856d273cc2c45fabf64d8bc6590e"
  license "gnuplot"
  revision 2

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt@5"
  depends_on "readline"
  depends_on "darkbrow/repo/libcaca"

  def install
    # Qt5 requires c++11 (and the other backends do not care)
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-tutorial
      --disable-wxwidgets
      --enable-history-file
      --enable-largefile
      --enable-objects
      --enable-plugins
      --enable-raise-console
      --enable-stats
      --with-bitmap-terminals
      --with-caca=#{Formula["libcaca"].opt_prefix}
      --with-gd=#{Formula["gd"].opt_prefix}
      --with-gpic
      --with-metapost
      --with-qt
      --with-regis
      --with-tutorial
      --without-x
      --without-latex
    ]

    system "./prepare" if build.head?
    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    # system "make", "check"
    system "make", "install"
    # (pkgshare/"5.5").install "demo"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end
