# Formula for georgiosnikitas/homebrew-brain-break
class BrainBreak < Formula
  desc "An AI-powered terminal quiz app"
  homepage "https://github.com/georgiosnikitas/brain-break"
  url "https://github.com/georgiosnikitas/brain-break/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "773ed05004b0d15cb5fef96c5cb221b3e25ca22cb7c92907d8b63233f501b929"
  license "MIT"
  head "https://github.com/georgiosnikitas/brain-break.git", branch: "main"

  depends_on "node"

  def install
    node_version = Utils.safe_popen_read(Formula["node"].opt_bin/"node", "--version").strip
    odie "brain-break requires Node.js >= 22.0.0 (found #{node_version})" if Version.new(node_version.delete_prefix("v")) < Version.new("22.0.0")

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
