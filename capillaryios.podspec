Pod::Spec.new do |s|

  s.name = "capillaryslack"
  s.version = "1.0.0"
  s.summary = "Public key RSA encryption."

  s.description = <<-DESC
    Encrypt with a RSA public key, decrypt with a RSA private key.
  DESC

  s.homepage = "https://github.com/oianmol/slack_capillary_ios"
  s.license = "MIT"
  s.author = { "Anmol Verma" => "anmol.verma4@gmail.com" }

  s.source = { :git => "https://github.com/oianmol/slack_capillary_ios.git", :tag => s.version }
  s.source_files = "capillaryslack/*.{swift,m,h}"
  s.framework = "Security"
  s.requires_arc = true

  s.swift_version = "5.0"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"
  s.watchos.deployment_target = "4.3"

  s.subspec "ObjC" do |sp|
    sp.source_files = "capillaryslack/*.{swift,m,h}"
  end
end