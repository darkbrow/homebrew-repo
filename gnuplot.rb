class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.5/gnuplot-5.4.5.tar.gz"
  sha256 "66f679115dd30559e110498fc94d926949d4d370b4999a042e724b8e910ee478"
  license "gnuplot"

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

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

  fails_with gcc: "5"

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
      --with-qt
      --without-x
      --without-latex
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
      --with-regis
      --with-tutorial
    ]

    system "./prepare" if build.head?
    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "check" if build.head?
    system "make", "install"
    (pkgshare/"5.5").install "demo" if build.head?
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
