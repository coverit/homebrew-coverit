require "formula"

class Coverit < Formula
  homepage "https://github.com/coverit/coverit"
  url "https://github.com/coverit/coverit.git", :branch => "master"

  version `curl -sL "https://raw.githubusercontent.com/coverit/coverit/master/cli/VERSION"`.gsub(/\s+/, " ").strip
  # version "alpha"

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

      cli_version = `cat VERSION`
      cli_sha = `git rev-parse --short HEAD`

      system "go", "build", "-o", "coverit", "-ldflags", "-X main.version #{cli_version} -X main.sha #{cli_sha}"
      bin.install "#{coverit_build_path}/cli/coverit"
    end
  end

  test do
    assert_match "coverit version #{version}", shell_output("#{bin}/coverit --version")
  end
end
