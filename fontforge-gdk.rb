class FontforgeGdk < Formula
  desc "Outline and bitmap font editor/converter"
  homepage "https://fontforge.github.io"
  url "https://github.com/fontforge/fontforge/releases/download/20201107/fontforge-20201107.tar.xz"
  sha256 "68bcba8f602819eddc29cd356ee13fafbad7a80d19b652d354c6791343476c78"
  license "GPL-3.0-or-later"
  head "https://github.com/fontforge/fontforge.git"

  depends_on "automake" => :build
  depends_on "cairo" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "czmq" => :build
  depends_on "fontconfig" => :build
  depends_on "freetype" => :build
  depends_on "gettext" => :build
  depends_on "giflib" => :build
  depends_on "glib" => :build
  depends_on "gtk+3" => :build
  depends_on "jpeg" => :build
  depends_on "libffi" => :build
  depends_on "libpng" => :build
  depends_on "libspiro" => :build
  depends_on "libtiff" => :build
  depends_on "libtool" => :build
  depends_on "libuninameslist" => :build
  depends_on "pango" => :build
  depends_on "pcre" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "readline" => :build
  depends_on "woff2" => :build
  depends_on "libx11" => :build
  depends_on "libxext" => :build
  depends_on "libxrender" => :build

  uses_from_macos "libxml2" => :build

  def install
    mkdir "build" do
      system "cmake", "..",
                      "-DENABLE_GUI=ON",
                      "-DENABLE_FONTFORGE_EXTRAS=ON",
                      *std_cmake_args
      system "make"
      system "make", "macbundle"
    end
    prefix.install "build/osx/FontForge.app"
    
    resource "cidmaps" do
      url "http://fontforge.sourceforge.net/cidmaps.tgz"
      sha256 "1bf9c7eb8835e6ed94e62cb49f1141bc046c562849e52e6c3c7f1d7cfc95c7b3"
    end

    resource("cidmaps").stage do
      (prefix/"FontForge.app/Contents/Resources/opt/local/share/fontforge").install Dir["*"]
    end
  end

  test do
    system bin/"ffg", "-version"
  end
end

