#!/bin/bash
# Clone tap repo

GIT_ORIGIN_NAME=`git remote get-url origin`
if [[ $GIT_ORIGIN_NAME != *"mahmoud-amer-m/"* ]]; then
  echo "Not creating homebrew tap because the git remote 'origin' is not in the danger organisation"
  exit
fi

TOOL_NAME=homebrew-dangerswiftforked

HOMEBREW_TAP_TMPDIR=$(mktemp -d)
git clone --depth 1 https://github.com/mahmoud-amer-m/homebrew-dangerswiftforked.git "$HOMEBREW_TAP_TMPDIR"
cd "$HOMEBREW_TAP_TMPDIR" || exit 1

TAR_FILENAME="$TOOL_NAME-$VERSION.tar.gz"
wget "https://github.com/mahmoud-amer-m/$TOOL_NAME/archive/$VERSION.tar.gz" -O "$TAR_FILENAME" 2> /dev/null
SHA=`shasum -a 256 "$TAR_FILENAME" | head -n1 | cut -d " " -f1`
rm "$TAR_FILENAME" 2> /dev/null

# Write formula
echo "class DangerSwift < Formula" > dangerswiftforked.rb
echo "  desc \"Write your Dangerfiles in Swift\"" >> dangerswiftforked.rb
echo "  homepage \"https://github.com/mahmoud-amer-m/homebrew-dangerswiftforked\"" >> dangerswiftforked.rb
echo "  version \"$VERSION\"" >> dangerswiftforked.rb
echo "  url \"https://github.com/mahmoud-amer-m/homebrew-dangerswiftforked/archive/#{version}.tar.gz\"" >> dangerswiftforked.rb
echo "  sha256 \"${SHA}\"" >> dangerswiftforked.rb
echo "  head \"https://github.com/mahmoud-amer-m/homebrew-dangerswiftforked.git\""  >> dangerswiftforked.rb
echo >> dangerswiftforked.rb
echo "  # Runs only on Xcode 10" >> dangerswiftforked.rb
echo "  depends_on :xcode => [\"10\", :build]" >> dangerswiftforked.rb
echo "  # Use the vendored danger" >> dangerswiftforked.rb
echo "  depends_on \"danger/tap/danger-js\"" >> dangerswiftforked.rb
echo >> dangerswiftforked.rb
echo "  def install" >> dangerswiftforked.rb
echo "    system \"make\", \"install\", \"PREFIX=#{prefix}\"" >> dangerswiftforked.rb
echo "  end" >> dangerswiftforked.rb
echo "end" >> dangerswiftforked.rb

#Commit changes
git add dangerswiftforked.rb 2> /dev/null
git commit -m "Releasing danger-swift version $VERSION" --quiet
git push origin master
