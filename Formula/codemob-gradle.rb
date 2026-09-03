# typed: false
# frozen_string_literal: true

# codemob-gradle is plain zsh plus one Gradle init script: nothing to compile.
# Homebrew only puts the binary on PATH. All machine setup happens in the
# explicit 'codemob-gradle install' step, and all teardown in
# 'codemob-gradle uninstall', so the person sees and approves what changes.
#
# Until the first tagged release exists there is no stable url; install with
# 'brew install --HEAD codemob-ai/codemob/codemob-gradle'. To publish a
# release, tag the repo (for example v0.1.0) and add above 'head':
#   url "https://github.com/codemob-ai/codemob-gradle/archive/refs/tags/v0.1.0.tar.gz"
#   sha256 "<sha256 of that tarball>"
class CodemobGradle < Formula
  desc "Per-worktree cloned Gradle homes so concurrent builds stop fighting over locks"
  homepage "https://github.com/codemob-ai/codemob-gradle"
  license "Apache-2.0"
  head "https://github.com/codemob-ai/codemob-gradle.git", branch: "main"

  depends_on :macos

  def install
    # The binary finds its lib/, hook/, and gradle/ folders two levels above
    # its own resolved path, so the whole tree goes into libexec and only a
    # symlink lands in bin.
    libexec.install "bin", "lib", "hook", "gradle"
    bin.install_symlink libexec/"bin/codemob-gradle"
  end

  def caveats
    <<~EOS
      Homebrew only put the binary on your PATH. To set up this machine
      (config, shell hook, gitignore entry, build limiter), run:
        codemob-gradle install

      To remove the tool later, run these two commands in this order:
        codemob-gradle uninstall
        brew uninstall codemob-gradle
    EOS
  end

  test do
    assert_match "usage: codemob-gradle", shell_output("#{bin}/codemob-gradle help")
  end
end
