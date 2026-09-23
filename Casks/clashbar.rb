cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.3.4"

  on_arm do
    sha256 has_core ? "b4ca70d9665e3ac376833c9551c1dbef5cad70f82454ed9ecfd7af28d1880780" \
                    : "2b4f343f1a93f641b4c52efa09f9a2a189bb843619fba9ea652a7f126ffe3fc7"
  end
  on_intel do
    sha256 has_core ? "41a4b61e6a5a85d80c0706f680363ad2caba1a7dd19bb29689244bd551409a88" \
                    : "b410987cb6f923264810787ca3f5ae5a408269eef4c6934a85857ff3740989e2"
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

    run "/bin/launchctl", args: ["bootout", "system/com.clashbar.helper"],
        sudo: true, must_succeed: false
    run "/usr/bin/install",
        args: ["-d", "-o", "root", "-g", "wheel", "-m", "755", "/Library/PrivilegedHelperTools"],
        sudo: true
    run "/usr/bin/install",
        args: ["-d", "-o", "root", "-g", "wheel", "-m", "755", "/Library/LaunchDaemons"],
        sudo: true
    run "/usr/bin/install",
        args: ["-o", "root", "-g", "wheel", "-m", "755",
               "{{appdir}}/ClashBar.app/Contents/Library/HelperTools/com.clashbar.helper",
               "/Library/PrivilegedHelperTools/com.clashbar.helper"],
        sudo: true
    run "/usr/bin/install",
        args: ["-o", "root", "-g", "wheel", "-m", "644",
               "{{appdir}}/ClashBar.app/Contents/Library/LaunchDaemons/com.clashbar.helper.plist",
               "/Library/LaunchDaemons/com.clashbar.helper.plist"],
        sudo: true
    run "/usr/bin/plutil",
        args: ["-remove", "BundleProgram", "/Library/LaunchDaemons/com.clashbar.helper.plist"],
        sudo: true
    run "/usr/bin/plutil",
        args: ["-insert", "Program", "-string", "/Library/PrivilegedHelperTools/com.clashbar.helper",
               "/Library/LaunchDaemons/com.clashbar.helper.plist"],
        sudo: true
    run "/bin/launchctl",
        args: ["bootstrap", "system", "/Library/LaunchDaemons/com.clashbar.helper.plist"],
        sudo: true
  end

  uninstall_postflight_steps do
    run "/bin/launchctl", args: ["bootout", "system/com.clashbar.helper"],
        sudo: true, must_succeed: false
    run "/bin/rm",
        args: ["-f", "/Library/LaunchDaemons/com.clashbar.helper.plist",
               "/Library/PrivilegedHelperTools/com.clashbar.helper"],
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
