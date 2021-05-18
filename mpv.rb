class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.33.1.tar.gz"
  sha256 "100a116b9f23bdcda3a596e9f26be3a69f166a4f1d00910d1789b6571c46f3a9"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git"

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
  depends_on "youtube-dl"

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
    resource "app_icon" do
      url "https://raw.githubusercontent.com/darkbrow/mpv-autosub/master/mpv.icns"
      sha256 "5125c8f286e96cbe9bcdc0ba11cc019d9b239c54e3f2ab6c0b7af0e46ff516ab"
    end

    rsrc_dir = buildpath/"TOOLS/osxbundle/mpv.app/Contents/Resources"
    rm "#{rsrc_dir}/icon.icns"

    resource("app_icon").stage do
      rsrc_dir.install "mpv.icns" => "icon.icns"
    end

    system Formula["python@3.9"].opt_bin/"python3", "bootstrap.py"
    system Formula["python@3.9"].opt_bin/"python3", "waf", "configure", *args
    # system Formula["python@3.9"].opt_bin/"python3", "waf", "install"
    system Formula["python@3.9"].opt_bin/"python3", "waf", "build"

    # build mpv.app
    bundle_opt = []
    bundle_opt << "--skip-deps" if build.without? "deps"
    system Formula["python@3.9"].opt_bin/"python3", "./TOOLS/osxbundle.py", *bundle_opt, "build/mpv"

    # correct version string in info.plist
    system "plutil", "-replace", "CFBundleShortVersionString", "-string", "#{version}", "build/mpv.app/Contents/Info.plist"

    prefix.install "build/mpv.app"
    bin.install_symlink prefix/"mpv.app/Contents/MacOS/mpv"
    zsh_completion.install "etc/_mpv.zsh"
    man1.install "build/DOCS/man/mpv.1"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")
  end
end
