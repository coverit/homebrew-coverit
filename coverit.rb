require "formula"

class Coverit < Formula
  homepage "https://github.com/coverit/coverit"
  url "https://github.com/coverit/coverit.git"

  version "0.0.0"

  depends_on 'go' => :build
  depends_on 'lcov'

  def install

    ENV["GOPATH"] = buildpath

    coverit_build_path = buildpath/"src/github.com/coverit/coverit"
    coverit_build_path.install Dir["{*,.git}"]
    godeps_workspace_path = "#{coverit_build_path}/Godeps/_workspace"

    # coverit's deps is managed by godeps
    ENV.append_path "GOPATH", godeps_workspace_path

    cd "src/github.com/coverit/coverit/cli" do
      system "go", "build", "-o", "coverit"
      bin.install "#{coverit_build_path}/cli/coverit"
    end
  end

  test do
    assert_match "coverit version #{version}", shell_output("#{bin}/coverit --version")
  end
end
