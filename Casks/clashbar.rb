cask "clashbar" do
  arch arm: "apple-silicon", intel: "intel"

  has_core = File.exist?(File.expand_path("~/Library/Application Support/clashbar/core/mihomo"))
  core_suffix = has_core ? "-no-core" : ""

  version "0.3.3"

  on_arm do
    sha256 has_core ? "0660c69863b681965a3b2e0125770f48c6c2fffee8f4edc9dccd41fbf4adbf6e" \
                    : "ff8ca07ce4ee6780fce19d620292b45b85667a92b1e12c6bffc0c213d0a4680c"
  end
  on_intel do
    sha256 has_core ? "e2efedd430aa7d9c11b517d609f8442a2df77a42fcaaea4bb1b119440e428e5d" \
                    : "181d2172a837fcecd5e7cce7c40e59c845144b25c2628d22018377e721ec6c8a"
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
