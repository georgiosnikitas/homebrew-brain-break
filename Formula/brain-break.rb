# Formula for georgiosnikitas/homebrew-brain-break
class BrainBreak < Formula
  desc "An AI-powered terminal quiz app"
  homepage "https://github.com/georgiosnikitas/brain-break"
  url "https://github.com/georgiosnikitas/brain-break/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "6dbb3d80d030a9f8d6d7e11fa778fa1f786b6cd8b7360b25d080e1546584d978"
  license "MIT"
  head "https://github.com/georgiosnikitas/brain-break.git", branch: "main"

  depends_on "node"

  def install
    node_version = Utils.safe_popen_read(Formula["node"].opt_bin/"node", "--version").strip
    odie "brain-break requires Node.js >= 25.8.0 (found #{node_version})" if Version.new(node_version.delete_prefix("v")) < Version.new("25.8.0")

    system "npm", "install"
    system "npm", "run", "build"

    chmod 0755, "dist/index.js"

    libexec.install "dist", "node_modules", "package.json"

    (bin/"brain-break").write_env_script "#{libexec}/dist/index.js",
      PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_match "brain-break", shell_output("#{bin}/brain-break 2>&1", 1)
  end
end
