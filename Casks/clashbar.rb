cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.3.0"

  on_arm do
    sha256 has_core ? "4aaebb8bda276219ff8527a887212a5ec36965d6496b4b677299745f7d30dc35" \
                    : "4f586c168ab44125dbc8377dec6c7d058af5dffef80869a3afac60f26201741e"
  end
  on_intel do
    sha256 has_core ? "18f9382a1b9db8e6bdd904de6f708ac37d8731591d3cc2437d9f4cfc4ff2b744" \
                    : "2bed157a12908fc8977d1505b03f517c1a488886397425bfab6fd9e0cfb3aea2"
  end

  url "https://github.com/Sitoi/ClashBar/releases/download/v#{version}/ClashBar-#{version}-#{arch}#{core_suffix}.dmg"
  name "ClashBar"
  desc "Menu bar proxy client based on Mihomo"
  homepage "https://github.com/Sitoi/ClashBar"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

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
