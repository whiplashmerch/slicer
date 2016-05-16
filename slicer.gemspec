Gem::Specification.new do |s|
  s.name        = 'slicer'
  s.version     = '0.0.3'
  s.date        = '2016-05-13'
  s.summary     = "Slicer"
  s.description = "Extract relations of a single record from a Rails database for use in testing and development"
  s.authors     = ["James Marks"]
  s.email       = 'james@whiplashmerch.com'
  s.files       = ["lib/slicer.rb"]
  s.homepage    = 'https://github.com/whiplashmerch/slicer'
  s.license     = 'MIT'
end


# Make the updates
# gem buiild slicer.gemspec 
# restart server / console

# Local development:
# gem 'slicer', :path => "/Library/Webserver/slicer" # Local development of the slicer gem


# Production testing, pre-release
# gem 'slicer', :git => 'https://github.com/whiplashmerch/slicer.git'

# Create rake task on install

# Create cap task on install