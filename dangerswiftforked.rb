class DangerSwift < Formula
  desc "Write your Dangerfiles in Swift"
  homepage "https://github.com/mahmoud-amer-m/homebrew-dangerswiftforked"
  version ""
  url "https://github.com/mahmoud-amer-m/homebrew-dangerswiftforked/archive/#{version}.tar.gz"
  sha256 ""
  head "https://github.com/mahmoud-amer-m/homebrew-dangerswiftforked.git"

  # Runs only on Xcode 10
  depends_on :xcode => ["10", :build]
  # Use the vendored danger
  depends_on "danger/tap/danger-js"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
