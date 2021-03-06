require 'formula'

class ZerocIce33 < Formula
  homepage 'https://github.com/joshmoore/zeroc-ice'

  url 'https://github.com/joshmoore/zeroc-ice/archive/v.3.3.1-clang.tar.gz'
  sha256 '0b406475c1cd7257a87c651b1e47b811b07be0f411b9a442e3e71e5f25372395'
  version '3.3.1'

  head 'https://github.com/joshmoore/zeroc-ice.git', :branch => 'Ice-3.3.1'

  depends_on 'mcpp'
  depends_on 'berkeley-db46' => '--without-java'
  depends_on :python

  def install

    ohai "Creating symbolic link for slice"

    share.mkpath
    ln_s prefix+"slice", share

    bdb46 = Formula['berkeley-db46']
    mcpp = Formula['mcpp']

    cd "rb" do
      system "make MCPP_HOME=#{mcpp.prefix} DB_HOME=#{bdb46.prefix} OPTIMIZE=yes prefix=#{prefix} embedded_runpath_prefix=#{prefix} install"
    end

    ENV["ICE_HOME"] = "#{prefix}"
    ENV["PYTHON_HOME"] = Pathname.new `python-config --prefix`.chomp
    cd "rb" do
      system "make OPTIMIZE=yes prefix=#{prefix} embedded_runpath_prefix=#{prefix} install"
    end
    cd "py" do
      system "make OPTIMIZE=yes prefix=#{prefix} embedded_runpath_prefix=#{prefix} install"
    end

  end

  def caveats; <<-EOS.undent
    Skipping build of ice-java due to jgoodies requirement.
    Download jar from http://zeroc.com

    Skipping build of ice-php due to compile issues:
    See http://www.zeroc.com/forums/help-center/4467-couldnt-compile-icephp-ice-3-3-1-php-5-3-0-a.html
    EOS
  end
  test do
    system "slice2java", "--version"
  end
end
