class Bioformats < Formula
  desc "Library for reading proprietary image file formats"
  homepage "http://www.openmicroscopy.org/site/products/bio-formats"
  url "http://downloads.openmicroscopy.org/bio-formats/5.7.0/artifacts/bioformats-5.7.0.zip"
  sha256 "168a47c5d3d1454208da5293cb0365ea7600506e9df2f5d41aab277cdd3fb276"

  depends_on "ant" => :build

  def install
    # Build libraries
    args = ["ant", "clean", "tools", "-Dmaven.repo.local",
            "#{buildpath}/.m2/repository"]
    system *args

    # Remove Windows files
    rm Dir["tools/*.bat"]

    # Copy artifacts
    libexec.install "artifacts/bioformats_package.jar"

    # Copy command line-tools
    libexec.install Dir["tools/*"]

    %w[bfconvert domainlist formatlist ijview mkfake omeul showinf tiffcomment xmlindent xmlvalid].each do |fn|
      bin.install_symlink libexec/fn
    end
  end
  test do
    system "showinf", "-version"
    system "bfconvert", "-version"
  end
end
