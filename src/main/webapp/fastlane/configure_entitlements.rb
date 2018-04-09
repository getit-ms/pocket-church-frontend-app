#!/usr/bin/env ruby
require 'xcodeproj'

proj = Xcodeproj::Project.open("../${nomeAplicativo.igreja}.xcodeproj")

targetid = proj.targets.first.uuid
proj.root_object.attributes['TargetAttributes'] = {targetid => {"SystemCapabilities" => {"com.apple.Push" => {"enabled" => 1}}}}

proj.recreate_user_schemes
proj.save
