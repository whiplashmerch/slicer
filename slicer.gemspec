Gem::Specification.new do |s|
  s.name        = 'slicer'
  s.version     = '0.0.0'
  s.date        = '2016-05-13'
  s.summary     = "Slicer"
  s.description = "Extract relations of a single record from a Rails database for use in testing and devlopment"
  s.authors     = ["James Marks"]
  s.email       = 'james@whiplashmerch.com'
  s.files       = ["lib/slicer.rb"]
  s.homepage    = 'https://github.com/whiplashmerch/slicer'
  s.license     = 'MIT'
end


# Make the updates
# gem buiild slicer.gemspec 
# restart server / console