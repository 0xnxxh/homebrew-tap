cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.2.3"

  on_arm do
    sha256 has_core ? "7d95e68c50c99345aaf1054ece05461c4f7a23417d0c92f0733ce23831ab4ae4" \
                    : "45787def05fb2e1669e60efc041e79d52f0ce2d14c13b7e61d9468d25f730590"
  end
  on_intel do
    sha256 has_core ? "a851627ed4f3b7638458c79fb022e939de580c726bfe889c14b6f2d000c0206f" \
                    : "15d9576149670beeb352ab15373b0175921348fc4e5987c4afc169e550624276"
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
            quit:      "com.clashbar",
            delete:    [
              "/Library/LaunchDaemons/com.clashbar.helper.plist",
              "/Library/PrivilegedHelperTools/com.clashbar.helper",
            ]

  zap trash: [
    "~/Library/Application Support/com.clashbar",
    "~/Library/Caches/com.clashbar",
    "~/Library/Preferences/com.clashbar.plist",
  ]
end
