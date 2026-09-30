cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.3.5"

  on_arm do
    sha256 has_core ? "236f00959f9886faa54e482f36bce3f365c5349d4b1b989e281cd594a4ce05f1" \
                    : "aaffa6ec6aa3ce32158b83d0d2ed0ea6c2e1b2c56e019f4e14b4ed5cc7277a2e"
  end
  on_intel do
    sha256 has_core ? "75b14df126def7694f90dffc9e34800ec735813edeedc7763850a414a43cd689" \
                    : "11a2e4b5fc6111a0d4099ace32ef31d79a05ffbdd8052ce0a1618fcdefac39ab"
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
