class Leveldb < Formula
  desc "Key-value storage library with ordered mapping"
  homepage "https://github.com/google/leveldb/"
  url "https://github.com/google/leveldb/archive/1.22.tar.gz"
  sha256 "55423cac9e3306f4a9502c738a001e4a339d1a38ffbee7572d4a07d5d63949b2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d31999d036ab81506c70b2e446a4fc62457307a610e9af51538cea0e592fd4b"
    sha256 cellar: :any,                 arm64_ventura:  "b7ca49e08f08c52f9a2c7f67dbcbd1214ca97023d1173f943d8df0a4dda66c55"
    sha256 cellar: :any,                 arm64_monterey: "666c5e8c3f01854847176459ee4fc06d3248dfda68e8249b2186777c09cab373"
    sha256 cellar: :any,                 sonoma:         "98aa66f907f2e279295bb6691302388264f6fc141128703ce4bfd315531815d2"
    sha256 cellar: :any,                 ventura:        "48d595e1d25c23f2376ba436b3a89913f9babbd0d715f4029d9eff7174923215"
    sha256 cellar: :any,                 monterey:       "327dd3eac9c6a481c5f7e578f815d6b3f3d912c33e47c4e15dd5ccce85a2bd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240f267390c10b75634da1be1bf04e0878819ef79d6d79fb52a4507adb47908b"
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  depends_on "snappy"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"
      bin.install "leveldbutil"

      system "make", "clean"
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libleveldb.a"
    end
  end

  test do
    assert_match "dump files", shell_output("#{bin}/leveldbutil 2>&1", 1)
  end
end
