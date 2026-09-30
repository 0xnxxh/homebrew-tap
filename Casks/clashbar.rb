cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.3.6"

  on_arm do
    sha256 has_core ? "9090fa6293773c9dfec6101fb2a82677e2746db3d1f6e77319d407d77a1e65d4" \
                    : "f25bd38eca4992292535675458a1260c8a5af32b5d7ffd83f3c78869fa48cc19"
  end
  on_intel do
    sha256 has_core ? "0f12e120e192949d47263beb37878cda4801c8f553024a34b115d93cab35f139" \
                    : "f2ab4eaf1720c418e18132ef2d6b0dc5417b89ca2165251a201a7e46f3a57716"
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

  postflight_steps do
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/ClashBar.app"]
  end

  uninstall_postflight_steps do
    run "/bin/launchctl", args: ["bootout", "system/com.clashbar.helper"],
        sudo: true, must_succeed: false
    run "/bin/rm",
        args: ["-f", "/Library/LaunchDaemons/com.clashbar.helper.plist",
               "/Library/PrivilegedHelperTools/com.clashbar.helper",
               "/Library/PrivilegedHelperTools/com.clashbar.helper.version"],
        sudo: true, must_succeed: false
  end

  uninstall launchctl: "com.clashbar.helper",
            quit:      "com.clashbar"

  zap trash: [
    "~/Library/Application Support/com.clashbar",
    "~/Library/Caches/com.clashbar",
    "~/Library/Preferences/com.clashbar.plist",
  ]
end
