class Cursor < Formula
  desc "Professional AI agent with command execution and file operations"
  homepage "https://github.com/bniladridas/cursor"
  url "https://github.com/bniladridas/cursor/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "a87057cf7692706cdfccd09ae8e2a0a39f0b0dc52e88afa35f538adbeabb6e8c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/bniladridas/cursor/releases/download/v0.1.16"
    sha256 arm64_sequoia: "b3b000bb7c246f2f7c2ef259a9953f7608d5df26f3cc50c475bbc756fb3c9dc4"
  end

  depends_on "cmake" => :build
  depends_on "cpr"
  depends_on "nlohmann-json"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCURSOR_BUILD_TESTS:BOOL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/bin/cursor-agent"

    (etc/"cursor-agent").install ".env.example" => "config.env"
  end

  def post_install
    (var/"cursor-agent").mkpath
    unless (etc/"cursor-agent/.env").exist?
      cp etc/"cursor-agent/config.env", etc/"cursor-agent/.env"
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
