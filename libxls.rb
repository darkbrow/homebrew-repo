class Libxls < Formula
  desc "Read binary Excel files from C/C++"
  homepage "https://github.com/libxls/libxls"
  url "https://github.com/libxls/libxls/releases/download/v1.6.2/libxls-1.6.2.tar.gz"
  sha256 "5dacc34d94bf2115926c80c6fb69e4e7bd2ed6403d51cff49041a94172f5e371"
  license "BSD-2-Clause"

  head do
    url "https://github.com/libxls/libxls.git", branch: "master"

    patch :DATA

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 1d1388d..3bcb6d9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,7 +37,7 @@ AC_PROG_INSTALL
 AC_PROG_CC
 AC_PROG_CC_C99
 AC_PROG_CXX
-AX_CXX_COMPILE_STDCXX_11([], [optional])
+# AX_CXX_COMPILE_STDCXX_11([], [optional])
 
 AS_IF([test "x$HAVE_CXX11" != x1], [
     AC_MSG_NOTICE([---])

