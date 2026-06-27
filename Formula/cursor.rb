class Cursor < Formula
  desc "Professional AI agent with command execution and file operations"
  homepage "https://github.com/bniladridas/cursor"
  url "https://github.com/bniladridas/cursor/archive/refs/tags/v0.1.29.tar.gz"
  sha256 "d3236f780b637b6975bf6819e102f12ecd9ebe20a0de29e3d01e33c480663649"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/bniladridas/cursor/releases/download/v0.1.29"
    sha256 arm64_sequoia: "44ae7c290e6157ba31f6da51627ceb7f8086794d5b8649c0cef9a99e6f9af7e8"
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
