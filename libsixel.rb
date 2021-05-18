class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/saitoha/libsixel/releases/download/v1.8.6/libsixel-1.8.6.tar.gz"
  sha256 "9f6dcaf40d250614ce0121b153949c327c46a958cfd2e47750d8788b7ed28e6a"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "gd"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gd",
                          "--with-jpeg=#{Formula["jpeg"].prefix}",
                          "--with-png",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    system "#{bin}/img2sixel", fixture
  end
end
