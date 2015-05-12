
task :build do
  `make -C ./ext/serhex`
end

task :clean do
  `make -C ./ext/serhex clean`
  Dir['./**/*.{bundle,o,so}'].each do |path|
    puts "Deleting #{path} ..."
    File.delete(path)
  end
  FileUtils.rm_rf('./pkg')
  FileUtils.rm_rf('./tmp')
end