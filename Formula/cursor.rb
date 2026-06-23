class Cursor < Formula
  desc "Professional AI agent with command execution and file operations"
  homepage "https://github.com/bniladridas/cursor"
  url "https://github.com/bniladridas/cursor/archive/refs/tags/v0.1.24.tar.gz"
  sha256 "1049b3fcab2fa34b9e907ba702273397049e8bf69cc607748e08f79e55f50d33"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/bniladridas/cursor/releases/download/v0.1.24"
    sha256 arm64_sequoia: "64c8dec3746a8abe1f3d2aa6dfb066b3a191b1140213ae86d4728622f83e05cb"
  end

  depends_on "cmake" => :build
  depends_on "cpr"
  depends_on "nlohmann-json"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCURSOR_BUILD_TESTS:BOOL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/bin/cursor-agent"
    bin.install_symlink "cursor-agent" => "cursor"
  end

  def post_install
    (var/"cursor-agent").mkpath
    config = etc/"cursor-agent/.env"
    return if config.exist?

    example = buildpath/".env.example"
    example = prefix/".env.example" unless example.exist?

    if example.exist?
      cp example, config
    else
      config.write <<~EOS
        # Cursor Agent Configuration
        # Add your API keys below.
        # TOGETHER_API_KEY=your_key_here
        # CEREBRAS_API_KEY=your_key_here
        # SERPAPI_KEY=your_key_here
      EOS
    end
  end

  test do
    system "#{bin}/cursor-agent", "--version"
  end

  def caveats
    <<~EOS
      Run "cursor" or "cursor-agent" to start.

      Configuration file is located at:
        #{etc}/cursor-agent/.env

      Edit this file with your API keys:
        - TOGETHER_API_KEY (for online mode)
        - CEREBRAS_API_KEY (for Cerebras mode)
        - SERPAPI_KEY (for web search)

      Data directory:
        #{var}/cursor-agent/
    EOS
  end
end
