cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.2.5"

  on_arm do
    sha256 has_core ? "09424a9175b61c7f170b89aa68277be0b9197ff4e4fd96f0a4688d1e7098d700" \
                    : "656326f20daf562962445fd361ce2c17d20eab61b7a09e19574d50e463643cb4"
  end
  on_intel do
    sha256 has_core ? "a776321ca0648023aa37f93b8c9832f48b5b7af018c0c046206a95817aa27121" \
                    : "9eb524771220aa898dfbd0efab112ff9f6c1c7360d223345cf53a1e4e134da93"
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
