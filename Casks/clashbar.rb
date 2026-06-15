cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.2.7"

  on_arm do
    sha256 has_core ? "853ed10e90ec9df61bcdd73d3a9e4aa621357513dc9b367cf7dc28c44feb7286" \
                    : "f730a7e84caffa24e34d8f110fc558a5d6ef5d9bc3a8de327cca3e78b2667612"
  end
  on_intel do
    sha256 has_core ? "2ae8ebd49c0bc16f508612dfcc8c4a71e9af743eac0f43ccb6c4bf76c48bba30" \
                    : "6c57fdb5bb9cbb6e8bdfabbfc35642f8d1b7cbea4d4eeaeaae9d5c68b3c1c805"
  end

  url "https://github.com/Sitoi/ClashBar/releases/download/v#{version}/ClashBar-#{version}-#{arch}#{core_suffix}.dmg"
  name "ClashBar"
  desc "Menu bar proxy client based on Mihomo"
  homepage "https://github.com/Sitoi/ClashBar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "ClashBar.app"

  postflight do

    puts "Run `xattr -cr /Applications/ClashBar.app` for the APP, see more details in https://github.com/Sitoi/ClashBar?tab=readme-ov-file#-%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98."

    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/ClashBar.app"], sudo: false
  end

  uninstall launchctl: "com.clashbar.helper",
            quit:      "com.clashbar"

  zap trash: [
    "~/Library/Application Support/com.clashbar",
    "~/Library/Caches/com.clashbar",
    "~/Library/Preferences/com.clashbar.plist",
  ]
end
