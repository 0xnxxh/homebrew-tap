cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.2.8"

  on_arm do
    sha256 has_core ? "f00ed1e33b4d9d674dc16bd93040a883b16a6568d8479aad5589620bf2e9418e" \
                    : "5aef2203fcd19b226340c5b5a9b5b7e72957ea1d16bd4ce630850037eed9cd1f"
  end
  on_intel do
    sha256 has_core ? "e0adfda74702cf50217d80862eca80485f2ef28890b54ebb97b0bc7e7d7895c5" \
                    : "1dda0e0241103810cb9ea1077a19627e2fb6e70f1a6978adcf5f76fbc5c43e89"
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
