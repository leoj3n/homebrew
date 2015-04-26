require "formula"
require "language/go"

class Nsq < Formula
  homepage "https://bitly.github.io/nsq"
  url "https://github.com/bitly/nsq/archive/v0.3.5.tar.gz"
  sha1 "a876334ad959685fa109f67b4d07231ae84bcf43"

  bottle do
    cellar :any
    sha1 "4eca017db1de9f3992da92a3eed95f6343393c74" => :yosemite
    sha1 "0fcd44d0fc5bc26ad364b2e5c943160f06bffcbe" => :mavericks
    sha1 "e3ce46fcb14aa4557a68ef7197b8a5889e556823" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
      :revision => "2dff11163ee667d51dcc066660925a92ce138deb"
  end

  go_resource "github.com/bitly/go-hostpool" do
    url "https://github.com/bitly/go-hostpool.git",
      :revision => "58b95b10d6ca26723a7f46017b348653b825a8d6"
  end

  go_resource "github.com/bitly/go-nsq" do
    url "https://github.com/bitly/go-nsq.git",
      :revision => "22a8bd48c443ec23bb559675b6df8284bbbdab29"
  end

  go_resource "github.com/bitly/go-simplejson" do
    url "https://github.com/bitly/go-simplejson.git",
      :revision => "fc395a5db941cf38922b1ccbc083640cd76fe4bc"
  end

  go_resource "github.com/bmizerany/perks" do
    url "https://github.com/bmizerany/perks.git",
      :revision => "6cb9d9d729303ee2628580d9aec5db968da3a607"
  end

  go_resource "github.com/mreiferson/go-options" do
    url "https://github.com/mreiferson/go-options.git",
      :revision => "2cf7eb1fdd83e2bb3375fef6fdadb04c3ad564da"
  end

  go_resource "github.com/mreiferson/go-snappystream" do
    url "https://github.com/mreiferson/go-snappystream.git",
      :revision => "028eae7ab5c4c9e2d1cb4c4ca1e53259bbe7e504"
  end

  go_resource "github.com/bitly/timer_metrics" do
    url "https://github.com/bitly/timer_metrics.git",
      :revision => "afad1794bb13e2a094720aeb27c088aa64564895"
  end

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
      :revision => "9bf7bff48b0388cb75991e58c6df7d13e982f1f2"
  end

  def install
    # build a proper GOPATH tree for local dependencies
    (buildpath + "src/github.com/bitly/nsq").install "internal", "nsqlookupd", "nsqd", "nsqadmin"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    system "#{bin}/nsqd", "--version"
  end
end
