class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.2/gnuplot-6.0.2.tar.gz"
  sha256 "f68a3b0bbb7bbbb437649674106d94522c00bf2f285cce0c19c3180b1ee7e738"
  license "gnuplot"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "show test"
  option "with-demo", "install demo script files"

  depends_on "gnu-sed" => :build # https://sourceforge.net/p/gnuplot/bugs/2676/
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gd"
  depends_on "glib"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt"
  depends_on "readline"
  depends_on "webp"

  depends_on "darkbrow/repo/libcaca"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end
  
  fails_with gcc: "5"

  def install
    args = %W[
      --disable-silent-rules
      --with-readline=#{Formula["readline"].opt_prefix}
      --disable-wxwidgets
      --with-qt
      --without-x
      --without-latex
      LRELEASE=#{Formula["qt"].bin}/lrelease
      MOC=#{Formula["qt"].pkgshare}/libexec/moc
      RCC=#{Formula["qt"].pkgshare}/libexec/rcc
      UIC=#{Formula["qt"].pkgshare}/libexec/uic
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
    
    # https://sourceforge.net/p/gnuplot/bugs/2676/
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"

    if OS.mac?
      # pkg-config files are not shipped on macOS, making our job harder
      # https://bugreports.qt.io/browse/QTBUG-86080
      # Hopefully in the future gnuplot can autodetect this information
      # https://sourceforge.net/p/gnuplot/feature-requests/560/
      qtcflags = []
      qtlibs = %W[-F#{Formula["qt"].opt_prefix}/Frameworks]
      %w[Core Gui Network Svg PrintSupport Widgets Core5Compat].each do |m|
        qtcflags << "-I#{Formula["qt"].opt_include}/Qt#{m}"
        qtlibs << "-framework Qt#{m}"
      end

      args += %W[
        QT_CFLAGS=#{qtcflags.join(" ")}
        QT_LIBS=#{qtlibs.join(" ")}
      ]
    end

    ENV.append "CXXFLAGS", "-std=c++17" # needed for Qt 6
    system "./prepare" if build.head?
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] },
                          *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    if build.with? "test"
      system "make", "check"
    end
    system "make", "install"
    if build.with? "demo"
        (pkgshare).install "demo"
    end
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
