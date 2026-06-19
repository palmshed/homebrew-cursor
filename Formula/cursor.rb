class Cursor < Formula
  desc "Professional AI agent with command execution and file operations"
  homepage "https://github.com/bniladridas/cursor"
  url "https://github.com/bniladridas/cursor/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "e078bb68eba20244d209e30e83608ebdff6ce20ec878d3be729d1d9d533bb80c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/bniladridas/cursor/releases/download/v0.1.17"
    sha256 arm64_sequoia: "ba694f7cfdf0174298ffbb60993cb7e20eed5b5ded2c572a27aeb85816c8c128"
  end

  depends_on "cmake" => :build
  depends_on "cpr"
  depends_on "nlohmann-json"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCURSOR_BUILD_TESTS:BOOL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/bin/cursor-agent"
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
