require "formula"

class Coverit < Formula
  homepage "https://github.com/coverit/coverit"
  url "https://github.com/coverit/coverit.git"

  version "0.0.0"

  depends_on 'go' => :build

  def install

    ENV["GOPATH"] = buildpath
    ENV["PATH"] = buildpath/"bin:#{ENV['PATH']}"
    # ENV.append_path "PATH", buildpath/"bin"

    coverit_build_path = buildpath/"src/github.com/coverit/coverit"
    coverit_build_path.install Dir["{*,.git}"]

    # coverit's deps is managed by godeps
    system "go", "get", "github.com/tools/godep"

    cd "src/github.com/coverit/coverit/cli" do
      system "godep", "go", "build", "-o", "coverit"
      bin.install "#{coverit_build_path}/cli/coverit"
    end
  end

  test do
    assert_match "coverit version #{version}", shell_output("#{bin}/coverit --version")
  end
end
