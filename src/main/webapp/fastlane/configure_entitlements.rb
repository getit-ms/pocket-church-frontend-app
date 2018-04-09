#!/usr/bin/env ruby
require 'xcodeproj'

proj = Xcodeproj::Project.open("../${nomeAplicativo.igreja};xcodeproj")

targetid = proj.targets.first.uuid
proj.root_object.attributes['TargetAttributes'] = {targetid => {"SystemCapabilities" => {"com.apple.Push" => {"enable" => 1}}}}

proj.build_configurations.each do |config|
  config.build_settings.store("CODE_SIGN_ENTITLEMENTS", "${nomeAplicativo.igreja}/pocket-church.entitlements")
end

proj.recreate_user_schemes
proj.save
