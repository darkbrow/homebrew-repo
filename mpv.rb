class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.34.1.tar.gz"
  sha256 "32ded8c13b6398310fa27767378193dc1db6d78b006b70dbcbd3123a1445e746"
  license :cannot_represent
  revision 1
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  option "without-deps", "Build skeletal app bundle"

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on xcode: :build

  depends_on "darkbrow/repo/ffmpeg"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "darkbrow/repo/libsixel"
  depends_on "darkbrow/repo/libcaca"
  depends_on "little-cms2"
  depends_on "luajit-openresty"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "yt-dlp"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    # luajit-openresty is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["luajit-openresty"].opt_lib/"pkgconfig"

    args = %W[
      --prefix=#{prefix}
      --enable-html-build
      --enable-javascript
      --enable-libmpv-shared
      --enable-lua
      --enable-libarchive
      --enable-uchardet
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
      --lua=luajit
      --disable-debug-build
    ]
 
    # change app icon to more big sur friendly one.
    resource "app_icons" do
      url "https://raw.githubusercontent.com/darkbrow/mpv-autosub/master/mpv-icons.tar.gz"
      sha256 "fd4e38e9b8575fcf0a7ecc44c5d754c150d023357a1b783eec477abf56cc6655"
    end

    resource("app_icons").stage do
      rm "#{buildpath/'TOOLS/osxbundle/mpv.app/Contents/Resources'}/icon.icns"
      (buildpath/"TOOLS/osxbundle/mpv.app/Contents/Resources").install "mpv.icns" => "icon.icns"
    end

    system Formula["python@3.9"].opt_bin/"python3.9", "bootstrap.py"
    system Formula["python@3.9"].opt_bin/"python3.9", "waf", "configure", *args
    system Formula["python@3.9"].opt_bin/"python3.9", "waf", "build"

    # build mpv.app
    bundle_opt = []
    bundle_opt << "--skip-deps" if build.without? "deps"
    system Formula["python@3.9"].opt_bin/"python3.9", "./TOOLS/osxbundle.py", *bundle_opt, "build/mpv"

    # correct version string in info.plist
    system "plutil", "-replace", "CFBundleShortVersionString", "-string", "#{version}", "build/mpv.app/Contents/Info.plist"

    # install & link command line support files
    prefix.install "build/mpv.app"
    bin.install_symlink prefix/"mpv.app/Contents/MacOS/mpv"
    zsh_completion.install "etc/_mpv.zsh"
    man1.install "build/DOCS/man/mpv.1"
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")
  end
end
