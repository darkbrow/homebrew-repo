class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.2.tar.gz"
  sha256 "7f00c98601e7f7709431fb4cbb83707c87016a3b015d48e5a7c2f018eff4b7f7"
  license "BSD-4-Clause"
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  depends_on "darkbrow/repo/libxls"
  depends_on "darkbrow/repo/libxlsxwriter"
  depends_on "libzip"
  depends_on "luajit-openresty"
  depends_on "ncurses"

  uses_from_macos "bison" => :build
  uses_from_macos "libxml2"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "src" do
      system "make", "prefix=#{prefix}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    input = <<~EOS
      let A1=1+1
      getnum A1
    EOS
    output = pipe_output(
      "#{bin}/sc-im --nocurses --quit_afterload 2>/dev/null", input
    )
    assert_equal "2", output.lines.last.chomp
  end
end
