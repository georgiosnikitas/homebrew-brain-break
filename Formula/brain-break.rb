# Formula for georgiosnikitas/homebrew-brain-break
class BrainBreak < Formula
  desc "An AI-powered terminal quiz app"
  homepage "https://www.npmjs.com/package/brain-break"
  url "https://registry.npmjs.org/brain-break/-/brain-break-1.17.5.tgz"
  sha256 "900e60d69ef83cd6e7ace7691a80773308ecc7eecda35217d47fb01246af41d7"
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
