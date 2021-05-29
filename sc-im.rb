class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.1.tar.gz"
  sha256 "73958f2adf2548be138f90a1fa2cb3a9c316a6d8d78234ebb1dc408cbf83bac7"
  license "BSD-4-Clause"
  head "https://github.com/andmarti1424/sc-im.git", branch: "freeze"

  depends_on "darkbrow/repo/libxls"
  depends_on "darkbrow/repo/libxlsxwriter"
  depends_on "libzip"
  depends_on "lua"
  depends_on "ncurses"

  uses_from_macos "libxml2"

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
