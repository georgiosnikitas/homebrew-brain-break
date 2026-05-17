# Formula for georgiosnikitas/homebrew-brain-break
class BrainBreak < Formula
  desc "An AI-powered terminal quiz app"
  homepage "https://www.npmjs.com/package/brain-break"
  url "https://registry.npmjs.org/brain-break/-/brain-break-1.18.1.tgz"
  sha256 "9d03745b1baa7a785ffa35ce942df36c943695da487e5315f7e9c661b1118fa8"
  license "MIT"

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
