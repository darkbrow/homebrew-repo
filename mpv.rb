class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.35.0.tar.gz"
  sha256 "dc411c899a64548250c142bf1fa1aa7528f1b4398a24c86b816093999049ec00"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on xcode: :build

  depends_on "darkbrow/repo/ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "darkbrow/repo/libsixel"
  depends_on "darkbrow/repo/libcaca"
  depends_on "little-cms2"
  depends_on "luajit"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # Avoid unreliable macOS SDK version detection
    # See https://github.com/mpv-player/mpv/pull/8939
    if OS.mac?
      sdk = (MacOS.version == :big_sur) ? MacOS::Xcode.sdk : MacOS.sdk
      ENV["MACOS_SDK"] = sdk.path
      ENV["MACOS_SDK_VERSION"] = "#{sdk.version}.0"
    end

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"

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
 
    python3 = "python3.11"
    system python3, "bootstrap.py"
    system python3, "waf", "configure", *args
    # system python3, "waf", "install"

    ## build app bundle -start-
    system python3, "waf", "build"
    system python3, "./TOOLS/osxbundle.py", "build/mpv"

    # correct version string in info.plist
    system "plutil", "-replace", "CFBundleShortVersionString", "-string", "#{version}", "build/mpv.app/Contents/Info.plist"

    # install & link command line support files
    prefix.install "build/mpv.app"
    bin.install_symlink prefix/"mpv.app/Contents/MacOS/mpv"
    zsh_completion.install "etc/_mpv.zsh"
    man1.install "build/DOCS/man/mpv.1"
    ## build app bundle -end-
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")
  end
end
