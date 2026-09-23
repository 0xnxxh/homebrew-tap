cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.3.4"

  on_arm do
    sha256 has_core ? "60f6ce2250a32176f818b3fbdc53b26d23c23a66ca028cc7cf080adaf15bf701" \
                    : "4d6da06cfd89c8081516fbdf643f3de8293f6404a1dd20f956b25ea9a8c56f4b"
  end
  on_intel do
    sha256 has_core ? "98fe0c7781eedcd476ed4e15155d32ebe593221f83040b8f3ac5ca5a498af7ac" \
                    : "d7944396e75812fe70be271d5df4e9a206f16ae9c8ceac655609fc3ee3ab4df2"
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
