# Formula for georgiosnikitas/homebrew-brain-break
class BrainBreak < Formula
  desc "An AI-powered terminal quiz app"
  homepage "https://github.com/georgiosnikitas/brain-break"
  url "https://github.com/georgiosnikitas/brain-break/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "5ac8f8762b1180d3094eb7f3903ed622070c87c328d5818eef8e04db8a669ee8"
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
